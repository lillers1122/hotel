#Lily Sky | Ada c9 Ampers | Hotel Project, Ruby
require 'date'

module Hotel
  class Room
    attr_reader :room_id

    def initialize(input)
      @room_id = input[:room_id]
    end

  end
end
