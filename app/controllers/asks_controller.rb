class AsksController < ApplicationController

  def show

    @page = params[:page] ? params[:page].to_i : 0
    @ask_item = AskItem.order(:updated_at).last
    @ask_items = AskItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)

    @total_pages = AskItem.count / ITEMS_PER_PAGE

    # LoadAskItemsJob.perform_later

  end
end