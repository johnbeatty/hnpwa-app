class TopsController < ApplicationController

  def show

    @page = params[:page] ? params[:page].to_i : 0
    @top_item = TopItem.order(:updated_at).last
    @top_items = TopItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)

    @total_pages = TopItem.count / ITEMS_PER_PAGE

    LoadTopItemsJob.perform_later

  end
end