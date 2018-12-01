class TopNewsChannel < ApplicationCable::Channel
  def subscribed
    logger.debug "Subscribed to TopNewsChannel from connect class #{params[:top_item_id]}"
    logger.debug params
    stream_from "TopNewsChannel#{params[:top_item_id]}"
  end

  def unsubscribed
  end
end
