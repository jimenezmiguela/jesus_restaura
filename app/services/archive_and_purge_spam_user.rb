class ArchiveAndPurgeSpamUser
  def initialize(user)
    @user = user
  end

  def call
    ActiveRecord::Base.transaction do
      archive_user!
      @user.destroy!
    end
  end

  private

  def archive_user!
    SpamUserArchive.create!(
      user_id:      @user.id,
      email:        @user.email,
      archived_at:  Time.current,

      saved_sections: serialize_saved_sections,
      saved_verses:   serialize_saved_verses,

      metadata: {
        user_created_at: @user.created_at,
        user_updated_at: @user.updated_at,
        record_counts: {
          saved_sections: @user.saved_sections.count,
          saved_verses:   @user.saved_verses.count
        }
      }
    )
  end

  def serialize_saved_sections
    @user.saved_sections.map do |section|
      {
        id:          section.id,
        title:       section.title,
        description: section.description,
        content:     section.content,
        note:        section.note,
        created_at:  section.created_at,
        updated_at:  section.updated_at
      }
    end
  end

  def serialize_saved_verses
    @user.saved_verses.map do |verse|
      {
        id:         verse.id,
        book:       verse.book,
        chapter:    verse.chapter,
        verse:      verse.verse,
        note:       verse.note,
        created_at: verse.created_at,
        updated_at: verse.updated_at
      }
    end
  end
end
