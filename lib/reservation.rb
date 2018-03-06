require 'awesome_print'
require 'date'

#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel
  COST = 200
  class Reservation
    attr_reader :reservation_id, :room_id, :start_date, :end_date

    def initialize(input)
      @reservation_id = input[:reservation_id]
      @room_id = input[:room_id]
      @start_date = Date.parse(input[:start_date])
      @end_date = Date.parse(input[:end_date])

      if @end_date != nil && @start_date - @end_date > 0
        raise ArgumentError.new("ENDING BEFORE STARTING IS NOT ALLOWED")
      end
    end

    def duration
      (@end_date - @start_date).to_i
    end

    def projected_cost
      cost = (duration * COST).to_f.round(2)
    end

    def overlap?(r_start, r_end)
      a = Date.parse(r_start)
      b = Date.parse(r_end)
      num = (b - a).to_i
      range = []

      count = 0
      num.times do
        range << a + count
        count += 1
      end

      if a > self.start_date && b < self.end_date
        return false
      elsif range.include?(self.start_date)
        return false
      elsif range.include?(self.end_date - 1)
        return false
      else true
      end
      
    end
  end
end
