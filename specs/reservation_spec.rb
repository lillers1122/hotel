#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require 'pry'
require_relative 'spec_helper'

describe "Reservation class" do

  describe "Reservation instantiation" do
    before do
      my_trip = {reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'}

      @reservation = Hotel::Reservation.new(my_trip)
    end

    it "is an instance of Reservation" do
      @reservation.must_be_kind_of Hotel::Reservation
    end

    it "is set up for specific attributes and data types" do
      [:reservation_id, :room_id, :start_date, :end_date, :block_id, :block_status, :cost].each do |prop|
        @reservation.must_respond_to prop
      end

      @reservation.reservation_id.must_be_kind_of Integer
      @reservation.room_id.must_be_kind_of Integer
      @reservation.start_date.must_be_kind_of Date
      @reservation.end_date.must_be_kind_of Date
      @reservation.cost.must_be_kind_of Integer
      @reservation.block_id.must_be_nil
      @reservation.block_status.must_be_nil
    end

    it "raises an error if end_date is before start_date" do
      invalid_data = {
        reservation_id: 8,
        room_id: 5,
        start_date: '2018-5-7',
        end_date: '2018-5-5',
      }
      proc {
        Hotel::Reservation.new(invalid_data)
      }.must_raise ArgumentError
    end

    it "raises an error if Dates are invalid" do
      proc {
        Hotel::Reservation.new({
          reservation_id: 8,
          room_id: 5,
          start_date: '2018-35-7',
          end_date: '2018-5-5',
        })
      }.must_raise ArgumentError

      proc{
        Hotel::Reservation.new({
          reservation_id: 1,
          room_id: 3,
          start_date: '2018-37',
          end_date: '2018-5-1',
        })
      }.must_raise ArgumentError
    end
  end

  describe "duration method" do
    it "calculates trip length in nights" do
      data = {reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'}

      my_trip = Hotel::Reservation.new(data)
      my_trip.duration.must_be_instance_of Integer
      my_trip.duration.must_equal 2
    end
  end

  describe "projected_cost method" do
    it "calculates trip cost for a normal reservation" do
      data = {reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'}

      my_trip = Hotel::Reservation.new(data)
      my_trip.projected_cost.must_be_instance_of Float
      my_trip.projected_cost.must_equal 400.00
    end

    it "calculates trip cost for an unavailable block reservation" do
      data = {reservation_id: 1, block_id: 1, cost: 180, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7', block_status: :UNAVAILABLE}

      my_trip = Hotel::Reservation.new(data)
      my_trip.projected_cost.must_be_instance_of Float
      my_trip.projected_cost.must_equal 360.00
    end

    it "calculates trip cost for an available block reservation" do
      data = {reservation_id: 1, block_id: 1, cost: 150, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7', block_status: :AVAILABLE}

      my_trip = Hotel::Reservation.new(data)
      my_trip.projected_cost.must_be_instance_of Float
      my_trip.projected_cost.must_equal 300.00
    end
    
    it "doesn't calculate trip cost for non-existant reservation" do
      proc {
        my_trip.projected_cost}.must_raise NameError
    end
  end

  describe "overlap? method" do
    before do
      @my_trip = Hotel::Reservation.new({reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'})
    end

    it "returns false if input dates conflict with an existing reservation" do
      @my_trip.overlap?('2018-5-5','2018-5-7').must_equal false #overlap - same dates
      @my_trip.overlap?('2018-5-2','2018-5-6').must_equal false #overlap - start_date in range
      @my_trip.overlap?('2018-5-6','2018-5-12').must_equal false #overlap - end_date in range
      @my_trip.overlap?('2018-5-4','2018-5-8').must_equal false #overlap - start_date and end_date in range
      @my_trip.overlap?('2018-5-6','2018-5-7').must_equal false #overlap - range inside start_date and end_date
    end

    it "returns true if input dates don't conflict with an existing reservation" do
      @my_trip.overlap?('2018-4-5','2018-4-29').must_equal true #no chance of overlap (before)
      @my_trip.overlap?('2018-5-10','2018-5-16').must_equal true #no chance of overlap (after)
      @my_trip.overlap?('2018-5-7','2018-5-12').must_equal true #no overlap - request_start on an end_date
      @my_trip.overlap?('2018-5-1','2018-5-5').must_equal true # no overlap - request_end on a start_date
    end
  end

  describe "book_blocked_room" do
    it "changes the status of a block room from available to unavailabe" do
      @my_trip = Hotel::Reservation.new(reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7', block_id: 1, block_status: :AVAILABLE)
      @my_trip.book_blocked_room
    end
  end

  describe "reservations_csv_prep" do
    it "creates an Array of the relevant data" do
      @my_trip = Hotel::Reservation.new({reservation_id: 1, room_id: 1, start_date: '2018-5-5', end_date: '2018-5-7', block_id: 1, block_status: :AVAILABLE})

      @my_trip.reservations_csv_prep.must_be_kind_of Array

      @my_trip.reservations_csv_prep[0].must_equal 1
      @my_trip.reservations_csv_prep[1].must_equal 1
      @my_trip.reservations_csv_prep[2].must_equal Date.parse('2018-5-5')
      @my_trip.reservations_csv_prep[3].must_equal Date.parse('2018-5-7')
      @my_trip.reservations_csv_prep[4].must_equal 200
      @my_trip.reservations_csv_prep[5].must_equal 1
      @my_trip.reservations_csv_prep[6].must_equal :AVAILABLE
    end
  end

end
