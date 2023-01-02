# frozen_string_literal: true

module OrdersHelper
  def show_tickets_seat(tickets)
    result = ''

    tickets.each do |t|
      result += "#{(t.row + 65).chr}#{t.column.to_s.rjust(2, "0")} "
    end

    return result
  end
end