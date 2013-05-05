class Game
  BoardWidth = 16
  BoardHeight = 16
  NumMine = 40

  attr_accessor :grids

  def initialize
    @grids = Hash.new(0)

    num_mine = 0

    while (num_mine < NumMine)
      col = Random.rand(BoardWidth)
      row = Random.rand(BoardHeight)

      if @grids[[col, row]] != :mine
        @grids[[col, row]] = :mine
        num_mine += 1

        top = row - 1
        bottom = row + 1
        left = col - 1
        right = col + 1

        neighbors = [[left, top], [col, top], [right, top], [right, row],
          [right, bottom], [col, bottom], [left, bottom], [left, row]]

        neighbors.each do |grid|
          x = grid[0]
          y = grid[1]
          @grids[[x, y]] += 1 if @grids[[x, y]] != :mine
        end
      end
    end
  end
end
