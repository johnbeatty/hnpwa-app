class LoadItemDetailsJob < ApplicationJob
  queue_as :default

  def perform(item)
    item_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/item/#{item.hn_id}.json?print=pretty").to_s
    item.populate(item_json)
    item.save

    if item_json.has_key? 'kids'
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
