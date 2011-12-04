Factory.define :user do |user|
  user.name "Foo Bar"
  user.email "foo@bar.com"
  user.password "foobar"
  user.password_confirmation "foobar"
end

Factory.sequence :username do |n|
  "foobar-#{n}"
end

Factory.sequence :email do |n|
  "foo-#{n}@bar.com"
end

Factory.define :post do |post|
  post.content "Foo bar"
  post.association :user
end
