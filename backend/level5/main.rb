# frozen_string_literal: true

require 'json'
require 'date'
require_relative 'car'
require_relative 'rental'
require_relative 'option'

input_file = File.read('./data/input.json')
data_hash = JSON.parse(input_file)
data_cars = data_hash['cars']
data_rentals = data_hash['rentals']
data_options = data_hash['options']

rentals = { 'rentals' => [] }

data_rentals.each do |rental|
  options = data_options.select { |x| x['rental_id'] == rental['id'] }
  hash_car = data_cars.find { |x| x['id'] == rental['car_id'] }
  start_date = rental['start_date']
  end_date = rental['end_date']
  distance = rental['distance']

  car = Car.new(hash_car['price_per_day'], hash_car['price_per_km'])
  rental_obj = Rental.new(start_date, end_date, distance, car)

  options_obj = []
  options_type = []
  options.each do |option|
    options_type << option['type']
    options_obj << Option.new(rental, option['type'])
  end

  actions = rental_obj.distribution(options_obj)

  rentals['rentals'] << { 'id' => rental['id'], 'options' => options_type, 'actions' => actions }
end
rentals



File.write('./data/output.json', JSON.pretty_generate(rentals))
