class HomeController < ApplicationController

  def index
    @arts = Art.approved.all

    all_featured = Art.featured.all.to_a
    @featured = all_featured[rand all_featured.size]

    @popular = Art.popular.limit(10)

    @events = Event.current.all.select {|e| e.arts.count > 0 && e.arts.first.photos.count > 0}
  end

  def map
    @arts = Art.approved.all

    @events = Event.current.all.select {|e| e.arts.count > 0 && e.arts.first.photos.count > 0}

    if params[:slug].present?
      @event = Event.where(:slug => params[:slug].strip).first
    end
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

  def autocomplete_commissioners
    query = params[:query]

    results = Commissioner.any_of({:name => /.*#{query}.*/i}).limit(10)
    render json: results.map{|x| x.name}
  end

end
