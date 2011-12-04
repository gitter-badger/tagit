# Factory.create(:valid_user)
Factory.define :valid_user, :class => User do |u|
  u.name "Foo Bar"
  u.username "foobar"
  u.email "foo@bar.com"
  u.password "foobar"
  u.password_confirmation "foobar"
end

# Factory.create(:random_user)
Factory.define :random_user, :class => User do |u|
  u.name "Foo Bar"
  u.username Factory.next(:username)
  u.email Factory.next(:email)
  u.password "foobar"
  u.password_confirmation "foobar"
end

# TODO: Maybe refactor, make it shorter
Factory.define :admin_user, :class => User do |u|
  u.name "Foo Bar"
  u.username "foobar"
  u.email "foo@bar.com"
  u.password "foobar"
  u.password_confirmation "foobar"
  u.admin true
end

# Factory.build(:invalid_user)
Factory.define :invalid_user , :class => User do |u|
end
