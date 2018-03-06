require 'date'
require_relative 'room'
require_relative 'reservation'
#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel
  class FrontDesk
    attr_reader :rooms, :reservations

    def initialize
      @rooms = create_rooms
      @reservations = []
    end

    def create_rooms
      rooms = []
      20.times do |num|
        room = Room.new(room_id: num + 1)
        rooms << room
      end
      return rooms
    end

    def all_rooms
      room_ids = []
      @rooms.each do |room|
        room_ids << room.room_id
      end
      return room_ids
    end

    def reserve_room(r_start, r_end)
        data = {
        reservation_id: @reservations.length + 1,
        room_id: @rooms.sample.room_id, #need to check for trip date conflicts later
        start_date: r_start,
        end_date: r_end
        }
      new_reservation = Hotel::Reservation.new(data)
      @reservations << new_reservation
      return new_reservation
    end

    def find_reservations_by_date(date)
      valid = []
      a = Date.parse(date)

      @reservations.each do |reservation|
        if a.between?(reservation.start_date, reservation.end_date)
          valid << reservation
        end
      end

      if valid.length == 0
        return nil
      else
      return valid
      end
    end




  end
end
