class Apiv1::RoomsController < ApplicationController
  before_filter :require_login

  NumSecondsCountdown = 5

  def index
    @rooms = Room.all
  end

  def create
    room = Room.add(@user, params[:id])
    @result = room ? 'succeeded' : 'failed'
  end

  def show
    return if params[:id] != 'current'

    @users = Hash.new
    @room = @user.room

    @room.users.each_value do |user|
      @users[user.name] = {ready: user.ready}  #TODO: remove this ugly code
    end
  end

  def update
    return if params[:id] != 'current'

    room = @user.room

    if params[:ready]
      @user.ready = params[:ready]

      if room.state == :waiting
        ready_users = room.users.select {|k,v| v.ready}
        if ready_users.size == Room.MaxNumUsers
          room.state = :countdown
          room.countdown = Time.now + NumSecondsCountdown
        end
      end
    end
  end

  def destroy
    return if params[:id] != 'current'

    @user.leave_room
    @result = 'succeeded'
  end
end
