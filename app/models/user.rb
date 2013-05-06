class User
  attr_accessor :name, :room

  def ready
    @ready
  end

  def ready=(ready)
    @ready = ready
    @room.start_if_all_ready if ready && @room
  end

  def game
    @room.game
  end

  def grids
    @room.game.grids
  end

  def known_grids
    @room.game.known_grids[@name] if @room && @room.game
  end

  def num_opened
    @room.game.num_opened[@name] if @room && @room.game
  end

  def open(x, y)
    @room.open(x, y, @name) if @room
  end

  def mark(x, y)
    @room.game.mark(x, y, @name) if @room && @room.game
  end

  def unmark(x, y)
    @room.game.unmark(x, y, @name) if @room && @room.game
  end

  def initialize(name)
    @name = name
    @@users[name] = self
    self.reset
  end

  def reset
    @ready = false
  end

  def self.find(name)
    @@users[name]
  end

  def enter_room(room)
    room.add_user(self)
  end

  def leave_room
    if @room
      @room.remove_user(self)
    end
  end

  private

  @@users = Hash.new
end
