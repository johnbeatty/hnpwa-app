class LoadNewItemJob < ApplicationJob
  queue_as :default

  def perform(new_news_location, hn_story_id)
    begin
        story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
        if story_json.nil? 
          return
        end
        item = Item.where(hn_id: hn_story_id).first_or_create
        item.populate(story_json)
        item.save

        new_item = NewItem.where(location: new_news_location).first_or_create
        new_item.item = item
        new_item.save

        ActionCable.server.broadcast "NewNewsChannel#{new_item.location}", {
          message: NewsController.render( new_item.item ).squish,
          location: new_item.location
        }
      rescue URI::InvalidURIError => error
        logger.error error
      end
  end
end
