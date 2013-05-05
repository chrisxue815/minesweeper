class User
  attr_accessor :room, :name, :ready

  def initialize(name)
    @name = name
    @ready = false
    @@users[name] = self
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
