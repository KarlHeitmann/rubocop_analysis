# frozen_string_literal: true

module RubocopAnalysis
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    DEFAULT_FILE_PATH = "rubocop_output.json"
    def initialize
      @file_name = DEFAULT_FILE_PATH
      @content = JSON.parse(File.read(@file_name))
      @result = RubocopAnalysis::Core.analyze(@content)
    end

    def run
      puts @result.header
      loop do
        main_menu
        action = gets.chomp
        break if action == "q"

        if action == "1"
          puts @result.nodes.map(&:as_hash)
        elsif action == "2"
          nodes = @result.filtered_nodes
          puts nodes.map { "#{_1.path} # offenses: #{_1.offenses.count}" }
          puts "\nTOTAL offended files: #{nodes.count}"
        end
      end
    end

    private

    def main_menu
      puts <<~MAIN_MENU
        Select an option:
        (1) Show all files
        (2) Show offended files
        (q)uit
      MAIN_MENU
    end
  end
end
