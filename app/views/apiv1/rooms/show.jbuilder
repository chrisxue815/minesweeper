json.me do
  json.partial! 'apiv1/rooms/user', user: @user
end

if @room
  json.extract! @room, :id, :state

  if @room.game_start_time
    json.time_played Time.now - @room.game_start_time
  end

  json.users @room.users.values do |item|
    if item != @user
      json.partial! 'apiv1/rooms/user', user: item
    end
  end
end
