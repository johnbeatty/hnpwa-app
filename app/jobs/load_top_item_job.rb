class LoadTopItemJob < ApplicationJob
  queue_as :default

  def perform(top_news_location, hn_story_id)
    begin
      story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
      logger.debug story_json
      item = Item.where(hn_id: hn_story_id).first_or_create
      item.populate(story_json)
      item.save

      top_item = TopItem.where(location: top_news_location).first_or_create
      top_item.item = item
      top_item.save

      ActionCable.server.broadcast "TopNewsChannel#{top_item.id}", {
        message: TopsController.render( top_item.item ).squish,
        top_item_id: top_item.id
      }
    rescue URI::InvalidURIError => error
      logger.debug error
    end
  end
end
