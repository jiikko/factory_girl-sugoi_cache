```ruby
require 'rails_helper'

RSpec.describe User, type: :model do
  it 'fast' do
    30.times { FactoryGirl.find_cache(:john) }
  end
  it 'fast' do
    30.times { FactoryGirl.load(:john) }
  end
  it 'slow' do
    30.times { FactoryGirl.create(:user, name: :john) }
  end
end
```
```ruby
FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
  end

  cache do
    factory(:john) { FactoryGirl.create(:user, name: :john) }
  end

  preload do
    factory(:john) { FactoryGirl.create(:user, name: :john) }
  end
end
```

