class SpamUserArchive < ApplicationRecord
  # Pure archive. Never associates back to deleted records.
  # Validates presence for forensic completeness.
  validates :user_id, :email, :archived_at, presence: true
end
