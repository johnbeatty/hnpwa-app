class AsksController < ApplicationController

  def show
    @page = params[:page] ? params[:page].to_i : 0
    @ask_item = AskItem.order(:updated_at).last
    @ask_items = AskItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)
    @item_ids = @ask_items.pluck(:item_id)
    @total_pages = AskItem.count / ITEMS_PER_PAGE
  end

end
