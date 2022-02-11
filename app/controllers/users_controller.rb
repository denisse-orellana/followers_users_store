class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  def index
    # @follower_suggestions = User.where.not(id: current_user.id)
    @follower_suggestions = User.all
  end

  def show
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end