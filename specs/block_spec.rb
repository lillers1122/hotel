#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
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

    describe "blocks_csv_prep" do
      it "it creates an array of the relevant data" do
        input = {block_id: 1, start_date: '2018-5-5', end_date: '2018-5-7', block_rooms: [1,2,3]}
        @block = Hotel::Block.new(input)

        @block.blocks_csv_prep.must_be_kind_of Array
        @block.blocks_csv_prep[4..6].must_equal [1,2,3]
      end
    end
  end
end
