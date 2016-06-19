class BattleService
  def initialize(battle)
    @battle = battle
  end

  def defend
    @battle.with_lock do
      @battle.active_unit.update_attribute(defend: true)
      @battle.shift_initiative
      @battle.save!
    end
  end

  def target

  end

  private


end
