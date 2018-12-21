class Item < ApplicationRecord
  has_one :top_item
  has_one :new_item
  has_one :job_item
  has_one :ask_item
  has_one :show_item
  has_one :hn_parent, class_name: 'Item', primary_key: 'parent', foreign_key: 'hn_id'

  # belongs_to :item_parent, class_name: 'Item', foreign_key: 'parent_id'
  
  has_many :kids, class_name: "Item", primary_key: 'hn_id', foreign_key: 'parent'
  after_save :update_list_item
  enum hn_type: [:job, :story, :comment, :poll, :pollopt]

  def populate(json) 
    if json.nil?
      return
    end
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
      host = URI.parse( json['url'] ).host
      self.host = host.gsub("www.", "") unless host.nil?
    end 
    self.score = json['score'] if json['score']
    self.descendants = json['descendants'] if json['descendants']
    self.title = json['title'] if json['title']
  end

  def update_list_item 
    if self.story?
      top_item.touch if top_item.present?
      new_item.touch if new_item.present?
      show_item.touch if show_item.present?
      ask_item.touch if ask_item.present?
    elsif self.job?
      job_item.touch if job_item.present?
    elsif self.comment?
      hn_parent.touch if hn_parent.present?
    end
  end
end
