class EventsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  def index
    @events = Event.all
  end

  def show
    @event = Event.includes(:attendees).find(params[:id])
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
    params.require(:event).permit(:title, :description, :event_date, :location)
  end
end
