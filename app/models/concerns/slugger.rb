module Slugger
  extend ActiveSupport::Concern
  included do 
    validates :title, uniqueness: true,
                      presence: true,
                      length: 3..50

    validates :slug, presence: true,
                  format: { with: /\A[a-zA-Z0-9-]+\z/ }
    
    before_validation { slug_from_title }

    extend FriendlyId
    friendly_id :slug, use: [:slugged, :finders] 
  end

  module ClassMethods
   
  end 

  
  module InstanceMethods
    def slugify_text(text)
      new_slug = text.gsub(/[^a-zA-Z0-9]+/, "-")
      new_slug.gsub!(/\A[-]|[-]\z/,"")
      new_slug.downcase!
      return new_slug
    end  

    def slug_from_title
      if !self.title.nil? and !self.title.blank?
        self.slug = slugify_text(self.title)
      end
    end
  end
  

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end