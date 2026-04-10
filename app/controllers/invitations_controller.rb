class InvitationsController < ApplicationController
  before_action :authenticate_user!

  def create
    @event = Event.find(params[:event_id])
    
    unless @event.creator == current_user
      redirect_to @event, alert: "Only the event creator can invite users."
      return
    end

    @invitation = @event.invitations.build(invitation_params)

    if @invitation.save
      redirect_to @event, notice: "#{@invitation.invitee.email} was successfully invited."
    else
      redirect_to @event, alert: @invitation.errors.full_messages.to_sentence
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:invitee_id)
  end
end
