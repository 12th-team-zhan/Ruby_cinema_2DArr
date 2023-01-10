# frozen_string_literal: true

class OrdersController < ApplicationController
  before_action :authenticate_user!, except: %i[checkout]
  before_action :find_order, only: %i[destroy pay cancel]
  skip_before_action :verify_authenticity_token, only: %i[checkout]

  def index
    @orders = current_user.orders.with_deleted.paginate(page: params[:page], per_page: 5).order(created_at: :desc)
  end

  def create
    infos = session[:tickets9487]

    @showtime = Showtime.find(infos["showtime_id"])
    @movie = @showtime.movie
    @cinema = @showtime.cinema
    @theater = @cinema.theater
    @total_price = calcTotalPrice(infos, @cinema)

    @tickets = Ticket.where({user_id: current_user.id, showtime_id: infos["showtime_id"], status: "reserved"})

    infos.delete("showtime_id")
    infos.merge!({movie_name: @movie.name, theater_name: @theater.name, 
                  cinema_name: @cinema.name, amount: @total_price, 
                  started_at: @showtime.started_at})


    @order = current_user.orders.new(infos)
    if @order.save
      @tickets.each do |ticket|
        ticket.update(order_id: @order.id)
      end

      redirect_to pay_order_path(@order)
    else
      redirect_back fallback_location: select_seats_tickets_path, alert: '訂單處理過程發生錯誤'
    end
  end

  def pay
    @movie = Movie.find_by(name: @order.movie_name)

    @tickets = Ticket.where({user_id: current_user.id, order_id: @order.id})

    order = { slug: @order.serial, amount: @order.amount, name: '電影票', email: current_user.email }
    @form_info = Mpg.new(order).form_info
  end

  def checkout
    response = MpgResponse.new(params[:TradeInfo])
    @result = response.result

    @order = Order.find_by(serial: @result['MerchantOrderNo'])
    @movie = Movie.find_by(name: @order.movie_name)
    
    if response.status == 'SUCCESS'
      @order.pay!

      @tickets = @order.tickets
      @tickets.each do |t|
        t.pay!
      end
    end
  end

  def destroy
    @order.cancal!
    @order.destroy

    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { render json: { status: "canceled" } }
    end
  end

  private

  def clean_order_params
    params.require(:order).permit(:amount, :payment_method, :created_at)
  end

  def find_order
    @order = current_user.orders.friendly.find(params[:id])
  end

  def calcTotalPrice(params, cinema)
    params["regular_quantity"].to_i * cinema.regular_price + 
    params["concession_quantity"].to_i * cinema.concession_price + 
    params["elderly_quantity"].to_i * cinema.elderly_price + 
    params["disability_quantity"].to_i * cinema.disability_price
  end
end
