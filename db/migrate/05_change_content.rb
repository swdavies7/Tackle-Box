class ChangeContent < ActiveRecord::Migration
  def change
    rename_column :lures, :content, :name
  end
end