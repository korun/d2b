# -*- encoding : utf-8 -*-
class GamesController < ApplicationController
  # GET /games
  # GET /games.json
  def index
    @games = Game.with_map.with_players.order(:created_at).page(params[:page])

    #respond_to do |format|
    #  format.html # index.html.erb
    #  format.json { render json: @games }
    #end
  end

  # GET /games/1
  # GET /games/1.json
  def show
    @game   = Game.full_load.find(params[:id])
    @units  = @game.units

    unless @game.started?
      @player = detect_player

      if    @player == 3
        @units = Hash[@units.collect{|x| [x.cell_num, x]}]
      elsif @player == 2
        @units = Hash[@units.collect{|x| [x.cell_num, x] if x.cell_num >= 7}]
      elsif @player == 1
        @units = Hash[@units.collect{|x| [x.cell_num, x] if x.cell_num <  7}]
      end

      if @player != 0 && @units.blank?
        render 'units/_form.html.haml'
        return
      end
    end

    @units = @game.units

    #respond_to do |format|
    #  format.html # show.html.erb
    #  format.json { render json: @game }
    #end
  end

  # GET /games/new
  # GET /games/new.json
  def new
    @game = Game.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @game }
    end
  end

  # GET /games/1/edit
  def edit
    @game = Game.find(params[:id])
  end

  # POST /games
  # POST /games.json
  def create

    params[:map_id] = rand(Map.count) + 1 if params[:map_id].to_i == 0

    @game = Game.new(params[:game])

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render json: @game, status: :created, location: @game }
      else
        format.html { render action: "new" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /games/1
  # PUT /games/1.json
  def update
    @game = Game.find(params[:id])

    respond_to do |format|
      if @game.update_attributes(params[:game])
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /games/1
  # DELETE /games/1.json
  def destroy
    @game = Game.find(params[:id])
    @game.destroy

    respond_to do |format|
      format.html { redirect_to games_url }
      format.json { head :no_content }
    end
  end

  def make_action
    respond_to do |format|
      format.html { redirect_to game_path(params[:id]) }
      format.js do
        case params[:act]
          when "getActive"
            @game   = Game.with_units.find(params[:id])
            @active = @game.active_unit
            render 'games/js/active.js.haml'
          when "checkState"
            @game = Game.with_units.find(params[:id])
            params[:step] = params[:step] || -2
            @logs = GameLog.where(:game_id => @game.id, :round => 1).where('"step" > ?', params[:step]).order(:step).all
            if @logs.present?
              last_step = @logs.last.step
              @logs.map!{|log| log.action}

              @logs[0] = "cleartrgt();" + @logs[0] if params[:step].to_i > 0

              @active = @game.active_unit
              border_array = []
              @game.units.each{|u| border_array << [u.cell_num, (u.big ? 1 : 0), @active.target_circle_type] if @active.can_hit?(u, @game.units)}
              str = "setActiveU(#{@active.cell_num},#{@active.big ? 1 : 0},#{border_array.inspect.html_safe});Step = #{last_step};"
              @logs << str
            end
            render js: @logs.inspect.html_safe
          when "do"
            @game    = Game.with_units.find(params[:id])
            @active  = @game.active_unit
            if @active.belongs_to_user?(current_user, @game.player1_id, @game.player2_id)
              @target  = @game.units.select{|u| u.id == params[:target_id].to_i}[0]
              @targets = @game.units.select{|u| u.side == @target.side} if @active.reach.in?([0b011, 0b111])
              @t_index = params[:target_i]
              if @target
                @active.undefend!
                str = render "games/js/attack#{@target.attack}.js.haml"
                str = clean_set_active(str[0])
                GameLog.create(:game_id => @game.id, :round => @game.current_round, :step => @game.current_step, :action => str)
              else
                render 'games/js/active.js.haml'
              end
            else
              @dec_step = true
              render 'games/js/active.js.haml'
            end
          when "defend"
            @game    = Game.with_units.find(params[:id])
            @active  = @game.active_unit
            @t_index = params[:target_i]
            @active.defend!
            str = render 'games/js/defend.js.haml'
            str = clean_set_active(str[0])
            GameLog.create(:game_id => @game.id, :round => @game.current_round, :step => @game.current_step, :action => str)
          else
            render js: "alert('#{params.inspect}');"
        end
      end
    end
  end

  private

  def clean_set_active(str)
    ret = str.gsub(/[\s]/, '')
    index1 = ret =~ /,function\(\)\{setActiveU/i
    if index1
      index2 = ret[index1..-1] =~ /\);\}/i
      ret = ret[0...index1] + ret[index1 + index2 + 3..-1]
    end
    ret
  end

  # Если изменяешь - измени и в units_controller!
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

end
