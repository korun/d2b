class Prototype < ActiveRecord::Base
  REACH = {
      # 0b000 =>              "friend 1   melee", # этакий неродивый баффер %)
      0b001 => :buffer,      #"friend 1   any"  , # любой союзник
      # 0b010 =>              "friend all melee", # O_o
      0b011 => :mass_buffer, #"friend all any"  , # все союзники
      0b100 => :warrior,     #"enemy  1   melee", # ближайший вражеский юнит
      0b101 => :archer,      #"enemy  1   any"  , # любой вражеский юнит
      # 0b110 =>              "enemy  all melee", # O_o
      0b111 => :mage         #"enemy  all any"    # все вражеские юниты
  }.freeze

  # Дополнительные источники для иммунитета и сопротивления
  IMMUNE = {
      0b1000000000 => 'Разрушение брони', # 512
      0b0100000000 => 'Яд'                # 256
  }.each_value(&:freeze).freeze

  SOURCES = {
      0b10000000 => 'Оружие', # 128
      0b01000000 => 'Разум' , # 64
      0b00100000 => 'Жизнь' , # 32
      0b00010000 => 'Смерть', # 16
      0b00001000 => 'Огонь' , # 8
      0b00000100 => 'Вода'  , # 4
      0b00000010 => 'Земля' , # 2
      0b00000001 => 'Воздух'  # 1
  }.each_value(&:freeze).freeze

  ATTACK = {
      1  => 'Повреждение',
      2  => 'Высосать жизнь',
      3  => 'Высосать жизнь (и для союзников)',
      4  => 'Лечение',
      5  => 'Увеличение силы', # баф, кратный 25 записывать в dmg
      6  => 'Дополнительный ход',
      7  => 'Страх',
      8  => 'Окаменение',
      9  => 'Паралич (1 ход)',
      10 => 'Паралич',
      11 => 'Сменить обличие (Двойник)',
      12 => 'Сменить обличие (Повелитель волков)',
      13 => 'Превращение',
      14 => 'Вызов'
  }.each_value(&:freeze).freeze

  ATTACK2 = {
      0b0100000000 => 'Яд', # 256
      1            => 'Ожог',
      2            => 'Мороз',
      3            => 'Критическое попадание',
      4            => 'Защита от магии элементов',
      5            => 'Защита от магии воздуха',
      6            => 'Защита от магии огня',
      7            => 'Оживление',
      8            => 'Снятие отрицательных эффектов',
      9            => 'Страх',
      10           => 'Окаменение',
      11           => 'Паралич (1 ход)',
      12           => 'Паралич',
      0b1000000000 => 'Разрушение брони', # 512
      13           => 'Понижение уровня',
      14           => 'Снижение инициативы',
      15           => 'Снижение повреждений'
  }.each_value(&:freeze).freeze

  has_many :units

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
    self.frames_count * 100
  end

  def reach_friends?
    self.reach & 0b100 == 0
  end

  def has_immune?(source)
    self.immune & source != 0
  end
end
