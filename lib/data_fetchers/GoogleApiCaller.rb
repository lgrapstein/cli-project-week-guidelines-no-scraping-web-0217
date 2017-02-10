class GoogleApi
  require 'pry'

  attr_reader :url, :results_arr, :places

  def initialize(url)
    @url = url
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
       @results_arr << GoogleModel.new(name, location, rating)
     end
     @results_arr
   end

end
