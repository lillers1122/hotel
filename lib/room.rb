require 'date'
#As an administrator, I can access the list of all of the rooms in the hotel
#As an administrator, I can reserve a room for a given date range
#As an administrator, I can access the list of reservations for a specific date
#As an administrator, I can get the total cost for a given reservation

module Hotel
  class Room
    attr_reader :room_id, :reservations

    def initialize(input)
      @room_id = input[:room_id]
      @reservations = [] #can maybe be removed? or reserve room method for FrontDesk will need to populate this field too
    end

  end
end
