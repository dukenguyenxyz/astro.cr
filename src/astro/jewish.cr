module Astro::Date::Jewish
  extend self

  def from_gregorian(year : Int32)
    year + 3760
  end

  def next_begin_year_from_gregorian(year : Int32)
    pesach = Astro::Festival::Pesach.year(year)
    Time.utc(year, pesach["mon"], pesach["day"], 12, 0, 0) + 163.days
  end

  def number_of_months(year : Int32)
    year.remainder(19).in?(0, 3, 6, 8, 11, 14, 17) ? 13 : 12
  end

  def length(year : Int32)
    (next_begin_year_from_gregorian(year + 1) - next_begin_year_from_gregorian(year)).days
  end
end

module Astro::Festival::Pesach
  extend self

  def year(x : Int32, gregorian = true)
    c = (x/100).to_i

    s = gregorian ? ((3*c - 5)/4).to_i : 0
    a = x + 3760
    alpha = (12*x + 12).remainder(19)
    b = x.remainder(4)
    q = -1.904412361576 + 1.554251796621 * alpha + 0.25 * b - 0.00317794022 * x + s
    j = (q.to_i + 3 * x + 5 * b + 2 - s).remainder(7)
    r = q - q.to_i

    if j.in?(2, 4, 6)
      d = q.to_i + 23
    elsif j == 1 && a > 6 && r >= 0.632870370
      d = q.to_i + 24
    elsif j == 0 && a > 11 && r >= 0.897723765
      d = q.to_i + 23
    else
      d = q.to_i + 22
    end

    if d <= 31
      m = 3
    else
      m = 4
      d -= 31
    end

    {day: d, mon: m}
  end
end
