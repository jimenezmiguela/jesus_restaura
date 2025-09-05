class CreateSavedVerses < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_verses do |t|
      t.references :user, null: false, foreign_key: true
      t.string :book
      t.integer :chapter
      t.integer :verse
      t.text :note

      t.timestamps
    end
  end
end
