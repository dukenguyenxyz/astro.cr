require "../spec_helper"

alias Jewish = Astro::Date::Jewish
alias Pesach = Astro::Festival::Pesach

describe Astro::Date::Jewish do
  Jewish.from_gregorian(1990).should eq(5750)
  Jewish.number_of_months(5751).should eq(12)
  Jewish.next_begin_year_from_gregorian(1990).should eq(Time.utc(1990, 9, 20, 12, 0, 0))
  Jewish.length(1990).should eq(354)
end

describe Astro::Festival::Pesach do
  describe "#year" do
    Pesach.year(1990).should eq({day: 10, mon: 4})
  end
end
