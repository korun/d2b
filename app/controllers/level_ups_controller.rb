# -*- encoding : utf-8 -*-
class LevelUpsController < ApplicationController
  # GET /level_ups
  # GET /level_ups.json
  def index
    @level_ups = LevelUp.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @level_ups }
    end
  end

  # GET /level_ups/1
  # GET /level_ups/1.json
  def show
    @level_up = LevelUp.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @level_up }
    end
  end

  # GET /level_ups/new
  # GET /level_ups/new.json
  def new
    @level_up = LevelUp.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @level_up }
    end
  end

  # GET /level_ups/1/edit
  def edit
    @level_up = LevelUp.find(params[:id])
  end

  # POST /level_ups
  # POST /level_ups.json
  def create
    @level_up = LevelUp.new(params[:level_up])

    respond_to do |format|
      if @level_up.save
        format.html { redirect_to @level_up, notice: 'Level up was successfully created.' }
        format.json { render json: @level_up, status: :created, location: @level_up }
      else
        format.html { render action: "new" }
        format.json { render json: @level_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /level_ups/1
  # PUT /level_ups/1.json
  def update
    @level_up = LevelUp.find(params[:id])

    respond_to do |format|
      if @level_up.update_attributes(params[:level_up])
        format.html { redirect_to @level_up, notice: 'Level up was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @level_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /level_ups/1
  # DELETE /level_ups/1.json
  def destroy
    @level_up = LevelUp.find(params[:id])
    @level_up.destroy

    respond_to do |format|
      format.html { redirect_to level_ups_url }
      format.json { head :no_content }
    end
  end
end
