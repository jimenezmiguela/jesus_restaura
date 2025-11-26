module BotProtection
  extend ActiveSupport::Concern

  included do
    invisible_captcha only: [:create], on_spam: :spam_detected
  end

  private

  def spam_detected
    # Log for audit
    Rails.logger.warn "InvisibleCaptcha spam detected in #{controller_name}##{action_name}"
    Rails.logger.warn "Params: #{params.inspect}"

    # Render shared partial
    render "shared/bot_detected", layout: "application", status: :ok
  end
end
