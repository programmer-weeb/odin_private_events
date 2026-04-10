class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_event, only: %i[show edit update destroy]
  before_action :authorize_creator!, only: %i[edit update destroy]

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
    if @event.private? && @event.creator != current_user && !@event.invitees.include?(current_user)
      redirect_to root_path, alert: "You are not authorized to view this private event."
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Event was successfully deleted.", status: :see_other
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

  def set_event
    @event = Event.includes(:attendees, :invitees).find(params[:id])
  end

  def authorize_creator!
    unless @event.creator == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
