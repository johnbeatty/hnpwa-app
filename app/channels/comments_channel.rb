class CommentsChannel < ApplicationCable::Channel
  
  def follow(data)
    stream_from "CommentsChannel:#{data['parent_id']}"
  end

  def unfollow
    stop_all_streams
  end
end
