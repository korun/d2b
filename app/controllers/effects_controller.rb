# -*- encoding : utf-8 -*-
class EffectsController < ApplicationController

  #before_filter :check_auth
  before_filter :check_admin#, :only => ['index', 'show']

  # GET /effects
  # GET /effects.json
  def index
    @effects = Effect.page(params[:page])
    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @effects }
    #end
  end

  # GET /effects/1
  # GET /effects/1.json
  def show
    @effect = Effect.find(params[:id])
    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @effect }
    #end
  end

end
