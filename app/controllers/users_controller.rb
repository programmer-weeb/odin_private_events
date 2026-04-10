class UsersController < ApplicationController
  before_action :authorize_creator!, only: %i[show]
  def show
    @user = User.find(params[:id])
  end

  def authorize_creator!
    unless User.find(params[:id]) == current_user
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end
end
