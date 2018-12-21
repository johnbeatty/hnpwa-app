class NewsController < ApplicationController

  def show

    @page = params[:page] ? params[:page].to_i : 0
    @new_item = NewItem.order(:updated_at).last
    @new_items = NewItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)

    @total_pages = NewItem.count / ITEMS_PER_PAGE

    # LoadNewItemsJob.perform_later

  end
end