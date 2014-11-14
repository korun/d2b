# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :arena do
    sequence(:name) { |n| "Neutral_#{n}" }

    background_file_name    'test.jpeg'
    background_content_type 'image/jpeg'
    background_file_size    2.megabytes
    # background_updated_at
    foreground_file_name    'test2.png'
    foreground_content_type 'image/png'
    foreground_file_size    1000.kilobytes
    # foreground_updated_at
  end
end
