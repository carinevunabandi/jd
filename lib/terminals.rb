
class Terminal
    def initialize 
        @tapped_card = nil
    end

    def set_card card
        @tapped_card = card
    end

    def enough_balance_on_card_for?(zone)
        case zone
        when "BUS"
            return false if @tapped_card.balance < FareCalculator::BUS_FARE
        else
            return false if @tapped_card.balance < FareCalculator.min_req_balance_at(zone)
        end
        true
    end
end


class TubeTerminal < Terminal
    STATIONS_ZONES = {
        "Holborn"      => "1",
        "Earl's Court" => "1, 2",
        "Wimbledon"    => "3",
        "Hammersmith"  => "2"
    }

    attr_accessor :station_name
    attr_accessor :station_zone

    def initialize station_name
        @station_name  = station_name
        @station_zone  = zone_for(station_name)
    end

    def tap_in card
        set_card(card)
        return false if !enough_balance_on_card_for?(@station_zone)
        @tapped_card.initiate_tube_trip(@station_name, @station_zone)
        true
    end

    def tap_out card, out_station_name
        station_zone = zone_for(out_station_name)
        set_card(card)
        @tapped_card.conclude_tube_trip(@out_station_name, station_zone)
        true
    end

    private

    def zone_for(station)
        STATIONS_ZONES[station]
    end
end

class BusTerminal < Terminal
    def initialize bus_no, stop_name
        @bus_no    = bus_no
        @stop_name = stop_name
    end

    def tap(card)
        set_card(card)
        return false if !enough_balance_on_card_for?("BUS")
        @tapped_card.initiate_bus_trip(@bus_no, @stop_name)
        true
    end
end