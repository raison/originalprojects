class SearchController < ApplicationController
  #before_filter :require_profile
  
  def index
    @search = Search.new(params)
  end
end
