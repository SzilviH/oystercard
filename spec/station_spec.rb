require 'station'

describe Station do
  let(:oldstr) { Station.new("oldstr", 1)}

    it "has a name" do
      expect(oldstr.name).to eq "oldstr"
    end

    it "has a zone assigned to it" do
      expect(oldstr.zone).to eq(1)
    end

end
