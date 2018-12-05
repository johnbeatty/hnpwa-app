class NewNewsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "NewNewsChannel#{params[:new_item_id]}"
  end

  def unsubscribed
  end
end
