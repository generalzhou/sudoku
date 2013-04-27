sudokode
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
