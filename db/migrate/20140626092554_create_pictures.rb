class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.string :name
      t.belongs_to :building, index: true
      t.string :file

      t.timestamps
    end
  end
end
