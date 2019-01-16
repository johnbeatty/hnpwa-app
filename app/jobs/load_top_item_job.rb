class LoadTopItemJob < ApplicationJob
  queue_as :default

  def perform(top_news_location, hn_story_id)
    begin
      story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
      item = Item.where(hn_id: hn_story_id).first_or_create
      item.populate(story_json)
      item.save

      top_item = TopItem.where(location: top_news_location).first_or_create
      top_item.item = item
      top_item.save

      ActionCable.server.broadcast "TopNewsChannel#{top_item.location}", {
        message: TopsController.render( top_item.item ).squish,
        location: top_item.location
      }
      ActionCable.server.broadcast "ItemsChannel:#{top_item.item.id}", {
        item: ItemsController.render( top_item.item ).squish,
        item_id: top_item.item.id
      }
    rescue URI::InvalidURIError => error
      logger.error error
    end
  end
end
