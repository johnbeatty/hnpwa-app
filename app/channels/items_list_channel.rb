class ItemsListChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    items = JSON.parse data['items']
    unless items.nil?
      items.each do |item|
        stream_from "ItemsListChannel:#{item}"
      end
    end
  end

  def unfollow
    stop_all_streams
  end
end
