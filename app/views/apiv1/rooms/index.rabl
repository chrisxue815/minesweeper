collection @rooms

attributes :id

node :num_users do |item|
  item.users.count{ |x| x }
end
