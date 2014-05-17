# -*- encoding : utf-8 -*-
class PrototypesController < ApplicationController
  # GET /prototypes
  # GET /prototypes.json
  def index
    @prototypes = Prototype.order(:race, :name).page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @prototypes }
    end
  end

  # GET /prototypes/1
  # GET /prototypes/1.json
  def show
    @prototype = Prototype.find(params[:id])
    @level_up  = LevelUp.includes(:prev_unit, :next_unit).find(@prototype.level_up_id)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @prototype }
    end
  end

  # GET /prototypes/new
  # GET /prototypes/new.json
  def new
    @prototype  = Prototype.new
    @prototypes = Prototype.order(:name).all
    @level_up   = LevelUp.new
  end

  # GET /prototypes/1/edit
  def edit
    @prototype  = Prototype.find(params[:id])
    @prototypes = Prototype.order(:name).all
    @level_up   = @prototype.level_up
  end

  # POST /prototypes
  # POST /prototypes.json
  def create
    @prototype = Prototype.new(params[:prototype])
    @level_up  = LevelUp.new(  params[:level_up] )

    respond_to do |format|
      if @prototype.valid? && @level_up.valid?
        @level_up.save
        @prototype.level_up_id = @level_up.id
        @prototype.save
        format.html { redirect_to @prototype, notice: 'Prototype was successfully created.' }
        format.json { render json: @prototype, status: :created, location: @prototype }
      else
        format.html { render action: "new" }
        format.json { render json: @prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /prototypes/1
  # PUT /prototypes/1.json
  def update
    @prototype = Prototype.find(params[:id])

    respond_to do |format|
      if @prototype.update_attributes(params[:prototype])
        format.html { redirect_to @prototype, notice: 'Prototype was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @prototype.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /prototypes/1
  # DELETE /prototypes/1.json
  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy

    respond_to do |format|
      format.html { redirect_to prototypes_url }
      format.json { head :no_content }
    end
  end
end
