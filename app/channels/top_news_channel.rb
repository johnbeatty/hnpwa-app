class TopNewsChannel < ApplicationCable::Channel
  def follow(data)
    locations = JSON.parse data['locations']
    unless locations.nil? 
      locations.each do |location|
        stream_from "TopNewsChannel#{location}"
      end
    end
  end

  def unfollow
    stop_all_streams
  end
end
