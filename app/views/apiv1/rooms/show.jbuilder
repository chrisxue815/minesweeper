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
  my_num_opened = @last_game.delete(@user.name)

  json.me do
    json.name @user.name
    json.num_opened = my_num_opened
  end

  json.users @last_game do |key, value|
    json.name key
    json.num_opened value
  end
end
