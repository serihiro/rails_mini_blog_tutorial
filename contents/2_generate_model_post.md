# #2 Generate model `Post`

## Generate a model `Post` and create table `posts`

You need a database table to stock contents of mini_blog post.  
So you generate a database table and a model class to access it.

Execute this command.
```sh
bin/rails g model Post
```
Then `bin/rails` generates a model class `Post` at `app/models/post.rb` and a migration file at `db/migrate/yyyymmddhhmmss_create_posts.rb`(`yyyymmddhhmmss` is a time when you execute this command).

Open `db/migrate/yyyymmddhhmmss_create_posts.rb` and edit like this.

```ruby
class CreatePosts < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :content, null: false
      t.timestamps
    end
  end
end
```

A line of `t.string :content, null: false` is added.  
This line defines `content` column whose type is `string` and `not null`.

```sh
bin/rails db:migrate
```

Now `posts` table is created at our SQLite databse.  
Note: In defaut, rails uses a SQLite as a database. In this tutorial you use SQLite too.)

## Add model validation

Open `app/models/posts.rb` and edit like this.

```ruby
class Post < ApplicationRecord
  validates :content, length: { maximum: 140 }, presence: true
end
```

A line of `validates :content, length: { maximum: 140 }, presence: true` defines two validation rules for `content` column

- `length: { maximum: 140 }`
  - Limit max length upto 140 characters.
- `presence: true`
  - Require not nil value.

If you about to save Post model with some violations to this validation rules, rails raises a `ActiveRecord::RecordInvalid` error.

## Access to database through model class

Now, `Post` model is ready to access your databse.   
Let's try database access with `rails console`, which is a command line tool which you can execute rails web application code.

Execute this command.

```sh
bin/rails console
```

Now `rails console` is launched.   
Type this script and hit enter key.

```ruby
Post.create(content: "I'm feelin great!")
```

Then you can see like this log in your console.

```ruby
Running via Spring preloader in process 71649
Loading development environment (Rails 5.1.4)
irb(main):001:0> Post.create(content: "I'm feelin great!")
(0.1ms)  begin transaction
SQL (0.8ms)  INSERT INTO "posts" ("content", "created_at", "updated_at") VALUES (?, ?, ?)  [["content", "I'm feelin great!"], ["created_at", "2017-09-17 22:38:54.763812"], ["updated_at", "2017-09-17 22:38:54.763812"]]
(0.5ms)  commit transaction
=> #<Post id: 1, content: "I'm feelin great!", created_at: "2017-09-17 22:38:54", updated_at: "2017-09-17 22:38:54">
```

A line of `Post.create(content: "I'm feelin great!")` executes a INSERT query to your database with content="I'm feelin great!".

If you about to call `create` method with `content: nil`, rails does not execute a insert query because of Post validation rules.

```ruby
irb(main):010:0> Post.create(content: nil)
   (0.1ms)  begin transaction
   (0.1ms)  rollback transaction
ActiveRecord::RecordInvalid: Validation failed: Content can't be blank
        from (irb):10
```

If you use `create!` method, rails raises `ActiveRecord::RecordInvalid`. If you want to raise error when validation check failed, you need to use `create!` instead of `create` (I recommend to use `create` in every cases.)

```ruby
irb(main):011:0> Post.create!(content: nil)
   (0.1ms)  begin transaction
   (0.1ms)  rollback transaction
ActiveRecord::RecordInvalid: Validation failed: Content can't be blank
        from (irb):11
```

Then confirm that the record is created properly.  
Type this script and hit enter key.

```ruby
Post.where(content: "I'm feelin great!")
```

```ruby
irb(main):002:0* Post.where(content: "I'm feelin great!")
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."content" = ? LIMIT ?  [["content", "I'm feelin great!"], ["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Post id: 2, content: "I'm feelin great!", created_at: "2017-09-17 22:38:54", updated_at: "2017-09-17 22:38:54">]>
```

A line of `Post.where(content: "I'm feelin great!")` executes a SELECT query to your datbase with `WHERE "posts"."content" = ""I'm feelin great!""` and returns all results.

Rails returns `ActiveRecord::Relation` object. That is a set of records. To fetch only first line, you need to call `first` to `ActiveRecord::Relation` object like this:

```ruby
Post.where(content: "I'm feelin great!").first
```

```ruby
irb(main):005:0> Post.where(content: "I'm feelin great!").first
  Post Load (0.3ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."content" = ? ORDER BY "posts"."id" ASC LIMIT ?  [["content", "I'm feelin great!"], ["LIMIT", 1]]
=> #<Post id: 2, content: "I'm feelin great!", created_at: "2017-09-17 22:38:54", updated_at: "2017-09-17 22:38:54">
```

Then you get `Post` object.

If you want to get all records:


```ruby
Post.all
```

```ruby
irb(main):007:0> Post.all
  Post Load (0.1ms)  SELECT  "posts".* FROM "posts" LIMIT ?  [["LIMIT", 11]]
=> #<ActiveRecord::Relation [#<Post id: 1, content: "unko", created_at: "2017-09-17 09:15:03", updated_at: "2017-09-17 09:15:03">, #<Post id: 2, content: "I'm feelin great!", created_at: "2017-09-17 22:38:54", updated_at: "2017-09-17 22:38:54">]>
```

If you want to find 1 record with id:


```ruby
Post.find(1)
```

```ruby
irb(main):008:0> Post.find(1)
  Post Load (0.2ms)  SELECT  "posts".* FROM "posts" WHERE "posts"."id" = ? LIMIT ?  [["id", 1], ["LIMIT", 1]]
=> #<Post id: 1, content: "unko", created_at: "2017-09-17 09:15:03", updated_at: "2017-09-17 09:15:03">
```
