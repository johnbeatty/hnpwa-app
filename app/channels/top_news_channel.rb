class TopNewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "TopNewsChannel#{params[:top_item_id]}"
  end

  def unsubscribed
  end
end
