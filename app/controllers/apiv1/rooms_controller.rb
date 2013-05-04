class Apiv1::RoomsController < ApplicationController
  def index
    @rooms = Room.all
  end

  def create
    user = request.session_options[:id]  #TODO
    @room = Room.add(user)
  end

  def update
    user = request.session_options[:id]  #TODO
    id = params[:id]
    @room = Room.add(user, id)
  end

  def destroy
    Room.remove(user)
  end
end
