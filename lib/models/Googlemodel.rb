class GoogleModel

  attr_reader :name, :location, :rating

  def initialize(name, location, rating = nil)
    @name = name
    @location = location
    @rating = rating
  end


end
