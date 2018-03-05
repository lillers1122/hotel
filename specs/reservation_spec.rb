require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do
    before do
      @reservation = Hotel::Reservation.new({reservation_id: 1 room_id: 1, start_date: nil, end_date: nil})
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
      @reservation.start_date.must_be_kind_of Time
      @reservation.end_date.must_be_kind_of Time
    end

    it "raises an error for invalid Dates" do
      @reservation.start_date.must_be_instance_of Time
      @reservation.end_date.must_be_instance_of Time
      invalid_data = {
        reservation_id: 8,
        room_id: 5
        start_date: Date.new(''),
        end_date: Date.new(''),
      }
      proc {
        Hotel::Reservation.new(invalid_data)
      }.must_raise ArgumentError
    end
  end

  describe "duration method" do
    it "calculates trip length in nights" do
      my_trip = Hotel::Reservation.new()
      my_trip.duration.must_be_instance_of Integer
      my_trip.duration.must_equal #nights
    end
  end

  describe "projected method" do
    it "calculates trip length in nights" do
      my_trip = Hotel::Reservation.new()
      my_trip.projected.must_be_instance_of Float
      my_trip.projected.must_equal #cost
    end
  end

end
