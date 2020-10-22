class LoadJobItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    job_stories_json = JSON.parse HTTP.get("https://hacker-news.firebaseio.com/v0/jobstories.json?print=pretty").to_s

    job_stories_json.each_with_index do |hn_story_id, job_news_location|
      LoadJobItemJob.perform_later job_news_location, hn_story_id
    end

    JobItem.where("location >= ?", job_stories_json.length).destroy_all
  end
end
