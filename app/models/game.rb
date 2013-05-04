class Game
  BoardWidth = 16
  BoardHeight = 16
  NumMine = 40

  attr_accessor :board

  def initialize
    board = Hash.new(0)

    num_mine = 0

    while (num_mine < NumMine)
      col = Random.rand(BoardWidth)
      row = Random.rand(BoardHeight)

      if board[[col, row]] != :mine
        board[[col, row]] = :mine
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
          board[[x, y]] += 1 if board[[x, y]] != :mine
        end
      end
    end
  end
end
