# frozen_string_literal: true

class Theater < ApplicationRecord
  # friendly_id
  extend FriendlyId
  friendly_id :name, use: :slugged

  # soft delete
  acts_as_paranoid

  # validation
  validates :name, presence: true
  validates :area, presence: true
  validates :address, presence: true
  validates :phone, presence: true

  # relationship
  has_one_attached :exterior_img
  has_many :cinemas, dependent: :destroy
  has_many :movie_theater, dependent: :destroy
  has_many :movies, through: :movie_theater, source: :movie
  has_rich_text :description
  has_rich_text :transportation
  
  # enum -> area
  enum area: { north: 0, middle: 1, south: 2, east: 3 }
end
