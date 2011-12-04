Factory.sequence :username do |n|
  "foobar-#{n}"
end

Factory.sequence :email do |n|
  "foo-#{n}@bar.com"
end

# Factory(:user) or Factory.create(:user)
Factory.define :user do |user|
  user.name "Foo Bar"
  user.username "foobar"
  user.email "foo@bar.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.define :admin, :class => User do |user|
  user.name "Foo Bar"
  user.username "foobar"
  user.email "foo@bar.com"
  user.password "foobar"
  user.password_confirmation "foobar"
  user.admin true
end

Factory.define :random_user, :class => User do |user|
  user.name "Foo Bar"
  user.username { Factory.next(:username) }
  user.email { Factory.next(:email) }
  user.password "foobar"
  user.password_confirmation "foobar"
end

# Factory.build(:invalid_user)
Factory.define :invalid_user , :class => User do |user|
end

Factory.define :post do |post|
  post.title "Foo bar"
  post.content "Foo bar"
  post.association :user
end
