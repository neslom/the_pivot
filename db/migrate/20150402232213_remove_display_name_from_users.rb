class RemoveDisplayNameFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :display_name
  end
end
