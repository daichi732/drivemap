class TopsController < ApplicationController
  skip_before_action :login_required
  def home
  end
end
