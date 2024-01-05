# frozen_string_literal: true

require "json"

# rubocop:disable Lint/SuppressedException
# This block is used to load development dependencies
# thay will not be available in production 
begin
  require "pry"
rescue LoadError
end
# rubocop:enable Lint/SuppressedException

require_relative "rubocop_analysis/version"
require_relative "rubocop_analysis/cli"

module RubocopAnalysis
  class Error < StandardError; end
  # Your code goes here...
end
