class LoadJobItemJob < ApplicationJob
  queue_as :default

  def perform(job_news_location, hn_story_id)
    begin
      story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
      item = Item.where(hn_id: hn_story_id).first_or_create
      item.populate(story_json)
      item.save

      job_item = JobItem.where(location: job_news_location).first_or_create
      job_item.item = item
      job_item.save

      ActionCable.server.broadcast "JobNewsChannel#{job_item.id}", {
        message: JobsController.render( job_item.item ).squish,
        job_item_id: job_item.id
      }
    rescue URI::InvalidURIError => error
      logger.error error
    end
  end
end
