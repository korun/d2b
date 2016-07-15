class BattleService
  def initialize(battle)
    @battle = battle
  end

  def defend
    @battle.with_lock do
      @battle.active_unit.update_attribute(:defend, true)
      @battle.shift_initiative
      @battle.save!
    end
  end

  def target(cell_num)
    # TODO: check user access
    target = @battle.unit_on_cell(cell_num)
    raise('Incorrect target') if target.nil? || !can_hit?(target)
  end

  private

  def active_unit
    @active_unit ||= @battle.active_unit
  end

  def blocked?(unit)
    first_line = unit.left_side? ? Unit::LEFT_SIDE_FIRST_LINE : Unit::RIGHT_SIDE_FIRST_LINE
    return false if unit.on_first_line?
    return false if @battle.units.detect { |u| u.alive? && u.on_cell?(*first_line) }.nil?
    true
  end

  def can_hit?(target_unit)
    attack = active_unit.attack
    return false if target_unit.dead? #&& !active_unit.can_revive?
    case active_unit.reach
      when Prototype::REACH.key(:buffer), Prototype::REACH.key(:mass_buffer) # союзник
        # лекарь или баффер
        if attack.in?(4..6)
          attack_side = self.left_side? ? Unit::LEFT_SIDE.to_a : Unit::RIGHT_SIDE.to_a
          return false unless target_unit.on_cell?(*attack_side)
          return attack != 4 || target_unit.hurt?
        else # WTF??? O_o
          return false
        end
      when Prototype::REACH.key(:warrior) # ближайший вражеский юнит
        attack_side = self.left_side? ? Unit::RIGHT_SIDE.to_a : Unit::LEFT_SIDE.to_a
        return false unless target_unit.on_cell?(*attack_side)
        if !blocked?(active_unit) && !blocked?(target_unit) && can_melee_reach?(target_unit)
          return true
        end
        return false
      when Prototype::REACH.key(:archer), Prototype::REACH.key(:mage) # любой (каждый) вражеский юнит
        attack_side = self.left_side? ? Unit::RIGHT_SIDE.to_a : Unit::LEFT_SIDE.to_a
        return target_unit.on_cell?(*attack_side)
      else
        return false
    end
  end

  def can_melee_reach?(target_unit)
    return true if active_unit.on_central_row? || target_unit.on_central_row?
    if (active_unit.on_bottom_row? && target_unit.on_bottom_row?) ||
        (active_unit.on_top_row? && target_unit.on_top_row?)
      return true
    end
    not_covered_by_other_on_line = @battle.units.detect do |u|
      u.alive? && u.cell_num != target_unit.cell_num && u.on_cell?(*target_unit.line)
    end.nil?
    return true if not_covered_by_other_on_line
    false
  end
end
