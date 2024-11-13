require "spec_helper"

RSpec.describe 'Card' do
    let(:brand_new_card)     { Card.new }
    let(:card)               { Card.new(10) }
    let(:start_station_name) { "Holborn" }
    let(:start_station_zone) { "1" }
    let(:end_station_name)   { "Holborn" }
    let(:end_station_zone)   { "1" }

    it "has an instance variable called balance" do
        expect(brand_new_card).to respond_to(:balance)
    end

    it "has an instance variable called current_trip" do
        expect(brand_new_card).to respond_to(:current_trip)
    end

    it "has a balance that is 0 by default" do
        expect(brand_new_card.balance).to eq 0.0
    end

    it "has a current_trip variable of type NilTubeTrip" do
        expect(brand_new_card.current_trip.class).to eq NilTubeTrip
    end

    describe "#load_balance" do
        let(:amount) { 6 }

        it "increases the balance by the amount given" do
            card.load_balance(amount)
            expect(card.balance).to eq 16.0
        end
    end

    describe "¢reduce_balance" do
        let(:amount) { 3 }

        it "decreases the balance by the amount given" do
            card.reduce_balance(amount)
            expect(card.balance).to eq 7.0
        end
    end

    describe "#initiate_bus_trip" do
        let(:bus_no)   { 326 }
        let(:bus_stop) { "Holborn" }

        it "creates an instance of a BusTrip using the bus_no and stop names supplied" do
            card.initiate_bus_trip(bus_no, bus_stop)
            expect(card.current_trip).to be_an_instance_of BusTrip
        end

        it "reduces the balance on the card by the Bus fare amount" do
            expect(card).to receive(:reduce_balance).with(FareCalculator::BUS_FARE)
            card.initiate_bus_trip(bus_no, bus_stop)
        end
    end

    describe "#initiate_tube_trip" do
        it "creates an instance of a TubeTrip using the Station Name and Station Zone supplied" do
            card.initiate_tube_trip(start_station_name, start_station_zone)
            expect(card.current_trip).to be_an_instance_of TubeTrip
        end

        it "updates the fare for the current trip with the max fare" do
            card.initiate_tube_trip(start_station_name, start_station_zone)
            expect(card.current_trip.charged_fare).to eq FareCalculator::MAX_FARE
        end

        it "reduces the balance on the card by the Maximum fare amount" do
            expect(card).to receive(:reduce_balance).with(FareCalculator::MAX_FARE)
            card.initiate_tube_trip(start_station_name, start_station_zone)
        end
    end

    describe "#conclude_tube_trip" do
        it "sets the end_station on the current_trip instance" do
            expect(card.current_trip).to receive(:set_end_of_trip_station).with(end_station_name, end_station_zone)
            card.conclude_tube_trip(end_station_name, end_station_zone)
        end

        it "invokes the FareCalculator to work out the actual fare for the current trip" do
            expect(FareCalculator).to receive(:fare_for).with(card.current_trip)
            card.conclude_tube_trip(end_station_name, end_station_zone)
        end

        it "updates the fare for the current trip with the actual fare calculated" do
            allow(FareCalculator).to receive(:fare_for).with(card.current_trip).and_return(3)
            card.conclude_tube_trip(end_station_name, end_station_zone)
            expect(card.current_trip.charged_fare).to eq 3
        end

        it "adjusts the balance on the card based on the actual amount charged on the current trip" do
            allow(FareCalculator).to receive(:fare_for).with(card.current_trip).and_return(3)
            card.conclude_tube_trip(end_station_name, end_station_zone)
            expect(card.balance).to eq 7
        end

        context "concluding a trip that when card was tapped at entry" do
            it "invokes setting the end of trip on an TubeTrip instance" do
                card.initiate_tube_trip(start_station_name, start_station_zone)
                card.conclude_tube_trip(end_station_name, end_station_zone)
                expect(card.current_trip).to be_an_instance_of TubeTrip
            end
        end

        context "concluding a trip that when card did not tap at entry" do
            it "invokes setting the end of trip on an NilTubeTrip instance" do
                card.conclude_tube_trip(end_station_name, end_station_zone)
                expect(card.current_trip).to be_an_instance_of NilTubeTrip
            end
        end
    end

    describe "#flush_current_trip" do
        it "resets the current_trip variable on the card to be an instance of NilTubeTrip" do
            card.initiate_tube_trip(:start_station_name, start_station_zone)
            card.flush_current_trip
            expect(card.current_trip).to be_an_instance_of NilTubeTrip
        end
    end
end