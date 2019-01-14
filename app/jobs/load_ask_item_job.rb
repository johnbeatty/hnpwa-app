class LoadAskItemJob < ApplicationJob
  queue_as :default

   def perform(ask_news_location, hn_story_id)
    begin
        story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
        item = Item.where(hn_id: hn_story_id).first_or_create
        item.populate(story_json)
        item.save

        ask_item = AskItem.where(location: ask_news_location).first_or_create
        ask_item.item = item
        ask_item.save

        ActionCable.server.broadcast "AskNewsChannel#{ask_item.id}", {
          message: AsksController.render( ask_item.item ).squish,
          ask_item_id: ask_item.id
        }
      rescue URI::InvalidURIError => error
        logger.error error
      end
  end
end
