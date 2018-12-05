class ShowNewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ShowNewsChannel#{params[:show_item_id]}"
  end

  def unsubscribed
  end
end
