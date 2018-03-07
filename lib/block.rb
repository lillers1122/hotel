require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'

module Hotel
  class Block < Reservation
    attr_reader :block_id, :discount
    attr_accessor :block_rooms

    def initialize(input)
      @block_id = input[:block_id]
      @block_rooms = input[:block_rooms]
      @discount = 0.80
      super
    end

    def projected_cost
      cost = ((duration * COST) * 0.80).to_f.round(2)
    end

  end
end
