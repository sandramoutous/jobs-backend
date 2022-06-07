class Rental
  attr_accessor :start_date, :end_date, :distance


  def initialize(start_date, end_date, distance, car)
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @car = car
  end

  def total_price
    duration = duration_rental
    price_day = decreasing_price_day(@car.price_per_day, duration)
    price_distance = price_distance(@car.price_per_km)
    price_day + price_distance
  end

  def duration_rental
    (Date.parse(@start_date)..Date.parse(@end_date)).count
  end

  def decreasing_price_day(price, days = 0)
    decreasing_price = 0
    decreasing_price += price
    days.times do |day|
      day += 1
      if day > 1 && day <= 4
        decreasing_price += (price * 0.9)
      elsif day > 4 && day <= 10
        decreasing_price += (price * 0.7)
      end
    end
    decreasing_price += (price * 0.5) * (days - 10) if days > 10
    decreasing_price.round(0)
  end

  def price_distance(price)
    price * (@distance || 0)
  end

  def distribution(options = [])
    distribution = []
    duration = duration_rental
    driver_part = total_price
    owner_part = (total_price * 0.7).round(0)
    commission_part = (total_price * 0.3).round(0)
    insurance_fee = commission_part / 2
    assistance_fee = duration * 100
    drivy_fee = commission_part - (insurance_fee + assistance_fee)

    options.each do |option|
      driver_part += Option::OPTIONS_PRICE[option.type.to_sym] * duration
      if option.owner_options?
        owner_part += Option::OPTIONS_PRICE[option.type.to_sym] * duration
      elsif option.drivy_options?
        drivy_fee += Option::OPTIONS_PRICE[option.type.to_sym] * duration
      end
    end

    distribution << { 'who' => 'driver', 'type' => 'debit', 'amount' => driver_part }
    distribution << { 'who' => 'owner', 'type' => 'credit', 'amount' => owner_part }
    distribution << { 'who' => 'insurance', 'type' => 'credit', 'amount' => insurance_fee }
    distribution << { 'who' => 'assistance', 'type' => 'credit', 'amount' => assistance_fee }
    distribution << { 'who' => 'drivy', 'type' => 'credit', 'amount' => drivy_fee }

    distribution
  end
end
