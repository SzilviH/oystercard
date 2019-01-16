require 'journey'

describe Journey do
  let(:station) {double :station}
  let(:station2) {double :station2}
  let(:card_without_balance)    {double :card, sufficient_funds?: false }
  let(:card_with_balance) {double :card, sufficient_funds?: true }
  let(:journey) {Journey.new(card_with_balance)}
  let(:complete_journey) {journey.touch_in(station); journey.touch_out(station2); journey}

  it "checks if it has sufficient funds to start journey" do
    expect{ Journey.new(card_without_balance).touch_in(station) }.to raise_error "Can\'t start journey: insufficient funds"
  end

  it "will charge fare of 6 if touched out without being touched in" do
    journey.touch_out(station)
    expect(journey.fare).to eq 6
  end

  it "will charge fare of 6 if touched in but not touched out" do
    journey.touch_in(station)
    expect(journey.fare).to eq 6
  end

  it "fare should be default minimum if entry and exit station present" do
    expect(complete_journey.fare).to eq Journey::DEFAULT_MIN_FARE
  end

  it "will remember the entry station after touch in" do
    journey.touch_in(station)
    expect(journey.entry_station).to eq station
  end

  it "will store journeys in journey history" do
    expect(complete_journey.store_journey).to eq [{entry_station: station, exit_station: station2}]
  end
end
