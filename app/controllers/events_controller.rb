class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    if user_signed_in?
      @events = Event.where(private: false)
                     .or(Event.where(creator_id: current_user.id))
                     .or(Event.where(id: current_user.invited_events.select(:id)))
                     .distinct
    else
      @events = Event.public_events
    end
    
    @past_events = @events.past
    @upcoming_events = @events.upcoming
  end

  def show
    @event = Event.includes(:attendees, :invitees).find(params[:id])
    
    if @event.private? && @event.creator != current_user && !@event.invitees.include?(current_user)
      redirect_to root_path, alert: "You are not authorized to view this private event."
    end
  end

  def new
    @event = current_user.created_events.build
  end

  def create
    @event = current_user.created_events.build(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :event_date, :location, :private)
  end
end
