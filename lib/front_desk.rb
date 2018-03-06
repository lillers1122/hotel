require 'date'
require 'pry'
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

    def find_room(room_id)
      @rooms.find{ |room| room.room_id == room_id }
    end

    def rooms_availabile(r_start, r_end)
      rooms = all_rooms

      unavailable_rooms = []

      @reservations.each do |reservation|
        if reservation.overlap?(r_start, r_end) == false
          a = reservation.room_id
          unavailable_rooms << a
        end
      end

      available_rooms = rooms - unavailable_rooms

      if available_rooms.length == 0
        raise ArgumentError.new("No rooms available!")
      else
        return available_rooms
      end
    end

    def reserve_room(r_start, r_end)
      available_rooms = rooms_availabile(r_start, r_end)
      new_room = available_rooms.first

      new_reservation = Hotel::Reservation.new({
        reservation_id: @reservations.length + 1,
        room_id: new_room,
        start_date: r_start,
        end_date: r_end
        })

      #find_room(new_reservation.room_id).add_reservation(new_reservation)
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
      valid.length == 0?  nil : valid
    end

    def find_cost(id)
      @reservations.each do |reservation|
        if reservation.reservation_id == id
          return reservation.projected_cost
        end
      end
    end

    def room_block(r_start, r_end, number)
      rooms = rooms_availabile(r_start, r_end)
      #(0..number)

      #make a block by ostensibly creating a reservation
    end

  end
end
