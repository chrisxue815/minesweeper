object @room

attributes :id, :state, :countdown

node :users do
  @users
end
