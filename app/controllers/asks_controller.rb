class AsksController < ApplicationController

  def show
    @page = params[:page] ? params[:page].to_i : FIRST_PAGE
    @ask_item = AskItem.order(:updated_at).last
    @ask_items = AskItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)
    @total_pages = AskItem.count / ITEMS_PER_PAGE
  end

end
