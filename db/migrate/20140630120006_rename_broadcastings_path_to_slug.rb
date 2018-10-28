class RenameBroadcastingsPathToSlug < ActiveRecord::Migration
  def change
    rename_column :broadcastings, :path, :slug
  end
end
