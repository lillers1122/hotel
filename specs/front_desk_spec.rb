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

  describe "find_room" do
    it "throws an argument error for a bad room_id" do
    end

    it "finds a room instance" do
    end
  end

  describe "find_reservation method" do
    it "throws an argument error for a bad reservation_id" do
    end

    it "finds a reservation instance" do
    end
  end

  describe "create_reservation" do
    it "accurately makes a room reservation for specific dates" do
    end
  end


end
