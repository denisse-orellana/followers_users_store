# Followers Async
## How an User can follow a Store

### Setup

* ✅  Ruby 2.6.3
* ✅  Rails 6.1.3
* ✅  Yarn 1.22.5
* ✅  Node v14.15.0

## Baby steps

First add devise for User

## 1. Models

```console
rails g devise User
rails g model Store name
rails g model Follow user_id:integer store_id:integer
rails db:migrate
```

```ruby
# follow.rb

class Follow < ApplicationRecord
  belongs_to :user 
  belongs_to :store
end
```

```ruby
class Store < ApplicationRecord
  has_many :follows
  has_many :users, through: :follows, dependent: :destroy
end
```

```ruby
class User < ApplicationRecord
  has_many :follows
  has_many :stores, through: :follows, dependent: :destroy
end
```

Checking associations from console:

```console
Store.last.users
User.last.stores
```

## 2. Controllers

```console
rails g controller Follow create destroy
```

```ruby
# follows_controller.rb

class FollowsController < ApplicationController
  def create
    @store = Store.find_by(params[:store_id])
    current_user.stores << @store
    respond_to do |format|
      format.js { render nothing: false }
    end
  end

  def destroy
    @store = Store.find_by(params[:store_id])
    @follow = current_user.follows.find_by(params[:store_id])
    @follow.destroy
    respond_to do |format|
      format.js { render nothing: false }
    end
  end
end
```

## 3. Views

```ruby
# follows/_follow_store.html.erb

<div id="follow-<%= @store.id %>">
  <% if current_user.stores.include?(@store) %>
    <%= link_to 'Unfollow', unfollow_path(@store), method: :delete, remote: true, class: 'btn btn-outline-success' %>
  <% else %>
    <%= link_to 'Follow', follow_path(@store), method: :post, remote: true, class: 'btn btn-outline-success' %>
  <% end %>
</div>
```

```ruby
# follows/_followers.html.erb

<div id="store-<%= @store.id %>">
  <h4><%= @store.users.count %> followers</h4>
</div>
```

```javascript
// follows/create.js.erb

$("#follow-<%= @store.id %>").html("<%= j(render 'follows/follow_store') %>")
$("#store-<%= @store.id %>").html("<%= j(render 'follows/followers') %>")
```

```javascript
// follows/destroy.js.erb

$("#follow-<%= @store.id %>").html("<%= j(render 'follows/follow_store') %>")
$("#store-<%= @store.id %>").html("<%= j(render 'follows/followers') %>")
```

#### Index view

```html
<!-- stores/index.html.erb -->

<% if user_signed_in? %>
  <div id="follow">
    <%= render 'follows/follow_store', store: @store %>
  </div>
<% end %>

```

#### Show view

```html
<!-- stores/show.html.erb -->

<% if user_signed_in? %>
  <div id="follow">
    <%= render 'follows/follow_store', store: @store %>
  </div>
<% end %>

<div>
  <div id="followers">
    <%= render 'follows/followers', store: @store %>
  </div>
</div>
```

## 4. Routes

``` ruby
scope '/follows/' do
  post '/:id', to: 'follows#create', as: 'follow'
  delete '/:id', to: 'follows#destroy', as: 'unfollow'
end
```