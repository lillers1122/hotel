require 'pry'
require_relative './lib/front_desk'
require_relative './lib/reservation'
require_relative './lib/block'
require_relative './lib/room'


#Make
def reserve_room(gustave)
  puts "🍩 Reservation Room 🍩"
  puts "\nReserve a room:"
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
  puts "🎈 Create New Block 🎈"
  puts "\nHold a block of rooms:"
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
  puts "🎈 Reserve Block Room 🎈"
  puts "\nReserve a room from a block:"
  print "\nPlease enter the Block ID number: "
    number = gets.chomp.to_i
  a = gustave.reservations_with_available_rooms(number).first

  puts "\n📅 Room " + a.room_id.to_s + " booked under Reservation ID: " + a.reservation_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  gustave.book_blocked_room(number)
  puts ""
end

#Validate input
def no_reservations_alert?(gustave) #superfluous?
  if gustave.reservations.length == 0 || (gustave.reservations.length != 0 && gustave.reservations.all? {|reservation| reservation.block_status == :AVAILABLE} == true)
    puts "\n🍩 No reservations on the books at this time!"
    return false
  # elsif (gustave.reservations.length != 0 && gustave.reservations.all? {|reservation| (reservation.block_id != nil && reservation.block_status == :AVAILABLE)} == true)
  #   puts "\n🍩 No reservations on the books at this time!"
  #   return false
  else
    return true
  end

end

def no_blocks_alert?(gustave)
  if gustave.blocks.length == 0
    puts "\n🎈 No blocks on the books at this time!"
    return false
  else
    return true
  end
end

def valid_reservation_id?(gustave)
  print "\nPlease enter a valid Reservation ID: "
  answer = gets.chomp.to_i
  reservation = gustave.find_reservation_by_id(answer)

  until reservation != nil
    print "Please enter a valid Reservation ID: "
    answer = gets.chomp.to_i
    reservation = gustave.find_reservation_by_id(answer)
  end
  return reservation
end

def valid_date?(gustave)
  print "\nPlease enter a date: "
  answer = gets.chomp.to_s
  reservations = gustave.find_reservations_by_date(answer)

  until reservations != nil
    print "Please enter a valid date: "
    answer = gets.chomp.to_s
    reservations = gustave.find_reservations_by_date(answer)
  end
  return reservations, answer
end

def valid_block_id(gustave)
  print "\nPlease enter a valid Block ID: "
  answer = gets.chomp.to_i
  holds = gustave.find_reservations_in_block(answer)

  until holds != nil
    print "Please enter a valid Block ID: "
    answer = gets.chomp.to_i
    holds = gustave.find_reservation_by_id(answer)
  end
  return holds, answer
end



#Inspect
def see_all_reservations(gustave)
  if no_reservations_alert?(gustave) == false
    return
  end

  puts "\n🍩 All reservations: \n"

  gustave.reservations.each do |reservation|
    if (reservation.block_id == nil && reservation.block_status == nil) || (reservation.block_id != nil && reservation.block_status == :UNAVAILABLE)
      puts "\nReservation ID: " + reservation.reservation_id.to_s
      if reservation.block_id != nil
        puts " Block ID: " + reservation.block_id.to_s
      end
      puts "  Room Number: " + reservation.room_id.to_s
      puts "  Nightly rate: " + reservation.cost.to_s
      puts "  Check-in: " + reservation.start_date.to_s
      puts "  Check-out: " + reservation.end_date.to_s
      puts ". . . . . . . . . . . . ."
    end
  end
end

def see_all_blocks(gustave)
  if no_blocks_alert?(gustave) == false
    return
  end

  puts "\n🎈 All blocks on the calendar: "

  gustave.blocks.each do |block|
    puts "\nBlock ID: " + block.block_id.to_s
    puts "  Block rooms: " + block.block_rooms.to_s
    puts "  Nightly rate: " + block.cost.to_s
    puts "  Check-in: " + block.start_date.to_s
    puts "  Check-out: " + block.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
end

