require 'rails_helper'

RSpec.describe Unit, type: :model do
  it 'Validates big units' do
    valid_cells = Unit::CELLS_RANGE.select(&:odd?)
    prototype = FactoryGirl.create(:prototype, big: true)
    fatty1 = Unit.build_from(prototype, cell_num: valid_cells.sample)
    expect(fatty1).to be_valid
    fatty2 = Unit.build_from(prototype, cell_num: valid_cells.sample + 1)
    expect(fatty2).not_to be_valid
    expect(fatty2.errors[:cell_num].size).to eq(1)
  end

  it 'Stay on our cell' do
    cell = rand(Unit::CELLS_RANGE)
    unit = FactoryGirl.build(:unit, cell_num: cell)
    expect(unit.on_cell?(cell)).to be(true)
  end

  it 'Stays on both cells if it big unit' do
    cell = Unit::CELLS_RANGE.select(&:odd?).sample
    prototype = FactoryGirl.create(:prototype, big: true)
    fatty = Unit.build_from(prototype, cell_num: cell)
    expect(fatty.on_cell?(cell)).to be(true)
    expect(fatty.on_cell?(cell + 1)).to be(true)
  end
end
