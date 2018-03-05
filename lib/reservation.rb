require 'awesome_print'

module Hotel
  class Reservation
    attr_reader :reservation_id, :room_id, :start_date, :end_date

    def initialize(input)
      @reservation_id = input[:reservation_id]
      @room_id = input[:room_id]
      @start_date = input[:start_date]
      @end_date = input[:end_date]
    end

    def duration
    end

    def projected_cost
    end





  end
end
