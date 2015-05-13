class AddVersionUniqnessIndex < ActiveRecord::Migration
  def change
    add_index :wonko_versions, [:wonko_file_id, :user_id, :version], unique: true
  end
end
