# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  type                   :string(255)
#  first_name             :string(255)
#  last_name              :string(255)
#  stripe_token           :string(255)
#  approved               :boolean
#

class Recipient < User
  has_many :grants, dependent: :destroy
  has_many :draft_grants, dependent: :destroy
  has_one :profile, class_name: 'RecipientProfile'

  attr_accessible :profile_attributes
  accepts_nested_attributes_for :profile

  def init_approved
    true
  end

  def previous_grants
    grants.complete_grants
  end

  def self.collection_to_csv()
    CSV.generate do |csv|
      csv << column_names
      recipients.each do |recipient|
        csv << recipient.attributes.values_at(*column_names)
      end
    end
  end

end
