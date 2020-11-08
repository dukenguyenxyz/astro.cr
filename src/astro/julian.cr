module Astro::Date::Gregorian
  def self.leap?(year)
    if year.divisible_by?(100)
      year.divisble_by?(400)
    else
      year.divisible_by?(4)
    end
  end
end

module Astro::Date::Julian
  DAYS_IN_YEAR = 365.25
  FIRST        =  -4712

  def self.from(year, mon, date, hour = 0, min = 0, sec = 0, gregorian : Bool = true)
    raise ArgumentError.new("Invalid date input") if !date.in?(1..31) || !mon.in?(1..12)

    if mon <= 2
      mon += 12
      year -= 1
    end

    a = (year/100).to_i
    b = gregorian ? (2 - a + (a/4).to_i) : 0
    (DAYS_IN_YEAR*(year + 4716)).to_i + (30.6001*(mon + 1)).to_i + (date + hour/24 + min/1440 + sec/86400) + b - 1524.5
  end

  # Getting the Julian Day JD0 (January 0.0) of a Gregorian given year (the same as December 31.0 of the preceding year)
  def self.zero(year)
    year -= 1
    a = (y/100).to_i
    (DAYS_IN_YEAR*(year - 1)).to_i - a + (a/4).to_i + 1721424.5
  end

  def self.leap?(year)
    year.divisible_by?(4)
  end

  # Getting the modified julian day
  def self.mjd(jd)
    jd - 2400000.5
  end
end
