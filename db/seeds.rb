# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(first_name: 'Karen', last_name: 'Chesnell', email: 'karen@example.com', birthdate: 19830728, fach: 'soprano', city: 'Buffalo', country: 'USA', admin: true)
User.create(first_name: 'Simon', last_name: 'Bundy', email: 'simon@example.com', birthdate: 19880902, fach: 'countertenor', city: 'Brisbane', country: 'Australia', admin: false)

TaskList.create(title: 'Default Tasks', user_id: 1)
TaskList.create(title: 'Default Tasks', user_id: 2)

Task.create(title: 'Take out the trash', task_list_id: 1)
Task.create(title: 'Water the plants', task_list_id: 1)
Task.create(title: 'Call mom', task_list_id: 1)

Task.create(title: 'Go to grocery store', task_list_id: 2)
Task.create(title: 'Call electric company', task_list_id: 2)
Task.create(title: 'Buy coffee', task_list_id: 2)