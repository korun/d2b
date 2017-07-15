class Unit < ActiveRecord::Base
  LEFT_SIDE   = (1..6).freeze
  RIGHT_SIDE  = (7..12).freeze
  CELLS_RANGE = (LEFT_SIDE.begin..RIGHT_SIDE.end).freeze

  LEFT_SIDE_FIRST_LINE  = LEFT_SIDE.select(&:even?).freeze
  RIGHT_SIDE_FIRST_LINE = RIGHT_SIDE.select(&:odd?).freeze

  TOP_ROW     = [1, 2, 7, 8].freeze
  CENTRAL_ROW = [3, 4, 9, 10].freeze
  BOTTOM_ROW  = [5, 6, 11, 12].freeze

  CELL_LINES = ([TOP_ROW] + [CENTRAL_ROW] + [BOTTOM_ROW]).transpose.each(&:freeze).freeze

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

  def alive?
    !self.dead?
  end

  def dead?
    self.health <= 0
  end

  def hurt?
    self.health_max > self.health
  end

  def left_side?
    self.cell_num < RIGHT_SIDE.begin
  end

  def line
    cell = self.cell_num
    cell += 1 if self.left_side? && self.big?
    CELL_LINES.detect { |cells| cells.include?(cell) }
  end

  def on_cell?(*cells)
    cells.each do |cell|
      return true if self.cell_num == cell.to_i || (self.big? && self.cell_num == cell.to_i - 1)
    end
    false
  end

  def on_first_line?
    first_line = self.left_side? ? LEFT_SIDE_FIRST_LINE : RIGHT_SIDE_FIRST_LINE
    self.on_cell?(*first_line)
  end

  def on_top_row?
    self.on_cell?(*TOP_ROW)
  end

  def on_central_row?
    self.on_cell?(*CENTRAL_ROW)
  end

  def on_bottom_row?
    self.on_cell?(*BOTTOM_ROW)
  end

  # For test only
  def kill!
    update!(health: 0)
  end
end
