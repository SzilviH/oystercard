class Journey

  DEFAULT_MIN_FARE = 1

  attr_reader :entry_station, :oystercard, :exit_station, :journey_history
  def initialize(card)
    @entry_station = nil
    @exit_station = nil
    @oystercard = card
    @journey_history = []
  end

  def touch_in(station)
    fail "Can\'t start journey: insufficient funds" if !oystercard.sufficient_funds?
    @entry_station = station
  end

  def touch_out(station)
    @exit_station = station
  end

  def fare
    @entry_station.nil? || @exit_station.nil? ? 6 : DEFAULT_MIN_FARE
  end

  def store_journey
      @journey_history << {entry_station: @entry_station, exit_station: @exit_station }
  end
end
