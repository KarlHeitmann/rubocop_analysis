# frozen_string_literal: true

module RubocopAnalysis
  # The CLI is a class responsible of handling all the command line interface
  # logic.
  class CLI
    DEFAULT_FILE_PATH = "rubocop_output.json"
    def initialize
      @file_name = DEFAULT_FILE_PATH
      @content = JSON.parse(File.read(@file_name))
    end

    def run
      puts "================================================================"
      puts "Parsed '#{@file_name}' file successfully"
      puts "-------"
      puts @content["summary"]
      puts "-------"
      puts @content["metadata"]
      puts
      while true
        main_menu
        action = gets.chomp
        break if action == "q"

        if action == "1"
          puts @content.keys
          puts @content["files"]
        end
      end
    end

    private

    def main_menu
      puts <<~MAIN_MENU
        Select an option:
        (1) Show offended files
        (q)uit
      MAIN_MENU
    end
  end
end
