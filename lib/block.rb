require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'

module Hotel
  class Block < Reservation
    attr_reader :block_id

    def initialize(input)
      @block_id = input[:block_id]
      super
    end
  end
end
