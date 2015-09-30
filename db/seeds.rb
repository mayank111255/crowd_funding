# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.create(name: 'mayank', email: 'mayank.agarwal@vinsol.com', password: '123', role: 'admin', is_activated: true)

# User.skip_callback(:create) do
# 	u=User.new(name: 'gaandu', email: 'fdf@dsf.com', password: 'gaandu')
# 	u.save(validate: false)
# end