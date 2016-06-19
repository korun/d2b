class Battle < ActiveRecord::Base
  has_many :units

  def active_unit
    u_id = active_unit_id
    return if u_id.nil?
    self.units.detect { |u| u.id == u_id }
  end

  def active_unit_id
    self.initiative.at(0)
  end

  def shift_initiative
    if self.initiative.at(1) == nil
      create_init
    else
      self.initiative.push self.initiative.shift
    end
    # self.current_step += 1
  end

  private

  def create_init
    self.initiative = self.units.shuffle.sort_by { |u| -u.initiative }.each_with_object([]) do |unit, array|
      array.push(unit.id) unless unit.dead?
    end.push(nil)
  end
end
