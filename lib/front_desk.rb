require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'
require_relative 'block'
#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel

  def self.convert_string_date(string)
    return Date.parse(string)
  end

  class FrontDesk
    attr_reader :rooms, :reservations, :blocks

    def initialize
      @rooms = create_rooms
      @reservations = []
      @blocks = []
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

    def make_room_block(number, r_start, r_end)
      if number > 5
        raise ArgumentError.new("Cannot block more than 5 rooms!")
      end

      rooms = (rooms_available(r_start, r_end)).take(number)
      # puts rooms

      new_block = Hotel::Block.new({
        block_id: @blocks.length + 1,
        block_rooms: rooms,
        start_date: r_start,
        end_date: r_end
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
          end_date: block.end_date.to_s
          })
        @reservations << new_reservation
      end
    end

    def find_reservations_in_block(r_block_id)
      @reservations.select { |reservation| reservation.block_id != nil && reservation.block_id == r_block_id}
    end

    def find_blocked_rooms(r_block_id)
      block_reservations = find_reservations_in_block(r_block_id)

      rooms_in_block = []

      block_reservations.each do |block_res|
        rooms_in_block << block_res.room_id
      end
      return rooms_in_block
    end

    def find_blocked_room(r_room_id, r_block_id)
      rooms = find_blocked_rooms(r_block_id)

      rooms.find { |room| room.room_id == r_room_id && room.block_id == r_block_id }

    end

    def book_blocked_room(block_id)
      blocked_rooms(block_id)
    end


  end


end

=begin
-As an administrator, I can create a block of rooms
-To create a block you need a date range, collection of rooms and a discounted room rate
-The collection of rooms should only include rooms that are available for the given date range
-If a room is set aside in a block, it is not available for reservation by the general public, nor can it be included in another block
-As an administrator, I can check whether a given block has any rooms available
-As an administrator, I can reserve a room from within a block of rooms

#Constraints
-A block can contain a maximum of 5 rooms
-When a room is reserved from a block of rooms, the reservation dates will always match the date range of the block
-All of the availability checking logic from Wave 2 should now respect room blocks as well as individual reservations
=end
