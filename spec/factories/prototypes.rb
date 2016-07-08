# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :prototype do
    level { rand(1..10) }
    experience { rand(7..1800) * 5 }
    reach { Prototype::REACH.keys.sample }
    sequence(:code) { |n| "#{Prototype::REACH[reach]}_#{n}" }
    big { rand > 0.65 }
    leader { rand < 0.3 }
    twice_attack { rand < 0.1 }
    max_health { rand(5..35) * 10 }
    max_armor { rand > 0.1 ? 0 : (rand(1..10) * 5) }
    immune { rand > 0.2 ? 0 : rand(1..Prototype::IMMUNE.keys.max)}
    resist {rand > 0.35 ? 0 : rand(1..Prototype::IMMUNE.keys.max)}
    initiative { rand(1..7) * 10 }
    attack do |p|
      if p.reach_friends?
        4 # TODO: heal
      else
        1 # TODO: damage
      end
    end
    # attack_2 {}
    accuracy { rand(4..9) * 10 }
    # accuracy_2 {}
    damage { rand(1..12) * 10 }
    # damage_2 {}
    source do |p|
      if p.reach_friends?
        32 # TODO: life
      else
        Prototype::SOURCES.keys.sample
      end
    end
    # source_2 {}
    # frames_count {}
    # enroll_cost {}
    # training_cost {}
  end
end
