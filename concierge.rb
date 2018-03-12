#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require_relative './lib/front_desk'
require_relative './lib/reservation'
require_relative './lib/block'
require_relative './lib/room'

# contents map - - - -
#Make
#Validate input
#Alerts
#Inspect
#Calculate
#Begin Interface
# - - - - - - - - - -

#Make
def reserve_room(gustave)
  puts "🍩 Reserve Room 🍩"
  puts "\nReserve a room:"

  check_in, check_out = valid_dates?

  begin
    a = gustave.reserve_room(check_in, check_out)
  rescue
    puts "\n 🍄 No rooms available!"
    return
  end

  puts "\n📅 Room " + a.room_id.to_s + " booked under Reservation ID: " + a.reservation_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  puts ""
  gustave.save_reservations
end

def reserve_block(gustave)
  puts "🎈 Create New Block 🎈"
  puts "\nHold a block of rooms:"
  print "\n Please enter the number of rooms (5 max): "
    entered_rooms = gets.chomp.to_i
    rooms = valid_integer?(entered_rooms)

  print "\n Please enter the nightly rate: "
    rate_entry = gets.chomp.to_i
    rate = valid_integer?(rate_entry)

  check_in, check_out = valid_dates?

  begin
    a = gustave.make_room_block(rooms, rate, check_in, check_out)
  rescue
    puts "\n 🍄 Cannot block more than 5 rooms!"
    return
  end

  puts "\n📅 Rooms: " + a.block_rooms.to_s + " reserved under Block ID: " + a.block_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  puts ""
  gustave.save_blocks
  gustave.save_reservations
end

def claim_blocked_room(gustave)
  puts "🎈 Reserve Block Room 🎈"
  puts "\nReserve a room from a block:"

  if no_blocks_alert?(gustave) == false
    return
  end

  holds, block_id = valid_block_id?(gustave)

  begin
    a = gustave.reservations_with_available_rooms(block_id).first
  rescue
    puts "\n 🍄 No rooms left in this block!"
    return
  end

  puts "\n📅 Room " + a.room_id.to_s + " booked under Reservation ID: " + a.reservation_id.to_s
  puts " from " + a.start_date.to_s + " to " + a.end_date.to_s
  gustave.book_blocked_room(block_id)
  puts ""
  gustave.save_reservations
end

#Validate input
def valid_integer?(input)
  number = input
  until input > 0
    print "  Please enter a valid number: "
    input = gets.chomp.to_i
    number = input
  end
  return number
end

def valid_dates?
  print "\n Please enter a start date: "
  r_start = gets.chomp.to_s
  check_in = valid_start_date?(r_start)

  print "\n Please enter an end date: "
  r_end = gets.chomp.to_s
  check_out = valid_end_date?(check_in, r_end)

  return check_in, check_out
end

def valid_start_date?(input)
  checker = Date.parse(input) rescue nil
  good = input

  until checker.class == Date && checker >= Date.today
    print " Please enter a valid date: "
    input = gets.chomp.to_s
    checker = Date.parse(input) rescue nil
    good = input
  end
  return good
end

def valid_end_date?(start, input)
  checker = Date.parse(input) rescue nil
  good = input

  until checker.class == Date && checker > Date.parse(start)
    print " Please enter a valid date: "
    input = gets.chomp.to_s
    checker = Date.parse(input) rescue nil
    good = input
  end
  return good
end

def valid_reservation_id?(gustave)
  print "\n Please enter a valid Reservation ID: "
  answer = gets.chomp.to_i
  reservation = gustave.find_reservation_by_id(answer)

  until reservation != nil
    print " Please enter a valid Reservation ID: "
    answer = gets.chomp.to_i
    reservation = gustave.find_reservation_by_id(answer)
  end
  return reservation
end

def valid_date?(gustave) # a booked date
  print "\n Please enter a valid date: "
  answer = gets.chomp.to_s
  reservations = gustave.find_reservations_by_date(answer)

  until reservations != nil
    print " Please enter a valid date: "
    answer = gets.chomp.to_s
    reservations = gustave.find_reservations_by_date(answer)
  end
  return reservations, answer
end

def valid_block_id?(gustave)
  print "\n Please enter a valid Block ID: "
  answer = gets.chomp.to_i
  holds = gustave.find_reservations_in_block(answer)

  until answer > 0 && holds.length != 0
    print " Please enter a valid Block ID: "
    answer = gets.chomp.to_i
    holds = gustave.find_reservations_in_block(answer)
  end
  return holds, answer
end

#Alerts
def no_reservations_alert?(gustave) #superfluous?
  if gustave.reservations.length == 0 || (gustave.reservations.length != 0 && gustave.reservations.all? {|reservation| reservation.block_status == :AVAILABLE} == true)
    puts "\n🍩 No reservations on the books at this time!"
    return false
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
  puts "🍩 Find Reservations by Date 🍩"
  reservations, answer = valid_date?(gustave)

  #RETURN RESULTS
  puts "\n🍩 You requested " + answer.to_s + ":"
  reservations.each do |reservation|
    if (reservation.block_id == nil && reservation.block_status == nil) || (reservation.block_id != nil && reservation.block_status == :UNAVAILABLE)
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
  end
  puts ""
end

def find_reservation_by_reservation_id(gustave)
  if no_reservations_alert?(gustave) == false
    return
  end

  #VALIDATE INPUT
  puts "🍩 Find Reservation by Reservation ID 🍩"
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
  puts "\n🎈 Find Block by Block ID 🎈"
  holds, answer = valid_block_id?(gustave)

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

#Begin Interface
concierge = Hotel::FrontDesk.new('support/reservations.csv', 'support/blocks.csv')

command = ""
while command != "NO"

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
end

print "\n☕️ Would you like to continue using Front Desk Portal? ☕️
Enter any key to continue or 'no' to exit: "
command = gets.chomp.upcase
end
