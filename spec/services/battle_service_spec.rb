require 'rails_helper'

RSpec.describe BattleService, type: :service do
  context 'defend' do
    before(:each) do
      cells  = Unit::CELLS_RANGE.to_a.shuffle
      @battle = FactoryGirl.create(:battle)
      @unit1  = @battle.add_unit!(
          FactoryGirl.create(:prototype, big: false, initiative: 80),
          cells.pop
      )
      @unit2  = @battle.add_unit!(
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
end
