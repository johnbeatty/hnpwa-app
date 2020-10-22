class LoadAskItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    ask_stories_json = JSON.parse HTTP.get("https://hacker-news.firebaseio.com/v0/askstories.json?print=pretty").to_s

    ask_stories_json.each_with_index do |hn_story_id, ask_news_location|
      LoadAskItemJob.perform_later ask_news_location, hn_story_id
    end

    AskItem.where("location >= ?", ask_stories_json.length).destroy_all
  end
end
