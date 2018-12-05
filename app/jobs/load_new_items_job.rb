class LoadNewItemsJob < ApplicationJob
  queue_as :default

   def perform(*args)
    logger.debug "Load New Items Job"

    new_stories_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/newstories.json?print=pretty").to_s

    logger.debug new_stories_json

    new_stories_json.each_with_index do |hn_story_id, new_news_location|
      LoadNewItemJob.perform_later new_news_location, hn_story_id
    end

    NewItem.where("location >= ?", new_stories_json.length).destroy_all
  end
end
