50.times do |n|
  user = User.find_or_initialize_by(
    email: "user#{n+1}@example.com",
    activated: true
   )

   if user.new_record?
     user.password = "password"
     user.save!
   end
end

puts "users = #{User.count}"