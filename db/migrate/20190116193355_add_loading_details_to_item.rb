class AddLoadingDetailsToItem < ActiveRecord::Migration[5.2]
  def change
    add_column :items, :loading_details, :boolean, default: false
  end
end
