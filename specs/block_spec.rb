require_relative 'spec_helper'

describe "Block class" do
  describe "Block initialize" do
    before do
      input = {block_id: 1, start_date: '2018-5-5', end_date: '2018-5-7'}
      @block = Hotel::Block.new(input)
    end

    it "is an instance of Block" do
      @block.must_be_kind_of Hotel::Block
    end

    it "is set up for specific attributes and data types" do
      [:room_id, :block_id, :start_date, :end_date, :block_rooms, :cost].each do |prop|
        @block.must_respond_to prop
      end

      @block.block_id.must_be_kind_of Integer
      @block.start_date.must_be_kind_of Date
      @block.end_date.must_be_kind_of Date
    end


  end
end
