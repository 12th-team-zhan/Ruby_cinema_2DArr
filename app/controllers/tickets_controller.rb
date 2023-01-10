# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :authenticate_user!, only: %i[create pay]

  def index
    @tickets = Ticket.all
  end

  def show; end

  def create
    infos = {showtime_id: params[:showtime_id], row: params[:row], column: params[:column]}

    @ticket = Ticket.new(infos)
    @ticket.user = current_user
    if @ticket.save
      render json: { msg: "success" }, status: :ok
    else
      render json: { msg: "fail" }, status: :ok
    end
  end

  def destroy
    @ticket = Ticket.find_by({showtime_id: params[:showtime_id], row: params[:row], column: params[:column]})
    @ticket.really_destroy!

    render json: { msg: "cancel" }, status: :ok
  end

  def select_amount
    @showtime = Showtime.find(params[:showtimeid])
    @movie = @showtime.movie
    @cinema = @showtime.cinema
    @theater = @showtime.cinema.theater

    @start_time = @showtime.started_at.strftime("%Y-%m-%d %I:%M %p")
  end

  def select_seats
    session[:tickets9487] = ticket_params
    infos = ticket_params

    @showtime = Showtime.find(params[:showtime_id])
    @movie = @showtime.movie
    @cinema = @showtime.cinema
    @theater = @showtime.cinema.theater

    @start_time = @showtime.started_at.strftime("%Y-%m-%d %I:%M %p")
    @total_price = calc_total_price(ticket_params, @cinema)

    @ticket_list = [
      ("全票#{infos["regular_quantity"]}" unless infos["regular_quantity"] == '0').to_s,
      ("優待票#{infos["concession_quantity"]}" unless infos["concession_quantity"] == '0').to_s,
      ("敬老票#{infos["elderly_quantity"]}" unless infos["elderly_quantity"] == '0').to_s,
      ("愛心票#{infos["disability_quantity"] }" unless infos["disability_quantity"]  == '0').to_s
    ]
  end

  def records
    infos = session[:tickets9487]

    total_quantity = calc_total_quantity(infos)
    seats = Ticket.where({user_id: current_user.id, showtime_id: infos["showtime_id"], status: "reserved"}).pluck("row", "column")
    
    render json: { totalQuantity: total_quantity, seats: seats }
  end

  private

  def find_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    permitted = params.permit(:showtime_id, :regular_quantity, :concession_quantity, :elderly_quantity, :disability_quantity)
    permitted.to_h || {}
  end

  def calc_total_price(params, cinema)
    params["regular_quantity"].to_i * cinema.regular_price + 
    params["concession_quantity"].to_i * cinema.concession_price + 
    params["elderly_quantity"].to_i * cinema.elderly_price + 
    params["disability_quantity"].to_i * cinema.disability_price
  end

  def calc_total_quantity(params)
    params["regular_quantity"].to_i + 
    params["concession_quantity"].to_i + 
    params["elderly_quantity"].to_i + 
    params["disability_quantity"].to_i
  end
end
