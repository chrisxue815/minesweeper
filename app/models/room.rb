class Room
  MaxNumPlayers = 2
  MaxNumRooms = 100

  attr_accessor :id, :players, :game

  def initialize
    id = first_available_room
    @@room_list[id] = self

    players = Array.new(MaxNumPlayers)
    game = Game.new
  end

  def self.all
    @@room_list
  end

  def self.find(id)
    @@room_list[id]
  end

  private

  @@room_list = Hash.new

  def first_available_room
    for i in 0...MaxNumRooms
      return i unless @@room_list[i]
    end
  end
end
