class SetPresentStateForReport < ActiveRecord::Migration
  def change
    Report.update_all(present_state: :active)
  end
end
