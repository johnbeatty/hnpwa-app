class LoadAskItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug "Load Ask Items Job"

    ask_stories_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/askstories.json?print=pretty").to_s

    logger.debug ask_stories_json

    ask_stories_json.each_with_index do |hn_story_id, ask_news_location|
      LoadAskItemJob.perform_later ask_news_location, hn_story_id
    end

    AskItem.where("location >= ?", ask_stories_json.length).destroy_all
  end
end
