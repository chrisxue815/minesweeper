json.array! @known_grids.keys do |position|
  json.x position[0]
  json.y position[1]
  json.value @known_grids[position]
end
