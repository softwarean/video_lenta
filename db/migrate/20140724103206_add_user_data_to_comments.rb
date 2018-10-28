class AddUserDataToComments < ActiveRecord::Migration
  def change
    add_column :comments, :user_data, :text
  end
end
