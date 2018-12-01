class LoadTopItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug "Load Top Items Job"

    top_stories_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty").to_s

    logger.debug top_stories_json

    top_stories_json.each_with_index do |hn_story_id, top_news_location|
      LoadTopItemJob.perform_later top_news_location, hn_story_id
    end
  end
end
