class Oystercard

  attr_reader :balance, :limit, :entry_station, :journey_history, :current_journey
  LIMIT = 90
  MIN_BALANCE = 1

  def initialize(journey = Journey)
    @balance = 0
    @limit = LIMIT
    @min_balance = MIN_BALANCE
    @entry_station = nil
    @exit_station = nil
    @journey_history = []
    @current_journey = journey.new
  end

  def top_up(value)
    limit_exceeded?(value)
    @balance += value
  end

  def touch_in(station)
    fail "Can\'t start journey: insufficient funds" if !sufficient_funds?

    # fail "Can\'t touch in: card already in use" if entry_station != nil
    @current_journey.start(station)
  end


  def touch_out(station)
    @current_journey.finish
    deduct(@current_journey.fare)
    store_journey
    # @current_journey = journey.new
  end

  private

  def sufficient_funds?
    balance >= @min_balance
  end

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

end
