# -*- encoding : utf-8 -*-

unless Map.first
  map_names = [
      "Нейтральные земли 1",
      "Нейтральные земли 2",
      "Нейтральные земли 3",
      "Руины 1",
      "Руины 2",
      "Руины 3",
      "Палуба корабля",
      "Прибрежная территория",
      "Земли Орд 1",
      "Земли Орд 2",
      "Земли Орд 3",
      "Земли Альянса 1",
      "Земли Альянса 2",
      "Земли Альянса 3",
      "Земли Империи 1",
      "Земли Империи 2",
      "Земли Империи 3",
      "Земли Кланов 1",
      "Земли Кланов 2",
      "Земли Кланов 3",
      "Земли Легионов 1",
      "Земли Легионов 2",
      "Земли Легионов 3",
      "Нейтральный город 1",
      "Нейтральный город 2",
      "Нейтральный город 3",
      "Столица Империи",
      "Столица Орд",
      "Столица Кланов",
      "Столица Легионов",
      "Столица Альянса"
  ]
  k = map_names.size + 1
  count = 0
  map_names.each_index do |i|
    m = Map.new(:name => map_names[i])
    if i == 2 || i == 9
      m.layer = k
      k += 1
    end
    count += 1 if m.save
  end
  puts "Maps created:\t#{map_names.size}"
  puts "Maps saved:\t#{count}"
else
  puts "Maps - skipped: we already have maps."
end

unless User.first
  u = User.new( username:"Вансан", role:1, nev_id:"1472", email:"ivankorunkov@ya.ru" )
  u.password = "qwerty12345"
  u.password_confirmation = "qwerty12345"
  puts "Administrator added:\t#{u.save}"
else
  puts "Administrator - skipped: we already have one."
end

unless Prototype.first
  File.open("db/prototypes.txt", "r") do |file|
    file.gets
    i = 1
    while (str = file.gets)
      str = str.split("\t")
      l = LevelUp.new
        l.acc_a = str[33].to_i
        l.acc_b = str[26].to_i
        l.acc2_a = str[35].to_i
        l.acc2_b = str[28].to_i
        l.armor_a = str[30].to_i
        l.armor_b = str[23].to_i
        l.dmg_a = str[32].to_i
        l.dmg_b = str[25].to_i
        l.dmg2_a = str[34].to_i
        l.dmg2_b = str[27].to_i
        l.exp_next_a = str[31].to_i
        l.exp_next_b = str[24].to_i
        l.hp_a = str[29].to_i
        l.hp_b = str[22].to_i
      print "##{i}\tLevelUp: #{l.save}, "
      p = Prototype.new
        p.accuracy = eval(str[11])
        p.accuracy_2 = eval(str[12])
        p.armor = eval(str[5])
        p.reach = eval(str[18])
        p.attack = eval(str[9])
        p.attack_2 = eval(str[10])
        p.big = eval(str[19])
        p.damage = eval(str[13])
        p.damage_2 = eval(str[14])
        p.experience = eval(str[3])
        p.immune = eval(str[6])
        p.resist = eval(str[7])
        p.initiative = eval(str[17])
        p.level = (str[2].to_i <= 0 ? 1 : str[2].to_i)
        p.level_up_id = l.id
        p.health = eval(str[4])
        p.name = str[0]
        p.race = eval(str[1])
        p.source = eval(str[15])
        p.source_2 = eval(str[16])
        p.enroll_cost = eval(str[20])
        p.training_cost = eval(str[21])
        p.twice_attack = eval(str[8])
        p.leader = eval(str[36])
      puts "Prototype: #{p.save} - #{p.name}"
      puts p.errors.full_messages unless p.errors.blank?
      i += 1
    end
  end
else
  puts "Prototypes - skipped: we already have one or more."
end