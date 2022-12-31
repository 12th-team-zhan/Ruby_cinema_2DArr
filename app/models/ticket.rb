# frozen_string_literal: true

class Ticket < ApplicationRecord
  before_validation :generate_serial
  acts_as_paranoid

  ### Action table
  after_create :broadcast_save
  after_destroy :broadcast_destroy

  # relationship
  belongs_to :showtime
  belongs_to :order
  belongs_to :user

  # enum
  enum status: { reserved: 0, booked: 1 }

  # validation
  validates :serial, presence: true, uniqueness: true
  validates_uniqueness_of :showtime_id, scope: [:row, :column]

  # AASM
  include AASM

  aasm column: :status do
    state :reserved, initial: true
    state :booked

    event :pay do
      transitions from: :reserved, to: :booked
    end
  end

  scope :includes_byorder_id, ->(orderid) {includes(showtime: [:movie,{ cinema: :theater }]).where(order_id: orderid).limit(1).references(:showtime).first
  }

  private

  def generate_serial
    self.serial = SecureRandom.alphanumeric(10) if serial.nil?
  end

  def broadcast_save
    SelectSeatsJob.perform_async(self.showtime_id, self.row, self.column, self.user_id, 'reserved')
  end

  def broadcast_destroy
    SelectSeatsJob.perform_async(self.showtime_id, self.row, self.column, self.user_id, 'canceled')
  end
end
