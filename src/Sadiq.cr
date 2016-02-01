require "./Sadiq/*"
require "redis"
require "json"
require "option_parser"
require "signal"

module Sadiq

  def self.enqueu(job, args)
  end

  def self.stop!
    @@stop = true
  end

  def self.stop
    @@stop
  end

end

Signal::QUIT.trap do
  Sadiq.stop!
end

Signal::KILL.trap do
  Sadiq.stop!
end

Signal::INT.trap do
  Sadiq.stop!
  sleep(1)
  exit
end
