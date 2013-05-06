json.extract! user, :name, :ready

if user.num_opened
  json.num_opened user.num_opened
end
