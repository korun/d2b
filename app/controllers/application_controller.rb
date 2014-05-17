# -*- encoding : utf-8 -*-
class ApplicationController < ActionController::Base
  protect_from_forgery

  def access_denied(path = root_path, mes = "Доступ запрещен.")
    flash[:error] = mes
    redirect_to path
  end

  private

  def check_auth
    access_denied(login_path, "Доступ не авторизованным пользователям запрещён.") unless logged_in?
  end

  def check_admin
    access_denied unless current_user.try(:admin?)
  end

end
