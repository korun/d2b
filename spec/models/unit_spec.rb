require 'rails_helper'

RSpec.describe Unit, type: :model do
  context 'Validations' do
    it 'Validates big units' do
      valid_cells = Unit::CELLS_RANGE.select(&:odd?)
      prototype   = FactoryGirl.create(:prototype, big: true)
      fatty1      = Unit.build_from(prototype, cell_num: valid_cells.sample)
      expect(fatty1).to be_valid
      fatty2 = Unit.build_from(prototype, cell_num: valid_cells.sample + 1)
      expect(fatty2).not_to be_valid
      expect(fatty2.errors[:cell_num].size).to eq(1)
    end
  end

  context 'Cells helpers' do
    it 'Stay on our cell' do
      cell = rand(Unit::CELLS_RANGE)
      unit = FactoryGirl.build(:unit, cell_num: cell)
      expect(unit.on_cell?(cell)).to be(true)
    end

    it 'Stays on both cells if it big unit' do
      cell      = Unit::CELLS_RANGE.select(&:odd?).sample
      prototype = FactoryGirl.create(:prototype, big: true)
      fatty     = Unit.build_from(prototype, cell_num: cell)
      expect(fatty.on_cell?(cell)).to be(true)
      expect(fatty.on_cell?(cell + 1)).to be(true)
    end

    it 'Allow to pass multiple cells' do
      cell = rand(Unit::CELLS_RANGE)
      unit = FactoryGirl.build(:unit, cell_num: cell)
      expect(unit.on_cell?(*Unit::CELLS_RANGE.to_a)).to be(true)
    end

    it 'Can stay on first line' do
      cell = (Unit::LEFT_SIDE_FIRST_LINE + Unit::RIGHT_SIDE_FIRST_LINE).sample
      unit = Unit.build_from(FactoryGirl.create(:prototype, big: false), cell_num: cell)
      expect(unit.on_first_line?).to be(true)
    end

    it 'Can stay on second line' do
      cell = (Unit::CELLS_RANGE.to_a - (Unit::LEFT_SIDE_FIRST_LINE + Unit::RIGHT_SIDE_FIRST_LINE)).sample
      unit = Unit.build_from(FactoryGirl.create(:prototype, big: false), cell_num: cell)
      expect(unit.on_first_line?).to be(false)
    end

    it 'Always stay in first line if big' do
      cell  = Unit::CELLS_RANGE.select(&:odd?).sample
      fatty = Unit.build_from(FactoryGirl.create(:prototype, big: true), cell_num: cell)
      expect(fatty.on_first_line?).to be(true)
    end

    it 'line returns preferable melee unit line' do
      prototype = FactoryGirl.create(:prototype, big: true)
      unit      = Unit.build_from(FactoryGirl.create(:prototype, big: false), cell_num: 1)
      expect(unit.line).to eq(Unit::CELL_LINES.first)
      fatty1 = Unit.build_from(prototype, cell_num: 9)
      expect(fatty1.line).to eq(Unit::RIGHT_SIDE_FIRST_LINE)
      fatty2 = Unit.build_from(prototype, cell_num: 5)
      expect(fatty2.line).to eq(Unit::LEFT_SIDE_FIRST_LINE)
    end
  end

  context 'Battle helpers' do
    it 'Unit without health - dead' do
      unit = FactoryGirl.build(:unit)
      expect(unit.alive?).to eq(true)
      unit.health = 0
      expect(unit.dead?).to eq(true)
    end

    it 'Hurtable' do
      unit = FactoryGirl.build(:unit)
      expect(unit.hurt?).to eq(false)
      unit.health /= 2
      expect(unit.hurt?).to eq(true)
    end
  end
end
