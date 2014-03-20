## Rails Tutorial Section3

[このページをやっていく](http://railstutorial.jp/book/ruby-on-rails-tutorial?version=4.0)

### 最初
```
$ mkdir rails_project
$ bundle init
```

`#gem 'rails'`のコメントを外す

```
$ bundle install --path vendor/bundle
$ bundle exec rails new .
```

`./Gemfile`でgemfileを変更

```
$ bundle install --without production
$ bundle update
$ bundle
$ bundle exec rails generate rspec:install
```



