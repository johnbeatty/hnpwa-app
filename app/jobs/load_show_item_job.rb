class LoadShowItemJob < ApplicationJob
  queue_as :default

  def perform(show_news_location, hn_story_id)
    begin
        story_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{hn_story_id}.json?print=pretty").to_s
        item = Item.where(hn_id: hn_story_id).first_or_create
        item.populate(story_json)
        item.save

        show_item = ShowItem.where(location: show_news_location).first_or_create
        show_item.item = item
        show_item.save

        ActionCable.server.broadcast "ShowNewsChannel#{show_item.id}", {
          message: ShowsController.render( show_item.item ).squish,
          show_item_id: show_item.id
        }
      rescue URI::InvalidURIError => error
        logger.error error
      end
  end
end
