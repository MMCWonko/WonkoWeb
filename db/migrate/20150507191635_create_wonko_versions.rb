class CreateWonkoVersions < ActiveRecord::Migration
  def change
    create_table :wonko_versions do |t|
      t.string :version
      t.string :type
      t.string :time
      t.string :origin
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :wonko_file, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :wonko_versions, :version
  end
end
