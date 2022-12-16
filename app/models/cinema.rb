# frozen_string_literal: true

class Cinema < ApplicationRecord
  validates :name, presence: true
  validates :max_row, presence: true
  validates :max_column, presence: true

  acts_as_paranoid

  # relationship
  has_many :seats
end