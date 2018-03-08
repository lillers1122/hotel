require 'pry'
require_relative './lib/front_desk'
require_relative './lib/reservation'
require_relative './lib/block'
require_relative './lib/room'

concierge = Hotel::FrontDesk.new

def reserve_room(gustave)
  puts "Reserve a room:"
  print "\n Please enter a start date: "
  check_in = gets.chomp
  print " Please enter an end date: "
  check_out = gets.chomp

  a = gustave.reserve_room(check_in, check_out)

  puts "\n📅 Room " + a.room_id.to_s + " booked under Reservation ID: " + a.reservation_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  puts ""
end

def reserve_block(gustave)
  puts "Hold a block of rooms:"
  print "\n Please enter the number of rooms (5 max): "
    rooms = gets.chomp.to_i
  print " Please enter the nightly rate: "
    rate = gets.chomp.to_i
  print " Please enter a start date: "
    check_in = gets.chomp
  print " Please enter an end date: "
    check_out = gets.chomp
  puts ""
  a = gustave.make_room_block(rooms, rate, check_in, check_out)

  puts "\n📅 Rooms: " + a.block_rooms.to_s + " reserved under Block ID: " + a.block_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  puts ""
end

def claim_blocked_room(gustave)
  puts "Reserve a room from a block:"
  print "\nPlease enter the Block ID number: "
    number = gets.chomp.to_i
  a = gustave.reservations_with_available_rooms(number).first

  puts "\n📅 Room " + a.room_id.to_s + " booked under Reservation ID: " + a.reservation_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  gustave.book_blocked_room(number)
  puts ""
end

def see_all_reservations(gustave)
  puts "\n🍩 All reservations: \n"
  puts ""
  gustave.reservations.each do |reservation|
    puts "Reservation ID: " + reservation.reservation_id.to_s
    if reservation.block_id != nil
      puts "🎈Block ID: " + reservation.block_id.to_s
    end
    if reservation.block_status != nil
      puts "🎈Booking Status: " + reservation.block_status.to_s
    end
    puts "  Room Number: " + reservation.room_id.to_s
    puts "  Nightly rate: " + reservation.cost.to_s
    puts "  Check-in: " + reservation.start_date.to_s
    puts "  Check-out: " + reservation.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
end

def see_all_blocks(gustave)
  puts "\n🎈 Blocks on the calendar: "
  puts ""

  gustave.blocks.each do |block|
    puts "Block ID: " + block.block_id.to_s
    puts "  Block rooms: " + block.block_rooms.to_s
    puts "  Nightly rate: " + block.cost.to_s
    puts "  Check-in: " + block.start_date.to_s
    puts "  Check-out: " + block.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
end

def find_reservations_by_date(gustave)
  puts "Find reservation by date:"
  print "\nPlease enter a date: "
  answer = gets.chomp.to_s
  reservations = gustave.find_reservations_by_date(answer)
  request = Date.parse(answer)

  puts "\n🍩 For " + request.to_s + ":"
  puts ""
  reservations.each do |reservation|
    puts "Reservation ID: " + reservation.reservation_id.to_s
    if reservation.block_id != nil
      puts "🎈Block ID: " + reservation.block_id.to_s
    end
    puts "  Room Number: " + reservation.room_id.to_s
    puts "  Nightly rate: " + reservation.cost.to_s
    puts "  Check-in: " + reservation.start_date.to_s
    puts "  Check-out: " + reservation.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
end

def find_reservation_by_reservation_id(gustave)
  print "Please enter Reservation ID: "
  answer = gets.chomp.to_i
  reservation = gustave.find_reservation_by_id(answer)

  puts "\n🍩 You requested Reservation ID: " + answer.to_s + ":"
  puts ""
  puts "Reservation ID: " + reservation.reservation_id.to_s
  if reservation.block_id != nil
    puts "🎈Block ID: " + reservation.block_id.to_s
  end
  if reservation.block_status != nil
    puts "Booking Status: " + reservation.block_status.to_s
  end
  puts "  Room Number: " + reservation.room_id.to_s
  puts "  Nightly rate: " + reservation.cost.to_s
  puts "  Check-in: " + reservation.start_date.to_s
  puts "  Check-out: " + reservation.end_date.to_s
  puts ""
end

def calculate_costs(gustave)
  puts "Calculate total cost:"
  print "\nPlease enter Reservation ID: "
  answer = gets.chomp.to_i
  reservation = gustave.find_reservation_by_id(answer)
  amount = gustave.find_cost(answer)

  puts "\n💰 Cost Calculation 💰"
  puts "\nReservation ID: " + answer.to_s
  puts " Dates: " + reservation.start_date.to_s + " to " + reservation.end_date.to_s
  puts " Total: $" + amount.to_s
  if reservation.block_status != nil
    print " Status: " + reservation.block_status.to_s
  end
  puts ""
end

continue = ""
while continue != "N"

puts "\n✨🌟 🏨 Front Desk Portal 🏨 🌟✨"
puts "- - - - - - - - - - - - - -"
puts "Please select from the listed:

A. Reserve a room
B. Hold a block of rooms
C. Reserve a room from a block

D. See all reservations
E. See all blocks

F. Find reservations by date
G. Find reservation by Reservation ID

H. Calculate cost
- - - - - - - - - - - - - -"
print "\nYour choice: "
answer = gets.chomp.upcase.to_s
puts ""

if answer == "A"
  reserve_room(concierge)
elsif answer == "B"
  reserve_block(concierge)
elsif answer == "C"
  claim_blocked_room(concierge)
elsif answer == "D"
  see_all_reservations(concierge)
elsif answer == "E"
  see_all_blocks(concierge)
elsif answer == "F"
  find_reservations_by_date(concierge)
elsif answer == "G"
  find_reservation_by_reservation_id(concierge)
elsif answer == "H"
# else exit
end



print "\nWould you like to continue using Front Desk Portal? (y/n): "
continue = gets.chomp.upcase
valid_continue_options = ["Y","N"]
until valid_continue_options.include?(continue)
  print "Enter if you want to continue (Y or N)"
  continue = gets.chomp.upcase
end
end



#what to do with invalid block id?
#what to do with invalid cost?
#what to do with invalid number of nights?





#
