class CreateWonkoOrigins < ActiveRecord::Migration
  def change
    create_table :wonko_origins do |t|
      t.references :object, polymorphic: true, index: true
      t.references :origin, polymorphic: true, index: true
      t.json :data
      t.string :type

      t.timestamps null: false
    end

    reversible do |dir|
      dir.up do
        WonkoFile.all.each do |file|
          file.build_origin(origin: file.user, type: 'uploaded_from_web').save!
        end

        WonkoVersion.all.each do |version|
          version.build_origin(origin: version.user, type: 'uploaded_from_web').save!
        end
      end
    end

    remove_column :wonko_versions, :origin
  end
end
