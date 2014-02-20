# == Schema Information
#
# Table name: user_profiles
#
#  id           :integer          not null, primary key
#  address      :text
#  city         :text
#  zipcode      :integer
#  phone        :text
#  relationship :text
#  user_id      :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class UserProfile < ActiveRecord::Base
  include ActionView::Helpers::NumberHelper
  attr_accessible :address, :city, :zipcode, :phone, :relationship, :user_id

  belongs_to :user

  before_save :format_phone_numbers

  private
    def format_phone_numbers
      self.phone = number_to_phone(self.phone, area_code: true)
    end
end
