class Apiv1::RoomsController < ApplicationController
  before_filter :require_login

  def index
    @rooms = Room.all
  end

  def create
    room = Room.add(@user, params[:id])
    @result = room ? 'succeeded' : 'failed'
  end

  def show
    return if params[:id] != 'current'

    @room = @user.room
  end

  def update
    @result = 'failed'

    return if params[:id] != 'current'
    return unless params[:ready]

    ready = (params[:ready] == 'true' ? true : false)
    @user.ready = ready
    @result = 'succeeded'
  end

  def destroy
    @result = 'failed'

    return if params[:id] != 'current'

    @user.leave_room
    @result = 'succeeded'
  end
end
