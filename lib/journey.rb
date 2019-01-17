# remember to initialize with station (default nil)

class Journey

  DEFAULT_MIN_FARE = 1
  DEFAULT_PENALTY_FARE = 6

  attr_reader :entry_station, :oystercard, :exit_station
  def initialize
    @entry_station = nil
    @exit_station = nil
  end

  def start(station)
    @entry_station = station
  end

  def finish(station)
    @exit_station = station
  end

  def complete?
    !@exit_station.nil?
  end

  def fare
    @entry_station.nil? || @exit_station.nil? ? DEFAULT_PENALTY_FARE : DEFAULT_MIN_FARE
  end
end
