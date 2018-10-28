class RegionAssociationToBuilding < ActiveRecord::Migration
  def change
    remove_column :buildings, :region, :string
    add_column :buildings, :region_id, :integer
  end
end
