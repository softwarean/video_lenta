class CreateConstructionTypes < ActiveRecord::Migration
  def change
    create_table :construction_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
