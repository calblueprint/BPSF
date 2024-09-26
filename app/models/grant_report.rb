class GrantReport
  include Datagrid
  include Rails.application.routes.url_helpers


  #
  # Scope
  #

  scope do
    Grant
  end

  #
  # Filters
  #

  filter(:condition, :dynamic, :header => "Custom Filter:")
  filter(:updated_at, :date, header: "Updated Between:", :range => true, :default => proc { [3.month.ago.to_date, Date.today]})

  #
  # Columns
  #


  column(:teacher_name, mandatory: true)
  column(:title, mandatory: true) do |grant|
      format(grant.title) do |value|
          link_to value, grant_path(grant)
      end
  end
  column(:status, order: :state , mandatory: true)
  column(:current_funds, header: "Current Funds", mandatory: true) do |grant|
      grant.current_funds
  end
  column(:goal, header: "Goal", mandatory: true) do |grant|
      grant.total_budget or 0
  end
  column(:updated_at, mandatory: true) do |grant|
      grant.updated_at.to_formatted_s(:long)
  end
end
