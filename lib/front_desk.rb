#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require 'csv'
require 'date'
require 'pry'
require_relative 'room'
require_relative 'reservation'
require_relative 'block'

# contents map - - - -
#LOAD CSV
#ROOM SPECIFIC
#RESERVATION SPECIFIC
#WRITE CSV
# - - - - - - - - - -

module Hotel

  def self.convert_string_date(string)
    return Date.parse(string)
  end

  class FrontDesk

    attr_reader :rooms, :reservations, :blocks

    def initialize(reservations_file, blocks_file)
      @reservations_file = reservations_file.to_s
      @blocks_file = blocks_file.to_s
      @rooms = create_rooms
      @reservations = load_reservations
      @blocks = load_blocks
    end

    #LOAD CSV:
    def load_reservations
      my_file = CSV.open(@reservations_file, headers: true)

      all_reservations = []
      my_file.each do |line|
        input_data = {}
        #status logic
        input_data[:reservation_id] = line[0].to_i
        input_data[:room_id] = line[1].to_i
        input_data[:start_date] = line[2]
        input_data[:end_date] = line[3]
        input_data[:cost] = line[4].to_i
        if line[5].to_i != 0 && line[6] != nil
          input_data[:block_id] = line[5].to_i
          input_data[:block_status] = line[6].to_sym ||= nil
        end
        all_reservations << Reservation.new(input_data)
      end
      return all_reservations
    end

    def load_blocks
      my_file = CSV.open(@blocks_file, headers: true)

      all_blocks = []
      my_file.each do |line|
        input_data = {}
        #status logic
        input_data[:start_date] = line[0]
        input_data[:end_date] = line[1]
        input_data[:cost] = line[2].to_i
        input_data[:block_id] = line[3].to_i
        input_data[:block_rooms] = line[4..-1].map { |room| room.to_i}

        all_blocks << Block.new(input_data)
      end
      return all_blocks
    end

    #ROOM SPECIFIC:
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

    def find_reservation_by_id(res_id)
      a = @reservations.find{ |reservation| reservation.reservation_id == res_id }

      if a == nil
        raise ArgumentError.new("Invalid Reservation ID")
      else
        return a
      end
    end

    def find_cost(res_id)
      reservation = find_reservation_by_id(res_id)
      reservation.projected_cost
    end

    #BLOCK SPECIFIC:
    def make_room_block(number, cost, r_start, r_end)
      if number > 5
        raise ArgumentError.new("Cannot block more than 5 rooms!")
      end

      rooms = (rooms_available(r_start, r_end)).take(number)

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

    #WRITE CSV:
    def save_reservations
      headers = ["reservation_id","room_id","start_date","end_date","cost","block_id","block_status"]
      CSV.open(@reservations_file, 'wb') do |csv|
        csv << headers
        @reservations.each do |reservation|
          csv << reservation.reservations_csv_prep
        end
      end

    end

    def save_blocks
      headers = ["start_date","end_date","cost","block_id","block_rooms"]
      CSV.open(@blocks_file, 'wb') do |csv|
        csv << headers
        @blocks.each do |block|
          csv << block.blocks_csv_prep
        end
      end
    end

  end
end
