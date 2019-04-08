require_relative 'member_factory'

FactoryBot.define do
  factory :project, class: "CodePraise::Database::ProjectOrm" do
    origin_id { 131723249 }
    name {"talkup_api"}
    size { 168 }
    ssh_url { "git@github.com:PigAndChicken/talkup_api.git" }
    http_url { "https://github.com/PigAndChicken/talkup_api.git" }
    association :owner, factory: :member
    initialize_with { CodePraise::Database::ProjectOrm.find(origin_id: 131723249) || CodePraise::Database::ProjectOrm.create(attributes) }

    factory :project_with_contributor do
      after(:create) do |project|
        contributor = FactoryBot.create(:member)
        project.add_contributor(contributor)
      end
    end
  end
end