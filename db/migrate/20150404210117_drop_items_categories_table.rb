class DropItemsCategoriesTable < ActiveRecord::Migration
  def change
    drop_table :items_categories
  end
end
