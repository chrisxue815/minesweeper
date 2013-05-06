class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body

  attr_accessor :room

  def ready
    @ready
  end

  def ready=(ready)
    @ready = ready
    @room.start_if_all_ready if ready && @room
  end

  def name
    @email
  end

  def name=(value)
    @email = value
  end

  def game
    @room.game
  end

  def grids
    @room.game.grids
  end

  def known_grids
    @room.game.known_grids[name] if @room && @room.game
  end

  def num_opened
    @room.game.num_opened[name] if @room && @room.game
  end

  def open(x, y)
    @room.open(x, y, name) if @room
  end

  def mark(x, y)
    @room.game.mark(x, y, name) if @room && @room.game
  end

  def unmark(x, y)
    @room.game.unmark(x, y, name) if @room && @room.game
  end

  def initialize
    reset
  end

  def reset
    @ready = false
  end

  def enter_room(room)
    room.add_user(self)
  end

  def leave_room
    if @room
      @room.remove_user(self)
    end
  end
end
