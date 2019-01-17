class ItemChannel < ApplicationCable::Channel
  
  def follow(data)
    stop_all_streams
    stream_from "ItemChannel:#{data['id']}"
    LoadItemDetailsWorker.perform_async data['id']
  end

  def unfollow
    stop_all_streams
  end
end
