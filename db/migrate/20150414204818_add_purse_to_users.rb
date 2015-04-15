class AddPurseToUsers < ActiveRecord::Migration
  def change
    add_column :users, :purse, :integer, default: 0
  end
end
