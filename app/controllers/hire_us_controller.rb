class HireUsController < ApplicationController
  after_action :send_confirmation, only: :create

  def show
    @work_inquiry = WorkInquiry.new
  end

  def create
    begin
      @work_inquiry = WorkInquiry.create(work_inquiry_params)

      @work_inquiry.save!
      flash[:success] = "Your inquiry was succesfully submitted."
      redirect_to confirmation_hire_us_path
    #rescue ActiveRecord::ValidationError => e

    rescue Exception => e
      flash.now[:alert] = "Your inquiry was not submitted, see the form below for errors."
      render 'show'
    end
  end

  def confirmation
  end
private
  def work_inquiry_params
    params.require(:work_inquiry).permit(:client_name, :client_email, :client_phone, :job_description, :budget, :reference_source)
  end

  def send_confirmation
    WorkInquiryMailer.delay.confirmation(@work_inquiry) if @work_inquiry.valid?
  end
end
