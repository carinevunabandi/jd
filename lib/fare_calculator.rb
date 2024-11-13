class FareCalculator
    Z1                = 2.5
    ONE_ZONE_NOT_Z1   = 2
    TWO_ZONES_INCL_Z1 = 3
    TWO_ZONES_EXCL_Z1 = 2
    THREE_ZONES       = 3.2
    BUS_FARE          = 1.8
    MAX_FARE          = THREE_ZONES

    def self.min_req_balance_at(station_zone)
        calculated_zone_fare([station_zone])
    end

    def self.fare_for(trip)
        start_station_zone = trip.start_station_zone
        end_station_zone   = trip.end_station_zone
        transport_mode     = trip.transp_mode
        
        return MAX_FARE if start_station_zone.nil?
        return MAX_FARE if end_station_zone.nil?
        return BUS_FARE if transport_mode == :bus

        journey_zones = [start_station_zone, end_station_zone].uniq
        return calculated_zone_fare(journey_zones)
    end

    private 
    
    def self.calculated_zone_fare(journey_zones)
        zones_count   = journey_zones.count

        if journey_zones == ["1"]
            Z1
        elsif zones_count == 1
            ONE_ZONE_NOT_Z1
        elsif zones_count == 2 && journey_zones.include?("1")
            TWO_ZONES_INCL_Z1
        elsif zones_count == 2 && !journey_zones.include?("1")
            TWO_ZONES_EXCL_Z1
        elsif zones_count == 3
            THREE_ZONES
        else
            MAX_FARE
        end
    end
end