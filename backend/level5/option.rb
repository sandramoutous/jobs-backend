class Option
  attr_accessor :rental, :type

  OPTIONS_PRICE = { gps: 500, baby_seat: 200, additional_insurance: 1000 }.freeze
  OWNER_OPTIONS = %w[gps baby_seat].freeze
  DRIVY_OPTIONS = ['additional_insurance'].freeze

  def initialize(rental, type)
    @rental = rental
    @type = type
  end

  def owner_options?
    OWNER_OPTIONS.include?(type)
  end

  def drivy_options?
    DRIVY_OPTIONS.include?(type)
  end
end
