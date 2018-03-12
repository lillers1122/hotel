#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require 'date'
require_relative 'reservation'

module Hotel
  class Block < Reservation
    attr_reader :block_id, :block_rooms

    def initialize(input)
      @block_id = input[:block_id]
      @block_rooms = input[:block_rooms]
      super
    end

    def blocks_csv_prep
      array = [@start_date, @end_date, @cost, @block_id] + @block_rooms
    end
  end
end
