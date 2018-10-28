class SetBroadcastingsState < ActiveRecord::Migration
  def up
    Broadcasting.find_each do |broadcasting|
      broadcasting.update_attribute :state, 'active'
    end
  end
end
