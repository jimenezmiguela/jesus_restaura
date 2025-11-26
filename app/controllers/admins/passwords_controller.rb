class Admins::PasswordsController < Devise::PasswordsController
  include BotProtection
end
