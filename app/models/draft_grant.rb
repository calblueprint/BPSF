# == Schema Information
#
# Table name: draft_grants
#
#  id                 :integer          not null, primary key
#  recipient_id       :integer
#  title              :text
#  summary            :text
#  subject_areas      :text
#  grade_level        :text
#  duration           :text
#  num_classes        :integer
#  num_students       :integer
#  total_budget       :integer
#  requested_funds    :integer
#  funds_will_pay_for :text
#  budget_desc        :text
#  purpose            :text
#  methods            :text
#  background         :text
#  n_collaborators    :integer
#  collaborators      :text
#  comments           :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class DraftGrant < ActiveRecord::Base
  attr_accessible :title, :summary, :subject_areas, :grade_level, :duration, 
                  :num_classes, :num_students, :total_budget, :requested_funds, 
                  :funds_will_pay_for, :budget_desc, :purpose, :methods, :background, 
                  :n_collaborators, :collaborators, :comments
end
