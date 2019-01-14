class LoadShowItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    show_stories_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/showstories.json?print=pretty").to_s

    show_stories_json.each_with_index do |hn_story_id, show_news_location|
      LoadShowItemJob.perform_later show_news_location, hn_story_id
    end

    ShowItem.where("location >= ?", show_stories_json.length).destroy_all
  end
end
