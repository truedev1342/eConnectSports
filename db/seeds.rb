# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
AdminUser.create!(:email => 'comeonandroid@gmail.com', :password => 'Ubghjvskj', :password_confirmation => 'Ubghjvskj')
Plan.create!(:name => 'Start Up', :price => '14', :cards => '5', :teams => '1')
Plan.create!(:name => 'Small Business', :price => '22', :cards => '10', :teams => '1')
Plan.create!(:name => 'Corporate Bronze', :price => '25', :cards => '10', :teams => '2')
Plan.create!(:name => 'Corporate Silver', :price => '50', :cards => '20', :teams => '4')
Plan.create!(:name => 'Corporate Gold', :price => '100', :cards => '50', :teams => '10')
Plan.create!(:name => 'Corporate Platinum', :price => '200', :cards => '125', :teams => '25')
