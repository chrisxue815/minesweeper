class Room
  MaxNumUsers = 2
  MaxNumRooms = 100
  NumSecondsCountdown = 5

  attr_accessor :id, :users, :game, :state, :game_start_time, :last_game

  def initialize(id)
    @id = id
    @users = Hash.new
    @state = :waiting
    @@rooms[id] = self
  end

  def add_user(user)
    return if @state == :running

    if @users.size < MaxNumUsers
      user.leave_room
      user.reset
      user.room = self
      @users[user.name] = user
    end
  end

  def remove_user(user)
    return if @state == :running

    @users.delete(user.name)
    user.room = nil
    @@rooms.delete(self.id) if @users.size == 0
  end

  def start_if_all_ready
    return if @state == :running

    ready_users = @users.select {|k,v| v.ready}

    if ready_users.size == MaxNumUsers
      @state = :running
      @game_start_time = Time.now + NumSecondsCountdown
      @game = Game.new(@users)
    end
  end

  def open(x, y, username)
    return unless @game

    opened = @game.open(x, y, username)

    restart_if_win(username)

    return opened
  end

  def restart_if_win(username)
    return if @game.num_opened[username] < Game::NumSafeGrids

    @last_game = @game.num_opened

    @users.each_value do |item|
      item.ready = false
    end

    @state = :waiting
    @game = nil
    @game_start_time = nil
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
