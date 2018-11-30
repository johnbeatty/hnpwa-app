class LoadTopItemsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    logger.debug "Load Top Items Job"

    top_stories_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/topstories.json?print=pretty").to_s

    logger.debug top_stories_json

    top_stories_json.each_with_index do |story_id, list_location|
      begin
        story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{story_id}.json?print=pretty").to_s
        logger.debug story_json
        item = Item.where(hn_id: story_id).first_or_create
        item.populate(story_json)
        item.save

        top_item = TopItem.where(location: list_location).first_or_create
        top_item.item = item
        top_item.save
      rescue URI::InvalidURIError => error
        logger.debug error
      end
    end
  end
end
