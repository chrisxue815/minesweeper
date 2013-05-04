object @room

attributes :id

node :num_players do |item|
  item.players.count{ |x| x }
end
