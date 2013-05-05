class Room
  MaxNumUsers = 2
  MaxNumRooms = 100

  attr_accessor :id, :users, :game

  def initialize(id)
    @id = id
    @users = Hash.new
    @game = Game.new
    @@rooms[id] = self
  end

  def add(user)
    if @users.size < MaxNumUsers
      user.room = self
      @users[user.name] = user
    end
  end

  def self.create
    id = first_available_room
    Room.new(id) if id
  end

  def self.all
    @@rooms.values
  end

  def self.find(id)
    @@rooms[id]
  end

  def self.add(user, id = nil)
    room = id ? Room.find(id) : Room.create
    room.add(user) if room

    return user.room
  end

  private

  @@rooms = Hash.new

  def self.first_available_room
    for i in 1..MaxNumRooms
      return i unless @@rooms[i]
    end
  end
end
