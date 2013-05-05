class Apiv1::RoomsController < ApplicationController
  before_filter :require_login

  def index
    @rooms = Room.all
  end

  def create
    room = Room.add(@user)
    @result = room ? 'succeeded' : 'failed'
  end

  def update
    room = Room.add(@user, params[:id])
    @result = room ? 'succeeded' : 'failed'
  end
end
