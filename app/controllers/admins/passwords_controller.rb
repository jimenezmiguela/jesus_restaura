class Admins::PasswordsController < Devise::PasswordsController
  include InvisibleCaptcha::ControllerExt

  invisible_captcha only: [:create], on_spam: :spam_detected

  def spam_detected
    render html: <<~HTML.html_safe, layout: false, status: :ok
      <!DOCTYPE html>
      <html>
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1">
          <title>Bot Detected</title>
          <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
        </head>

        <body class="container py-5">
          <h1 class="text-danger">Bot detected!</h1>
          <p>If you are not a bot, please go back and try again.</p>

          <a href="#{request.referrer || '/'}" class="btn btn-primary">Back</a>
        </body>
      </html>
    HTML
  end
end
