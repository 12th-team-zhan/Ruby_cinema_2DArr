# frozen_string_literal: true

module Admin
  class ShowtimesController < AdminController
    before_action :find_movie, only: %i[index create]
    before_action :find_showtime, only: %i[destroy]

    def index
      @theaters = @movie.theaters

      @showtime = Showtime.new

      @showtimes = @movie.showtimes.order(started_at: :desc).includes(:cinema => [:theater]).paginate(page: params[:page], per_page: 10)
    end

    def create
      @showtime = @movie.showtimes.new(showtime_params)

      showtime_start = showtime_params[:started_at].to_datetime.to_i
      showtime_end = showtime_params[:end_at].to_datetime.to_i

      @showtimes = Showtime.where(cinema_id: showtime_params[:cinema_id])
      showtime_all = @showtimes.map { |showtime| [showtime.started_at.to_i, showtime.end_at.to_i] }

      showtime_condition = showtime_all.map do |arr|
        if showtime_start < arr[0]
          showtime_end < arr[0]
        elsif showtime_start > arr[1]
          showtime_end > arr[1]
        else
          false
        end
      end

      if showtime_condition.include?(false) || showtime_start > showtime_end || showtime_start < Time.current.to_i || showtime_start == showtime_end
        redirect_to admin_movie_showtimes_path(@movie.id), alert: "場次設定有誤,請重新輸入"
      else
        @showtime.save
      end
    end

    def destroy
      @showtime.destroy
    end

    private

    def find_movie
      @movie = Movie.find(params[:movie_id])
    end

    def find_showtime
      @showtime = Showtime.find(params[:id])
    end

    def showtime_params
      params.require(:showtime).permit(:started_at, :end_at, :deleted_at, :cinema_id)
    end
  end
end
