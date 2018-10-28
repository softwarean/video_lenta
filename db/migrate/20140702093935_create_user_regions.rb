class CreateUserRegions < ActiveRecord::Migration
  def change
    create_table :user_regions do |t|
      t.belongs_to :user, index: true
      t.belongs_to :region, index: true

      t.timestamps
    end
  end
end
