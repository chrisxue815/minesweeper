class Room
  MaxNumUsers = 2
  MaxNumRooms = 100

  attr_accessor :id, :users, :game, :state, :countdown

  def initialize(id)
    @id = id
    @users = Hash.new
    @game = Game.new
    @state = :waiting
    @countdown = 0
    @@rooms[id] = self
  end

  def add_user(user)
    if @users.size < MaxNumUsers
      user.leave_room
      user.room = self
      @users[user.name] = user
    end
  end

  def remove_user(user)
    users.delete(user.name)
    user.room = nil
    @@rooms.delete(self.id) if users.size == 0
  end

  def self.all
    @@rooms.values
  end

  def self.find(id)
    @@rooms[id]
  end

  def self.add(user, id = nil)
    if id
      id = id.to_i
      room = Room.find(id)
      room = Room.new(id) unless room
    else
      id = first_available_room
      room = Room.new(id) if id
    end

    room.add_user(user) if room

    user.room
  end

  private

  @@rooms = Hash.new

  def self.first_available_room
    for i in 1..MaxNumRooms
      return i unless @@rooms[i]
    end
  end
end
