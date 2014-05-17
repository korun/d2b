# -*- encoding : utf-8 -*-
module PrototypesHelper
  def enroll_units_options(units, id)
    str = ""
    units.each do |u|
      str += my_option(u.id,
                       u.name,
                       u.id == id,
                       'data-race' => u.race,
                       'data-gold' => u.enroll_cost,
                       'data-big'  => (u.big? ? 1 : false)
      )
    end
    str.html_safe
  end
  def resist_options(s)
    sources = {}
    Prototype::SOURCES.each{|k, v| sources[k] = v}
    Prototype::IMMUNE.each{ |k, v| sources[k] = v}
    str = ""
    sources.each do |k, v|
      str += my_option(k, v, (s & k != 0))
    end
    str.html_safe
  end
  def decode_resist(s)
    return 'Нет' if s == 0
    str = ""
    sources = {}
    Prototype::SOURCES.each{|k, v| sources[k] = v}
    Prototype::IMMUNE.each{ |k, v| sources[k] = v}
    sources.each do |k, v|
      str += "#{', ' unless str.blank?}#{v}" if s & k != 0
    end
    str
  end

  def unit_name(u) # u - prototype
    u ? u.name : 'Нет'
  end

  private

  def my_option(val, html, selected = false, options = {})
    str = "<option value=\"#{val}\""
    options.each{|k, v| str += " #{k}=\"#{v}\"" unless v.blank?}
    str + "#{' selected' if selected}>#{html}</option>\n"
  end

end
