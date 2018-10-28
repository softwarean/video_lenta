class SetUsersRole < ActiveRecord::Migration
  def up
    User.find_each do |user|
      user.update_attribute(:role, 'admin')
    end
  end
end
