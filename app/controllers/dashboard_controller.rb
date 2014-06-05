class DashboardController < ApplicationController
  def index
    @tasks = Task.order(:created_at)
  end
end
