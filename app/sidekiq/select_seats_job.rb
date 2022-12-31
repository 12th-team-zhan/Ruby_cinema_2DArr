# frozen_string_literal: true

class SelectSeatsJob
  include Sidekiq::Job

  def perform(showtime_id, row, column, user_id, status)
    ActionCable.server.broadcast("select_seats_#{showtime_id}", {row: row, column: column, userId: user_id, status: status})
  end
end
