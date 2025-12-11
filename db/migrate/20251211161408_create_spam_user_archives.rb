class CreateSpamUserArchives < ActiveRecord::Migration[7.1]
  def change
    create_table :spam_user_archives do |t|
      t.integer :user_id
      t.string :email
      t.string :username
      t.string :ip_address
      t.text :user_agent
      t.jsonb :saved_sections
      t.jsonb :saved_verses
      t.jsonb :metadata
      t.datetime :archived_at

      t.timestamps
    end
  end
end
