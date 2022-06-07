# frozen_string_literal: true

require 'json'
require 'date'

input_file = File.read('./data/input.json')
data_hash = JSON.parse(input_file)
@data_cars = data_hash['cars']
@data_rentals = data_hash['rentals']

def rentals
  rentals = { 'rentals' => [] }

  @data_rentals.each do |rental|
    car = @data_cars.select { |x| x['id'] == rental['car_id'] }.first
    price_per_day = car['price_per_day']
    price_per_km = car['price_per_km']
    duration = duration_rental(Date.parse(rental['start_date']), Date.parse(rental['end_date']))
    price_day = decreasing_price_day(price_per_day, duration)
    price_distance = distance_price(price_per_km, rental['distance'])
    total_price = total_price(price_day, price_distance)
    commission = commission(total_price, duration)

    rentals['rentals'] << { 'id' => rental['id'], 'price' => total_price, 'commission' => commission }
  end
  rentals
end

def duration_rental(start_date, end_date)
  (start_date..end_date).count
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

def distance_price(price, distance = 0)
  distance * price
end

def total_price(price_day, price_distance)
  price_day + price_distance
end

def commission(total_price, days)
  commission_part = (total_price * 0.3).round(0)
  distribution = {
    insurance_fee: 0,
    assistance_fee: 0,
    drivy_fee: 0
  }
  distribution[:insurance_fee] = commission_part / 2
  distribution[:assistance_fee] = days * 100
  distribution[:drivy_fee] = commission_part - (distribution[:insurance_fee] + distribution[:assistance_fee])
  distribution
end

File.write('./data/output.json', JSON.pretty_generate(rentals))
