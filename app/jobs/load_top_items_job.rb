class LoadTopItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    top_stories_json = JSON.parse HTTP.get("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty").to_s

    top_stories_json.each_with_index do |hn_story_id, top_news_location|
      LoadTopItemJob.perform_later top_news_location, hn_story_id
    end

    TopItem.where("location >= ?", top_stories_json.length).destroy_all
  end
end
