object @room

attributes :id, :state

node :time_played do
  Time.now - @room.game_start_time if @room && @room.game_start_time
end

node :me do
end

node :users do
  @users
end
