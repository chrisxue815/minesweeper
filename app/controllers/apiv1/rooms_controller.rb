class Apiv1::RoomsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def index
    @rooms = Room.all
  end

  def create
    room = Room.add(@user, params[:id])
    @result = room ? 'succeeded' : 'failed'
  end

  def show
    case params[:id]
    when 'current'
      @room = @user.room
    when 'last'
      @last_game = @user.room.last_game
    end
  end

  def update
    @result = 'failed'

    return if params[:id] != 'current'

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
