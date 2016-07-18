require 'rails_helper'

RSpec.describe BattleService, type: :service do
  context 'defend' do
    before(:each) do
      cells    = Unit::CELLS_RANGE.to_a.shuffle
      @battle  = FactoryGirl.create(:battle)
      @unit1   = @battle.add_unit!(
          FactoryGirl.create(:prototype, big: false, initiative: 80),
          cells.pop
      )
      @unit2   = @battle.add_unit!(
          FactoryGirl.create(:prototype, big: false, initiative: 60),
          cells.pop
      )
      @service = BattleService.new(@battle)
    end

    it 'Defend unit and shift initiative' do
      expect(@battle.active_unit).to eq(@unit1)
      expect(@unit1.defend?).to eq(false)
      @service.defend
      @unit1.reload
      expect(@unit1.defend?).to eq(true)
      expect(@battle.active_unit).to eq(@unit2)
      expect(@battle.changed?).to eq(false)
    end

    it 'concurrently safe' do
      make_concurrent_calls @service, :defend
      expect(@battle.active_unit).to eq(@unit1)
      expect(@battle.units.where(defend: true).count).to eq(2)
    end
  end

  context 'blocked?' do
    it 'blocks second line' do
      battle  = FactoryGirl.create(:battle)
      service = BattleService.new(battle)
      unit1   = battle.add_unit!(FactoryGirl.create(:prototype, big: false), 3)
      unit2   = battle.add_unit!(FactoryGirl.create(:prototype, big: false), 12)
      unit1f  = battle.add_unit!(FactoryGirl.create(:prototype, big: false), Unit::LEFT_SIDE_FIRST_LINE.sample)
      unit2f  = battle.add_unit!(FactoryGirl.create(:prototype, big: false), Unit::RIGHT_SIDE_FIRST_LINE.sample)
      expect(service.send(:blocked?, unit1)).to eq(true)
      expect(service.send(:blocked?, unit1f)).to eq(false)
      expect(service.send(:blocked?, unit2)).to eq(true)
      expect(service.send(:blocked?, unit2f)).to eq(false)
    end

    it 'unblock second line if first line dead' do
      battle  = FactoryGirl.create(:battle)
      service = BattleService.new(battle)
      unit1   = battle.add_unit!(FactoryGirl.create(:prototype, big: false), 3)
      unit2   = battle.add_unit!(FactoryGirl.create(:prototype, big: false), 12)
      unit1f  = battle.add_unit!(FactoryGirl.create(:prototype, big: false), Unit::LEFT_SIDE_FIRST_LINE.sample)
      unit2f  = battle.add_unit!(FactoryGirl.create(:prototype, big: false), Unit::RIGHT_SIDE_FIRST_LINE.sample)

      unit1f.update!(health: 0) && unit2f.update!(health: 0)
      battle.units(true) # Reload
      expect(service.send(:blocked?, unit1)).to eq(false)
      expect(service.send(:blocked?, unit2)).to eq(false)
    end

    it 'cannot block big units' do
      battle  = FactoryGirl.create(:battle)
      service = BattleService.new(battle)
      cell    = Unit::LEFT_SIDE.select(&:odd?).sample
      fatty1  = battle.add_unit!(FactoryGirl.create(:prototype, big: true), cell)
      cell    = Unit::LEFT_SIDE_FIRST_LINE.select { |c| !fatty1.on_cell?(c) }.sample
      battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell)
      cell   = Unit::RIGHT_SIDE.select(&:odd?).sample
      fatty2 = battle.add_unit!(FactoryGirl.create(:prototype, big: true), cell)
      cell   = Unit::RIGHT_SIDE_FIRST_LINE.select { |c| !fatty2.on_cell?(c) }.sample
      battle.add_unit!(FactoryGirl.create(:prototype, big: false), cell)
      expect(service.send(:blocked?, fatty1)).to eq(false)
      expect(service.send(:blocked?, fatty2)).to eq(false)
    end
  end

  context 'can_melee_reach?' do
    before(:each) do
      prototype     = FactoryGirl.create(:prototype, big: false)
      big_prototype = FactoryGirl.create(:prototype, big: true)
      @battle       = FactoryGirl.create(:battle)
      @units        = []
      @units[3]     = @battle.add_unit!(big_prototype, 3)
      @units[4]     = @units[3]
      @units[9]     = @battle.add_unit!(big_prototype, 9)
      @units[10]    = @units[9]
      Unit::CELLS_RANGE.each do |cell|
        next if @units[3].on_cell?(cell) || @units[9].on_cell?(cell)
        @units[cell] = @battle.add_unit!(prototype, cell)
      end
      @service = BattleService.new(@battle)
    end

    it 'second line cannot melee attack' do
      run_case = ->(target_side) do
        target_side.each do |target_cell|
          target = @battle.unit_on_cell(target_cell)
          expect(@service.send(:can_melee_reach?, target)).to eq(false)
        end
      end
      [1, 5, 8, 12].each do |cell|
        unit = @units[cell]
        @battle.initiative[0] = unit.id
        expect(@battle.active_unit).to eq(unit)
        run_case.call(unit.left_side? ? Unit::RIGHT_SIDE : Unit::LEFT_SIDE)
      end
    end

    it 'second line can melee attack if all first line dead' do
      run_case = ->(target_side) do
        target_side.each do |target_cell|
          target = @battle.unit_on_cell(target_cell)
          expect(@service.send(:can_melee_reach?, target)).to eq(true)
        end
      end
      @battle.transaction do
        (Unit::LEFT_SIDE_FIRST_LINE + Unit::RIGHT_SIDE_FIRST_LINE).each do |cell|
          @units[cell].update!(health: 0) # Kill
        end
      end
      @battle.units(true) # Reload
      [1, 5, 8, 12].each do |cell|
        unit = @units[cell]
        @battle.initiative[0] = unit.id
        expect(@battle.active_unit).to eq(unit)
        run_case.call(unit.left_side? ? Unit::RIGHT_SIDE : Unit::LEFT_SIDE)
      end
    end

    it 'first line units cannot reach second line' do
    end

    it 'central (big) units can reach any from first line' do
    end

    it 'first line corner units can reach only 2 closest targets' do
    end

    it 'first line units can reach second line if first line dead' do
    end
  end
end
