class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  validates_presence_of :username
  has_and_belongs_to_many :posts

  scope :unapproved_admins, -> { where(approved: false) }
  scope :approved_admins, -> { where(approved: true, site_admin: false) }
  scope :site_admins, -> { where(approved: true, site_admin: true) }

  def active_for_authentication?
    self.approved?
  end
end
