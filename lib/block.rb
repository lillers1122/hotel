require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'

module Hotel
  class Block < Reservation
    attr_reader :block_id
    attr_accessor :block_rooms

    def initialize(input)
      @block_id = input[:block_id]
      @block_rooms = input[:block_rooms]
      super
    end

  end
end
