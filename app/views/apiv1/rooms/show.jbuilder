if @room
  json.me do
    json.partial! 'apiv1/rooms/user', user: @user
  end

  if @room
    json.extract! @room, :id, :state

    if @room.game_start_time
      json.time_played Time.now - @room.game_start_time
    end

    other_users = @room.users.values
    other_users.delete(@user)

    json.users other_users do |item|
      json.partial! 'apiv1/rooms/user', user: item
    end
  end
elsif @last_game
  other_users = @last_game.clone
  me = other_users.delete(@user.name)

  json.me do
    json.name @user.name
    json.num_opened me
    json.test other_users.size
  end

  json.users other_users.keys do |key|
    json.name key
    json.num_opened other_users[key]
  end
end
