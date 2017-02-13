class GoogleModel

  attr_reader :name, :location, :rating, :price

  def initialize(name, location, rating = nil, price = nil)
    @name = name
    @location = location
    @rating = rating
    @price = price
  end


end
