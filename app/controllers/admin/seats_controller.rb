# frozen_string_literal: true

module Admin
  class SeatsController < AdminController
    before_action :find_cinema, only: %i[index new create edit update]

    def index
      @seats = @cinema.seats.first

      if @seats.nil?
        redirect_to new_admin_cinema_seats_path(@cinema), alert: '影廳座位未建立'
      else
        respond_to do |format|
          format.html { render :index }
          format.json { render json: { seatList: @seats.seat_list } }
        end
      end
    end

    def new
      seat_list = Array.new(@cinema.max_row) { Array.new(@cinema.max_column, 1) }

      respond_to do |format|
        format.html
        format.json { render json: { seatList: seat_list } }
      end
    end

    def create
      @seats = @cinema.seats.new({seat_list: params[:seat_list]})

      if @seats.save
        redirect_to admin_theater_cinemas_path(@cinema.theater_id), notice: '成功新增座位'
      else
        redirect_to new_admin_cinema_seats_path(@cinema)
      end
    end

    def edit
      @seats = @cinema.seats.first

      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { seatList: @seats.seat_list } }
      end
    end

    def update
      @seats = @cinema.seats.first

      if @seats.update({seat_list: params[:seat_list]})
        redirect_to admin_theater_cinemas_path(@cinema.theater_id), notice: '成功更新座位'
      else
        redirect_to edit_admin_cinema_seats_path(@cinema)
      end
    end

    private

    def seat_params
      params.permit(:added, :notAdded)
    end

    def find_cinema
      @cinema = Cinema.find(params[:cinema_id])
    end
  end
end
