class UsersController < ApplicationController
  before_action :set_user, only: %i[show]
  before_action :authorize_creator!, only: %i[show]

  def show
    @past_attended_events = @user.attended_events.past
    @upcoming_attended_events = @user.attended_events.upcoming
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_creator!
    unless @user == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
