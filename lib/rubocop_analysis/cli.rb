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
      server_cli = RuboCop::Server::CLI.new
      # It must have the --server flag in order to run with server
      # binding.pry
      # REFACTOR: maybe two lines below could use ternary? like:
      # total_options = ARGV.include? "--server" ? ARGV : ARGV + "[--server"]
      total_options = ARGV
      total_options << "--server" unless ARGV.include? "--server"
      exit_status = server_cli.run(argv = total_options)
      # exit exit_status if server_cli.exit?

      # This runs if rubocop server is running
      if RuboCop::Server.running?
        # Enjoy this breakpoint to run this command:
        # > RuboCop::Server::ClientCommand::Foo.new.run
        # and see the rubocop static analysis results on screen.
        binding.pry
        exit_status = RuboCop::Server::ClientCommand::Foo.new.run
      end
      exit exit_status

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
