# 0 Setup ruby and rails5
In this tutorial, we use `rbenv` to manage ruby version.

## 0.1 Install rbenv
- Install rbenv by following with [rbenv install instruction](https://github.com/rbenv/rbenv#installation).

## 0.2 Install ruby

```sh
rbenv install 2.4.2
rbenv global 2.4.2
gem install bundler
```

## 0.3 Install rails

```sh
gem install rails -v 5.2.4
```

## 0.4 Confirm done the setup successfully

```sh
ruby -v
# ruby 2.4.2p198 (2017-09-14 revision 59899) [x86_64-darwin15]
```

```sh
rails -v
# Rails 5.1.4
```
