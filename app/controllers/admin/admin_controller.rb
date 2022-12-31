# frozen_string_literal: true

module Admin
  class AdminController < ActionController::Base
    layout 'admin'
    before_action :current_user_is_staff
    rescue_from ActiveRecord::RecordNotFound ,with: :record_not_found

    def current_user_is_admin
      render file: "#{Rails.root}/public/404.html", layout: false, status: 400 unless current_user.admin?
    end

    def current_user_is_staff
      render file: "#{Rails.root}/public/404.html", layout: false,  status: 400 unless current_user.admin? || current_user.staff?
    end

    def record_not_found
      render file: "#{Rails.root}/public/404.html", status: 400, layout: false 
    end
  end
end
