class CreateUploaders < ActiveRecord::Migration
  def change
    create_table :uploaders do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :authentication_token
      t.string :name
      t.json :data

      t.timestamps null: false
    end
    add_index :uploaders, :authentication_token, unique: true
  end
end
