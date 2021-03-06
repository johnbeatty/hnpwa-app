class JobsController < ApplicationController

  def show
    @page = params[:page] ? params[:page].to_i : FIRST_PAGE
    @job_item = JobItem.order(:updated_at).last
    @job_items = JobItem.order(:location).limit(ITEMS_PER_PAGE).offset(@page * ITEMS_PER_PAGE).includes(:item)
    @total_pages = JobItem.count / ITEMS_PER_PAGE
  end
end
