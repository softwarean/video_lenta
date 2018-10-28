class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.string :reason
      t.text :text
      t.string :author
      t.string :email

      t.timestamps
    end
  end
end
