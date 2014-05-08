class Tag < ActiveRecord::Base
  include Slugger
  has_and_belongs_to_many :posts
end
