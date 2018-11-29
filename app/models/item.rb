class Item < ApplicationRecord
  enum hn_type: [:job, :story, :comment, :poll, :pollopt]

  def populate(json) 
    self.hn_id = json['id'] if json['id']
    self.deleted = json['deleted'] if json['deleted']
    self.hn_type = json['type'] if json['type']
    self.by = json['by'] if json['by']
    self.time = DateTime.strptime("#{json['time']}",'%s') if json['time']
    self.text = json['text'] if json['text']
    self.dead = json['dead'] if json['dead']
    self.parent = json['parent'] if json['parent']
    self.poll = json['poll'] if json['poll']
    if json['url']
      self.url = json['url'] 
      self.host = URI.parse( json['url'] ).host
    end 
    self.score = json['score'] if json['score']
    self.descendants = json['descendants'] if json['descendants']
    self.title = json['title'] if json['title']
  end
end
