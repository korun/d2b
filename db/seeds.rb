# -*- encoding : utf-8 -*-

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w[
empire
clans
undead
legions
elves
neutral
humans
neutral_elves
greenskin
dragons
marsh_dwellers
barbarians
merfolks
dark_elves
].each do |code|
  Race.find_or_create_by code: code
end
