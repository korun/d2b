# -*- encoding : utf-8 -*-
module ApplicationHelper

  def show_flash
    res = []
    flash.each do |k, v|
      res << content_tag(:div, v, :class => "flash_#{k}")
    end
    raw(res.join)
  end

  def menu_items
    [
        {name: 'maps',       title: 'Карты' },
        {name: 'effects',    title: 'Эффекты',      admin: true},
        {name: 'level_ups',  title: 'LevelUp',      admin: true},
        {name: 'prototypes', title: 'Юниты' },
        #{name: 'units',      title: 'Юниты'  ,      admin: true},
        {name: 'games',      title: 'Игры'  },
        {name: 'users',      title: 'Пользователи', login: true}
    ]
  end

  def admin?
    logged_in? && current_user.admin?
  end

  def error_messages_for(object)
    render 'layouts/error_messages', :object => object
  end

  def nil_to_no(x)
    x ? x : 'Нет'
  end

  def yes_or_no(x)
    x ? 'Да' : 'Нет'
  end

end
