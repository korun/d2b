namespace :factory_girl do
  desc 'Verify that all FactoryGirl factories are valid'
  task lint: :environment do
    if Rails.env.test?
      begin
        DatabaseCleaner.start
        FactoryGirl.lint
      ensure
        DatabaseCleaner.clean
      end
    else
      puts "bundle exec rake factory_girl:lint RAILS_ENV='test'"
      exit 1
    end
  end
end
