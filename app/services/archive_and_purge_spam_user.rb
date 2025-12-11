class ArchiveAndPurgeSpamUser
  def initialize(user)
    @user = user
  end

  def call
    ActiveRecord::Base.transaction do
      archive_user!
      @user.destroy!   # dependent: :destroy cleans all child records
    end
  end

  private

  def archive_user!
    SpamUserArchive.create!(
      user_id:      @user.id,
      email:        @user.email,
      username:     @user.username,
      ip_address:   @user.last_sign_in_ip,
      user_agent:   @user.current_sign_in_user_agent,
      archived_at:  Time.current,

      saved_sections: serialize_saved_sections,
      saved_verses:   serialize_saved_verses,

      metadata: {
        user_created_at:     @user.created_at,
        user_last_sign_in_at: @user.last_sign_in_at,
        record_counts: {
          saved_sections: @user.saved_sections.count,
          saved_verses:   @user.saved_verses.count
        }
      }
    )
  end

  def serialize_saved_sections
    @user.saved_sections.map do |s|
      {
        id: s.id,
        title: s.title,
        description: s.description,
        content: s.content,
        note: s.note,
        created_at: s.created_at,
        updated_at: s.updated_at
      }
    end
  end

  def serialize_saved_verses
    @user.saved_verses.map do |v|
      {
        id: v.id,
        book: v.book,
        chapter: v.chapter,
        verse: v.verse,
        note: v.note,
        created_at: v.created_at,
        updated_at: v.updated_at
      }
    end
  end
end
