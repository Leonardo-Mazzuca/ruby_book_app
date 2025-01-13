class UpdateBookingDates < ActiveRecord::Migration[8.0]
  def change
    # Remover as colunas existentes
    remove_column :bookings, :check_in_date, :date
    remove_column :bookings, :check_out_date, :date
    remove_column :bookings, :check_in_time, :time
    remove_column :bookings, :check_out_time, :time

    # Adicionar novas colunas com datetime
    add_column :bookings, :check_in, :datetime
    add_column :bookings, :check_out, :datetime
  end
end
