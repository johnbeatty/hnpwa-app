class LoadItemDetailsJob < ApplicationJob
  queue_as :comments

  def perform(item)
    item_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{item.hn_id}.json?print=pretty").to_s
    item.populate(item_json)
    item.save

    if item_json and item_json.has_key? 'kids'
      item_json['kids'].each_with_index do |kid_hn_id, kid_location|
        kid = Item.where(hn_id: kid_hn_id).first_or_create
        kid.kid_location = kid_location
        kid.parent_id = item.id
        kid.save
        LoadItemDetailsJob.perform_now kid
      end
    end

    if item.story?
      ActionCable.server.broadcast "ItemChannel:#{item.hn_id}", {
        item_metadata: ItemsController.render( partial: 'item_metadata', locals: {item: item} ).squish,
        item_id: item.hn_id
      }
      ActionCable.server.broadcast "ItemsListChannel:#{item.id}", {
        item: ItemsController.render( item ).squish,
        item_id: item.id
      }
      ActionCable.server.broadcast "CommentsChannel:#{item.hn_id}", {
        comments: ItemsController.render( partial: 'comments', locals: {item: item} ).squish,
        parent_id: item.hn_id,
        item_id: item.hn_id
      }
    end
    if item.loading_details
      item.loading_details = false
      item.save
    end
  end
end
