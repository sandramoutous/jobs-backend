class Car
  attr_accessor :price_per_day, :price_per_km

  def initialize(price_per_day, price_per_km)
    @price_per_day = price_per_day
    @price_per_km = price_per_km
  end
end
