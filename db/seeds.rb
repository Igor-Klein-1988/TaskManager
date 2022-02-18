# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin = Admin.find_or_create_by(first_name: 'admin', last_name: 'admin', email: 'admin@localhost.com')
admin.password = 'admin'
admin.save

20.times do |i|
  u = [Manager, Developer].sample.new
  u.email = "email#{i}@mail.gen"
  u.first_name = "FN#{i}"
  u.last_name = "LN#{i}"
  u.password = "#{i}"

  u.save
end

30.times do |i|
  task = Task.new
  task.name = "Task №#{i}"
  task.author = (Admin.all + Manager.all).sample
  task.assignee = (Manager.all + Developer.all).sample
  task.state = Task::STATES.sample
  task.description = "Task №#{i}, state: #{task.state}, author Id: #{task.author.id}, assignee Id: #{task.assignee.id}."
  
  task.save
end
