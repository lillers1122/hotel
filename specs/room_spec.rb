require_relative 'spec_helper'

describe "Room class" do
  describe "Room initialize" do
    before do
      @room = Hotel::Room.new(room_id: 1, reservations: [], status: :AVAILABLE)
    end

    it "is an instance of Room" do
      @room.must_be_kind_of Hotel::Room
    end

    it "is set up for specific attributes and data types" do
      [:room_id, :reservations, :status].each do |prop|
        @room.must_respond_to prop
      end

      @room.room_id.must_be_kind_of Integer
      @room.reservations.must_be_kind_of Array
      @room.status.must_be_kind_of Symbol
    end

    it "sets reservations to an empty array" do
      @room.reservations.length.must_equal 0
    end

    it "sets status to an :AVAILABLE" do
      @room.status.must_equal :AVAILABLE
    end
  end

  describe "unavailable method" do
    it "changes driver's status to UNAVAILABLE" do
    end
  end

end
