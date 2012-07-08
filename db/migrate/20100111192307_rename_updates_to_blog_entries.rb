class RenameUpdatesToBlogEntries < ActiveRecord::Migration
  def self.up
    remove_foreign_key :remarks, :name => "remarks_ibfk_1"
    rename_table :updates, :blog_entries
    rename_column :remarks, :update_id, :blog_entry_id
    add_foreign_key :remarks, :blog_entries
  end

  def self.down
    remove_foreign_key :remarks, :blog_entries
    rename_table :blog_entries, :updates
    rename_column :remarks, :blog_entry_id, :update_id
    add_foreign_key :remarks, :updates, :name => "remarks_ibfk_1"
  end
end
