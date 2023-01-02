# frozen_string_literal: true

class Order < ApplicationRecord
  extend FriendlyId

  acts_as_paranoid
  belongs_to :user
  has_many :tickets
  friendly_id :serial, :use => [:slugged, :finders]

  enum status: { pending: 0, paid: 1, cancel: 2 }
  enum payment_method: { credit_card: 0, remittance: 1, cash: 2 }

  before_validation :generate_serial

  validates :serial, presence: true, uniqueness: true
  validates :amount, presence: true

  # serial
  before_validation :generate_serial

  # soft delete
  acts_as_paranoid

  # relationship
  belongs_to :user
  has_many :tickets
  has_many :showtimes, through: :tickets, source: :showtime

  before_destroy :really_destroy_tickets!

  # enum of column
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

<<<<<<< HEAD
  def should_generate_new_friendly_id?
    slug.blank? || serial_changed?
=======
  def really_destroy_tickets!
    tickets.with_deleted.each do |ticket|
      ticket.really_destroy!
    end
>>>>>>> 8ba7b6c (購票流程 -> 選擇座位-訂單確認-訂單管理頁面)
  end
end
