require 'oystercard'

describe Oystercard do

  let(:station) { double :station }
  let(:station2) { double :station2 }
  let(:station3) { double :station3 }
  let(:station4) { double :station4 }
  let(:card_with_10) { subject.top_up(10) ; subject }
  let(:card_in_journey) {card_with_10.touch_in(station, journey_class) ; subject}
  let(:card_with_one_journey) {card_in_journey.touch_out(2, station2) ; subject}
  let(:card_with_two_journeys) do
    card_with_one_journey.touch_in(station3, journey_class)
    card_with_one_journey.touch_out(2, station4)
    subject
  end
  let(:journey) {double(:journey, finish: nil, fare: 1)}
  let(:journey_class) {double(:journey_class, new: journey)}
  let(:@current_journey) {}


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

  describe "#touch_in" do
    it "touch in checks if it has sufficient funds" do
      subject.top_up(Oystercard::MIN_BALANCE - 0.01 )
      expect {subject.touch_in(station)}.to raise_error "Can\'t start journey: insufficient funds"
    end
    it "tels current journey to start" do
      card = Oystercard.new(journey_class)
      card.top_up(10)
      expect(journey).to receive(:start).with(station)
      card.touch_in(station)
    end

    it "store current journey" do
      card_with_10.touch_in(station, journey_class)
      expect(card_with_10.current_journey).to eq journey
    end
  end

  describe "#touch out" do
    it "should tell current journey to finish" do
      expect(card_in_journey.current_journey).to receive(:finish)
      card_in_journey.touch_out(station)
    end
    it "should ask the current journey what the fare was" do
      card = Oystercard.new(journey_class)
      expect(card.current_journey).to receive(:fare)
      card.touch_out(station)
    end
    it "should deduct the fare from balance" do
      card = Oystercard.new(journey_class)
      card.top_up(10)
      card.touch_out(station)
      expect(card.balance).to eq 9
    end
  end



  # some test for touch in when there is enough balance

  it "will store journeys in journey history" do
    expect(card_with_one_journey.journey_history).to eq [{entry_station: station, exit_station: station2}]
  end

  it "will store multiple journeys" do
    expect(card_with_two_journeys.journey_history).to eq [{entry_station: station, exit_station: station2},
       {entry_station: station3, exit_station: station4}]
  end

end
