require 'rails_helper'

RSpec.describe Battle, type: :model do
  context 'add_unit!' do
    it 'Allow to add units' do
      battle = FactoryGirl.create(:battle)
      unit   = battle.add_unit!(FactoryGirl.create(:prototype), Unit::CELLS_RANGE.select(&:odd?).sample)
      expect(battle.units.size).to eq(1)
      expect(battle.active_unit_id).to eq(unit.id)
      expect(battle.active_unit).to eq(unit)
      expect(battle.initiative.at(1)).to eq(Battle::INITIATIVE_SEPARATOR)
    end

    it "Didn't allow to use same cell for multiple units" do
      cell   = rand(Unit::CELLS_RANGE)
      battle = FactoryGirl.create(:battle)
      battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell)
      expect {
        battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell)
      }.to raise_error("Cell #{cell} already taken")
    end

    it "Didn't allow to use same cell for multiple units (include big)" do
      cell   = Unit::CELLS_RANGE.select(&:odd?).sample
      battle = FactoryGirl.create(:battle)
      battle.add_unit!(FactoryGirl.create(:prototype, big: true), cell)
      expect {
        battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell + 1)
      }.to raise_error("Cell #{cell + 1} already taken")
    end

    it "Didn't allow to place big unit on wrong cell" do
      cell   = Unit::CELLS_RANGE.select(&:even?).sample
      battle = FactoryGirl.create(:battle)
      expect {
        battle.add_unit!(FactoryGirl.create(:prototype, big: true), cell)
      }.to raise_error('Failed to add unit')
    end

    it "Didn't allow to place big unit on thin's head" do
      cell   = Unit::CELLS_RANGE.select(&:even?).sample
      battle = FactoryGirl.create(:battle)
      battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell)
      expect {
        battle.add_unit!(FactoryGirl.create(:prototype, big: true), cell - 1)
      }.to raise_error("Cell #{cell} already taken")
    end
  end

  context 'initiative' do
    it 'Generate correct initiative' do
      cells       = Unit::CELLS_RANGE.to_a.shuffle
      initiatives = (20..80).step(20).to_a.reverse!
      unit_ids    = []
      battle      = FactoryGirl.create(:battle)
      initiatives.each do |i|
        unit_ids.push(
            battle.add_unit!(
                FactoryGirl.create(:prototype, big: false, initiative: i),
                cells.pop
            ).id
        )
      end
      expect(battle.initiative).to eq(unit_ids + [Battle::INITIATIVE_SEPARATOR])
      unit_ids.each do |unit_id|
        expect(battle.active_unit_id).to eq(unit_id)
        expect(battle.active_unit.id).to eq(unit_id)
        battle.shift_initiative
      end
      expect(battle.active_unit_id).to eq(unit_ids.first)
      expect(battle.active_unit.id).to eq(unit_ids.first)
    end
  end
end
