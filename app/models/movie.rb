# frozen_string_literal: true

class Movie < ApplicationRecord
  # friendly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

  # soft delete
  acts_as_paranoid

  # validation
  validates :name, presence: true
  validates :duration, presence: true

  # relationships
  belongs_to :user
  has_many :showtimes, dependent: :destroy
  has_many :cinemas, through: :showtimes, source: :cinema
  has_many :movie_theater, dependent: :destroy
  has_many :theaters, through: :movie_theater, source: :theater
  has_one_attached :movie_poster
  has_many_attached :scene_images
  has_rich_text :description

  # enum -> film_rating
  enum film_rating: { general: 0, parental_guidance: 1, parental_guidance12: 2, parental_guidance15: 3, restricted: 4 }
end
