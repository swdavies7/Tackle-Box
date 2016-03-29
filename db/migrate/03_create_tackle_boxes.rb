class CreateTackleBoxes < ActiveRecord::Migration
  def change
    create_table :tackle_boxes do |t|
      t.string :name
      t.string :manufacturer
      t.integer :angler_id
    end
  end
end