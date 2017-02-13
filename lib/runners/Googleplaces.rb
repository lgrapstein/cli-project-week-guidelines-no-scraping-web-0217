class GooglePlaces

  attr_accessor :places, :location_data, :keyword

  def call
    puts " "
    puts " "
    puts "************************************************************"
    puts "************************************************************"
    puts " "
    puts "Which of these locations in Manhattan are you interested in?"
    puts "             _________________________________              "
    puts " "
    location_request
  end

  def locations
    possible_locations = {"Midtown"=> "40.7549,-73.9840", "East Village" => "40.7265,-73.9815", "West Village" => "40.7358,-74.0036", "Chinatown" => "40.7158,-73.9990", "Tribeca" => "40.7163,-74.0086", "Upper West Side" => "40.7736,-73.9566", "Upper East Side" => "40.7870,-73.9754"}
  end

  def location_request
    locations.each do |location, coordinates|
      puts location
    end
    puts " "
    puts "************************************************************"
    puts "************************************************************"
    puts " "
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
      puts "Please try again."
      call
    end
  end

  def get_user_input
    gets.chomp.strip.downcase
  end

  def keyword
    @keyword = ["Airport", "Restaurant", "Bar", "Hospital", "Library", "Subway_station", "Bakery", "ATM", "Movie_theatre", "Cafe", "Park", "Pharmacy", "Synogague", "Art_gallery", "Church", "Clothing_store", "Dentist", "Gym", "University", "School", "Police", "Parking", "Night_club", "Liquor_store", "Museum"].uniq.sort
  end

  def run
    puts " "
    puts "**********************************************************************"
    puts "**********************************************************************"
    puts " "
    puts " "
    puts "Please enter the keyword you are searching for from the options below:"
    puts "              ________________________________________                "
    puts " "

    keyword.each do |keyword|
      puts keyword.split('_').join(" ")
    end
    puts "______________________________________________________________________"
    puts " "
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
    puts "______________________________________________________________________"
    puts " "
    puts "Your search term was #{input.capitalize}, I am searching..."
    puts "                            ...                            "
    puts " "
    keyword_arr = keyword
    url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=#{@location_data}&radius=1000&type=#{input}&key=AIzaSyDRNa7BlVOQIa5kVCp5voO95ol_6xPvdkY" if keyword_arr.include?(input.capitalize)
    if url == nil
      puts "Your search was not found. Please try again"
      run
    else
      @places = GoogleApi.new(url).places
    end
    puts "Thank you for your patience. I found these #{input}'s close to you:"
    puts "             ________________________________________              "
    puts " "
    if @places.count > 0
      @places.each.with_index(1) do |place, index|
        puts "#{index}. #{place.name}."
      end
    end
  end

  def follow_up
    puts "___________________________________________________________________"
    puts " "
    puts "Would you like more details? If so, enter the number from the list below and we will provide more details."
    puts "             ________________________________________              "
    puts " "
    response = get_user_input
    puts " "
    dummy = nil
    @places.each.with_index(1) do |place, index|
      if response.to_i == index
        puts "***********************************************************************"
        puts " "
        puts "The location of #{place.name} is #{place.location}."
        puts " "
        puts "The rating for #{place.name} is #{place.rating}." if place.rating != nil
        puts " "
        puts "The price level for #{place.name} is #{place.price} out of 5." if place.price != nil
        puts " "
        puts "************************************************************************"
        puts "************************************************************************"
        dummy = "yes"
      end
    end
    if dummy == nil
      puts " "
      puts "I did not get that. Please try again"
      run
    else
      puts " "
      puts "___________________________________________________________________"
      puts " "
      puts "Would you like to make another search (Y/N)"
      puts " "
      puts "                  ______________________________                   "
      user_input_again = get_user_input
      if user_input_again == "Y" || "y"
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
    puts " "
    puts " "
    puts "*********************************************************************"
    puts "*********************************************************************"
    puts " "
    puts "Thank you for your time. Come back again soon."
    puts " "
    puts "*********************************************************************"
    puts "*********************************************************************"
    abort
  end

end
