# -*- encoding : utf-8 -*-
class Map < ActiveRecord::Base
  validates :name,  :presence => true,  :uniqueness => true
  validates :layer, :numericality => {:only_integer => true, :greater_than => -1}
end
