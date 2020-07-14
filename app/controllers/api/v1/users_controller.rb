# frozen_string_literal: true

class Api::V1::UsersController < Api::V1::BaseController
  skip_before_action :authenticate_user!, only: [:create]

  before_action :set_user, only: [:show, :update, :destroy]

  def show
    if @user
      render json: @user
    else
      respond_with_error "User with id #{params[:id]} not found.", :not_found
    end
  end

  def create
    @user = User.create user_params

    if @user.valid?
      render json: @user
    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def update
    if @user.blank?
      respond_with_error "User with id #{params[:id]} not found.", :not_found

    elsif @user.update(user_params)
      render json: @user

    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.blank?
      respond_with_error "User with id #{params[:id]} not found.", :not_found

    elsif @user.destroy
      render json: @user

    else
      render json: { error: @user.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:email, :first_name, :last_name, :password, :password_confirmation)
    end
end