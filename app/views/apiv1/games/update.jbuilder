if @grids
  json.array! @grids.keys do |position|
    json.x position[0]
    json.y position[1]
    json.value @grids[position]
  end
elsif @result
  json.result @result
end
