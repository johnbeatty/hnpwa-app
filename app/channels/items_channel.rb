class ItemsChannel < ApplicationCable::Channel
  def follow_items(data)
    stop_all_streams
    items = JSON.parse data['items']
    unless items.nil?
      items.each do |item|
        stream_from "ItemsChannel:#{item}"
      end
    end
  end

  def unfollow
    stop_all_streams
  end
end
