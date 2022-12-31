# frozen_string_literal: true

class SelectSeatsChannel < ApplicationCable::Channel

  def subscribed
    stream_from "select_seats_#{params[:showtime_id]}"
  end

  def unsubscribed
  end
end
