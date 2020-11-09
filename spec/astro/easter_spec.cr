require "../spec_helper"

alias Easter = Astro::Festival::Easter

describe Astro::Festival::Easter do
  describe "#gregorian" do
    Easter.gregorian(1991).should eq({day: 31, mon: 3})
    Easter.gregorian(1992).should eq({day: 19, mon: 4})
    Easter.gregorian(1993).should eq({day: 11, mon: 4})
    Easter.gregorian(1954).should eq({day: 18, mon: 4})
    Easter.gregorian(2000).should eq({day: 23, mon: 4})
    Easter.gregorian(1818).should eq({day: 22, mon: 3})
  end

  describe "#julian" do
    Easter.julian(179).should eq({day: 12, mon: 4})
    Easter.julian(711).should eq({day: 12, mon: 4})
    Easter.julian(1243).should eq({day: 12, mon: 4})
  end
end
