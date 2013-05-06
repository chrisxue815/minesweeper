class Apiv1::GamesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :require_login
  skip_before_filter :verify_authenticity_token

  def show
    return if params[:id] != 'current'

    @grids = @user.known_grids
  end

  def update
    return if params[:id] != 'current'

    x = params[:x].to_i
    y = params[:y].to_i

    case params[:operation]
    when 'open'
      @grids = @user.open(x, y)
    when 'mark'
      result = @user.mark(x, y)
      @result = result ? 'succeeded' : 'failed'
    when 'unmark'
      result = @user.unmark(x, y)
      @result = result ? 'succeeded' : 'failed'
    end
  end
end
