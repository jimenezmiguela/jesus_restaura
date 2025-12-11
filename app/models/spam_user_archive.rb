class SpamUserArchive < ApplicationRecord
  # Pure archive. Never associates back to deleted records.
  # No validations except presence for forensic completeness.
  validates :email, :archived_at, presence: true
end
