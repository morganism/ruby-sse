require 'sinatra'
require 'sinatra/streaming'
require 'json'

set :port, 1080

fifo_path = '/tmp/myfifo'
File.mkfifo(fifo_path) unless File.exists?(fifo_path)
connections = []

class Logger
	def self.info(msg)
    puts msg
	end

	def self.error(msg)
    puts msg
	end
end
logger = Logger.new

Thread.new do
  loop do
    # Wait for data to be available in the named pipe
    fifo = File.open(fifo_path, 'r')
    message = JSON.parse(fifo.gets.chomp)
    fifo.close

    begin
      connections.each do |out|
        out << "id: #{message['id']}\n" if message.key? 'id'
        out << "event: #{message['event']}\n" if message.key? 'event'
        out << "data: #{message['data'].to_json}\n\n" if message.key? 'data'
      end
    rescue Exception => e
      logger.error "Error sending SSE stream: #{e.message}"
    end
  end
end

get '/stream', provides: 'text/event-stream' do
  stream :keep_open do |out|
    connections << out

    out.callback do
      logger.info 'Connection closed'
      connections.delete(out)
    end
  end
end

get '/' do
  erb :default
end

get '/help' do
  erb :help
end

