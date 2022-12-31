# frozen_string_literal: true

class SeatsController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :find_cinema, only: %i[index]

  def index
    @seat_list = @cinema.seats.first.seat_list
    @not_vacancy = Ticket.where({showtime_id: params[:showtime_id]})

    seat_list = make_seating_chart(@seat_list, @not_vacancy)

    render json: { seatList: seat_list }
  end

  private
  def find_cinema
    @cinema = Cinema.find(params[:cinema_id])
  end

  def make_seating_chart(seat_list, not_vacancy)
    not_vacancy.each do |nv|
      if nv.status == 'booked'
        seat_list[nv.row][nv.column] = '2'
      elsif nv.status == 'reserved'
        if nv.user_id == current_user.id
          seat_list[nv.row][nv.column] = '3'
        else
          seat_list[nv.row][nv.column] = '4'
        end
      end
    end

    return seat_list
  end
end
