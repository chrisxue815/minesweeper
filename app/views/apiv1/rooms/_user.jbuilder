json.extract! user, :name, :ready

if user.num_opened
  json.extract! user, :num_opened
end
