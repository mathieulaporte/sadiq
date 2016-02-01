module Sadiq
  class Worker
    getter :name_space, :redis
    def initialize(@name_space)
      @id       = SecureRandom.uuid
      @registre = Sadiq::AsyncWorker.registre.clone
      @redis    = Redis.new
      subscribe
    end

    def id_key
      "#{name_space}:worker:#{self.to_s}:crystal"
    end

    def subscribe
      redis.sadd("#{name_space}:workers", "#{self.to_s}:crystal")
    end

    def unsubscribe
      redis.srem("#{name_space}:workers", "#{self.to_s}:crystal")
    end

    def to_s
      hostname = `hostname`.strip
      "#{hostname}:#{@id.to_s}"
    end

    def working_on!(job_data)
      working_on_data = {
        queue:   "crystal",
        run_at:  Time.now.to_s,
        payload: job_data
      }.to_json
      redis.set(id_key, working_on_data)
      redis.set("#{name_space}:worker:#{self.to_s}:crystal:started", 1)
    end

    def job_done!
      redis.incr("#{name_space}:stat:processed")
    end

    def process(data)
      job_data = decode(data)
      working_on!(job_data)
      klass = job_data["class"].to_s
      begin
        @registre[klass].perform!(job_data["args"])
      rescue ex
        puts ex.to_s
      ensure

      end
      job_done!
    end

    def decode(object)
      JSON.parse(object)
    end
  end
end
