# frozen_string_literal: true

module RubocopAnalysis
  class CLI
    def show_offended_files
      # TODO: Add a nested menu here, so the user can type something and filter files that match the typed path.
      # The filters should be stored on instance variables
      @files_filter = +""
      nodes = @result.filtered_nodes(@cops_filtered)
      choice = +""
      loop do
        nodes_filtered = nodes.select { _1.path.include? @files_filter }
        puts(array_with_index_map(nodes_filtered) { "#{_1[0]} - #{_1[1].path} # offenses: #{_1[1].offenses.count}" })
        puts "\nTOTAL offended files: #{nodes_filtered.count}"
        puts "--- Files filter: #{@files_filter} ---"
        print(@mode == ACTION_MODE ? "> #{choice}" : Rainbow("(#{@files_filter}) > ").green)
        system("stty raw -echo")
        q = STDIN.getc
        system("stty -raw echo")

        break if q == CTRL_C_CODE

        if q == TAB_KEY
          if @mode == ACTION_MODE
            @mode = FILTER_MODE
            @files_filter = +""
          elsif @mode == FILTER_MODE
            @mode = ACTION_MODE
            choice = +""
          end
          next
        end
        if q == CARRIAGE_RETURN
          puts
          # detail_file(nodes_filtered[choice.to_i])
          # binding.pry
          puts nodes_filtered[choice.to_i].show("  ")
          gets.chomp
          choice = +""
        end
        if @mode == FILTER_MODE
          if q == BACKSPACE
            @files_filter = @files_filter[...-1]
          else
            @files_filter << q
          end
        elsif @mode == ACTION_MODE
          if q == BACKSPACE
            choice = choice[...-1]
          else
            choice << q if digit? q
          end
        end
        puts
      end
    end
  end
end
