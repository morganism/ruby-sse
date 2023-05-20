#!/usr/bin/env ruby
#
# @author: morgan.sziraki@gmail.com
# @date: Sat 20 May 2023 15:26:24 BST

=begin

https://www.w3.org/TR/2012/WD-eventsource-20120426/#the-eventsource-interface
=end

require 'json'
require 'optparse'

# '{"id": "0002", "event": "number", "data": {"x": "1", "y": "30", "i": "r0"}}'

class EventSource

  def initialize(options = {})
    @count = options.count

  end

  def id
    Time.now.to_f
  end
end

# if running as a script
if __FILE__ == $0
  options = OpenStruct.new

  OptionParser.new do |opts|
    opts.banner = 'Usage: event_source.rb OPTIONS'
    opts.on('-c', '--count #','send this many time') { |o| options.count = o }
    opts.on_tail('-h', '--help') {
      puts opts
      exit
    }
  end.parse!

  puts EventSource.new(options)
end
