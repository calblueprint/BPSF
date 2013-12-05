# Handles showing and updating users
class UserController < ApplicationController
  load_and_authorize_resource

  def show
    @user = User.find params[:id]
    total_payments = Payment.find_all_by_user_id @user
    @payments = Array.new
    # What does this do?
    total_payments.each do |payment|
      payment_hash = Hash.new
      crowdfund = Crowdfund.find payment.crowdfund_id
      payment_hash[:crowdfund] = crowdfund
      payment_hash[:amount] = payment.amount
    end
    @profile = @user.profile
  end

  def edit
    @user = User.find params[:id]
    @payments = Payment.find_by_user_id @user
    @profile = @user.profile
  end

  def update
    if @user.update_attributes params[:user]
      flash[:success] = 'Profile updated!'
      redirect_to user_path @user
    else
      render 'edit'
    end
  end

  def approve
    user = User.find params[:id]
    user.approved = true
    @pending_users = User.where approved: false
    if user.save!
      flash[:success] = "#{user.name} Approved!"
    end
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js { render "update_pending_users" }
    end
  end

  def reject
    user = User.find params[:id]
    user.destroy
    @pending_users = User.where approved: false
    flash[:success] = 'User rejected.'
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
      format.html { redirect_to admin_dashboard_path }
      format.js { render "update_pending_users" }
    end
  end
end
