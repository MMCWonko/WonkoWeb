class RemoveVersions < ActiveRecord::Migration
  def up
    drop_table :versions
  end
end
