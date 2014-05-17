# -*- encoding : utf-8 -*-
module GamesHelper
  def generate_unit_tag(id)
    class_id = [7, 9, 11].include?(id) ? '1' : '0'
    #id       = id < 10 ? '0' + id.to_s : id.to_s
    id = id.to_s
    content_tag("div", "", :id => "cU"  + id, :class => "circle#{class_id}") +
    content_tag("div", "", :id => "U"   + id, :class => "model")             +
    content_tag("div", "", :id => "efU" + id, :class => "effect")            +
    content_tag("div", "", :id => "eU"  + id, :class => "effect")
  end

  def double_gen_portrait(id)
    id1 = id.to_s
    tmp = content_tag("div", "", :id => "lhU" + id1, :class => "lessh" )
    result = content_tag("div", tmp, :id => "pU"  + id1, :class => "portrait") +
             content_tag("div", "", :id => "dnU"  + id1, :class => "dmgNum")   +
             content_tag("div", "", :id => "defU" + id1, :class => "defend")

    id2 = (id + 1).to_s
    tmp = content_tag("div", "", :id => "lhU" + id2, :class => "lessh" )

    result +
        content_tag("div", tmp, :id => "pU"  + id2, :class => "portrait") +
        content_tag("div", "", :id => "dnU"  + id2, :class => "dmgNum")   +
        content_tag("div", "", :id => "defU" + id2, :class => "defend")   +
        content_tag("div", "", :id => "hU"   + id1, :class => "health")   +
        content_tag("div", "", :id => "hU"   + id2, :class => "health")
  end

end
