class UsersController < ApplicationController

  def show
    @user_id = params[:id]
    @user = User.find_by_hn_id @user_id
    LoadUserDetailsJob.perform_later @user_id
  end
end