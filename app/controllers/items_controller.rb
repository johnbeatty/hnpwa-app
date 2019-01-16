class ItemsController < ApplicationController

  def show
    @item = Item.find_by_hn_id params[:id]
    LoadItemDetailsJob.perform_later @item
  end
end
