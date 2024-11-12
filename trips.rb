class Trip
    attr_accessor :transp_mode
    attr_accessor :charged_fare
    
    def initialize transp_mode
        @transp_mode = transp_mode
    end
end

class BusTrip < Trip
    attr_accessor :bus_no
    attr_accessor :stop_name
    
    def initialize bus_no, stop_name, transp_mode
        super(transp_mode)
        @bus_no       = bus_no
        @stop_name    = stop_name
        @charged_fare = FareCalculator::BUS_FARE
    end
end

class TubeTrip < Trip
    attr_accessor :start_station_name
    attr_accessor :start_station_zone
    attr_accessor :end_station_name
    attr_accessor :end_station_zone

    
    def initialize start, zone, transp_mode
        super(transp_mode)
        @start_station_name = start
        @start_station_zone = zone
        @charged_fare       = FareCalculator::MAX_FARE
    end

    def set_end_of_trip_station end_station, end_station_zone
        @end_station_name = end_station
        @end_station_zone = end_station_zone
    end
end

class NilTubeTrip < TubeTrip
    attr_accessor :bus_no
    attr_accessor :stop_name
    
    def initialize
        # super(transp_mode)
        @bus_no       = bus_no
        @stop_name    = stop_name
        @charged_fare = 0
    end
end