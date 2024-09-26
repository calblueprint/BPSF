class DonorReport
  include Datagrid

  #
  # Scope
  #

  scope do
    User.donors
  end

  #
  # Filters
  #

  filter(:condition, :dynamic, :header => "Custom Filters:")
  filter(:updated_at, :date, header: "Updated Between:", :range => true, :default => proc { [3.month.ago.to_date, Date.today]})
  filter(:donated, :xboolean) do |value|
    self.includes(:payments).where('payments.id is not null = ?', value)
  end

  #
  # Columns
  #

  column(:id, :mandatory => true)
  column(:first_name, mandatory: true)
  column(:email, mandatory: true)
  column(:updated_at, mandatory: true) do |user|
      user.updated_at.to_formatted_s(:long)
  end
  column(:donated, mandatory: true) do |user|
      user.donated? ? "Yes" : "No"
  end
end
