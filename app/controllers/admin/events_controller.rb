class Admin::EventsController < Admin::AdminController
  before_filter :load_event, :only => [:show, :update, :destroy]
  

  def new
    @event = Event.new
  end

  def create
    @event = Event.new params[:event]

    if @event.save
      redirect_to admin_event_path(@event), :notice => "Successfully updated event."
    else
      render :new
    end
  end

  # doubles as an edit page
  def show
  end
  
  def update
    @event.attributes = params[:event]
    
    if @event.save
      redirect_to admin_event_path(@event), :notice => "Successfully updated event."
    else
      render :show
    end
  end
  
  protected
  
  def load_event
    unless params[:id] and (@event = Event.where(:slug => params[:id]).first)
      head :not_found and return false
    end
  end
  
end