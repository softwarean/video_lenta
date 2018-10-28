class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :name
      t.belongs_to :building, index: true
      t.string :file

      t.timestamps
    end
  end
end
