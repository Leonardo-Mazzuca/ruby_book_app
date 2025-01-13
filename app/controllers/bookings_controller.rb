class BookingsController < ApplicationController
  before_action :set_booking, only: %i[ show edit update destroy ]
  before_action :authenticate_user!, only: [:new, :create, :show, :edit]


  # GET /bookings or /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1 or /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
    @booking = Booking.find(params[:id])
  end

  # POST /bookings or /bookings.json
  def create
    @room = Room.find_by(id: booking_params[:room_id])
    
     # Verificar se a sala existe
    if @room.nil?
        flash[:alert] = "Room not found."
        render :new, status: :unprocessable_entity
        return
    end
      
   # Criar a reserva
    
    check_in_datetime = "#{booking_params[:check_in_date]}T#{booking_params[:check_in_time]}"
    check_out_datetime = "#{booking_params[:check_out_date]}T#{booking_params[:check_out_time]}"


    @booking = Booking.new(
      room: @room,
      user: current_user,
      check_in: check_in_datetime,
      check_out: check_out_datetime
    )
    
    # render json: {check_out_datetime: check_out_datetime, check_in_datetime: check_in_datetime}

    room_id = @room.id

    check_in_datetime = DateTime.parse(check_in_datetime).to_s
    check_out_datetime = DateTime.parse(check_out_datetime).to_s

    isAvailable = checkRoomAvailability(room_id, check_in_datetime, check_out_datetime)

    if(!isAvailable)
      @booking.errors.add(:base, "Room is not available for the selected dates.")
      render 'rooms/show', status: :unprocessable_entity
      return
    end

    #  isInPast = (DateTime.parse(check_out_datetime) < DateTime.now) || (DateTime.parse(check_in_datetime) < DateTime.now)

    # if(isInPast)
    #   @booking.errors.add(:base, "You can't book in the past!")
    #   render 'rooms/show', status: :unprocessable_entity
    #   return
    # end

    if check_out_datetime <= check_in_datetime
      @booking.errors.add(:base, "The check-out date must be after the check-in date.")
      render 'rooms/show', status: :unprocessable_entity
      return
    end
  

    # render json: {booking: @booking}
  
    # # Tenta salvar a reserva
    if @booking.save
      redirect_to booking_path(@booking), notice: "Booking created successfully!"
    else
      render 'rooms/show', status: :unprocessable_entity
    end

  end

  
  # PATCH/PUT /bookings/1 or /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: "Booking was successfully updated." }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1 or /bookings/1.json
  def destroy
    @booking.destroy!

    respond_to do |format|
      format.html { redirect_to bookings_path, status: :see_other, notice: "Booking was successfully destroyed." }
      format.json { head :no_content }
    end
  end

    

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def booking_params
      params.require(:booking).permit(:room_id, :check_in_date, :check_out_date, :check_in_time, :check_out_time)
    end
  


    def checkRoomAvailability(room_id, check_in_datetime, check_out_datetime)

    
      actualBookings = Booking.where(room_id: room_id)
    
      actualBookings.each do |booking|
     
        booking_check_in = booking.check_in
        booking_check_out = booking.check_out
    
        # Verifique se os intervalos de datas se sobrepõem
        if datesRangesOverlap?(check_in_datetime, check_out_datetime, booking_check_in, booking_check_out)
          return false
        end
      end
    
      return true
    end

    def datesRangesOverlap?(check_in_datetime, check_out_datetime, booking_check_in, booking_check_out)
      
      return check_in_datetime < booking_check_out && check_out_datetime > booking_check_in
    end
    

    
end
