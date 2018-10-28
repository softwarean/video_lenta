class AddCoordinatesToBuildings < ActiveRecord::Migration
  def change
    add_column :buildings, :latitude, :string
    add_column :buildings, :longitude, :string
  end
end
