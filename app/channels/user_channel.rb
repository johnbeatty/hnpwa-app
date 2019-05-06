class UserChannel < ApplicationCable::Channel
  def subscribed
    stop_all_streams
    stream_from "UserChannel#{params[:user_id]}"
    LoadUserDetailsJob.perform_later @user_id
  end

  def unsubscribed
    stop_all_streams
  end
end
