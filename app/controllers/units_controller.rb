# -*- encoding : utf-8 -*-
class UnitsController < ApplicationController
  # GET /units
  # GET /units.json
  def index
    @game  = Game.with_units.find(params[:game_id])
    @units = @game.units

    respond_to do |format|
      format.html # index.html.erb
      format.json do
        render json: my_json(@units)
      end
    end
  end

  # GET /units/1
  # GET /units/1.json
  def show
    @unit = Unit.includes(:prototype).find(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.json do
        render json: my_json(@unit)
      end
    end
  end

  # GET /units/new
  # GET /units/new.json
  #def new
  #  @unit = Unit.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @unit }
  #  end
  #end

  # GET /units/1/edit
  #def edit
  #  @unit = Unit.find(params[:id])
  #end

  # POST /units                                           # ActionDispatch::Cookies::CookieOverflow
  # POST /units.json
  def create
    @game   = Game.find(params[:game_id])
    @player = detect_player
    @units  = params[:units]
    error   = false
    unit_range  = 1..12
    pl1_u_count = 0
    pl2_u_count = 0
    # ЗАПИЛИ ПРОВЕРКУ НА СТОИМОСТЬ ЮНИТОВ!!!
    return access_denied() unless @game
    return access_denied(@game) if @player == 0
    return access_denied(@game, "Битва уже началась!") if @game.started?

    if    @player == 1
      unit_range = 1..6
    elsif @player == 2
      unit_range = 7..12
    end

    @units.each do |k, v|
      if k.to_i.in?(unit_range)
        unit = @game.add_unit(v[:prototype_id], k)
        if unit # != nil
          #if unit.save
          if unit[:unit].valid?
            k.to_i < 7 ? pl1_u_count += 1 : pl2_u_count += 1
          else
            error = true
          end
          @units[k] = unit[:unit]
        else
          @units.delete(k)
        end
      else
        @units.delete(k)
      end
    end

    if (@player == 1 && pl1_u_count == 0) || (@player == 2 && pl2_u_count == 0)
      tmp = @player == 1 ? 1 : 7
      error = true
      @units[tmp] = Unit.new
      @units[tmp].errors.add :id, "Вы не выбрали войска."
    end

    if @player == 3 && (pl1_u_count == 0 || pl2_u_count == 0)
      if    pl1_u_count == 0
        error = true
        @units[1] = Unit.new
        @units[1].errors.add :id, "Вы не выбрали войска для нападающей стороны."
      end
      if pl2_u_count == 0
        error = true
        @units[7] = Unit.new
        @units[7].errors.add :id, "Вы не выбрали войска для обороняющейся стороны."
      end
    end

    if !error
      @units.each{ |k, unit| unit.save }
      # перезагружаем game из БД, для корректной работы .ready?
      @game = Game.with_units.find(params[:game_id])
      if @game.ready?
        @game.create_init!

        GameLog.create(:game_id => @game.id, :round => 1, :step => -1, :action => my_json(@game.units).gsub(/[\s]/, ''))

        @game.current_round = 1
        @game.save
      end
      redirect_to @game
    else
      render 'units/_form.html.haml'
    end
  end

  # PUT /units/1
  # PUT /units/1.json
  #def update
  #  @unit = Unit.find(params[:id])
  #
  #  respond_to do |format|
  #    if @unit.update_attributes(params[:unit])
  #      format.html { redirect_to @unit, notice: 'Unit was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @unit.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # DELETE /units/1
  # DELETE /units/1.json
  def destroy
    @unit = Unit.find(params[:id])
    @unit.destroy

    respond_to do |format|
      format.html { redirect_to units_url }
      format.json { head :no_content }
    end
  end

  private

  # Если изменяешь - измени и в games_controller!
  def detect_player
    res = 0
    return res unless current_user
    cid = current_user.id
    if @game.player1_id == cid && @game.player2_id == cid
      res = 3
    elsif @game.player1_id == cid
      res = 1
    elsif @game.player2_id == cid
      res = 2
    end
    res
  end

  def my_json(u)
    u.to_json(
        :only => [:id, :cell_num, :defend, :health, :health_max],
        :include => {:prototype => {:only => [:id, :race,:name, :big, :reach, :attack]}}
    )
  end

end
