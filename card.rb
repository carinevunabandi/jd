class Card
    attr_accessor :balance
    attr_accessor :current_trip
    
    def initialize balance = 0.0
        @balance = balance
        @current_trip = NilTubeTrip.new
    end

    def initiate_bus_trip(bus_no, stop_name)
        @current_trip = BusTrip.new(stop_name, bus_no, :bus)
        reduce_balance(@current_trip.charged_fare)
    end

    def initiate_tube_trip(station_name, station_zone)
        @current_trip = TubeTrip.new(station_name, station_zone, :tube)
        reduce_balance(@current_trip.charged_fare)
    end

    def conclude_tube_trip(station_name, station_zone)
        @current_trip.set_end_of_trip_station(station_name, station_zone)
        calculated_fare = FareCalculator.fare_for(@current_trip)
        adjust_charged_tube_fare(calculated_fare)
        @current_trip.charged_fare = calculated_fare
    end

    def adjust_charged_tube_fare(calculated_fare)
        load_balance(@current_trip.charged_fare)
        reduce_balance(calculated_fare)
    end

    def load_balance amount
        @balance = @balance + amount.to_f
    end

    def reduce_balance amount
        @balance = @balance - amount.to_f
    end

    def flush_current_trip
        @current_trip = NilTubeTrip.new
    end

    def trips
        Trip.all
    end
end