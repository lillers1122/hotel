require 'date'
#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel
  class Room
    attr_reader :room_id, :reservations, :status

    def initialize(input)
      @room_id = input[:room_id]
      @reservations = []
      @status = :AVAILABLE
    end

    def unavailable
      @status = :UNAVAILABLE
    end

  end
end
