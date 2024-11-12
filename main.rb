#!/usr/bin/ruby

# require "byebug"
require "./card"
require "./terminals"
require "./fare_calculator"
require "./trips"


STATIONS = {
    "1" => "Holborn"     ,
    "2" => "Earl's Court",
    "3" => "Wimbledon"   ,
    "4" => "Hammersmith" 
}

def separator
    puts "----------------------------------------------------------------"
end

def output_dots
    puts " .."
end

def display_stations
    puts "---- Holborn      (Zone 1):       1"
    puts "---- Earl's Court (Zones 1, 2):   2"
    puts "---- Wimbledon    (Zone 3):       3"
    puts "---- Hammersmith  (Zone 2):       4"
end

def convert_selection_to_station_name(station_no_selection)
    STATIONS[station_no_selection]
end

def chevrons_prompt
    print ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> "
end

def space
    puts " "
end

def print_spending_and_balance card
    puts "*****************************************************"
    puts "Your trip cost: £#{card.current_trip.charged_fare}!" 
    puts "Your balance is £#{card.balance}!" 
    puts "*****************************************************"
end

def top_up_card card
    puts "Enter Top up amount: "
    chevrons_prompt
    amount = gets.chomp
    card.load_balance(amount)
    space
    puts "Great! Successfully topped-up £#{amount}"
    puts "Your Card balance is now £#{card.balance}"
    space
    return card
end

def select_journey_type
    puts "Select Journey Type: "
    puts "---- Tube: 1"
    puts "---- Bus:  2"
    puts "---- Cancel: 3"
    chevrons_prompt
    gets.chomp
end

def continue_travelling?
    puts "Do you want to continue travelling? "
    puts "---- Yes: 1"
    puts "---- No:  2"
    chevrons_prompt
    response = gets.chomp
    response == "1" ? true : false
end

def prompt_station_selection
    station_name = convert_selection_to_station_name(gets.chomp)

    while station_name.nil?
        puts "Unrecognised station selection. Select correct station from the list:"
        display_stations
        chevrons_prompt
        station_name = convert_selection_to_station_name(gets.chomp)
    end
    station_name
end

def prompt_bus_stop_selection
    puts "Select Bus service stop name:"
    display_stations
    chevrons_prompt
    bus_stop = convert_selection_to_station_name(gets.chomp)
    while bus_stop.nil?
        puts "Unrecognised Bus Stop selection. Select Bus Station from the list:"
        display_stations
        chevrons_prompt
        bus_stop = convert_selection_to_station_name(gets.chomp)
    end
    # puts "You are starting your bus journey at #{bus_stop.upcase}"
    bus_stop
end

def travel_on_tube
    output_dots
    puts " ... Travelling on tube ..."
    output_dots
    puts "You've reached the end of your journey. Select Station ending journey at:"
    display_stations
    chevrons_prompt
end

def card_tap_out
    end_station_name = prompt_station_selection
    puts "You are ending your journey at #{end_station_name.upcase} Station."
    puts "Type OUT to tap out: " 
    puts "... Waiting to tap out ..." 
    chevrons_prompt
    tap_out = gets.chomp
    if tap_out.downcase == "out"
        puts "Tapping out ..." 
        @terminal.tap_out(@card, end_station_name)    
        puts "Successfully tapped out!" 
    else
        puts "*** WARNING: You did not tap out! You will be charged the maximum fare. ***" 
    end
end
    



##### START #####
separator
puts "*** Welcome to TFL ****"
separator
@card  = Card.new
puts "Your card balance is £#{@card.balance}. Top-up first."
@card = top_up_card(@card)

continue_travelling = true

while continue_travelling == true
    @card.flush_current_trip
    journey_type = select_journey_type

    case journey_type
    when "1"
        puts "Selected: TUBE journey" 
        space
        puts "Specify START station: "
        display_stations
        chevrons_prompt
        start_station_name = prompt_station_selection
        @terminal = TubeTerminal.new(start_station_name)

        puts "You are starting your journey at #{start_station_name.upcase} Station"

        puts "Type IN to tap in"
        chevrons_prompt
        tap_in = gets.chomp

        if tap_in.downcase == "in"
            puts "Attempt to tap in ..." 
            tap_outcome = @terminal.tap_in(@card)

            if tap_outcome == true
                puts "Successfully tapped in at #{start_station_name} Tube station."
                travel_on_tube
                card_tap_out
                print_spending_and_balance(@card)
            else
                puts "Failed tapped in at  #{start_station_name} due to insufficient balance. Top your card up first."
                # exit
            end
        else
            puts "*** WARNING: You did not tap in at entry. You will be charged maximum fare. ***" 
            travel_on_tube
            card_tap_out
            print_spending_and_balance(@card)
        end
    when "2"
        puts "Selected: BUS journey" 
        puts "Type Bus Service No:"
        chevrons_prompt
        bus_no   = gets.chomp
        bus_stop = prompt_bus_stop_selection

        @terminal = BusTerminal.new(bus_no, bus_stop)
        puts "You are starting your bus journey at #{bus_stop.upcase}"

        puts "Type IN to tap in:"
        chevrons_prompt
        tap_in = gets.chomp

        if tap_in.downcase == "in"
            puts "Attempt to tap in ..." 
            tap_outcome = @terminal.tap(@card)
            print_spending_and_balance(@card)
        else
            puts "You're a thief!"
            print_spending_and_balance(@card)
        end
    when "3"
        exit
    else
        puts "You must select the Journey type: TUBE or BUS or Exit the app"
    end

    continue_travelling = continue_travelling?
end
separator
puts "*** Thanks for choosing TFL ****"
separator
exit