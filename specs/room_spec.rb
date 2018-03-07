require_relative 'spec_helper'

describe "Room class" do
  describe "Room initialize" do
    before do
      @room = Hotel::Room.new(room_id: 1)
    end

    it "is an instance of Room" do
      @room.must_be_kind_of Hotel::Room
    end

    it "is set up for specific attributes and data types" do
      @room.must_respond_to :room_id
      @room.room_id.must_be_kind_of Integer
    end

    it "correctly initializes default data" do
      @room.room_id.must_equal 1
    end
  end

end
