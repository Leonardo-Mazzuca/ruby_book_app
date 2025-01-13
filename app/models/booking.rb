class Booking < ApplicationRecord

  belongs_to :room
  belongs_to :user
  

  def getHoursInterval
    check_in = self.check_in
    check_out = self.check_out
  
    check_in_hour = check_in.hour
    check_out_hour = check_out.hour

    if check_out_hour < check_in_hour
      check_out_hour += 24
    end
  
    return check_out_hour - check_in_hour
  end
  

  

end
