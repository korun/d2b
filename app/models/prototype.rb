# -*- encoding : utf-8 -*-

class Prototype < ActiveRecord::Base

  REACH = {
  #   0b000 =>                              "friend 1   melee", # этакий неродивый баффер %)
      0b001 => "любой союзник",            #"friend 1   any"  , # баффер-точечник
  #   0b010 =>                              "friend all melee", # O_o
      0b011 => "все союзники",             #"friend all any"  , # баффер-массовик
      0b100 => "ближайший вражеский юнит", #"enemy  1   melee", # воин
      0b101 => "любой вражеский юнит",     #"enemy  1   any"  , # лучник
  #   0b110 =>                              "enemy  all melee", # O_o
      0b111 => "все вражеские юниты"       #"enemy  all any"    # маг
  }

  validates :level,      presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :experience, presence: true, numericality: {only_integer: true, greater_than: 0}
  
  validates :big,          inclusion: {in: [true, false]}
  validates :leader,       inclusion: {in: [true, false]}
  validates :twice_attack, inclusion: {in: [true, false]}

  validates :max_health, presence: true, numericality: {only_integer: true, greater_than: 0}
  validates :max_armor,  presence: true, numericality: {only_integer: true}, inclusion: {in: 0..100}
  validates :immune,     presence: true, numericality: {only_integer: true, greater_than: -1}
  validates :resist,     presence: true, numericality: {only_integer: true, greater_than: -1}
  
  

  def animation_delay
    frames_count * 100
  end
end
