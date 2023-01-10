# frozen_string_literal: true

module OrdersHelper
  def show_tickets_seat(tickets)
    result = ''

    tickets.each do |t|
      result += "#{(t.row + 65).chr}#{t.column.to_s.rjust(2, "0")} "
    end

    return result
  end

  def show_ticket_seat(ticket)
    result = "#{(ticket.row + 65).chr}#{ticket.column.to_s.rjust(2, "0")}"

    return result
  end

  def order_status(status)
    if status == 'SUCCESS'
      html = " <h2><i class'fa-solid fa-thumbs-up me-3'></i>付款成功</h2>"
    else
      html = " <h2><i class='fa-regular fa-face-sad-tear me-3'></i>交易過程發生問題，付款失敗</h2>"
    end
    
    html.html_safe
  end
end