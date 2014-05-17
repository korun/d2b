# -*- encoding : utf-8 -*-
class Prototype < ActiveRecord::Base
  #has_one :level_up#, :dependent => :destroy
  belongs_to :level_up

  RACES   = {
      1  => "Защитники Империи",
      2  => "Горные кланы"     ,
      3  => "Орды нежити"      ,
      4  => "Легионы проклятых",
      5  => "Эльфийский союз"  ,
      6  => "Нейтралы"         ,
      7  => "Нейтральные люди" ,
      8  => "Нейтральные эльфы",
      9  => "Зеленокожие"      ,
      10 => "Драконы"          ,
      11 => "Обитатели болот"  ,
      12 => "Варвары"          ,
      13 => "Морские жители"   ,
      14 => "Тёмные эльфы"
  }

  # Дополнительные источники для иммунитета и сопротивления
  IMMUNE = {
      0b1000000000 => 'Разрушение брони', # 512
      0b0100000000 => 'Яд'                # 256
  }

  SOURCES = {
      0b10000000 => 'Оружие', # 128
      0b01000000 => 'Разум' , # 64
      0b00100000 => 'Жизнь' , # 32
      0b00010000 => 'Смерть', # 16
      0b00001000 => 'Огонь' , # 8
      0b00000100 => 'Вода'  , # 4
      0b00000010 => 'Земля' , # 2
      0b00000001 => 'Воздух'  # 1
  }

  REACH = {
#     0b000 =>                              "friend 1   melee", # этакий неродивый баффер %)
      0b001 => "любой союзник",            #"friend 1   any"  , # баффер-точечник
#     0b010 =>                              "friend all melee", # O_o
      0b011 => "все союзники",             #"friend all any"  , # баффер-массовик
      0b100 => "ближайший вражеский юнит", #"enemy  1   melee", # воин
      0b101 => "любой вражеский юнит",     #"enemy  1   any"  , # лучник
#     0b110 =>                              "enemy  all melee", # O_o
      0b111 => "все вражеские юниты"       #"enemy  all any"    # маг
  }

  ATTACK  = {
      1  => "Повреждение",
      2  => "Высосать жизнь",
      3  => "Высосать жизнь (и для союзников)",
      4  => "Лечение",
      5  => "Увеличение силы",                    # баф, кратный 25 записывать в dmg
      6  => "Дополнительный ход",
      7  => "Страх",
      8  => "Окаменение",
      9  => "Паралич (1 ход)",
      10 => "Паралич",
      11 => "Сменить обличие (Двойник)",
      12 => "Сменить обличие (Повелитель волков)",
      13 => "Превращение",
      14 => "Вызов"
  }

  ATTACK2 = {
      0b0100000000  => "Яд", # 256
      1  => "Ожог",
      2  => "Мороз",
      3  => "Критическое попадание",
      4  => "Защита от магии элементов",
      5  => "Защита от магии воздуха",
      6  => "Защита от магии огня",
      7  => "Оживление",
      8  => "Снятие отрицательных эффектов",
      9  => "Страх",
      10 => "Окаменение",
      11 => "Паралич (1 ход)",
      12 => "Паралич",
      0b1000000000 => "Разрушение брони", # 512
      13 => "Понижение уровня",
      14 => "Снижение инициативы",
      15 => "Снижение повреждений"
  }

  attr_protected :delay_a

  validates :name,        :presence => true, :length => {:minimum => 3, :maximum => 40}
  validates :race,        :presence => true, :inclusion => {:in => RACES.keys}
  validates :level,       :presence => true, :numericality => {:only_integer => true, :greater_than => -1}
  validates :level_up_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :level_up_id, :presence => true, :inclusion => {:in => LevelUp.pluck(:id)}
  validates :experience,  :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :health,      :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :armor,       :presence => true, :numericality => {:only_integer => true}, :inclusion => {:in => 0..100}
  validates :immune,      :presence => true, :numericality => {:only_integer => true, :greater_than => -1}
  validates :resist,      :presence => true, :numericality => {:only_integer => true, :greater_than => -1}

  validates :twice_attack, :inclusion => {:in => [true, false]}
  validates :attack,       :presence => true, :inclusion => {:in => ATTACK.keys  }
  validates :attack_2,     :allow_blank => true, :inclusion => {:in => ATTACK2.keys}
  validates :accuracy,     :presence => true, :numericality => {:only_integer => true}, :inclusion => {:in => 0..100}
  validates :damage,       :presence => true, :numericality => {:only_integer => true}
  validates :damage,       :inclusion => {:in => 0..300}, :unless => :leader?
  validates :damage,       :inclusion => {:in => 0..400}, :if     => :leader?
  validates :damage_2,     :allow_blank => true, :numericality => {:only_integer => true}, :inclusion => {:in => 0..300}
  validates :source,       :presence => true, :inclusion => {:in => SOURCES.keys}
  validates :source_2,     :allow_blank => true, :inclusion => {:in => SOURCES.keys}
  validates :initiative,   :presence => true, :numericality => {:only_integer => true}, :inclusion => {:in => 0..100}
  validates :reach,        :presence => true, :inclusion => {:in => REACH.keys}
  validates :big,          :inclusion => {:in => [true, false]}
  validates :delay_a,      :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :enroll_cost,  :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :training_cost, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :add_num,      :allow_blank => true, :numericality => {:only_integer => true, :greater_than => -1}
  validates :leader,       :inclusion => {:in => [true, false]}

  scope :not_big, where(:big => false)
  scope :ready,   where(:attack => [1, 4], :attack_2 => nil)
  scope :can_enrolled_by, lambda { |cost| where("enroll_cost < ?", cost)  }

  def has_immune?(source)
    self.immune & source != 0
  end

  #def level_up
  #  LevelUp.find level_up_id
  #end

end
