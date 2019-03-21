require_relative 'member_factory'

FactoryBot.define do
  factory :project, class: "CodePraise::Database::ProjectOrm" do
    origin_id { 126318191 }
    name {"alpha-blog"}
    size { 7181 }
    ssh_url { "git://github.com/XuVic/alpha-blog.git" }
    http_url { "https://github.com/XuVic/alpha-blog" }
    association :owner, factory: :member
    initialize_with { CodePraise::Database::ProjectOrm.find(origin_id: 126318191) || CodePraise::Database::ProjectOrm.create(attributes) }

    factory :project_with_contributor do
      after(:create) do |project|
        contributor = FactoryBot.create(:member)
        project.add_contributor(contributor)
      end
    end
  end
end