class LoadNewItemJob < ApplicationJob
  queue_as :default

  def perform(new_news_location, hn_story_id)
    begin
        story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
        logger.debug story_json
        item = Item.where(hn_id: hn_story_id).first_or_create
        item.populate(story_json)
        item.save

        new_item = NewItem.where(location: new_news_location).first_or_create
        new_item.item = item
        new_item.save

        ActionCable.server.broadcast "NewNewsChannel#{new_item.id}", {
          message: NewsController.render( new_item.item ).squish,
          new_item_id: new_item.id
        }
      rescue URI::InvalidURIError => error
        logger.debug error
      end
  end
end
