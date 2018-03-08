require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'
require_relative 'block'

module Hotel

  def self.convert_string_date(string) #will raise error if input is invalid date
    return Date.parse(string)
  end

  class FrontDesk
    attr_reader :rooms, :reservations, :blocks

    def initialize
      @rooms = create_rooms
      @reservations = []
      @blocks = []
    end

    #ROOM SPECIFIC - get rid of???:
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

    #RESERVATION SPECIFIC:
    def rooms_available(r_start, r_end)
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
      available_rooms = rooms_available(r_start, r_end)
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

    #BLOCK SPECIFIC:
    def make_room_block(number, cost, r_start, r_end)
      if number > 5
        raise ArgumentError.new("Cannot block more than 5 rooms!")
      end

      rooms = (rooms_available(r_start, r_end)).take(number)
      # puts rooms

      new_block = Hotel::Block.new({
        block_id: @blocks.length + 1,
        block_rooms: rooms,
        start_date: r_start,
        end_date: r_end,
        cost: cost
        })

      @blocks << new_block
      room_block_reservations(new_block)
      return new_block
    end

    def room_block_reservations(block) #helper
      block.block_rooms.each do |room|
        new_reservation = Hotel::Reservation.new({
          block_id: block.block_id,
          reservation_id: @reservations.length + 1,
          room_id: room,
          start_date: block.start_date.to_s,
          end_date: block.end_date.to_s,
          block_status: :AVAILABLE,
          cost: block.cost
          })
        @reservations << new_reservation
      end
    end

    def find_reservations_in_block(r_block_id)
      @reservations.select { |reservation| reservation.block_id != nil && reservation.block_id == r_block_id}
    end

    def reservations_with_available_rooms(r_block_id)
      reservations = find_reservations_in_block(r_block_id)

      acceptable = reservations.select {|block_res| block_res.block_status == :AVAILABLE}

      if acceptable.length == 0
        raise ArgumentError.new("No rooms in block #{r_block_id} left to book!")
      else
        return acceptable
      end
    end

    def book_blocked_room(r_block_id)
      reservation = reservations_with_available_rooms(r_block_id).first

      reservation.book_blocked_room
      return reservation
    end

  end
end
