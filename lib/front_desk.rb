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

    def reserve_room(visit_start, visit_end)
        data = {
        reservation_id: @reservations.length + 1,
        room_id: @rooms.sample.room_id,
        start_date: Date.new(visit_start),
        end_date: Date.new(visit_end)
        }
        
      new_reservation = Hotel::Reservation.new(data)

      @reservations << new_reservation

    end

    def find_reservation
    end




  end
end
