class LoadItemDetailsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'comments', lock: :until_and_while_executing

  def perform(hn_id)
    item = Item.find_by_hn_id hn_id

    begin
      http = HTTP.persistent "https://hacker-news.firebaseio.com"
      item_json = JSON.parse http.get("/v0/item/#{item.hn_id}.json").to_s
      if item_json.nil?
        return
      end
      item.populate(item_json)
      item.save

      load_kids(http, item.hn_id, item_json)

    ensure
      http.close if http
    end

    if item.story?
      ActionCable.server.broadcast "ItemChannel:#{item.hn_id}", {
        item_metadata: ItemsController.render( partial: 'item_metadata', locals: {item: item} ).squish,
        comments_header: ItemsController.render( partial: 'comments_header', locals: {item: item} ).squish,
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
  end

  def load_kids(http, parent_id, item_json)
    if item_json and item_json.has_key? 'kids'
      item_json['kids'].each_with_index do |kid_hn_id, kid_location|

        kid_json = JSON.parse http.get("/v0/item/#{kid_hn_id}.json").to_s
        if kid_json.nil?
          next
        end

        kid = Item.where(hn_id: kid_hn_id).first_or_create
        kid.kid_location = kid_location
        kid.parent_id = parent_id
        kid.populate(kid_json)
        kid.save

        load_kids(http, kid.hn_id, kid_json)
      end
    end
  end
end
