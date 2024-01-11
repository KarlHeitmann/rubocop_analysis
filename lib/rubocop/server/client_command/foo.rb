# frozen_string_literal: true

#
# This code is based on https://github.com/fohte/rubocop-daemon.
#
# Copyright (c) 2018 Hayato Kawai
#
# The MIT License (MIT)
#
# https://github.com/fohte/rubocop-daemon/blob/master/LICENSE.txt
#
module RuboCop
  module Server
    module ClientCommand
      # This class is a client command to execute server process.
      # @api private
      class Foo < Exec
        def run
          # super
          # TODO: tweak the code snippet below (borrowed from rubocop source code) to
          # send a specific command to rubocop server. It should:
          # - [ ] Change the name of this class, from Foo to whathever you want
          # - [x] Run rubocop analysis
          # - [ ] get the result in a variable
          # - [ ] DON'T WRITE ANYTHING to STDOUT.
          # - [ ] add a param to #run with the settings rubocop server
          #       should consider to perform a ~slightly~ different
          #       analysis than what the `.rubocop.yml` file tells rubocop
          #       to do. It should ~override~ some of the rubocop rules there.
          ensure_server!
          Cache.status_path.delete if Cache.status_path.file?
          read_stdin = ARGV.include?('-s') || ARGV.include?('--stdin')
          response = send_request(
            command: 'exec',
            args: ARGV.dup,
            body: read_stdin ? $stdin.read : ''
          )
          warn stderr unless stderr.empty?
          binding.pry
          status
        end
      end
    end
  end
end
