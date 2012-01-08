# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :train_station do
    name { Faker::AddressAU.city 'WA' }
  end
end
