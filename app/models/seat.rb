# frozen_string_literal: true

class Seat < ApplicationRecord
  # soft delete
  acts_as_paranoid

  # relationship
  belongs_to :cinema
end
