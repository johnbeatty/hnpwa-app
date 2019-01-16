class ItemsController < ApplicationController

  def show
    @item = Item.find_by_hn_id params[:id]
    unless @item.loading_details
      @item.loading_details = true
      @item.save
      LoadItemDetailsJob.perform_later @item
    end
  end
end
