class Unit < ActiveRecord::Base
  LEFT_SIDE  = 1..6.freeze
  RIGHT_SIDE = 7..12.freeze

  belongs_to :prototype, -> { readonly }

  validates :prototype_id, :presence => true, :numericality => {:only_integer => true, :greater_than => 0}
  validates :cell_num,     :presence => true, :inclusion => {:in => 1..12}
  validates :level,        :numericality => {:only_integer => true, :greater_than => 0}

  def dead?
    self.health <= 0
  end
end