def find_reservations_by_date(gustave)
  if no_reservations_alert?(gustave) == false
    return
  end
  #VALIDATE DATE
  puts "🍩 Find reservation by date 🍩"
  reservations, answer = valid_date?(gustave)

  #RETURN RESULTS
  puts "\n🍩 You requested " + answer.to_s + ":"
  reservations.each do |reservation|
    puts "\nReservation ID: " + reservation.reservation_id.to_s
    if reservation.block_id != nil
      puts "Block ID: " + reservation.block_id.to_s
    end
    puts "  Room Number: " + reservation.room_id.to_s
    puts "  Nightly rate: " + reservation.cost.to_s
    puts "  Check-in: " + reservation.start_date.to_s
    puts "  Check-out: " + reservation.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
  puts ""
end

def find_reservation_by_reservation_id(gustave)
  if no_reservations_alert?(gustave) == false
    return
  end

  #VALIDATE INPUT
  puts "🍩 Find reservation by Reservation ID 🍩"
  reservation = valid_reservation_id?(gustave)

  #RETURN RESULTS
  if reservation.block_status != :AVAILABLE
    puts "\n🍩 You requested Reservation ID: " + reservation.reservation_id.to_s + ":"
    puts "\nReservation ID: " + reservation.reservation_id.to_s
    if reservation.block_id != nil && reservation.block_status == :UNAVAILABLE
      puts " Block ID: " + reservation.block_id.to_s
      puts " Booking Status: " + reservation.block_status.to_s
    end
    puts "  Room Number: " + reservation.room_id.to_s
    puts "  Nightly rate: " + reservation.cost.to_s
    puts "  Check-in: " + reservation.start_date.to_s
    puts "  Check-out: " + reservation.end_date.to_s
  end
  puts ""
end

def find_block_by_block_id(gustave)
  if no_blocks_alert?(gustave) == false
    return
  end

  #VALIDATE INPUT
  puts "\n🎈 Find block by Block ID 🎈"
  holds, answer = valid_block_id(gustave)

  #RETURN RESULTS
  puts "\n🎈 You requested Block ID " + answer.to_s + ":"
  holds.each do |hold|
    puts "\nReservation ID: " + hold.reservation_id.to_s
    puts " Block ID: " + hold.block_id.to_s
    puts " Booking Status: " + hold.block_status.to_s
    puts "  Room Number: " + hold.room_id.to_s
    puts "  Nightly rate: " + hold.cost.to_s
    puts "  Check-in: " + hold.start_date.to_s
    puts "  Check-out: " + hold.end_date.to_s
    puts ". . . . . . . . . . . . ."
  end
  puts ""
end

#Calculate
def calculate_costs(gustave)
  if no_reservations_alert?(gustave) == false
    return
  end

  puts "💰 Calculate Total Cost 💰"

  #VALIDATE INPUT
  reservation = valid_reservation_id?(gustave)
  amount = gustave.find_cost(reservation.reservation_id)

  #RETURN RESULTS
  if reservation.block_id != nil && reservation.block_status == :AVAILABLE
    puts "\n🔱 You have not requested a complete reservation! 🔱"
    puts "\nReservation ID: " + reservation.reservation_id.to_s + " is held for Block ID: " + reservation.block_id.to_s
    puts "\nIt is currently available to reserve:"
    puts " Dates: " + reservation.start_date.to_s + " to " + reservation.end_date.to_s
    puts " Total: $" + amount.to_s
    return
  else
    puts "\n🔱 Cost Calculation 🔱"
    puts "\nReservation ID: " + reservation.reservation_id.to_s
    puts " Dates: " + reservation.start_date.to_s + " to " + reservation.end_date.to_s
    puts " Total: $" + amount.to_s
    if reservation.block_status != nil
      print " Status: " + reservation.block_status.to_s
    end
  end
  puts ""
end




concierge = Hotel::FrontDesk.new

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
H. Find block by Block ID

I. Calculate cost
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
  find_block_by_block_id(concierge)
elsif answer == "I"
  calculate_costs(concierge)
# else exit?
end


#press any key to continue or enter exit to quit
print "\nWould you like to continue using Front Desk Portal? (y/n): "
continue = gets.chomp.upcase
valid_continue_options = ["Y","N"]
until valid_continue_options.include?(continue)
  print "Please enter y if you want to continue (Y or N)"
  continue = gets.chomp.upcase
end
end


#check input for making things
#what to do with invalid number of nights?
#what to do with invalid date - past date! OKay? be able to look at previous trips too?? but not make trips in the past?
#what to do with past reservations? if saving to csv
