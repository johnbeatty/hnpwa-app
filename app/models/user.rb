class User < ApplicationRecord

  def populate(json)
    self.about = json['about'] if json['about']
    self.karma = json['karma'] if json['karma']
    self.created = DateTime.strptime("#{json['created']}",'%s') if json['created']
  end
end
