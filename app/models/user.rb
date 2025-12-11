class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :saved_verses, dependent: :destroy
  has_many :saved_sections, dependent: :destroy

  INVALID_TLDS = %w[ru xyz click rest uno monster top space]
  DISPOSABLE_DOMAINS = %w[
    mailinator.com temp-mail.org yopmail.com
    10minutemail.com guerrillamail.com sharklasers.com
  ]

  before_validation :normalize_email
  before_validation :normalize_gmail_dots   # <-- ADDED because 7/8 spam bots used Gmail

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validate :reject_invalid_tlds
  validate :reject_disposable_domains

  private

  def normalize_email
    self.email = email.to_s.strip.downcase
  end

  def normalize_gmail_dots
    return unless email.present?

    local, domain = email.split('@')
    return unless domain == "gmail.com"

    self.email = "#{local.delete('.')}@#{domain}"
  end

  def reject_invalid_tlds
    tld = email.split('.').last
    errors.add(:email, "TLD not permitted") if INVALID_TLDS.include?(tld)
  end

  def reject_disposable_domains
    domain = email.split('@').last
    errors.add(:email, "domain not permitted") if DISPOSABLE_DOMAINS.include?(domain)
  end
end
