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

      unit1f.kill! && unit2f.kill!
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
    let(:run_case) do
      ->(target_side, result) do
        target_side.each do |target_cell|
          target = @battle.unit_on_cell(target_cell)
          expect(@service.send(:can_melee_reach?, target)).to eq(result)
        end
      end
    end

    let(:reload_units) do
      -> do
        @units = @battle.units(true).each_with_object([]) do |u, arr|
          arr[u.cell_num] = u; arr[u.cell_num + 1] = u if u.big?
        end
      end
    end

    let(:revive_units) do
      -> do
        @battle.units.update_all('health = health_max') && reload_units.call
      end
    end

    let(:kill_and_reload) do
      -> (*cells) do
        @battle.units.transaction do
          cells.each do |cell|
            @units[cell].kill!
          end
        end
        reload_units.call
      end
    end

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

    it 'blocked second line cannot melee attack' do
      [1, 5, 8, 12].each do |cell|
        unit = @units[cell]
        @service.set_active_unit! unit
        expect(@battle.active_unit).to eq(unit)
        run_case.call(unit.left_side? ? Unit::RIGHT_SIDE : Unit::LEFT_SIDE, false)
      end
    end

    it 'second line corners can melee attack if all first line dead' do
      kill_and_reload.call(*(Unit::LEFT_SIDE_FIRST_LINE + Unit::RIGHT_SIDE_FIRST_LINE))
      attackers_map = {
          1  => [8, 10],
          5  => [10, 12],
          8  => [1, 3],
          12 => [3, 5]
      }.each_value(&:freeze).freeze
      attackers_map.each do |acive_cell, targets|
        unit = @units[acive_cell]
        @service.set_active_unit! unit
        expect(@battle.active_unit).to eq(unit)
        run_case.call(targets, true)
      end
    end

    it 'first line units cannot reach second line' do
      (Unit::LEFT_SIDE_FIRST_LINE + Unit::RIGHT_SIDE_FIRST_LINE).each do |cell|
        unit = @units[cell]
        @service.set_active_unit! unit
        expect(@battle.active_unit).to eq(unit)
        run_case.call(unit.left_side? ? [8, 12] : [1, 5], false)
        run_case.call(unit.left_side? ? [10] : [3], true) # but can attack fat units
      end
    end

    it 'central (big) units can reach any from first line' do
      [3, 4, 9, 10].each do |cell|
        unit = @units[cell]
        @service.set_active_unit! unit
        expect(@battle.active_unit).to eq(unit)
        run_case.call(unit.left_side? ? Unit::RIGHT_SIDE_FIRST_LINE : Unit::LEFT_SIDE_FIRST_LINE, true)
      end
    end

    it 'first line corner units can reach only 2 closest targets' do
      @service.set_active_unit! @units[2]
      run_case.call([7, 9], true)
      run_case.call([11], false)
      @service.set_active_unit! @units[6]
      run_case.call([9, 11], true)
      run_case.call([7], false)
      @service.set_active_unit! @units[7]
      run_case.call([2, 4], true)
      run_case.call([6], false)
      @service.set_active_unit! @units[11]
      run_case.call([4, 6], true)
      run_case.call([2], false)
    end

    it 'first line corner units can reach last target after other dead' do
      @service.set_active_unit! @units[2]
      kill_and_reload.call(9)
      run_case.call([11], false) # covered by 7
      kill_and_reload.call(7)
      run_case.call([11], true)

      revive_units.call

      @service.set_active_unit! @units[6]
      ActiveRecord::Base.logger.warn 'KILL 9'
      kill_and_reload.call(9)

      ActiveRecord::Base.logger.warn 'KILLED?'
      run_case.call([7], false) # covered by 11
      kill_and_reload.call(11)
      run_case.call([7], true)

      revive_units.call

      @service.set_active_unit! @units[7]
      kill_and_reload.call(4)
      run_case.call([6], false)
      kill_and_reload.call(2)
      run_case.call([6], true)

      revive_units.call

      @service.set_active_unit! @units[11]
      kill_and_reload.call(4)
      run_case.call([2], false)
      kill_and_reload.call(6)
      run_case.call([2], true)
    end

    it 'first line units can reach second line if first line dead' do
      kill_and_reload.call(*Unit::RIGHT_SIDE_FIRST_LINE)
      attackers_map = {
          2  => [8],
          4  => [8, 12], # 10 - dead
          6  => [12]
      }.each_value(&:freeze).freeze
      attackers_map.each do |acive_cell, targets|
        @service.set_active_unit! @units[acive_cell]
        run_case.call(targets, true)
      end

      revive_units.call
      kill_and_reload.call(*Unit::LEFT_SIDE_FIRST_LINE)
      attackers_map = {
          7 => [1],
          9 => [1, 5], # 3 - dead
          11 => [5]
      }.each_value(&:freeze).freeze
      attackers_map.each do |acive_cell, targets|
        @service.set_active_unit! @units[acive_cell]
        run_case.call(targets, true)
      end
    end
  end
end
