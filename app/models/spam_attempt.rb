class SpamAttempt < ApplicationRecord
  # Logs future spam attempts (captcha blocks, rate limits, suspicious input)
  def self.log(request:, email:, blocked_by:)
    create!(
      ip_address:  request.remote_ip,
      user_agent:  request.user_agent,
      email:       email,
      endpoint:    request.path,
      params:      request.filtered_parameters,
      blocked_by:  blocked_by,
      occurred_at: Time.current
    )
  rescue => e
    Rails.logger.error("SpamAttempt logging failed: #{e.message}")
  end
end
