module BotProtection
  extend ActiveSupport::Concern

  included do
    invisible_captcha only: [:create], on_spam: :spam_detected
  end

  private

  def spam_detected
    # Log permanent forensic record
    SpamAttempt.log(
      request: request,
      email: params[:email],
      blocked_by: "invisible_captcha"
    )

    # Optional Rails log
    Rails.logger.warn "InvisibleCaptcha spam detected in #{controller_name}##{action_name}"
    Rails.logger.warn "Params: #{params.inspect}"

    # Friendly UI response
    render "shared/bot_detected", layout: "application", status: :ok
  end
end
