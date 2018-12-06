module ItemsHelper

  def item_url(item)
    if item.url.nil?
      item_path(item.hn_id)
    else
      item.url
    end
  end

  def item_title_url(item)

  end
end

