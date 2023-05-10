require 'sinatra'
require 'sinatra/streaming'
require 'json'

set :port, 1080

fifo_path = '/tmp/myfifo'
File.mkfifo(fifo_path) unless File.exists?(fifo_path)
connections = []

Thread.new do
  loop do
    # Wait for data to be available in the named pipe
    fifo = File.open(fifo_path, 'r')
    message = fifo.gets.chomp
    j = JSON.parse(message)
    fifo.close

    begin
      connections.each do |out|
        out << "event: #{j['event']}\n" if j.key?('event');
        out << "data: #{j['data'].to_json}\n\n"
      end
    rescue Exception => e
      logger.error "Error sending SSE stream: #{e.message}"
    end
  end
end

get '/' do
  puts webpage
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

def webpage
  File.read('/tmp/mydash')
end
