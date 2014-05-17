# -*- encoding : utf-8 -*-
class Effect < ActiveRecord::Base
  belongs_to :unit

  EFFECTS = {
      0 => "Оборона",
      1 => "Паралич",
      2 => "Страх"  ,
      3 => "Яд"     ,
      4 => "Ожог"   ,
      5 => "Мороз"  ,
      6 => "Защита" , # от элементов
      7 => "Оборот"
  }

  validates :unit_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :unit_id, :presence => true, :inclusion => {:in => Unit.pluck(:id)}
  validates :number,  :presence => true, :numericality => { :only_integer => true }
  validates :time,    :presence => true, :numericality => { :only_integer => true, :greater_than => 0 }
  validates :e_type,  :presence => true, :inclusion => {:in => EFFECTS.keys}

end
