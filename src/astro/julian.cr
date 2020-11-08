class InvalidDateException < Exception
  def initialize(jd, reason : String)
    super("Invalid Date Output from JD: #{jd} (#{reason})")
  end
end

module Astro::Date
  enum DayOfWeek
    Sunday
    Monday
    Tuesday
    Wednesday
    Thursday
    Friday
    Saturday
  end

  struct Julian
    property year : Int32
    property mon : Int32
    property day : Int32 | Float32 | Float64

    alias JD = Int32 | Float32 | Float64

    def initialize(@year, @mon, day, hour = 0, min = 0, sec = 0)
      @day = day + hour/24 + min/1440 + sec/86400
      raise ArgumentError.new("Invalid day input") if !@day.in?(1..32) || !@mon.in?(1..14)
    end

    DAYS_IN_MONTH = 30.6001
    DAYS_IN_YEAR  =  365.25
    FIRST         =   -4712
    ASTRO_FIRST   =    4716

    # # Main Algorithms

    # Converting a Gregorian / Julian date into JD
    def to_jd(gregorian : Bool = true) : JD
      if @mon <= 2
        @mon += 12
        @year -= 1
      end

      a = (@year/100).to_i
      b = gregorian ? (2 - a + (a/4).to_i) : 0
      (DAYS_IN_YEAR*(@year + ASTRO_FIRST)).to_i + (DAYS_IN_MONTH*(@mon + 1)).to_i + @day + b - 1524.5
    end

    # Converting a JD into a Julian date
    def self.from_jd(jd : JD) : self
      raise ArgumentError.new("Invalid negative JD input") if jd < 0

      jd += 0.5
      z = jd.trunc
      f = (jd - z).round(5)

      if z < 2299161
        a = z
      else
        alpha = ((z - 1867216.25)/36524.25).to_i
        a = z + 1 + alpha - (alpha/4).to_i
      end

      b = a + 1524
      c = ((b - 122.1)/DAYS_IN_YEAR).to_i
      d = (DAYS_IN_YEAR * c).to_i
      e = ((b - d)/DAYS_IN_MONTH).to_i

      day = (b - d - (DAYS_IN_MONTH*e).to_i + f).round(5)

      mon = if e < 14
              e - 1
            elsif e.in?(14, 15)
              e - 13
            else
              raise InvalidDateException.new(jd, "invalid month number")
            end

      year = if mon > 2
               c - ASTRO_FIRST
             elsif mon.in?(1, 2)
               c - ASTRO_FIRST + 1
             else
               raise InvalidDateException.new(jd, "invalid year number")
             end

      self.new(year, mon, day)
    end

    def -(other : Julian) : JD
      (self.to_jd - other.to_jd).to_i
    end

    def +(other : JD) : self
      self.class.from_jd(self.to_jd + other)
    end

    def self.day_of_week(jd : JD) : DayOfWeek
      DayOfWeek.from_value((jd + 1.5).remainder(7).to_i)
    end

    def day_of_year : Int32
      self.class.day_of_year(self.leap?, @mon, @day)
    end

    def self.day_of_year(jd : JD) : Int32
      julian = self.class.from_jd(jd)

      self.class.day_of_year(julian.leap?, julian.mon, julian.day)
    end

    def self.day_of_year(year, mon, day)
      self.class.day_of_year(year.leap?, mon, day)
    end

    def self.day_of_year(leap : Bool, mon : Int32, day : Int32 | Float32 | Float64)
      k = leap ? 1 : 2
      n = (275*mon/9).to_i - k * ((mon + 9)/12).to_i + day - 30
      n.to_i
    end

    def self.date_from_day(year : Int32, day : Int32 | Float32 | Float64)
      k = self.class.leap?(year) ? 1 : 2
      m = day < 32 ? 1 : (9*(k + day)/275 + 0.98).to_i
      day - (275*m/9).to_i + k * ((m + 9)/12).to_i + 30
    end

    # # Subcategory Algorithms

    # Getting the Julian Day JD0 (January 0.0) of a Gregorian given year (the same as December 31.0 of the preceding year)
    def zero
      self.class.zero(self.year)
    end

    def self.zero(year)
      year -= 1
      a = (y/100).to_i
      (DAYS_IN_YEAR*(year - 1)).to_i - a + (a/4).to_i + 1721424.5
    end

    # Check whether the year is a leap year
    def leap?
      self.class.leap?(self.year)
    end

    def self.leap?(year)
      year.divisible_by?(4)
    end

    # Getting the modified julian day
    def self.mjd(jd)
      jd - 2400000.5
    end
  end
end
