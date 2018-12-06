class AddKidLocationToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :kid_location, :bigint
  end
end
