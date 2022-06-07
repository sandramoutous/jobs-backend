# frozen_string_literal: true

require 'json'
require 'date'

input_file = File.read('./data/input.json')
data_hash = JSON.parse(input_file)
data_cars = data_hash['cars']
data_rentals = data_hash['rentals']

rentals = { 'rentals' => [] }

data_rentals.each do |rental|
  car = data_cars.select { |x| x['id'] == rental['car_id'] }.first

  start_date = Date.parse(rental['start_date'])
  end_date = Date.parse(rental['end_date'])
  duration = (start_date..end_date).count
  duration_price = duration * car['price_per_day']
  distance_price = rental['distance'] * car['price_per_km']
  total_price = duration_price + distance_price

  rentals['rentals'] << { 'id' => rental['id'], 'price' => total_price }
end

File.write('./data/output.json', JSON.pretty_generate(rentals))
