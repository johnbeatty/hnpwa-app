class LoadUserDetailsJob < ApplicationJob
  queue_as :default

  def perform(hn_user_id)
    user_json = JSON.parse Http.get("https://hacker-news.firebaseio.com/v0/user/#{hn_user_id}.json").to_s
    user = User.where(hn_id: hn_user_id).first_or_create
    user.populate(user_json)
    user.save
  end
end
