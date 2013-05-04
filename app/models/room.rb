class Room
  MaxNumPlayers = 2
  MaxNumRooms = 100

  attr_accessor :id, :players, :game

  def initialize
    @id = first_available_room
    @players = Array.new
    @game = Game.new
  end

  def add_player(player)
    @players.push(player) if @players.count < MaxNumPlayers
  end

  def self.all
    @@room_list.values
  end

  def self.find(id)
    @@room_list[id] = Room.new if id.nil? || @@room_list[id].nil? && id <= MaxNumRooms
    @@room_list[id]
  end

  def self.add(user, id = nil)
    room = self.find(id)
    room.add_player(user)
  end

  private

  @@room_list = Hash.new

  def first_available_room
    for i in 1..MaxNumRooms
      return i unless @@room_list[i]
    end
  end
end
