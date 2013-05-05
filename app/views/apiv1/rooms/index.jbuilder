json.array! @rooms do |item|
  json.extract! item, :id
  json.num_users item.users.size
end
