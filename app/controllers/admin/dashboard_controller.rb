# Actions for the main admin dashboard page and setting the
# grant status
class Admin::DashboardController < ApplicationController
  include GrantsHelper
  authorize_resource class: false

  def index
    if !current_user.approved
      raise CanCan::AccessDenied.new
    end

    @grant_report = GrantReport.new(params[:grant_report])
    respond_to do |f|
      f.html do
        @grant_report.scope {|scope| scope.page(params[:page]).per_page(25)}
      end
      f.csv do
        if params[:csv_type] == "grant"
          send_data @grant_report.to_csv,
            type: "text/csv",
            disposition: 'inline',
            filename: "grant-report-#{Time.now.to_s}.csv"
        end
      end
    end

    @donor_report = DonorReport.new(params[:donor_report])
    respond_to do |f|
      f.html do
        @donor_report.scope {|scope| scope.page(params[:page]).per_page(25)}
      end
      f.csv do
        if params[:csv_type] == "donor"
          send_data @donor_report.to_csv,
          type: "text/csv",
          disposition: 'inline',
          filename: "donor-report-#{Time.now.to_s}.csv"
        end
      end
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
