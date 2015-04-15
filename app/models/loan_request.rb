class LoanRequest < ActiveRecord::Base
  validates :title, :description, :amount,
    :requested_by_date, :repayment_begin_date,
    :repayment_rate, :contributed, presence: true
  has_attached_file :picture,
                     styles: { large: "960x960",
                               medium: "300x300>",
                               thumb: "100x100>" },
                     default_url: "public/seed_photos/:style/missing.png"
  validates_attachment_content_type :picture,
                                     content_type: /\Aimage\/.*\Z/
  has_many :orders
  has_many :loan_requests_contributors
  has_many :users, through: :loan_requests_contributors
  has_many :loan_requests_categories
  has_many :categories, through: :loan_requests_categories
  belongs_to :user
  enum status: %w(active funded)
  enum repayment_rate: %w(monthly weekly)

  def owner
    self.user.name
  end

  def requested_by
    self.requested_by_date.strftime("%B %d, %Y")
  end

  def updated_formatted
    self.updated_at.strftime("%B %d, %Y")
  end

  def repayment_begin
    self.repayment_begin_date.strftime("%B %d, %Y")
  end

  def funding_remaining
    amount - contributed
  end

  def self.projects_with_contributions
    where("contributed > ?", 0)
  end

  def project_contributors
    LoanRequestsContributor.where(loan_request_id: self.id).pluck(:user_id).map do |user_id|
      User.find(user_id)
    end
  end

  def list_project_contributors
    project_contributors.map(&:name).to_sentence
  end

  def progress_percentage
    ((1.00 - (funding_remaining.to_f / amount.to_f)) * 100).to_i
  end

  def minimum_payment
    if repayment_rate == "weekly"
      contributed / 12
    else
      contributed / 3
    end
  end

  def pay!(amount, borrower)
    repayment = amount / project_contributors.size
    project_contributors.each do |lender|
      lender.increment!(:purse, repayment)
    end
  end
end
