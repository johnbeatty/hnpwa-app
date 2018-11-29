class TopsController < ApplicationController

  def show

    @top_items = TopItem.order(:location).limit(30).includes(:item)

    LoadTopItemsJob.perform_later
  end
end