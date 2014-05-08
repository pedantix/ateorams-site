class WorkInquiriesController < ApplicationController
before_action :verify_approved_admin!
before_action :set_inquiry!, only: [:show, :update, :edit]
  def index
    case 
    when params[:scope_to]== "answered"
      @inquiries_array = WorkInquiry.answered
      @filter = "answered"
    when params[:scope_to] == "unanswered"
      @inquiries_array = WorkInquiry.unanswered
      @filter = "unanswered"
    else
      @inquiries_array = WorkInquiry.all
    end
      @inquiries = Kaminari.paginate_array(@inquiries_array).page(params[:page]).per(10)
  end

  def edit

  end

  def update
   begin
      @inquiry.update_attributes!(work_inquiry_status_params)
      flash[:success] = "Successfully updated status of work inquiry."
      redirect_to work_inquiry_path(@inquiry)
    rescue Exception => e
      render 'edit'
    end
  end

  def show
  end

private 
  def set_inquiry!
    @inquiry = WorkInquiry.find(params[:id])
  end

  def work_inquiry_status_params
    params.require(:work_inquiry).permit(:reply)
  end
end
