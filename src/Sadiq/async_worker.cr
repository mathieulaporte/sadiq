module Sadiq
  abstract class AsyncWorker
    # REGISTRE = {} of String => Sadiq::AsyncWorker
    def self.register
      WorkerRegistre.register(self)
      # REGISTRE[self.to_s] = self.new
    end

    def self.registre
      # REGISTRE
      WorkerRegistre.registre
    end

    def self.enqueu(*args)
      #resquee like
      #redis.sadd("#{name_space}:queue:#{@queue}")
    end

    def self.perform_async(*args)
      #sidekiq like
      msg = {
        "class" => "MyWorker",
        "args" => [1, 2, 3],
        "jid" => SecureRandom.hex(12),
        "retry" => true,
        "enqueued_at" => Time.now.to_f
      }
      redis.lpush("namespace:queue:default", JSON.dump(msg))
    end

    def perform!(*args)
      self.class.new.perform(*args)
    end

    abstract def perform(*args)
  end
end
