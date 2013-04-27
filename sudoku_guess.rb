# NOT COMPLETE


require 'pry'
require 'debugger'
class Sudoku
  
  attr_reader :board

  def initialize(board_string)
    @board = Board.new(board_string)
  end

  def solve(test_board = @board.clone)
    puts test_board
    x = 0

    y = test_board.board_map.find_index do |row| 

      x = row.find_index do |cell|
        cell == 0
      end
    end

    possibles = possible_values(x, y, test_board)
    

    possibles.each do |test_case|
      test_board_clone = test_board.clone
      test_board_clone.board_map[y][x] = test_case
      return solve(test_board_clone) if solve(test_board_clone)
       
    end
    return test_board if test_board.solved?
  end

  
  def possible_values(x_coord, y_coord, test_board)
    possibles =[]
    (1..9).each do |number|
      possibles << number if not_in_row?(number, y_coord,test_board) \
                          && not_in_column?(number, x_coord, test_board) \
                          && not_in_box?(number, x_coord, y_coord, test_board)
    end
    return possibles
  end

  def not_in_row?(number, row, test_board)
    !test_board.board_map[row].include?(number)
  end

  def not_in_column?(number, column, test_board)
    test_board.board_map.none? { |row| row[column] == number }
  end

  def not_in_box?(number, x, y, test_board)
    starting_x = (x/3) * 3 
    starting_y = (y/3) * 3
    (starting_y..starting_y +2).all? do |y_coord|
      (starting_x..starting_x+2).none? do |x_coord|
        test_board.board_map[y_coord][x_coord] == number
      end
    end
  end

end

class Board
  attr_accessor :board_map
  
  def initialize(board_string)
    @board_map = board_string.split('').each_slice(9).to_a
    @board_map.map! { |row| row.map(&:to_i) }
  end

  def to_s
    puts ''
    @board_map.each do |row|
      puts row.join(' | ')
      puts "__________________________________"
    end
  end
  
  def solved?
    @board_map.flatten.none? {|cell| cell == 0}
  end

  def clone
    board_string = @board_map.flatten.join
    Board.new(board_string)
  end
end

board_string = File.readlines('sample.unsolved.txt')[1].chomp

game = Sudoku.new(board_string)


# Remember: this will just fill out what it can and not "guess"
p game.solve

puts game.board
