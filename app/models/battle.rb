class Battle < ActiveRecord::Base
  INITIATIVE_SEPARATOR = 0

  has_many :units

  def active_unit
    u_id = active_unit_id
    return if u_id.nil? || u_id == INITIATIVE_SEPARATOR
    self.units.detect { |u| u.id == u_id }
  end

  def active_unit_id
    self.initiative.at(0)
  end

  def add_unit!(prototype_id, cell = 1)
    cell_id = cell.to_i
    if prototype_id.respond_to? :id
      p = prototype_id
    else
      p = Prototype.find(prototype_id)
    end
    big_does_not_fit = false
    if p.big?
      big_does_not_fit = cell_id.odd? && self.units.detect { |u| u.on_cell?(cell_id + 1) }
      cell_id += 1 if big_does_not_fit # For pretty error message only
    end
    if big_does_not_fit || self.units.detect { |u| u.on_cell?(cell_id) }
      raise "Cell #{cell_id} already taken"
    end

    u = Unit.build_from(p, cell_num: cell_id)
    self.with_lock do
      (self.units.push(u) && create_init && self.save!) || raise('Failed to add unit')
    end
    u
  end

  def shift_initiative
    if self.initiative.at(1) == INITIATIVE_SEPARATOR
      create_init
    else
      self.initiative.push self.initiative.shift
    end
    # self.current_step += 1
  end

  private

  def create_init
    self.initiative = self.units(true).shuffle.sort_by { |u| -u.initiative }.each_with_object([]) do |unit, array|
      array.push(unit.id) unless unit.dead?
    end.push(INITIATIVE_SEPARATOR)
  end
end
