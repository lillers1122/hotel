#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require_relative 'spec_helper'
=begin

#HARD-CODED TEST DATA from support files
##test_teservations.csv
reservation_id,room_id,start_date,end_date,cost,block_id,block_status
1,1,2018-05-05,2018-05-07,200,,
2,2,2018-05-05,2018-05-06,160,1,AVAILABLE
3,3,2018-05-05,2018-05-06,160,1,AVAILABLE

##test_blocks.csv
start_date,end_date,cost,block_id,block_rooms
2018-05-05,2018-05-06,160,1,2,3

=end

describe "FrontDesk class" do
  describe "Initializer" do
    it "is an instance of FrontDesk" do
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      concierge.must_be_kind_of Hotel::FrontDesk
    end

    it "establishes the base data structures when instantiated" do
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      [:rooms, :reservations, :blocks].each do |prop|
        concierge.must_respond_to prop
      end

      concierge.rooms.must_be_kind_of Array
      concierge.reservations.must_be_kind_of Array
      concierge.blocks.must_be_kind_of Array
    end
  end

  #LOAD CSV:
  describe "load_reservations method" do
    it "loads in the number of reservations on the CSV file correctly" do
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      concierge.reservations.length.must_equal 3
      concierge.reservations[1].cost.must_equal 160
      concierge.reservations[1].block_id.must_equal 1
      concierge.reservations[1].block_status.must_equal :AVAILABLE
    end
  end

  describe "load_blocks method" do
    it "loads in the previously saved block data" do
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      concierge.blocks.length.must_equal 1
      concierge.blocks[0].cost.must_equal 160
      concierge.blocks[0].block_id.must_equal 1
      concierge.blocks[0].block_status.must_be_nil
      concierge.blocks[0].start_date.must_equal Date.parse('2018-05-05')
      concierge.blocks[0].end_date.must_equal Date.parse('2018-05-06')
    end
  end

  #ROOM SPECIFIC
  describe "create_room method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
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
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      concierge.all_rooms.must_be_kind_of Array
      concierge.all_rooms.length.must_equal 20
      concierge.all_rooms.first.must_equal 1
      concierge.all_rooms.last.must_equal 20
    end
  end

  describe "find_room method" do #unnecessary?
    it "finds a specific room" do
      concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      concierge.find_room(1).room_id.must_equal 1
    end
  end

  describe "rooms_available method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      16.times do
        @concierge.reserve_room('2018-5-5','2018-5-7')
      end
    end

    it "return an array of available rooms for a given date range" do
      @concierge.rooms_available('2018-5-5','2018-5-7').length.must_equal 1
    end

    it "must raise an error if no rooms are available" do
      proc {
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.rooms_available('2018-5-5','2018-5-7')}.must_raise ArgumentError
    end
  end

  describe "reserve_room method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.reservations.length.must_equal 3
    end

    it "accurately makes a room reservation for specific dates" do
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reservations.length.must_equal 4
      @concierge.reservations[3].reservation_id.must_equal 4
      @concierge.reservations[3].room_id.must_be_kind_of Integer
      @concierge.reservations[3].start_date.must_equal Date.parse('2018-5-5')
      @concierge.reservations[3].end_date.must_equal Date.parse('2018-5-7')
    end
  end

  #RESERVATION SPECIFIC:
  describe "find_reservations_by_date method" do #includes availabe block resrvation holds
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-10')
    end

    it "returns nil if there are no reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-6-5').must_be_nil
    end

    it "returns reservations during the requested timeframe" do
      @concierge.find_reservations_by_date('2018-5-6').length.must_equal 5
    end
  end

  describe "find_reservation_by_id method" do
    it "returns the reservation for the id specified" do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      a = @concierge.reserve_room('2018-5-5','2018-5-7')
      b = @concierge.reserve_room('2018-5-5','2018-5-10')
      @concierge.find_reservation_by_id(4).must_equal a
      @concierge.find_reservation_by_id(5).must_equal b
    end

    it "returns the reservation for the id specified" do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      proc {
        @concierge.find_reservation_by_id(4)
      }.must_raise ArgumentError
    end
  end

  describe "find_cost method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
    end

    it "returns the cost of the first reservation" do
      @concierge.find_cost(1).must_equal 400.00
    end

    it "returns the cost of a given reservation id" do
      @concierge.reserve_room('2018-5-5','2018-5-7')
      @concierge.reserve_room('2018-5-5','2018-5-10')
      @concierge.reserve_room('2018-5-5','2018-5-7')

      @concierge.find_cost(5).must_equal 1000.00
      @concierge.find_cost(6).must_equal 400.00
    end

    it "returns correct cost for a block room reservation" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.find_cost(4).must_equal 320.00
    end

    it "raises an error when asked to calculate trip cost for a non-existant reservation" do
      proc {
        @concierge.find_cost(4)
      }.must_raise ArgumentError
    end
  end

  #BLOCK SPECIFIC:
  describe "make_room_block method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.blocks.length.must_equal 1
    end

    it "accurately makes a room block for specific dates" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.blocks[1].block_id.must_equal 2
      @concierge.blocks[1].start_date.must_equal Date.parse('2018-5-5')
      @concierge.blocks[1].end_date.must_equal Date.parse('2018-5-7')
    end

    it "accurately updates @blocks" do
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.blocks.length.must_equal 2
    end

    it "raises an ArgumentError if request is for too many rooms" do
      proc {
        @concierge.make_room_block(6, 160, '2018-5-5', '2018-5-7')
      }.must_raise ArgumentError
    end
  end

  describe "room_block_reservations helper method" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.blocks.length.must_equal 1
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "accurately updates @reservations" do
      @concierge.reservations.length.must_equal 6
    end

    it "accurately reserves rooms" do
      @concierge.reservations[4].block_id.must_equal 2
      @concierge.reservations[4].block_status.must_equal :AVAILABLE
    end
  end

  describe "find_reservations_in_block() method" do
    it "finds reservations in a given block" do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.blocks.length.must_equal 1
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
      @concierge.find_reservations_in_block(2).length.must_equal 3
      @concierge.find_reservations_in_block(2)[0].must_be_kind_of Hotel::Reservation
      @concierge.find_reservations_in_block(2)[-1].must_be_kind_of Hotel::Reservation
    end
  end

  describe "reservations_with_available_rooms" do
    before do
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.blocks.length.must_equal 1
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "returns the number of available reservations within a specific block" do
      @concierge.reservations_with_available_rooms(1).length.must_equal 2
      @concierge.reservations_with_available_rooms(2).length.must_equal 3
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
      @concierge = Hotel::FrontDesk.new('support/test_reservations.csv', 'support/test_blocks.csv')
      @concierge.blocks.length.must_equal 1
      @concierge.make_room_block(3, 160, '2018-5-5', '2018-5-7')
    end

    it "updates the reservation of the first room available of first block" do
      @concierge.blocks.length.must_equal 2
      @concierge.reservations_with_available_rooms(1).length.must_equal 2
      @concierge.book_blocked_room(1)
      @concierge.reservations_with_available_rooms(1).length.must_equal 1
    end

    it "updates the reservation of the first room available of a given block" do
      @concierge.blocks.length.must_equal 2
      @concierge.reservations_with_available_rooms(2).length.must_equal 3
      @concierge.book_blocked_room(2)
      @concierge.reservations_with_available_rooms(2).length.must_equal 2
    end

    it "raises an error if no rooms are available" do
      proc {
        4.times do
          @concierge.book_blocked_room(2)
        end
      }.must_raise ArgumentError
    end
  end

  #WRITE CSV
  # describe "save_reservations method" do
  #   it "" do
  #   end
  # end
  #
  # describe "save_block method" do
  #   it "" do
  #   end
  # end
end
