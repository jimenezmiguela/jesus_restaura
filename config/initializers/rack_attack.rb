# frozen_string_literal: true

class Rack::Attack
  ### Cache Store ###
  # MemoryStore is sufficient for low traffic apps.
  # Can be swapped for Redis later with no code changes.
  cache.store = ActiveSupport::Cache::MemoryStore.new

  ### ENV-Driven Limits (with safe defaults) ###
  SIGNUP_LIMIT = ENV.fetch('RATE_SIGNUP_LIMIT', 5).to_i
  LOGIN_LIMIT  = ENV.fetch('RATE_LOGIN_LIMIT', 10).to_i
  API_LIMIT    = ENV.fetch('RATE_API_LIMIT', 100).to_i
  RATE_PERIOD  = 1.minute

  ### Safelist ###
  safelist('allow_localhost') do |req|
    ['127.0.0.1', '::1'].include?(req.ip)
  end

  ### Throttle: User registration ###
  throttle('users/sign_up/ip', limit: SIGNUP_LIMIT, period: RATE_PERIOD) do |req|
    req.ip if req.path == '/users' && req.post?
  end

  ### Throttle: User login ###
  throttle('users/sign_in/ip', limit: LOGIN_LIMIT, period: RATE_PERIOD) do |req|
    req.ip if req.path == '/users/sign_in' && req.post?
  end

  ### Throttle: API reads ###
  throttle('api/read/ip', limit: API_LIMIT, period: RATE_PERIOD) do |req|
    req.ip if req.path.start_with?('/api/')
  end

  ### Throttled response ###
  self.throttled_responder = lambda do |_req|
    [
      429,
      { 'Content-Type' => 'text/plain' },
      ['Too many requests. Please slow down.']
    ]
  end
end

### Optional: Log throttled events ###
ActiveSupport::Notifications.subscribe('rack.attack') do |_name, _start, _finish, _id, payload|
  req = payload[:request]

  SpamAttempt.log(
    request: req,
    email: req.params.dig('user', 'email'),
    blocked_by: payload[:match_type]
  )
end
