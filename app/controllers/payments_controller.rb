class PaymentsController < ApplicationController

  def create
    if !anyone_signed_in?
      @grant = Grant.find(params[:grant_id])
      deny_access(url: url_for(@grant))
    else
      @payment = current_user.payments.build(:amount => params[:amount],
                                             :user_id => current_user.id,
                                             :crowdfund_id => params[:grant_id])
      @payment.save
      current_user.stripe_token ||= params[:stripe_token]
      current_user.save
      redirect_to root_url, notice: "Donation processed!"
    end
  end

  def destroy
    Payment.find(params[:id]).destroy
    flash[:success] = "Payment cancelled."
    redirect_to root_url
  end
end
