class LoanRequest < ActiveRecord::Base
  validates :title, :description, :amount,
            :requested_by_date, :repayment_begin_date,
            :repayment_rate, presence: true
  has_attached_file :picture,
    :styles => { :large => "960x960",
                 :medium => "300x300>",
                 :thumb => "100x100>" },
                 :default_url => "public/seed_photos/:style/missing.png"
  validates_attachment_content_type :picture,
    :content_type => /\Aimage\/.*\Z/
  has_many :orders
  has_many :loan_requests_categories
  has_many :categories, :through => :loan_requests_categories
  status: %w(active retired)
end
