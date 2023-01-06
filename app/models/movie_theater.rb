# frozen_string_literal: true

class MovieTheater < ApplicationRecord
  # relationships
  belongs_to :movie
  belongs_to :theater
end
