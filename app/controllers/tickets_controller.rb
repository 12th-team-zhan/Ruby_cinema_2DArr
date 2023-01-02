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

    @showtime = Showtime.find(params[:showtime_id])
    @movie = @showtime.movie
    @cinema = @showtime.cinema
    @theater = @showtime.cinema.theater

    @start_time = @showtime.started_at.strftime("%Y-%m-%d %I:%M %p")
    @total_price = calcTotalPrice(ticket_params, @cinema)
  end

  private

  def find_ticket
    @ticket = Ticket.find(params[:id])
  end

  def ticket_params
    permitted = params.permit(:showtime_id, :regular_quantity, :concession_quantity, :elderly_quantity, :disability_quantity)
    permitted.to_h || {}
  end

  def calcTotalPrice(params, cinema)
    params["regular_quantity"].to_i * cinema.regular_price + 
    params["concession_quantity"].to_i * cinema.concession_price + 
    params["elderly_quantity"].to_i * cinema.elderly_price + 
    params["disability_quantity"].to_i * cinema.disability_price
  end
end
