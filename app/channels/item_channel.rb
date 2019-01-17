class ItemChannel < ApplicationCable::Channel
  
  def follow(data)
    stream_from "ItemChannel:#{data['id']}"
    item = Item.find_by_hn_id data['id']
    LoadItemDetailsJob.perform_later item
  end

  def unfollow
    stop_all_streams
  end
end
