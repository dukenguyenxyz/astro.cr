require "../spec_helper"

alias Julian = Astro::Date::Julian

describe Astro::Date::Julian do
  describe "#to_jd" do
    it "(7.a) should calculate the JD of the launch of Sputnik 1" do
      Julian.new(1957, 10, 4.81).to_jd.should eq(2436116.31)
    end

    it "(7.b) should calculate the JD of 12:00 27/01/333" do
      Julian.new(333, 1, 27.5).to_jd(gregorian: false).should eq(1842713.0)
      Julian.new(333, 1, 27, 12).to_jd(gregorian: false).should eq(1842713.0)
    end
  end

  describe "#from_jd" do
    it "(7.c) should calculate the dates from jd" do
      Julian.from_jd(2436116.31).should eq(Julian.new(1957, 10, 4.81))
      Julian.from_jd(1842713.0).should eq(Julian.new(333, 1, 27.5))
      Julian.from_jd(1507900.13).should eq(Julian.new(-584, 5, 28.63))
    end
  end

  describe "calculate interval in days" do
    it "(7.d) calculates the difference betweeen Julian days" do
      (Julian.new(1986, 2, 9.0) - Julian.new(1910, 4, 20.0)).should eq(27689)
    end

    it "(7.d) finds the date 10000 days after 1991/7/11" do
      (Julian.new(1991, 7, 11) + 10000).should eq(Julian.new(2018, 11, 26))
    end
  end

  describe "calculate day of the week/year from JD/ Julian day" do
    it "(7.e) calculates the day of the week from JD" do
      Julian.day_of_week(2434923.5).should eq(Astro::Date::DayOfWeek::Wednesday)
    end

    it "(7.f) calculates the day of the week from Julian day" do
      Julian.new(1978, 11, 14).day_of_year.should eq(318)
    end

    it "(7.g) calculates the day of the week from Julian day" do
      Julian.new(1988, 4, 22).day_of_year.should eq(113)
    end
  end
end
