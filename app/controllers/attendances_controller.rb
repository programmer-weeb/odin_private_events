class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event

  def create
    @attendance = @event.attendances.build(attendee: current_user)

    if @attendance.save
      redirect_to @event, notice: "You are now attending this event!"
    else
      redirect_to @event, alert: @attendance.errors.full_messages.to_sentence
    end
  end

  def destroy
    @attendance = @event.attendances.find_by(attendee_id: current_user.id)
    
    if @attendance&.destroy
      redirect_to @event, notice: "You are no longer attending this event.", status: :see_other
    else
      redirect_to @event, alert: "You are not an attendee of this event."
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end
end
