class Unit < ActiveRecord::Base
  LEFT_SIDE   = (1..6).freeze
  RIGHT_SIDE  = (7..12).freeze
  CELLS_RANGE = (LEFT_SIDE.begin..RIGHT_SIDE.end).freeze

  INHERITED_ATTRS = %i[
    big? leader? twice_attack? max_armor immune
    reach attack attack_2 source source_2
    frames_count enroll_cost training_cost
  ].freeze

  belongs_to :battle
  belongs_to :prototype, -> { readonly }

  validates :prototype, presence: true
  validates :cell_num, presence: true, inclusion: {in: CELLS_RANGE}
  validate if: :big? do
    errors.add(:cell_num, :invalid) unless cell_num.to_i.odd?
  end
  validates :level, numericality: {only_integer: true, greater_than: 0}

  delegate *INHERITED_ATTRS, to: :prototype

  def self.build_from(prototype, attrs = {})
    unit = self.new(
        prototype:  prototype,
        level:      prototype.level,
        experience: prototype.experience,
        health:     prototype.max_health,
        health_max: prototype.max_health,
        armor:      prototype.max_armor,
        resist:     prototype.resist,
        initiative: prototype.initiative,
        accuracy:   prototype.accuracy,
        accuracy_2: prototype.accuracy_2,
        damage:     prototype.damage,
        damage_2:   prototype.damage_2
    )
    unit.assign_attributes(attrs)
    yield(unit) if block_given?
    unit
  end

  def dead?
    self.health <= 0
  end

  def on_cell?(cell)
    if self.big?
      self.cell_num == cell || self.cell_num + 1 == cell
    else
      self.cell_num == cell
    end
  end
end
