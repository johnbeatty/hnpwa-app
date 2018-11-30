class TopNewsChannel < ApplicationCable::Channel
  def subscribed
    logger.debug "Subscribed to TopNewsChannel from connect class"
    stream_from "TopNewsChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
