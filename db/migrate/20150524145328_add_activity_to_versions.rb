class AddActivityToVersions < ActiveRecord::Migration
  def change
    add_reference :versions, :activity, index: true, foreign_key: true
  end
end
