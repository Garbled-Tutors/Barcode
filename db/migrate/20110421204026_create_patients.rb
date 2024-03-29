class CreatePatients < ActiveRecord::Migration
  def self.up
    create_table :patients do |t|
      t.string :name
      t.string :address
      t.integer :pid

      t.timestamps
    end
  end

  def self.down
    drop_table :patients
  end
end
