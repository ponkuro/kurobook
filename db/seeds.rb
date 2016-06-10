# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

100.times do |i|
  @sample = User.new(
    name: "testuser_#{i}",
    email: "testuser_#{i}@example.com",
    password: 'password',
    uid: "#{i}",
    provider: 'sample'
  )
  @sample.skip_confirmation!
  @sample.save
end