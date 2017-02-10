class GooglePlaces

  attr_accessor :places, :location_data

  def call
    puts "Which of these locations in Manhattan are you interested in?"
    location_request
  end

  def locations
    possible_locations = {"Midtown"=> "40.7549,-73.9840", "East Village" => "40.7265,-73.9815", "West Village" => "40.7358,-74.0036", "Chinatown" => "40.7158,-73.9990", "Tribeca" => "40.7163,-74.0086", "Upper West Side" => "40.7736,-73.9566", "Upper East Side" => "40.7870,-73.9754"}
  end

  def location_request
    locations.each do |location, coordinates|
      puts location
    end
    location = get_user_input
    dummy = nil
    locations.each do |place, coordinates|
      if location == place.downcase
        @location_data = coordinates
        run
        dummy = "yay"
      end
    end
    if location == "exit"
      exit
    elsif dummy == nil && location != "exit"
      puts "Please try again"
      call
    end
  end

  def get_user_input
    gets.chomp.strip.downcase
  end

  def keyword
    keyword = ["Restaurant", "Bar", "Hospital", "Library", "Subway_station", "Bakery", "ATM", "Movie_theatre", "Cafe", "Park", "Pharmacy", "Synogague"]
  end

  def run
    puts "Please enter the keyword you are searching for from the options below"
    keyword.each do |keyword|
      puts keyword.split('_').join(" ")
    end
    input_keyword = get_user_input
    if input_keyword == "help"
      help
    elsif input_keyword == "exit"
      exit
    else
      find(input_keyword)
    end
    follow_up
  end

  def find(input)
    puts "Your search term was #{input.capitalize}, I am searching..."
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@location_data}&radius=1000&type=#{input}&key=AIzaSyDRNa7BlVOQIa5kVCp5voO95ol_6xPvdkY"
    @places = GoogleApi.new(url).places
    puts "Thank you for your patience. I found these #{input}'s close to you:"
    if @places.count > 0
      @places.each.with_index(1) do |place, index|
        puts "#{index}. #{place.name}."
      end
    end
  end

  def follow_up
    puts "Would you like more details? If so, enter the number from the list below and we will provide more details."
    response = get_user_input
    dummy = nil
    @places.each.with_index(1) do |place, index|
      if response.to_i == index
        puts "The location of #{place.name} is #{place.location}."
        puts "The rating for #{place.name} is #{place.rating}." if place.rating != nil
        dummy = "yes"
      end
    end
    if dummy == nil
      puts "I did not get that. Please try again"
      run
    else
      puts "Would you like to make another search (y/n)"
      user_input_again = get_user_input
      if user_input_again == "y"
        run()
      else
        exit
      end
    end
  end



  def help
    puts "Type 'exit' to exit"
    puts "Type anything else to start a new search"
    answer = gets.chomp.strip.downcase
    if answer == "exit"
      exit
    else
      run
    end
  end

  def exit
    puts "Thank you for your time. Come back again soon."
    abort
  end

end
