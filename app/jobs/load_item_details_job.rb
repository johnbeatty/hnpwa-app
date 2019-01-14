class LoadItemDetailsJob < ApplicationJob
  queue_as :comments

  def perform(item)
    item_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{item.hn_id}.json?print=pretty").to_s
    item.populate(item_json)
    item.save

    if item.story?
      ActionCable.server.broadcast "ItemsChannel#{item.hn_id}", {
        item_metadata: ItemsController.render( partial: 'item_metadata', locals: {item: item} ).squish,
        item_id: item.hn_id
      }
    elsif item.comment?
      comment = item
      while not comment.hn_parent.nil? and not comment.hn_parent.story? 
        comment = comment.hn_parent
      end
      if comment.hn_parent
        ActionCable.server.broadcast "CommentsChannel:#{comment.hn_parent.hn_id}", {
          comments: ItemsController.render( partial: 'comments', locals: {item: comment.hn_parent} ).squish
        }
      end
    end

    if item_json and item_json.has_key? 'kids'
      item_json['kids'].each_with_index do |kid_hn_id, kid_location|
        kid = Item.where(hn_id: kid_hn_id).first_or_create
        kid.kid_location = kid_location
        kid.parent_id = item.id
        kid.save
        LoadItemDetailsJob.perform_later kid
      end
    end
  end
end
