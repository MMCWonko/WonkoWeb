class CreateWonkoFiles < ActiveRecord::Migration
  def change
    create_table :wonko_files do |t|
      t.string :uid
      t.string :name
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :wonko_files, :uid, unique: true
  end
end
