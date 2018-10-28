class CreateBuildings < ActiveRecord::Migration
  def change
    create_table :buildings do |t|
      t.string :name
      t.string :state
      t.string :construction_type
      t.string :locality
      t.date :start_date
      t.date :finish_date
      t.text :description

      t.timestamps
    end
  end
end
