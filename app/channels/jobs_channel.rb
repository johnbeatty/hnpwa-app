class JobsChannel < ApplicationCable::Channel
  def subscribed
    stream_from "JobsChannel#{params[:job_item_id]}"
  end

  def unsubscribed
  end
end
