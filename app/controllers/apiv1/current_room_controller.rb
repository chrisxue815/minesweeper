class Apiv1::CurrentRoomController < ApplicationController
  before_filter :require_login

  def index
    @room = @user.room
    @users = Hash.new
    @room.users.each_value do |user|
      @users[user.name] = {ready: user.ready}  #TODO: remove this ugly code
    end
  end

  def update
    @user.ready = params[:ready] if params[:ready]
  end

  def destroy
    @user.leave_room
    @result = 'succeeded'
  end
end
