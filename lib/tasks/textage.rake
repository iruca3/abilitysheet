namespace :textage do
  task update: :environment do
    Scrape::Textage.new.run
  end
end
