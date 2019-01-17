class CommentsChannel < ApplicationCable::Channel
  
  def follow(data)
    stop_all_streams
    stream_from "CommentsChannel:#{data['parent_id']}"
  end

  def unfollow
    stop_all_streams
  end
end
