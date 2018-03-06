require_relative 'spec_helper'

describe "FrontDesk class" do
  describe "Initializer" do
    it "is an instance of FrontDesk" do
      concierge = Hotel::FrontDesk.new
      concierge.must_be_kind_of Hotel::FrontDesk
    end

    it "establishes the base data structures when instantiated" do
      concierge = Hotel::FrontDesk.new
      [:rooms, :reservations].each do |prop|
        concierge.must_respond_to prop
      end

      concierge.rooms.must_be_kind_of Array
      concierge.reservations.must_be_kind_of Array
    end
  end

  describe "create_room method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.create_rooms
    end
    it "creates 20 rooms" do
      @concierge.rooms.length.must_equal 20
    end

    it "creates rooms with ids from 1 - 20" do
      @concierge.rooms.first.room_id.must_equal 1
      @concierge.rooms.last.room_id.must_equal 20
    end
  end

  describe "all_rooms method" do
    it "prints a list of every room_id in the hotel" do
      concierge = Hotel::FrontDesk.new
      concierge.all_rooms.must_be_kind_of Array
      concierge.all_rooms.length.must_equal 20
      concierge.all_rooms.first.must_equal 1
      concierge.all_rooms.last.must_equal 20

    end

    it "finds a room instance" do
    end
  end

  describe "reserve_room method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.reservations.length.must_equal 0
    end

    it "accurately makes a room reservation for specific dates" do
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reservations.length.must_equal 1
      @concierge.reservations.first.reservation_id.must_equal 1
      @concierge.reservations.first.room_id.must_be_kind_of Integer
      @concierge.reservations.first.start_date.must_equal Date.parse('2018-5-5')
      @concierge.reservations.first.end_date.must_equal Date.parse('2018-5-7')
    end
  end

  describe "find_reservations_by_date method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-10')
    end

    it "returns nil if there are no reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-6-5','2018-6-7').must_be_nil
    end

    it "returns reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-5-5','2018-5-10').length.must_equal 2
    end
  end




end
