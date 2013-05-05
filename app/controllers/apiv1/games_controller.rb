class Apiv1::GamesController < ApplicationController
  def show
    return if params[:id] != 'current'
  end

  def update
    return if params[:id] != 'current'
  end
end
