# -*- encoding : utf-8 -*-
class MapsController < ApplicationController
  # GET /maps
  # GET /maps.json
  def index
    @maps = Map.order(:id).all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @maps }
    end
  end

  # GET /maps/1
  def show
    @map = Map.find(params[:id])
  end

end
