class Admin::EventsController < Admin::AdminController
  before_action :load_event, only: [:show, :update, :destroy]

  def new
    @event = Event.new
  end

  def create
    @event = Event.new params[:event]

    if @event.save
      redirect_to admin_event_path(@event),
                  notice: 'Successfully updated event.'
    else
      render :new
    end
  end

  # doubles as an edit page
  def show
  end

  def destroy
    @event.destroy
    redirect_to admin_path
  end

  def update
    @event.attributes = params[:event]

    if @event.save
      redirect_to admin_event_path(@event),
                  notice: 'Successfully updated event.'
    else
      render :show
    end
  end

  protected

  def load_event
    @event = Event.find(params[:id])
  end
end
