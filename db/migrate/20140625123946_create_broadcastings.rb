class CreateBroadcastings < ActiveRecord::Migration
  def change
    create_table :broadcastings do |t|
      t.string :name
      t.belongs_to :building, index: true

      t.timestamps
    end
  end
end
