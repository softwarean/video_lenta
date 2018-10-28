class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :state
      t.string :file

      t.timestamps
    end
  end
end
