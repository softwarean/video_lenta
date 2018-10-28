class SetStateForReport < ActiveRecord::Migration
  def up
    Report.update_all(state: :actual)
  end
end
