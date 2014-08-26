# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  include GrantsHelper
  authorize_resource :class => false

  def index
    if !current_user.approved
      raise CanCan::AccessDenied.new
    end
    
    @grants = (Grant.includes(:school).all-DraftGrant.all).sort_by(&:order_status).paginate :page => params[:page], :per_page => 6
    
    @donors = User.donors
    donated = params[:donated]
    if donated && donated == 'Donated'
      @donors = User.donors.select {|user| user.payments.length > 0}
    elsif donated && donated == 'Have Not Donated'
      @donors = User.donors.select {|user| user.payments.length == 0}
    end
    @donors.sort_by! {|u| [u.last_name, u.first_name]}
    @donors = @donors.paginate :page => params[:page], :per_page => 6

    @recipients = Recipient.all
    school = params[:school]
    if school && school != 'All'
      schoolId = School.find_by_name(school).id
      @recipients = Recipient.select {|recip| recip.profile.school_id == schoolId }
    end
    @recipients.sort_by! {|u| [u.last_name, u.first_name]}
    @recipients = @recipients.paginate :page => params[:page], :per_page => 6
    
    @pending_users = User.where approved: false
    @pending_users = @pending_users.paginate :page => params[:page], :per_page => 6
  end

  def grant_event
    @grant = Grant.find params[:id]
    @grant.send params[:state]
    respond_to do |format|
      format.html { redirect_to admin_dashboard_path }
      format.js
    end
  end

  def load_distributions
    @successful = successful
    @unsuccessful = unsuccessful
    @accepted_school = accepted_school
    @rejected_school = rejected_school
    @accepted_subject = accepted_subject
    @rejected_subject = rejected_subject
    @successful_goal = successful_goal
    @unsuccessful_goal = unsuccessful_goal
    respond_to do |format|
      format.js
    end
  end

  def use_https?
    true
  end
end
