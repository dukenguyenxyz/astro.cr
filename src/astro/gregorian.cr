module Astro::Date::Gregorian
  extend self

  def leap?(year)
    if year.divisible_by?(100)
      year.divisble_by?(400)
    else
      year.divisible_by?(4)
    end
  end
end
