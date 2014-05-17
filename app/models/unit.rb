# -*- encoding : utf-8 -*-
class Unit < ActiveRecord::Base
  belongs_to :prototype, :readonly => true
  belongs_to :game

  LEFT_SIDE  = 1..6
  RIGHT_SIDE = 7..12


  #prototype_id
  #game_id
  #cell_num
  #level

  #health
  #health_max
  #accuracy
  #accuracy_2
  #armor
  #damage
  #damage_2
  #initiative
  #resist
  #experience

  #defend

  attr_accessible :prototype_id, :game_id, :cell_num, :level
  validates :prototype_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :prototype_id, :presence => true, :inclusion => {:in => Prototype.pluck(:id)}
  validates :game_id,      :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :game_id,      :presence => true, :inclusion => {:in => Game.pluck(:id)}
  validates :cell_num,     :presence => true, :inclusion => {:in => 1..12}
  validates :level,        :numericality => {:only_integer => true, :greater_than => 0}

  # Prototypes attrs
  def big;      self.prototype.big      end
  def name;     self.prototype.name     end
  def delay_a;  self.prototype.delay_a  end
  def race;     self.prototype.race     end
  def reach;    self.prototype.reach    end
  def attack;   self.prototype.attack   end
  def attack_2; self.prototype.attack_2 end
  def source;   self.prototype.source   end
  def source_2; self.prototype.source_2 end

  def belongs_to_user?(user, left_id, right_id)
    (self.side == 0 && user.id == left_id) || (self.side == 1 && user.id == right_id)
  end

  def side
    self.cell_num < 7 ? 0 : 1
  end

  def dead?
    self.health <= 0
  end

  def defend!
    self.defend = true
    self.save
  end

  def undefend!
    self.defend = false
    self.save
  end

  def blocked?(all_units)
    first_line = self.cell_num < 7 ? [2, 4, 6] : [7, 9, 11]
    return false if self.cell_num.in?(first_line) || all_units.select{|u| !u.dead? && u.cell_num.in?(first_line)}.blank?
    true
  end

  # Перед вызовом обязательно проверять на "can_hit?"
  def hit(target_unit)
    msg    = ""
    dmg    = ""
    damage = 0
    immune = target_unit.has_immune?(self.source)
    resist = target_unit.has_resist?(self.source)
    miss   = rand(101) > self.accuracy
    if miss
      msg = 'miss'
      dmg = 'miss'
    elsif target_unit.dead?
      return {need_revive:true} if self.can_revive? && !immune && !resist
    elsif immune || resist
      dmg = immune ? 'immune' : 'resist'
      msg = 'block'
    elsif self.attack == 4 # лечение
      damage = self.damage
      damage = target_unit.health_max - target_unit.health if target_unit.health_max - target_unit.health < damage
      msg = 'heal'
      dmg = "+#{damage}"
    else
      damage = self.damage
      damage = ((damage + (rand * (2 * (damage * 0.05).round + 1)).round - (damage * 0.05).round) * (1 - target_unit.armor / 100.0)).to_i
      damage = damage >> 1 if target_unit.defend?
      damage = target_unit.health if target_unit.health < damage
      msg = 'dmg'
      dmg = "-#{damage}"
    end
    {msg:msg, dmg:dmg, damage:damage, immune:immune, resist:resist, miss:miss}
  end

  def hit!(target_unit, all_units)
    if self.can_hit?(target_unit, all_units)
      result = self.hit(target_unit)
      if result[:miss] || result[:immune] || result[:need_revive] || target_unit.dead?
        return result
      elsif result[:resist]
        target_unit.delete_resist!(self.source)
      else
        target_unit.health -= (self.attack == 4 ? -result[:damage] : result[:damage])
        target_unit.save
      end
      result
    else
      false
    end
  end

  def has_immune?(source)
    self.prototype.has_immune?(source)
  end

  def has_resist?(source)
    self.resist & source != 0
  end

  def delete_resist(source)
    self.resist ^= source
  end

  def delete_resist!(source)
    self.delete_resist(source)
    self.save
  end

  def can_hit?(target_unit, all_units) # WARNING, see prototype.rb
    reach  = self.reach
    attack = self.attack
    return false unless !target_unit.dead? || self.can_revive?
    case reach
      when 0b001, 0b011 # союзник
        # лекарь или баффер
        if attack.in?(4..6)
          attack_side = self.cell_num < 7 ? LEFT_SIDE : RIGHT_SIDE
          return target_unit.cell_num.in?(attack_side) && (attack != 4 || target_unit.health_max - target_unit.health > 0)
        else
          return false
        end
      when 0b100        # ближайший вражеский юнит
        attack_side = self.cell_num < 7 ? RIGHT_SIDE : LEFT_SIDE
        return false unless target_unit.cell_num.in?(attack_side)
        return true  unless self.blocked?(all_units) || target_unit.blocked?(all_units) || self.has_exception?(target_unit, all_units)
        return false
      when 0b101, 0b111 # любой (каждый) вражеский юнит
        attack_side = self.cell_num < 7 ? RIGHT_SIDE : LEFT_SIDE
        return target_unit.cell_num.in?(attack_side)
      else
        return false
    end
  end
  
  def can_revive?
    self.attack_2 == 7
  end

  def target_circle_type
    return 'h' if self.attack.in?(4..6)
    return 's' if self.attack == 14
    'a'
  end

  def has_exception?(target_unit, all_units)
    return false if self.in_c_line? || target_unit.in_c_line?
    return false if (self.in_b_line? && target_unit.in_b_line?) || (self.in_t_line? && target_unit.in_t_line?)
    return false if all_units.select{|u| !u.dead? && u.cell_num != target_unit.cell_num && u.cell_num.in?(target_unit.column)}.blank?
    true
  end

  def column
    if    self.cell_num.in?([1,  3,  5])
      [1,  3,  5]
    elsif self.cell_num.in?([2,  4,  6])
      [2,  4,  6]
    elsif self.cell_num.in?([7,  9, 11])
      [7,  9, 11]
    elsif self.cell_num.in?([8, 10, 12])
      [8, 10, 12]
    end
  end
  
  def in_t_line?
    self.cell_num.in?([1, 2,  7,  8])
  end
  
  def in_c_line?
    self.cell_num.in?([3, 4,  9, 10])
  end
  
  def in_b_line?
    self.cell_num.in?([5, 6, 11, 12])
  end

end
