# -*- encoding : utf-8 -*-
class SessionsController < ApplicationController

  def new
  end

  def create
    user = login(params[:email], params[:password])
    if user && user.deleted_at.blank?
      flash[:notice] = "Авторизация выполнена!"
      redirect_back_or_to root_url
    else
      flash[:error] = "Неверное имя пользователя или пароль"
      render :new
    end
  end

  def destroy
    logout
    flash[:notice] = "Выход осуществлен!"
    redirect_to root_path
  end

end
