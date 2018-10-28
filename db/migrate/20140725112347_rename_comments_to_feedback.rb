class RenameCommentsToFeedback < ActiveRecord::Migration
  def change
    rename_table :comments, :feedbacks
  end
end
