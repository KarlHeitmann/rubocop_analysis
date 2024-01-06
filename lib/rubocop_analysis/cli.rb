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

      @cops_filtered = []
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
          nodes = @result.filtered_nodes(@cops_filtered)
          puts(nodes.map { "#{_1.path} # offenses: #{_1.offenses.count}" })
          puts "\nTOTAL offended files: #{nodes.count}"
        elsif action == "3"
          results = []
          nodes = @result.filtered_nodes([])
          nodes.each do |node|
            node.offenses.each do |offense|
              results << offense.class unless results.include? offense.class
            end
          end
          puts((1..results.count).to_a.zip(results).map { "#{_1[0]} - #{_1[1]}" })
          puts "Select an option"
          choice = 0
          choice = gets.chomp.to_i until (choice.positive? && choice <= results.count)
          @cops_filtered << results[choice - 1] # TODO: Add toggle, if the choice made by user already is in @cops_filtered, remove it
        end
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
      MAIN_MENU
    end
  end
end
