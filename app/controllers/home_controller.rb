class HomeController < ApplicationController
  
  def index
    @arts = Art.approved.all
  end
  
  def map
    @arts = Art.approved.all
  end

  def send_contact
    if params[:name].present? and params[:email].present? and params[:text].present?
      begin
        AdminMailer.contact_form(params[:name], params[:email], params[:text]).deliver
        redirect_to contact_path, :notice => "Thanks for your comments!"
      rescue Exception => ex
        Rails.logger.info "ERROR sending mail: #{ex.message}"
        
        flash.now[:alert] = "We had a problem sending your comment. Please try it again."
        render :contact
      end
    else
      flash.now[:alert] = "Please fill out all fields and try again."
      render :contact
    end
  end
  
end