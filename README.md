# FactoryGirl::SugoiPreload

Inspired by https://github.com/fnando/factory_girl-preload

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'factory_girl-sugoi_preload'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install factory_girl-sugoi_preload

## Usage
```
RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
```

```
FactoryGirl.define do
  factory :user do
    name "MyString"
    email "MyString"
  end

  preload do
    factory(:john) { FactoryGirl.create(:user, name: :john) }
  end
end
```

```

require 'rails_helper'

RSpec.describe User, type: :model do
  fixtures :all
  factorygirl_preload :users

  it 'fast' do
    3000.times { FactoryGirl.load(:john) }
  end
  it 'slow' do
    3000.times { FactoryGirl.create(:user, name: :john) }
  end
end
```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/factory_girl-sugoi_preload.

