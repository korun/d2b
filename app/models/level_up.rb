# -*- encoding : utf-8 -*-
class LevelUp < ActiveRecord::Base
  belongs_to :next_unit, :class_name => 'Prototype'
  belongs_to :prev_unit, :class_name => 'Prototype'

  ATTRS = [:acc_a, :acc_b, :acc2_a, :acc2_b, :armor_a, :armor_b, :dmg_a, :dmg_b, :dmg2_a, :dmg2_b, :exp_next_a, :exp_next_b, :hp_a, :hp_b]

  validates :next_unit_id, :allow_blank => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :next_unit_id, :inclusion => {:in => Prototype.pluck(:id)}, :allow_blank => true
  validates :prev_unit_id, :allow_blank => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :prev_unit_id, :inclusion => {:in => Prototype.pluck(:id)}, :allow_blank => true
  validates_each ATTRS do |record, attr, value|
    record.errors.add(attr, 'должно быть неотрицательным числом') if value.to_i < 0
  end

end
