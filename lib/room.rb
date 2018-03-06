require 'date'
#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel
  class Room
    attr_reader :room_id
    attr_accessor :reservations

    def initialize(input)
      @room_id = input[:room_id]
      @reservations = []
    end

    def add_reservation(new_reservation)
      @reservations << new_reservation
    end

    # def available?(s_date, e_date)
    #   available_rooms = []
    #
    #   @rooms.each do |room|
    #     room.reservations.each do |reservation|
    #       binding.pry
    #       if reservation.overlap?(s_date, e_date) == false
    #         binding.pry
    #         available_rooms << reservation[:room_id]
    #
    #       end
    #     end
    #   end
    #   return available_rooms
    # end

  end
end
