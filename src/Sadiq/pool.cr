module Sadiq
  class Pool
    def initialize(size, timeout, proc)
      @pool     = [proc.call]
      size.times do
        @pool << proc.call
      end
      @timeout   = timeout
      @semaphore = Mutex.new
      @mutex     = Mutex.new
      @free = [] of Int32
      size.times do |i|
        @free << i
      end
    end

    def with
      i = @mutex.synchronize do
        @free.pop
      end
      @semaphore.synchronize do
        yield @pool[i]
      end
      @free << i
    end
  end
end
