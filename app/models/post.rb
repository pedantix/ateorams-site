class Post < ActiveRecord::Base
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :admins
  validates_presence_of :title
  validates_presence_of :body

  include Slugger

  attr_accessor :tags_text
  after_save { digest_tags unless tags_text.nil? }
  after_initialize :constitue_tags

  def abstract_body
    abstract_text = ""
    text_array = self.body.split(" ")

    text_array.each do |word|
      abstract_text << word + " "

      break if abstract_text.length >= 255
    end
    abstract_text << "..." if abstract_text.length < self.body.length
    return abstract_text
  end

  def author
    return 'ateorams' if self.admins.empty?
    self.admins.first.username
  end

  def has_owner?(admin)
    self.admins.include?(admin)
  end

private
  def digest_tags
    #clear tags association
    self.tag_ids = nil

    #add tags
    tags_text.split(",").each do |tag_word|
      begin
       self.tags << Tag.find(slugify_text tag_word)
      rescue ActiveRecord::RecordNotFound => e
        self.tags << Tag.create!(title: tag_word.strip)
      end
    end 
  end

  def constitue_tags
    if tags_text.nil?
      self.tags_text = ''
      self.tags.each {|t| self.tags_text <<  "#{self.tags_text.empty? ? '': ', ' }#{t.title}"}
    end
  end
end
