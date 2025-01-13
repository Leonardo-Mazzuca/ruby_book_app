class AddTimeToBookings < ActiveRecord::Migration[6.0]
  def change

    remove_column :bookings, :check_out, :datetime, if_exists: true
    remove_column :bookings, :check_in, :datetime, if_exists: true

    # Adicionando as colunas de data e hora
    add_column :bookings, :check_in_time, :time
    add_column :bookings, :check_out_time, :time
    add_column :bookings, :check_in_date, :date
    add_column :bookings, :check_out_date, :date

    # Remover a coluna duplicada de check_out_time (caso haja)

  end
end
