module Sadiq
  module Stat
    extend self

    def redis
      
    end

    def [](stat)
      get(stat)
    end

    def incr(stat)
      redis.incrby("stat:#{stat}", by)
    end

    def <<(stat)
      incr stat
    end
  end
end
