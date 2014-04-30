class HireUsController < ApplicationController
  def show
    @work_inquiry = WorkInquiry.new
  end

  def create
    begin
      @work_inquiry = WorkInquiry.create!(work_inquiry_params)
      redirect_to confirmation_hire_us_path
    rescue Exception => e
      render 'show'
    end
  end

  def confirmation
  end

private

  def work_inquiry_params
    params.require(:work_inquiry).permit(:client_name, :client_email, :client_phone, :job_description, :budget)
  end
end
