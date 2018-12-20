class ItemsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ItemsChannel#{params[:item_id]}"
  end

  def unsubscribed
  end
end
