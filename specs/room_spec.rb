require_relative 'spec_helper'

describe "Room class" do
  describe "Room initialize" do
    before do
      @room = Hotel::Room.new(room_id: 1, reservations: [])
    end

    it "is an instance of Room" do
      @room.must_be_kind_of Hotel::Room
    end

    it "is set up for specific attributes and data types" do
      [:room_id, :reservations].each do |prop|
        @room.must_respond_to prop
      end

      @room.room_id.must_be_kind_of Integer
      @room.reservations.must_be_kind_of Array
    end

    it "sets reservations to an empty array" do
      @room.reservations.length.must_equal 0
    end
  end

  describe "add_reservation method" do
    before do
      @new_room = Hotel::Room.new(room_id: 1, reservations: [])
      @new_room.reservations.length.must_equal 0
    end

    it "adds a new reservation to the @reservations array" do
      my_trip = Hotel::Reservation.new({reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'})
      @new_room.add_reservation(my_trip)
      @new_room.reservations.length.must_equal 1
    end

    it "raises an error for an unacceptable date combination" do
      proc {my_trip = Hotel::Reservation.new({reservation_id: 1, room_id: 1, start_date: '2018-5-7', end_date: '2018-5-3'})
      @new_room.add_reservation(my_trip)}.must_raise ArgumentError
    end
  end

  # describe "available?(r_start, r_end) method" do
  #   before do
  #     @concierge = Hotel::FrontDesk.new
  #   end
  #
  #   it "begins with a clean slate (0 reservations)" do
  #     @concierge.reservations.length.must_equal 0
  #     @concierge.check_availability('2018-5-3','2018-5-15').length.must_equal 20
  #   end
  #
  #   it "returns rooms that are entirely available during requested dates" do
  #     # my_trip = Hotel::Reservation.new({reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-5'})
  #
  #     @concierge.reserve_room('2018-5-5','2018-5-5')
  #     @concierge.check_availability('2018-5-3','2018-5-15').must_be_kind_of Array
  #     @concierge.check_availability('2018-5-3','2018-5-15').length.must_equal 19
  #   end
  # end


end
