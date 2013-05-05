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

  def leave_room
    @room.users.delete(self)
    @room = nil
  end

  private

  @@users = Hash.new
end
