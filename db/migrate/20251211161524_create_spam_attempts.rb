class CreateSpamAttempts < ActiveRecord::Migration[7.1]
  def change
    create_table :spam_attempts do |t|
      t.string :ip_address
      t.text :user_agent
      t.string :email
      t.string :endpoint
      t.jsonb :params
      t.string :blocked_by
      t.datetime :occurred_at

      t.timestamps
    end
  end
end
