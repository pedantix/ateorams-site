# Attributes:
# * id [integer, primary, not null] - primary key
# * budget [string] - TODO: document me
# * client_email [string] - maybe one day I will be part of a client model
# * client_name [string] - maybe one day I will be part of a client model
# * client_phone [string] - maybe one day I will be part of a client model
# * created_at [datetime] - creation time
# * job_description [text] - work to be done
# * reference_source [string] - who told you about us?
# * reply [boolean] - has a reply been sent?
# * updated_at [datetime] - last update time
class WorkInquiry < ActiveRecord::Base
  [:budget, :client_name, :client_phone, :job_description].each do |a|
    validates_presence_of a
  end

  validates :client_email, presence: true,
                           email: { strict_mode: true }
end
