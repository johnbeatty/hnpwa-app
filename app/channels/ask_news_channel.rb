class AskNewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "AskNewsChannel#{params[:ask_item_id]}"
  end

  def unsubscribed
  end
end
