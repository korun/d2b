# -*- encoding : utf-8 -*-

class UsernameValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add attribute, (options[:message] || "имеет недопустимый формат.") unless
        value !~ /admin|аdmin|system|sуstem|sуstеm|админ|aдмин|система/i
  end
end

class User < ActiveRecord::Base
  authenticates_with_sorcery!

  ROLES = {
      0 => "Пользователь",
      1 => "Администратор"
  }

  attr_accessible :username, :email, :password, :password_confirmation, :nev_id, :male, :nev_id
  #attr_protected :deleted_at

  validates :username, :presence => true, :uniqueness => true, :length => {:minimum => 3, :maximum => 40}
  validates :username, :username => true, :unless => :admin?
  validates :email,    :presence => true, :uniqueness => true, :format => {:with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i}, :unless => :deleted?
  validates :password, :presence => true, :confirmation => true, :length => {:minimum => 6}, :on => :create
  validates :role,     :presence => true, :inclusion => {:in => ROLES.keys}
  validates :nev_id,   :numericality => { :only_integer => true, :greater_than => 0 }, :allow_blank => true
  validates :male,     :inclusion => {:in => [true, false]}

  scope :not_deleted, where(:deleted_at => nil)

  def admin?
    role == 1
  end

  def deleted?
    deleted_at.present?
  end

  def sex
    male ? "Мужчина" : "Женщина"
  end

end
