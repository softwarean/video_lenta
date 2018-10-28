class CreateContractors < ActiveRecord::Migration
  def change
    create_table :contractors do |t|
      t.string :name
      t.belongs_to :building, index: true

      t.timestamps
    end
  end
end
