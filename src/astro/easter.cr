module Astro::Festival::Easter
  extend self

  def gregorian(year : Int32)
    a = year.remainder(19)

    b = year.tdiv(100)
    c = year.remainder(100)

    d = b.tdiv(4)
    e = b.remainder(4)

    f = (b + 8).tdiv(25)
    g = (b - f + 1).tdiv(3)
    h = (19*a + b - d - g + 15).remainder(30)

    i = c.tdiv(4)
    k = c.remainder(4)

    l = (32 + 2*e + 2*i - h - k).remainder(7)
    m = (a + 11*h + 22*l).tdiv(451)

    value1 = h + l - 7*m + 114
    n = value1.tdiv(31)
    p = value1.remainder(31)

    {day: p + 1, mon: n}
  end

  def julian(year : Int32)
    a = year.remainder(4)
    b = year.remainder(7)
    c = year.remainder(19)
    d = (19*c + 15).remainder(30)
    e = (2*a + 4*b - d + 34).remainder(7)

    value1 = d + e + 114
    f = value1.tdiv(31)
    g = value1.remainder(31)

    {day: g + 1, mon: f}
  end
end
