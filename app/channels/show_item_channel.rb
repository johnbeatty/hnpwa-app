class ShowItemChannel < ApplicationCable::Channel
  def follow(data)
    stop_all_streams
    locations = data['locations']
    unless locations.nil?
      locations.each do |location|
        stream_from "ShowItemChannel:#{location}"
      end
    end
  end

  def unfollow
    stop_all_streams
  end
end
