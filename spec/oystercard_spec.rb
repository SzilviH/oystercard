require 'oystercard'

describe Oystercard do

  let(:station) { double :station }
  let(:station2) { double :station2 }
  let(:station3) { double :station3 }
  let(:station4) { double :station4 }
  let(:card_with_10) { subject.top_up(10) ; subject }
  let(:card_in_journey) {card_with_10.touch_in(station) ; subject}
  let(:card_with_one_journey) {card_in_journey.touch_out(2, station2) ; subject}
  let(:card_with_two_journeys) do
    card_with_one_journey.touch_in(station3)
    card_with_one_journey.touch_out(2, station4)
    subject
  end


  it "has a 0 balance when a new card is initialized" do
    expect(subject.balance).to eq 0
  end

  it "has an empty journey_history array when initialized" do
    expect(subject.journey_history).to eq []
  end

  it "amends the card balance when the top up method is called" do
    expect(card_with_10.balance).to eq 10
  end

  it "will raise an error if the user tries to top up the card beyond a limit" do
    expect{ subject.top_up(subject.limit + 1) }.to raise_error "This exceeds the £#{subject.limit} limit"
  end

  it "sufficient_funds method checks that balance is >= minimum balance" do
    subject.top_up(Oystercard::MIN_BALANCE)
    expect(subject.sufficient_funds?).to eq true
  end

  it "sufficient_funds returns false if balance is < minimum balance" do
    subject.top_up(Oystercard::MIN_BALANCE-0.5)
    expect(subject.sufficient_funds?).to eq false
  end

  it "will raise an error if user tries to touch out without touching in first" do
    expect{ card_with_10.touch_out(2, station)}.to raise_error "Can\'t touch out without touching in first"
  end

  it "will raise an error if user tries to touch in and the card is already in use" do
    expect{ card_in_journey.touch_in(station) }.to raise_error "Can\'t touch in: card already in use"
  end

  it "should deduct a fare from the card balance when the touch_out method is called" do
    expect(card_with_one_journey.balance).to eq 8
  end

  it "will remember the entry station after touch in" do
    expect(card_in_journey.entry_station).to eq station
  end

  it "will reset the entry station to nil after touching out" do
    expect(card_with_one_journey.entry_station).to eq nil
  end

  it "will store journeys in journey history" do
    expect(card_with_one_journey.journey_history).to eq [{entry_station: station, exit_station: station2}]
  end

  it "will store multiple journeys" do
    expect(card_with_two_journeys.journey_history).to eq [{entry_station: station, exit_station: station2},
       {entry_station: station3, exit_station: station4}]
  end

end
