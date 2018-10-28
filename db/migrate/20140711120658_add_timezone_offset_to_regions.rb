class AddTimezoneOffsetToRegions < ActiveRecord::Migration
  def change
    add_column :regions, :timezone_offset, :integer
  end
end
