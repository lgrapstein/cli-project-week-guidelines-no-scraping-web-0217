class GoogleApi
  require 'pry'

  attr_reader :url, :results_arr, :places

  def initialize(url)
    @url = url
#    binding.pry
    @places = JSON.parse(RestClient.get(url))
    @results_arr = []
  end

   def places
     places = []
     places_arr = @places["results"]
     places_arr.each do |result|
       name = result["name"]
       rating = result["rating"]
       location = result["vicinity"]
       price_level = result["price_level"]
#       price = price_level.to_i.times{|x| "$"}
       @results_arr << GoogleModel.new(name, location, rating, price_level)
     end
     @results_arr
   end

end
