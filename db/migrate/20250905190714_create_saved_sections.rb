class CreateSavedSections < ActiveRecord::Migration[7.1]
  def change
    create_table :saved_sections do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :content
      t.text :note

      t.timestamps
    end
  end
end
