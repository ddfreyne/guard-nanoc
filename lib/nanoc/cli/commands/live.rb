usage 'live [options]'
summary 'start the web server, and recompile the site when changed'
description <<-EOS
Start the static web server (like `nanoc view` would), and watch for changes
in the background (like `guard start` would). See the documentation of those
two commands for details. The options are forwarded to `nanoc view` only.
EOS

required :H, :handler,       'specify the handler to use (webrick/mongrel/...)'
required :o, :host,          'specify the host to listen on (default: 0.0.0.0)'
required :p, :port,          'specify the port to listen on (default: 3000)'
flag     :L, :'live-reload', 'reload on changes'

module Nanoc::CLI::Commands
  class Live < ::Nanoc::CLI::CommandRunner
    def run
      require 'guard'
      require 'guard/commander'

      Thread.new do
        # Crash the entire process if the viewer dies for some reason (e.g.
        # the port is already bound).
        Thread.current.abort_on_exception = true
        Nanoc::CLI::Commands::View.new(options, arguments, command).run
      end

      Guard.start(no_interactions: true)
    end
  end
end

runner Nanoc::CLI::Commands::Live
