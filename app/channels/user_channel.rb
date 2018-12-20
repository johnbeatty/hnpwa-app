class UserChannel < ApplicationCable::Channel
  def subscribed
    stream_from "UserChannel#{params[:user_id]}"
  end

  def unsubscribed
  end
end
