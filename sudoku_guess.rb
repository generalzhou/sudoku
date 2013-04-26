# NOT COMPLETE


require 'pry'
require 'debugger'
class Sudoku
  
  attr_reader :board

  def initialize(board_string)
    @board = Board.new(board_string)
  end

  def solve2(test_board = @board.clone)
    return test_board if test_board.solved?

    # binding.pry
    puts test_board

    test_board.board_map.each_with_index do |row, y|

      row.each_with_index do |cell, x|
        return test_board if test_board.solved? 
        if cell == 0
          
          possible = possible_values(x , y, test_board)          

          return false if possible.empty?

          possible.each do |test_case|

            test_board.board_map[y][x] = test_case
            
            solve(test_board.clone) unless test_board.solved? 

          end
        end
      end
    end
  end


  def solve(test_board = @board.clone)


    test_board.board_map.each_with_index do |row, y|
      row.each_with_index do |cell, x|
        return test_board if test_board.solved?

        if cell == 0
          puts test_board
          possible = possible_values(x, y, test_board)

          possible.each do |test_case|
          clone_test_board = test_board.clone
          clone_test_board.board_map[y][x] = test_case

          solve(clone_test_board) unless clone_test_board.solved? 
          end
        end
      end
    end
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
