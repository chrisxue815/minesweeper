class Game
  BoardWidth = 16
  BoardHeight = 16
  NumMine = 40

  attr_accessor :grids, :known_grids, :num_opened

  def initialize(users)
    @grids = Hash.new(0)

    first_opened = [Random.rand(BoardWidth), Random.rand(BoardHeight)]
    mine_left = NumMine
    grid_left = BoardWidth * BoardHeight - neighbors(first_opened).size - 1

    for y in 0...BoardHeight
      for x in 0...BoardWidth
        current = [x, y]
        rand = Random.rand(grid_left)

        if rand < mine_left && !neighbor?(current, first_opened)
          @grids[current] = :mine
          mine_left -= 1

          neighbors(current).each do |neighbor|
            @grids[neighbor] += 1 if @grids[neighbor] != :mine
          end

          break if mine_left == 0
        end
      end
    end

    #TODO
    for y in 0...BoardHeight
      for x in 0...BoardWidth
        grid = @grids[[x, y]]
        print grid == :mine ? 'm' : grid
        print ' '
      end
      puts
    end

    user_known_grids = open_blank(first_opened)

    @known_grids = Hash.new
    users.each_key do |name|
      @known_grids[name] = user_known_grids.clone
    end

    @num_opened = Hash.new(user_known_grids.size)
  end

  def open(username, x, y)
    user_known_grids = known_grids[username]
    current = [x, y]
    grid = grids[current]

    if grid == 0
      opened = open_blank(x, y, user_known_grids)
    else
      opened = {current => grid}
    end

    opened.each do |position, value|
      if user_known_grids[position]
        opened.delete(position)
      else
        user_known_grids[position] = value
        num_opened[username] += 1
      end
    end

    return opened
  end

  def mark(username, x, y)
    user_known_grids = known_grids[username]
    current = [x, y]
    if user_known_grids[current]
      return false
    else
      user_known_grids[current] = :marked
      return true
    end
  end

  def unmark(username, x, y)
    user_known_grids = known_grids[username]
    current = [x, y]
    if user_known_grids[current] == :mark
      user_known_grids.delete(current)
      return true
    else
      return false
    end
  end

  # similar to A* algorithm
  def open_blank(x, y = nil, user_known_grids = nil)
    unless user_known_grids
      user_known_grids = Hash.new
    end

    unless y
      y = x[1]
      x = x[0]
    end

    opened = Hash.new
    pending = Array.new

    pending.push([x, y])

    while pending.size > 0
      current = pending.delete_at(pending.size - 1)
      opened[current] = grids[current]

      neighbors(current).each do |neighbor|
        next if opened[neighbor]

        grid = grids[neighbor]
        known_grid = user_known_grids[neighbor]

        if grid != :mine && known_grid != :marked
          opened[neighbor] = grid
          pending.push(neighbor) if grid == 0
        end
      end
    end

    return opened
  end

  def neighbors(x, y = nil)
    unless y
      y = x[1]
      x = x[0]
    end

    left = x - 1
    right = x + 1
    top = y - 1
    bottom = y + 1

    result = Array.new
    add_if_valid(left, top, result)
    add_if_valid(x, top, result)
    add_if_valid(right, top, result)
    add_if_valid(right, y, result)
    add_if_valid(right, bottom, result)
    add_if_valid(x, bottom, result)
    add_if_valid(left, bottom, result)
    add_if_valid(left, y, result)

    return result
  end

  def add_if_valid(x, y, array)
    array.push([x, y]) if x >= 0 && x < BoardWidth && y >= 0 && y < BoardHeight
  end

  def neighbor?(p1, p2)
    (p1[0] - p2[0]).abs <= 1 && (p1[1] - p2[1]).abs <= 1
  end
end
