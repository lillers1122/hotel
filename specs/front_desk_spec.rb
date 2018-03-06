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
  end

  describe "find_room method" do #unnecessary?
    it "finds a specific room" do
      concierge = Hotel::FrontDesk.new
      concierge.find_room(1).room_id.must_equal 1
    end
  end

  describe "rooms_availabile method" do
    before do
      @concierge = Hotel::FrontDesk.new
      18.times do
        @concierge.reserve_room('2018-5-5','2018-5-7')
      end
    end

    it "return an array of available rooms for a given date range" do
      @concierge.rooms_availabile('2018-5-5','2018-5-7').length.must_equal 2
    end

    it "must raise an error if no rooms are available" do
      proc {@concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.rooms_availabile('2018-5-5','2018-5-7')}.must_raise ArgumentError
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

    # it "adds a new reservation to the correct room object" do
    #   @concierge.reserve_room('2018-5-5','2018-5-7')
    #   a =  @concierge.reservations.first.room_id
    #   @concierge.find_room(a).reservations.length.must_equal 1
    # end
  end

  describe "find_reservations_by_date method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-10')
    end

    it "returns nil if there are no reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-6-5').must_be_nil
    end

    it "returns reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-5-6').length.must_equal 2
    end
  end

  describe "find_cost method" do
    before do
      @concierge = Hotel::FrontDesk.new
    end

    it "returns the cost of the first reservation" do
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.find_cost(1).must_equal 400.00
    end

    it "returns the cost of a given reservation id" do
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-10')
      @concierge.reserve_room('2018-5-5','2018-5-7')

      @concierge.find_cost(2).must_equal 1000.00
    end
  end


end
