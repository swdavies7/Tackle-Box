class AddTackleBoxId < ActiveRecord::Migration
  def change
    add_column :lures, :tackle_box_id, :integer
  end
end