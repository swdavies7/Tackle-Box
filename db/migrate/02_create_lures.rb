class CreateLures < ActiveRecord::Migration
  def change
    create_table :lures do |t|
      t.string :content
      t.integer :angler_id
    end
  end
end
