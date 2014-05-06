class WorkInquiryMailer < ActionMailer::Base
  default from: "no-reply@ateorams.com"
  add_template_helper HireUsHelper

  def confirmation(work_inquiry)
    @inquiry = work_inquiry
    #attachments['ateorams-image.jpg'] = File.read("#{Rails.root}/app/assets/images/Attheedgeof-black.png")
    mail(to: work_inquiry.client_email,
          cc: Admin.site_admins.pluck(:email) ,
        subject: "Request Received. Thank you, for your interest!")
  end
end
