class RemoveBuildingType < ActiveRecord::Migration
  def up
    drop_table :construction_types
  end
end
