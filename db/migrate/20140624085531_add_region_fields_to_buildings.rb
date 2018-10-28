class AddRegionFieldsToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :region, :string
    add_column :buildings, :district, :string
  end
end
