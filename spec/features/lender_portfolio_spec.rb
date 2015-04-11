require "rails_helper"

RSpec.feature "lender portfolio page" do
  let(:lender) { User.create(email: "example@example.com",
                             password: "password",
                             name: "richard",
                             role: 0)
  }

  let!(:borrower) { User.create(email: "jeff@example.com",
                                password: "pass",
                                name: "jeff",
                                role: 1)
  }

  let!(:loan_request) { LoanRequest.create(title: "Farm Tools",
                                           description: "help out with the farm tools",
                                           amount: "100",
                                           requested_by_date: "2015-06-01",
                                           repayment_begin_date: "2015-12-01",
                                           contributed: "50",
                                           repayment_rate: "monthly",
                                           user_id: borrower.id)
  }

  before(:each) { lender.projects << loan_request }

  scenario "page shows all info of a loan request that has been contributed to" do
    visit "/"
    login_as(lender)
    visit lender_path(lender)

    project = lender.projects.first
    category = Category.create(title: "agricultuer", description: "agri stuff")
    project.categories << category

    [project.title, project.user.name, lender.contributed_to(project).newest_contribution,
     lender.total_contributed].each do |x|
      expect(page).to have_content(x)
    end
  end
end
