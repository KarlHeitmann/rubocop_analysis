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
      loop do
        main_menu
        action = gets.chomp
        break if action == "q"

        if action == "1"
          puts @content["files"]
        elsif action == "2"
          filtered_files = @content["files"].select { _1["offenses"].any? }
          # puts "#{filtered_files} # offenses: #{filte}"
          puts(filtered_files.map { "#{_1["path"]} # offenses: #{_1["offenses"].count}" })
          puts "\nTOTAL offended files: #{filtered_files.count}"
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
