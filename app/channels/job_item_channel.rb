class JobItemChannel < ApplicationCable::Channel

  def follow(data)
    stop_all_streams
    locations = JSON.parse data['locations']
    unless locations.nil?
      locations.each do |location|
        stream_from "JobItemChannel:#{location}"
      end
    end
  end

  def unfollow
    stop_all_streams
  end
end
