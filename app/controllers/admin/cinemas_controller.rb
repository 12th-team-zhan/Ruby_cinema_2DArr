# frozen_string_literal: true

module Admin
  class CinemasController < AdminController
    before_action :find_theater, only: %i[index new create]
    before_action :find_cinema, only: %i[edit update destroy]

    def index
      @cinemas = @theater.cinemas.order(id: :desc)
    end

    def new
      @cinema = Cinema.new
    end

    def create
      @cinema = @theater.cinemas.new(cinema_params)

      if @cinema.save
        redirect_to admin_theater_cinemas_path(@theater), notice: '成功新增影廳'
      else
        render :new
      end
    end

    def edit; end

    def update
      @seats = @cinema.seats.first

      raw_row = @cinema.max_row
      raw_column = @cinema.max_column
      new_row = cinema_params[:max_row].to_i
      new_column = cinema_params[:max_column].to_i

      if raw_row != new_row || raw_column != new_column
        if @seats.nil?
          redirect_to admin_theater_cinemas_path(@cinema.theater_id), alert: '影廳座位未建立'
        else
          seat_list_raw = @seats.seat_list
          seat_list_new = update_seat_list(seat_list_raw, raw_column, new_row, new_column)

          if not @seats.update({seat_list: seat_list_new})
            redirect_to admin_theater_cinemas_path(@cinema.theater_id), alert: '影廳座位更新有問題'
          end
        end
      end

      if @cinema.update(cinema_params)
        redirect_to admin_theater_cinemas_path(@cinema.theater_id), notice: '成功更新影廳'
      else
        render :edit
      end
    end

    def destroy
      @cinema.destroy
      redirect_to admin_theater_cinemas_path(@cinema.theater_id), notice: '影廳已刪除'
    end

    private

    def cinema_params
      params.require(:cinema).permit(:name, :max_row, :max_column, :regular_price,
                                     :concession_price, :disability_price, :elderly_price)
    end

    def find_cinema
      @cinema = Cinema.find(params[:id])
    end

    def find_theater
      @theater = Theater.find(params[:theater_id])
    end

    def update_seat_list(seats_raw, raw_column, new_row, new_column)
      seats_raw_flatten = seats_raw.flatten
      seats_new = Array.new(new_row) { Array.new(new_column, 1) }

      seats_raw_flatten.each_with_index do |item, index|
        seat_index = index.divmod(raw_column)
        if item != "1" && seat_index[0] <= new_row && seat_index[1] <= new_column
          seats_new[seat_index[0]][seat_index[1]] = item
        end
      end
      return seats_new 
    end
  end
end
