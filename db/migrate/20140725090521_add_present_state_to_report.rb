class AddPresentStateToReport < ActiveRecord::Migration
  def change
    add_column :reports, :present_state, :string
  end
end
