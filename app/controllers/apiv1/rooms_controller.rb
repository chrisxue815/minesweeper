class Apiv1::RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def create
    @room = Room.new
  end

  def update
    @room = Room.find(params[:id])
  end
end
