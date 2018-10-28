class RemoveRegionFromBuildings < ActiveRecord::Migration
  def change
    remove_column :buildings, :region_id, :integer
  end
end
