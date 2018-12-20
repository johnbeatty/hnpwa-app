class CommentsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "CommentsChannel:#{params[:hn_id]}"
  end

  def unsubscribed
  end
end
