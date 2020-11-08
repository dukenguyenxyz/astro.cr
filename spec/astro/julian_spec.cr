require "../spec_helper"

alias Julian = Astro::Date::Julian

describe Astro::Date::Julian do
  it "(7.a) should calculate the JD of the launch of Sputnik 1" do
    Julian.from(1957, 10, 4.81).should eq(2436116.31)
  end

  it "(7.b) should calculate the JD of 12:00 27/01/333" do
    Julian.from(333, 1, 27.5, gregorian: false).should eq(1842713.0)
    Julian.from(333, 1, 27, 12, gregorian: false).should eq(1842713.0)
  end
end
