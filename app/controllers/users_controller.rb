# -*- encoding : utf-8 -*-
class UsersController < ApplicationController
  before_filter :check_auth,     :except => ['new', 'create']
  before_filter :edit_permission,  :only => ['edit', 'update', 'edit_password', 'update_password']
  before_filter :check_admin,      :only => 'destroy'

  def index
    respond_to do |format|
      format.html do
        @all = false
        if current_user.admin? && params[:mode] && params[:mode] == 'all'
          @all   = true
          @users = User.order("role DESC").order(:username).page(params[:page])
        else
          @users = User.not_deleted.order("role DESC").order(:username).page(params[:page])
        end
      end
      format.json do # это для красивой js-подстановки
        q = "%#{params[:q]}%"
        render json: User.not_deleted.where("lower(username) like ?", q).all.to_json(only: [:name, :id])
      end
    end
  end

  def show
    @admin = logged_in? && current_user.admin?
    @user = User.find(params[:id])
    @all  = @admin && @user.deleted? ? true : false
  end

  def new
    redirect_to root_url if logged_in? && !current_user.admin?
    @user = User.new
  end

  def create
    role = params[:user].delete(:role)
    admin = logged_in? && current_user.admin?
    params[:user].delete(:deleted_at)

    @user = User.new(params[:user])
    @user.role = admin ? role : 0   # пользователь

    if @user.save
      if admin
        flash[:notice] = "Пользователь добавлен."
        redirect_to @user
      else
        flash[:notice] = "Регистрация завершена!"
        redirect_to login_url
      end
    else
      render :new
    end
  end

  def edit
  end

  def update
    role = params[:user].delete(:role)
    del  = params[:user].delete(:deleted_at)

    @user.role = current_user.admin? ? role : 0
    @user.deleted_at = del if current_user.admin?

    params[:user].delete(:password)
    params[:user].delete(:password_confirmation)

    if @user.update_attributes(params[:user])
      flash[:notice] = "Информация обновлена."
      redirect_to @user
    else
      render action: "edit"
    end
  end

  def edit_password
  end

  def update_password
    if (params[:user][:old_password].blank? && current_user.admin? && @user.id != current_user.id) || login(@user.email, params[:user][:old_password])
      @user.errors.add :password, "недостаточной длины (не может быть меньше 6 символов)" if params[:user][:password].size < 6
      @user.errors.add :password, "не совпадает с подтверждением" unless params[:user][:password] == params[:user][:password_confirmation]
      @user.password              = params[:user][:password]
      @user.password_confirmation = params[:user][:password_confirmation]
      params[:user].delete(:old_password)
      if !@user.errors.any? && @user.save
        flash[:notice] = "Пароль изменён."
        redirect_to @user
      else
        render action: "edit_password"
      end
    else
      @user.errors.add :old_password, "введён неверно"
      render action: "edit_password"
    end
  end

  def destroy
    return redirect_to(users_url) if params[:id].to_i == 1
    @user = User.find(params[:id])

    if @user.deleted?
      @user.username   = @user.username.split('_', 2)[1]
      @user.email      = @user.email.split('_', 2)[1]
      @user.deleted_at = nil
    else
      @user.username   = "#{rand(9000)+1000}_" + @user.username
      @user.email      = "#{rand(9000)+1000}_" + @user.email
      @user.deleted_at = Time.now
    end

    if @user.save
      flash[:notice] = @user.deleted? ? "Пользователь удалён." : "Пользователь восстановлен."
    else
      flash[:error]  = @user.errors.full_messages.inspect
    end
    #@user.destroy
    redirect_to all_users_url
  end

  private

  def edit_permission
    unless current_user.admin? || current_user.id == params[:id].to_i
      flash[:error] = "Доступ запрещен."
      redirect_to users_path
      return
    end
    @user = current_user.admin? ? User.where(:id => params[:id]).not_deleted.first : current_user
    if @user.blank?
      flash[:error] = "Пользователь не найден."
      redirect_to users_path
    end
  end

end
