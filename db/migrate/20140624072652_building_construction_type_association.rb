class BuildingConstructionTypeAssociation < ActiveRecord::Migration
  def change
    remove_column :buildings, :construction_type, :string
    add_column :buildings, :construction_type_id, :integer
  end
end
