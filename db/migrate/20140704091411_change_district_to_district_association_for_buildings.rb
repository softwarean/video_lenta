class ChangeDistrictToDistrictAssociationForBuildings < ActiveRecord::Migration
  def change
    remove_column :buildings, :district, :string
    add_column :buildings, :district_id, :integer
  end
end
