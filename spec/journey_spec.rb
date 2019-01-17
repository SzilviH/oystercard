require 'journey'

describe Journey do
  let(:station) {double :station}
  let(:station2) {double :station2}

  context "on creation" do
    it "has a fare of default penalty fare" do
      expect(subject.fare).to eq Journey::DEFAULT_PENALTY_FARE
    end
    it "will not be complete" do
      expect(subject).not_to be_complete
    end
  end

  context "after starting journey" do
    it "will remember the entry station" do
      subject.start(station)
      expect(subject.entry_station).to eq station
    end

    it "will not be complete" do
      expect(subject).not_to be_complete
    end

    it "will default fare to penalty fare" do
      expect(subject.fare).to eq Journey::DEFAULT_PENALTY_FARE
    end
  end

  context "finishing journey after starting journey" do
    let(:complete_journey) {subject.start(station); subject.finish(station2); subject}
    it "will remember the exit station" do
      expect(complete_journey.exit_station).to eq station2
    end

    it "fare should be default to minimum" do
      expect(complete_journey.fare).to eq Journey::DEFAULT_MIN_FARE
    end

    it "should be complete" do
      expect(complete_journey).to be_complete
    end
  end

  context "finishing journey without entry_station" do
    it "will charge default penalty fare" do
      subject.finish(station2)
      expect(subject.fare).to eq Journey::DEFAULT_PENALTY_FARE
    end
  end

end
