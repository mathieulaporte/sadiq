module Sadiq
  abstract class AsyncWorker
    # REGISTRE = {} of String => Sadiq::AsyncWorker
    def self.register
      WorkerRegistre.register(self)
      # REGISTRE[self.to_s] = self.new
    end

    def self.registre
      WorkerRegistre.register(self)
    end

    def self.enqueu(*args)
      #redis.sadd("#{name_space}:queue:#{@queue}")
    end

    def self.perform_async(*args)
    end

    def perform!(*args)
      self.class.new.perform(*args)
    end

    abstract def perform(*args)
  end
end
