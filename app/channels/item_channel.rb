class ItemChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ItemChannel#{params[:item_id]}"
  end

  def unsubscribed
    stop_all_streams
  end
end
