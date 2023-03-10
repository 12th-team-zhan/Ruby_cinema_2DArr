# frozen_string_literal: true

module Admin
  class MoviesController < AdminController
    before_action :authenticate_user!
    before_action :find_movie, only: %i[edit update destroy]

    def index
      @movies = Movie.order(debut_date: :desc)
    end

    def new
      @movie = Movie.new
      @theaters = Theater.all
    end

    def edit
      @theaters = Theater.all
    end

    def update
      if @movie.update(movie_params)
        append_movie_poster

        redirect_to admin_movies_path, notice: "成功修改"
      else
        render :edit
      end
    end

    def create
      @movie = current_user.movies.create(movie_params)
      @theaters = Theater.all

      if @movie.save
        append_movie_poster

        if params["theater"].present?
          params.require(:theater).each do |theater|
            MovieTheater.create(movie_id: @movie.id, theater_id: theater.to_i)
          end
        end

        redirect_to admin_movies_path, notice: "成功新增電影!"
      else
        render :new
      end
    end

    def destroy
      @movie.destroy

      redirect_to admin_movies_path, notice: "刪除成功"
    end

    def delete_images
      @image = ActiveStorage::Attachment.find(params[:id])
      @image.purge

      redirect_to admin_movies_path
    end

    def create_movie_poster
      append_movie_poster
    end

    private

    def find_movie
      @movie = Movie.friendly.find(params[:id])
    end

    def movie_params
      params.require(:movie).permit(:name, :eng_name, :duration, :film_rating,
                                    :director, :actor, :debut_date,
                                    :description, :youtube_iframe, images: [])
    end

    def append_movie_poster
      return if params[:movie][:movie_poster].blank?

      @movie.movie_poster.attach(params[:movie][:movie_poster])
    end

    def append_images
      return if params[:movie][:scene_images].blank?

      params[:movie][:scene_images].each do |image|
        @movie.scene_images.attach(image)
      end
    end
  end
end
