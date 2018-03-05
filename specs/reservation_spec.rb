require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do
    before do
      my_trip = {reservation_id: 1, room_id: 1, start_date:  Date.new(2018,5,5), end_date: Date.new(2018,5,7)}

      @reservation = Hotel::Reservation.new(my_trip)


    end

    it "is an instance of Reservation" do
      @reservation.must_be_kind_of Hotel::Reservation
    end

    it "is set up for specific attributes and data types" do
      [:reservation_id, :room_id, :start_date, :end_date].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.reservation_id.must_be_kind_of Integer
      @reservation.room_id.must_be_kind_of Integer
      @reservation.start_date.must_be_kind_of Date
      @reservation.end_date.must_be_kind_of Date
    end

    it "raises an error for invalid Dates" do
      @reservation.start_date.must_be_instance_of Date
      @reservation.end_date.must_be_instance_of Date
      invalid_data = {
        reservation_id: 8,
        room_id: 5,
        start_date: Date.new(2018,5,7),
        end_date: Date.new(2018,5,5),
      }
      proc {
        Hotel::Reservation.new(invalid_data)
      }.must_raise ArgumentError
    end
  end

  describe "duration method" do
    it "calculates trip length in nights" do
      data = {reservation_id: 1, room_id: 1, start_date:  Date.new(2018,5,5), end_date: Date.new(2018,5,7)}

      my_trip = Hotel::Reservation.new(data)
      my_trip.duration.must_be_instance_of Integer
      my_trip.duration.must_equal 2
    end
  end

  describe "projected_cost method" do
    it "calculates trip length in nights" do
      data = {reservation_id: 1, room_id: 1, start_date:  Date.new(2018,5,5), end_date: Date.new(2018,5,7)}

      my_trip = Hotel::Reservation.new(data)
      my_trip.projected_cost.must_be_instance_of Float
      my_trip.projected_cost.must_equal 200
    end
  end

end
