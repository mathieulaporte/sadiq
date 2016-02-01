require "colorize"
module Sadiq
  class Processor
    getter :redis, :channel, :name_space, :workers

    def initialize
      @redis       = Redis.new
      @channel     = Channel(String).new
      @concurrency = 25
      @queue       = "*"
      @name_space  = "resque"
      @workers     = [] of Worker
      parse!
    end

    def parse!
      OptionParser.parse! do |parser|
        parser.on("-c CONCURRENCY", "--to=CONCURRENCY", "Specifies the concurrency") { |concurrency| @concurrency = concurrency.to_i }
        parser.on("-q QUEUE", "--to=QUEUE", "Queue") { |queue| @queue = queue }
        parser.on("-n NS", "--to=NS", "Namespace") { |ns| @name_space = "#{name_space}:#{ns}" }
      end
    end

    def pop_job
      redis.lpop("#{name_space}:queue:#{@queue}")
    end

    def loop_for_jobs
      loop do
        break if Sadiq.stop
        while data = pop_job
          channel.send(data)
        end
        sleep 1
      end
      @workers.each { |w| w.unsubscribe }
    end

    def run
      puts "Start #{@concurrency} workers, working on #{@queue}".colorize(:green)
      puts "Checking #{name_space}:queue:#{@queue}"
      @concurrency.times do
        spawn do
          worker = Worker.new(name_space)
          workers << worker
          loop do
            data = channel.receive
            begin
              worker.process(data)
            rescue ex
              puts ex
            end
          end
        end
      end
      loop_for_jobs
    end
  end
end
