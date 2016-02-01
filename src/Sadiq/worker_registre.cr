module Sadiq
  class WorkerRegistre
    @@registre = {} of String => Sadiq::AsyncWorker

    def self.register(klass)
      @@registre[self.to_s] = klass.new
    end

    def self.registre
      @@registre
    end
  end
end
