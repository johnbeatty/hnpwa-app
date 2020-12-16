class LoadItemDetailsWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'comments', lock: :until_and_while_executing

  
  def perform(hn_id)
    @item = Item.find_by_hn_id hn_id

    begin
      http = HTTP.persistent "https://hacker-news.firebaseio.com"
      item_json = JSON.parse http.get("/v0/item/#{@item.hn_id}.json").to_s
      if item_json.nil?
        return
      end
      @item.populate(item_json)
      @item.save
      
      puts "total descendants #{@item.descendants}"
      @count = 0
      load_kids(http, @item.hn_id, item_json)
      puts "total count #{@count}"
    ensure
      http.close if http
    end
    @item.touch
    if @item.story?
      ActionCable.server.broadcast "ItemChannel:#{@item.hn_id}", {
        item: ItemsController.render( partial: 'item', locals: {item: @item} ).squish,
        comments_header: ItemsController.render( partial: 'comments_header', locals: {item: @item, completed: true} ).squish,
        progress: nil,
        item_id: @item.hn_id
      }
      ActionCable.server.broadcast "ItemsListChannel:#{@item.id}", {
        item: ItemsController.render( @item ).squish,
        item_id: @item.id
      }
      ActionCable.server.broadcast "CommentsChannel:#{@item.hn_id}", {
        comments: ItemsController.render( partial: 'comments', locals: {item: @item} ).squish,
        parent_id: @item.hn_id,
        item_id: @item.hn_id
      }
    end
  end

  def load_kids(http, parent_id, item_json)
    @count += 1
    puts "load kids start #{@count}"
    ActionCable.server.broadcast "ItemChannel:#{@item.hn_id}", {
      item: nil,
      comments_header: nil,
      progress: [((@count.to_f/ [@item.descendants.to_f, 1].max ) * 100).to_i, 99].min,
      item_id: @item.hn_id
    }
    
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
    puts "load kids stop #{@count}"
  end
end
