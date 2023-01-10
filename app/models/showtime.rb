# frozen_string_literal: true

class Showtime < ApplicationRecord
  # soft delete
  acts_as_paranoid

  # relationship
  belongs_to :movie
  belongs_to :cinema
  has_many :tickets
end
