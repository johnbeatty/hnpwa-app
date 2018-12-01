class TopsController < ApplicationController

  def show

    @top_item = TopItem.order(:updated_at).last
    @top_items = TopItem.order(:location).limit(30).includes(:item)

    # LoadTopItemsJob.perform_later

  end
end