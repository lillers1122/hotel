require_relative 'spec_helper'

describe "FrontDesk class" do
  describe "Initializer" do
    it "is an instance of FrontDesk" do
      concierge = Hotel::FrontDesk.new
      concierge.must_be_kind_of Hotel::FrontDesk
    end

    it "establishes the base data structures when instantiated" do
      concierge = Hotel::FrontDesk.new
      [:rooms, :reservations, :blocks].each do |prop|
        concierge.must_respond_to prop
      end

      concierge.rooms.must_be_kind_of Array
      concierge.reservations.must_be_kind_of Array
      concierge.blocks.must_be_kind_of Array
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

  describe "rooms_available method" do
    before do
      @concierge = Hotel::FrontDesk.new
      18.times do
        @concierge.reserve_room('2018-5-5','2018-5-7')
      end
    end

    it "return an array of available rooms for a given date range" do
      @concierge.rooms_available('2018-5-5','2018-5-7').length.must_equal 2
    end

    it "must raise an error if no rooms are available" do
      proc {@concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.rooms_available('2018-5-5','2018-5-7')}.must_raise ArgumentError
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

    it "returns correct cost for a block room reservation" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.find_cost(1).must_equal 320.00

    end
  end

  describe "make_room_block method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.blocks.length.must_equal 0
    end

    it "accurately makes a room block for specific dates" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.blocks.length.must_equal 1
      @concierge.blocks.first.block_id.must_equal 1
      @concierge.blocks.first.start_date.must_equal Date.parse('2018-5-5')
      @concierge.blocks.first.end_date.must_equal Date.parse('2018-5-7')
    end

    it "accurately updates @blocks" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.blocks.length.must_equal 1
    end

    it "raises an ArgumentError if request is for too many rooms" do
      proc {
        @concierge.make_room_block(6, 160, '2018-5-5', '2018-5-7')
      }.must_raise ArgumentError
    end
  end

  describe "room_block_reservations helper method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.blocks.length.must_equal 0
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "accurately updates @reservations" do
      @concierge.reservations.length.must_equal 3
    end

    it "accurately reserves rooms" do
      @concierge.reservations.first.block_id.must_equal 1
      @concierge.reservations.first.block_status.must_equal :AVAILABLE
    end
  end

  describe "find_reservations_in_block() method" do
    it "finds reservations in a given block" do
      @concierge = Hotel::FrontDesk.new
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.find_reservations_in_block(1).length.must_equal 3
      @concierge.find_reservations_in_block(1).first.must_be_kind_of Hotel::Reservation
    end
  end

  describe "reservations_with_available_rooms" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "returns the number of reservations with available within a specific block" do
      @concierge.reservations_with_available_rooms(1).length.must_equal 3
    end

    it "raises an error if reservations have rooms available" do
      proc {
        4.times do
          @concierge.book_blocked_room(1)
        end
      }.must_raise ArgumentError
    end
  end

  describe "book_blocked_room method" do
    before do
      @concierge = Hotel::FrontDesk.new
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "it updates the reservation of the first room available withtin a block" do
      @concierge.reservations_with_available_rooms(1).length.must_equal 3
      @concierge.book_blocked_room(1)
      @concierge.reservations_with_available_rooms(1).length.must_equal 2
    end

    it "raises an error if no rooms are available" do
      proc {
        4.times do
          @concierge.book_blocked_room(1)
        end
      }.must_raise ArgumentError
    end
  end
end















#
