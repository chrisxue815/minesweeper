class Apiv1::GamesController < ApplicationController
  before_filter :require_login

  def show
    return if params[:id] != 'current'

    @known_grids = @user.known_grids
  end

  def update
    return if params[:id] != 'current'

    x = params[:x].to_i
    y = params[:y].to_i

    case params[:operation]
    when 'open'
      @user.open(x, y)
    when 'mark'
      @user.mark(x, y)
    end
  end
end
