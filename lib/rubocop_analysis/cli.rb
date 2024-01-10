# frozen_string_literal: true

module RubocopAnalysis
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    DEFAULT_FILE_PATH = "rubocop_output.json"
    BEGIN_F_KEY_CODE = "\e"
    CTRL_C_CODE = "\u0003"
    CARRIAGE_RETURN = "\r"
    BACKSPACE = "\u007F"
    TAB_KEY = "\t"

    FILTER_MODE = "filter_mode"
    ACTION_MODE = "action_mode"

    def initialize
      @file_name = DEFAULT_FILE_PATH
      @content = JSON.parse(File.read(@file_name))
      @result = RubocopAnalysis::Core.analyze(@content)

      @cops_filtered = []
      @files_filter = ""
      @mode = ACTION_MODE
    end

    def run
      puts @result.header
      loop do
        main_menu
        action = gets.chomp
        break if action == "q"

        send(handle_main_menu[action])
      end
    end

    private

    def main_menu
      puts <<~MAIN_MENU
        Select an option:
        (1) Show all files
        (2) Show offended files
        (3) View Offenses
        (q)uit
        Filtered classes: #{@cops_filtered}
      MAIN_MENU
    end

    def handle_main_menu
      {
        "1" => :show_all_files,
        "2" => :show_offended_files,
        "3" => :view_offenses,
        "q" => :quit,
      }
    end

    def show_all_files
      puts @result.nodes.map(&:as_hash)
    end

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
          detail_file(nodes_filtered[choice.to_i])
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

    def detail_file(node)
      puts Rainbow(node.path).green
      puts "--------------------------"
      node.offenses.each do |offense|
        puts "  #{offense.cop_name}"
        puts "  #{offense.severity}"
        puts "  #{offense.message}"
        puts "::: ::: :::"
      end
      gets.chomp
    end

    def view_offenses
      results = []
      @result.filtered_nodes([]).each do |node|
        node.offenses.each do |offense|
          results << offense.class unless results.include? offense.class
        end
      end
      # puts((1..results.count).to_a.zip(results).map { "#{_1[0]} - #{_1[1]}" })
      puts(array_with_index_map(results) { "#{_1[0]} - #{_1[1]}" })
      puts "Select an option"
      choice = 0
      choice = gets.chomp.to_i until (choice.positive? && choice <= results.count)
      selected_class = results[choice - 1]
      @cops_filtered.include?(selected_class) ? @cops_filtered.delete(selected_class) : @cops_filtered << selected_class
    end

    def digit?(str)
      code = str.ord
      # 48 is ASCII code of 0
      # 57 is ASCII code of 9
      48 <= code && code <= 57
    end

    def array_with_index_map(nodes)
      (1..nodes.count).to_a.zip(nodes).map { |node| yield node }
    end
  end
end
