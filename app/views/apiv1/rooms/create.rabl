object @room

node :result do |item|
  item ? 'succeeded' : 'failed'
end
