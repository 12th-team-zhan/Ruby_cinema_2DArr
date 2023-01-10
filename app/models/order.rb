# frozen_string_literal: true

class Order < ApplicationRecord
  # friendly_id
  extend FriendlyId
  friendly_id :serial, use: :slugged

  # soft delete
  acts_as_paranoid

  # relationship
  belongs_to :user
  has_many :tickets

  # validation
  validates :serial, presence: true, uniqueness: true
  validates :amount, presence: true

  # serial
  before_validation :generate_serial

  # delete tickets when delete order
  before_destroy :really_destroy_tickets!
    
  # enum -> status
  enum status: { pending: 0, paid: 1, canceled: 2 }

  # AASM
  include AASM

  aasm column: :status do
    state :pending, initial: true
    state :paid, :canceled

    event :pay do
      transitions from: :pending, to: :paid
    end

    event :cancal do
      transitions from: [:pending, :paid], to: :canceled
    end
  end

  private

  def generate_serial
    self.serial = SecureRandom.alphanumeric(10) if serial.nil?
  end

  def should_generate_new_friendly_id?
    slug.blank? || serial_changed?
  end

  def really_destroy_tickets!
    tickets.with_deleted.each do |ticket|
      ticket.really_destroy!
    end
  end
end
