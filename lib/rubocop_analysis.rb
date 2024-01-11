# frozen_string_literal: true

require "json"
require "rainbow"

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
require_relative "rubocop_analysis/cli/show_offended_files"
require_relative "rubocop_analysis/cops/base"
require_relative "rubocop_analysis/cops/unknown"
require_relative "rubocop_analysis/cops/metrics/method_length"
require_relative "rubocop_analysis/offense"
require_relative "rubocop_analysis/core"
require_relative "rubocop_analysis/node"

module RubocopAnalysis
  class Error < StandardError; end
  # Your code goes here...
end
