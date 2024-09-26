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

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :first_name, :last_name, :email, :password,
                  :password_confirmation, :remember_me, :type,
                  :approved, :profile_attributes, :terms_of_service

  has_many :payments, dependent: :destroy
  has_one :profile, class_name: 'UserProfile'
  accepts_nested_attributes_for :profile

  validates :type, presence: { message: "must be selected" }
  validates :terms_of_service, acceptance: true

  scope :donors, -> { where type: "User" }

  def name
    return "#{first_name} #{last_name}"
  end

  def init_approved
    true
  end

  def default_card
    if self.stripe_token
      customer = Stripe::Customer.retrieve(self.stripe_token)
      customer.cards.retrieve(customer[:default_card])
    end
  end

  def last4
    default_card[:last4] if default_card
  end

  def donated?
      self.payments.length > 0
  end
end
