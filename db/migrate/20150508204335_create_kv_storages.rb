class CreateKvStorages < ActiveRecord::Migration
  def change
    create_table :kv_storages do |t|
      t.string :key
      t.binary :value
    end
    add_index :kv_storages, :key, unique: true
  end
end
