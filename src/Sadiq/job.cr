require "json"
require "secure_random"
module Sadiq
  class Job
    getter :data, :redis, :name_space

    def initialize(data, @name_space)
      @id       = SecureRandom.uuid
      @data     = decode(data)
      @redis    = Redis.new
      @registre = Sadiq::AsyncWorker.registre.clone
      redis.sadd("#{name_space}workers", "#{self.to_s}:crystal")
    end

    def to_s
      "sadiq:#{@id.to_s}"
    end

    def working_on!
      working_on_data = {
        queue:   "crystal",
        run_at:  Time.now.to_s,
        payload: data
      }.to_json
      redis.set("#{name_space}worker:#{self.to_s}:crystal", working_on_data)
      redis.set("#{name_space}worker:#{self.to_s}:crystal:started", 1)
    end

    def job_done!
      redis.incr("#{name_space}stat:processed")
    end

    def perform
      working_on!
      klass = @data["class"].to_s
      @registre[klass].perform(@data["args"])
      job_done!
    end

    def decode(object)
      JSON.parse(object)
    end
  end
end
