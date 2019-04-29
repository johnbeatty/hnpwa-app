class ShowsController < ApplicationController

  def show
    @page = params[:page] ? params[:page].to_i : FIRST_PAGE
    @show_item = ShowItem.order(:updated_at).last
    @show_items = ShowItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)
    @total_pages = ShowItem.count / ITEMS_PER_PAGE
  end
end