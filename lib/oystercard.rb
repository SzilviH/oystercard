class Oystercard

  attr_reader :balance, :limit, :entry_station, :journey_history
  LIMIT = 90
  MIN_BALANCE = 1

  def initialize
    @balance = 0
    @limit = LIMIT
    @min_balance = MIN_BALANCE
    @entry_station = nil
    @exit_station = nil
    @journey_history = []
  end

  def top_up(value)
    limit_exceeded?(value)
    @balance += value
  end

  def touch_in(station)
    fail "Can\'t touch in: card already in use" if entry_station != nil
    sufficient_funds?
    @entry_station = station
  end

  def touch_out(fare, station)
    fail "Can\'t touch out without touching in first" if entry_station == nil
    deduct(fare)
    @exit_station = station
    store_journey
    @entry_station = nil
  end


  private

  def store_journey
      journey = {entry_station: @entry_station, exit_station: @exit_station }
      @journey_history << journey
  end

  def deduct(fare)
    @balance -= fare
  end

  def limit_exceeded?(value)
    fail "This exceeds the £#{limit} limit" if balance + value > limit
  end

  def sufficient_funds?
    fail "Can\'t start journey: insufficient funds" if balance <= @min_balance
  end

end
