class BattleService
  def initialize(battle)
    @battle = battle
  end

  def defend
    @battle.with_lock do
      active_unit.update_attribute(:defend, true)
      @battle.shift_initiative
      @battle.save!
    end
  end

  def target(cell_num)
    active_unit
  end

  private

  def active_unit
    @battle.active_unit
  end
end
