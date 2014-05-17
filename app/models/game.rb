# -*- encoding : utf-8 -*-
class Game < ActiveRecord::Base
  belongs_to :map
  belongs_to :player1, :class_name => 'User'
  belongs_to :player2, :class_name => 'User'
  has_many   :units,   :class_name => 'Unit'

  COST_TYPE = {
      0 => "Золото и опыт",
      1 => "Только золото",
      2 => "Только опыт"
  }

  LORD_FACE = {
      0  => "Нейтралы",
      1  => "Империя",
      2  => "Империя",
      3  => "Империя",
      4  => "Империя",
      5  => "Кланы",
      6  => "Кланы",
      7  => "Кланы",
      8  => "Кланы",
      9  => "Легионы проклятых",
      10 => "Легионы проклятых",
      11 => "Легионы проклятых",
      12 => "Легионы проклятых",
      13 => "Орды нежити",
      14 => "Орды нежити",
      15 => "Орды нежити",
      16 => "Орды нежити",
      17 => "Эльфийский альянс",
      18 => "Эльфийский альянс",
      19 => "Эльфийский альянс",
      20 => "Эльфийский альянс"
  }

  attr_accessible :map_id, :player1_id, :player2_id, :player1_face, :player2_face, :rounds, :cost_type, :gold, :experience

  validates :map_id,       :presence => true, :numericality => {:only_integer => true, :greater_than => -1}
  #validates :map_id,       :presence => true, :inclusion => {:in => [0] + Map.pluck(:id)}
  validates :player1_id,   :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :player1_id,   :presence => true, :inclusion => {:in => User.not_deleted.pluck(:id)}
  validates :player2_id,   :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  #validates :player2_id,   :presence => true, :inclusion => {:in => User.not_deleted.pluck(:id)}
  validates :player1_face, :presence => true, :inclusion => {:in => LORD_FACE.keys}
  validates :player2_face, :presence => true, :inclusion => {:in => LORD_FACE.keys}
  validates :rounds,       :presence => true, :inclusion => {:in => 1..5}
  validates :cost_type,    :presence => true, :inclusion => {:in => COST_TYPE.keys}
  validates :gold,         :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :experience,   :presence => true, :numericality => {:only_integer => true, :greater_than => 0}

  #scope1:
  #scope2:
  #initiative:
  #current_round:
  #standoff:

  scope :with_units_only, includes(:units)
  scope :with_units,      includes({:units => :prototype})
  scope :with_map,        includes(:map)
  scope :with_players,    includes(:player1, :player2)
  scope :full_load,       includes(:player1, :player2).with_units

  def add_unit(p_id, cell = 1)
    return nil if p_id.blank?
    p = Prototype.find(p_id)
    return nil if p.blank?
    u = Unit.new(
        prototype_id: p.id,
        game_id:      self.id,
        cell_num:     cell,
        level:        p.level # ИСПРАВИТЬ!!!
    )
    u.health     = p.health
    u.accuracy   = p.accuracy
    u.accuracy_2 = p.accuracy_2
    u.armor      = p.armor
    u.damage     = p.damage
    u.damage_2   = p.damage_2
    u.initiative = p.initiative
    u.resist     = p.resist
    u.experience = p.experience
    u.health_max = p.health
    {:prototype => p, :unit => u}
  end

  def active_unit
    init_init
    self.units.select{|u| u if u.id == self.initiative[0]}[0]
  end

  def ready?
    pl1u, pl2u = 0, 0
    self.units.each do |u|
      pl1u += 1 if u.cell_num < 7
      pl2u += 1 if u.cell_num > 6
    end
    pl1u > 0 && pl2u > 0 ? true : false
  end

  def started?
    self.current_round > 0
  end

  def create_init!
    self.units.shuffle!
    self.initiative = self.units.select{|u| !u.dead?}.sort_by{|o| -o.initiative}.map{|o| o.id} + [nil]
  end

  def del_init!(id)
    init_init
    self.initiative.delete(id)
    self.create_init! if self.initiative[0] == nil
    self.save
  end

  def shift_init!
    init_init
    if self.initiative[1] == nil
      self.create_init!
    else
      self.initiative.push self.initiative.shift
    end
    self.current_step += 1
    self.save
  end

  def save
    self.initiative = self.initiative.to_s
    super
  end

  def restart!
    Unit.update_all("health = health_max, defend = 'f'", {:game_id => self.id})
    game = Game.find(self.id)
    game.create_init!
    game.current_step = 0
    game.save
  end

  private

  def init_init
    self.initiative = eval(self.initiative) if self.initiative.class == String
  end

end
