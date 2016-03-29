class AddManu < ActiveRecord::Migration
  def change
    add_column :lures, :manufacturer, :string
  end
end