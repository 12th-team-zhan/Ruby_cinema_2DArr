# frozen_string_literal: true

class Cinema < ApplicationRecord
  # validation
  validates :name, presence: true
  validates :max_row, presence: true
  validates :max_column, presence: true

  # soft delete
  acts_as_paranoid

  # relationship
  belongs_to :theater
  has_many :seats, dependent: :destroy
  has_many :showtimes, dependent: :destroy
  has_many :movies, through: :showtimes, source: :movie
end
