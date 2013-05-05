class User
  attr_accessor :name, :room

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

  def ready
    @ready
  end

  def ready=(ready)
    @ready = ready
    @room.check_all_ready if ready && @room
  end

  private

  @@users = Hash.new
end
