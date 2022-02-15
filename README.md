# Followers Async 👩‍💻 
## How an User can follow a Store 

### Setup

* ✅  Ruby 2.6.3
* ✅  Rails 6.1.3
* ✅  Yarn 1.22.5
* ✅  Node v14.15.0

## Baby steps

First add devise for User

```console
bundle add gem 'devise'
rails generate devise:install
```

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
# store.rb

class Store < ApplicationRecord
  has_many :follows
  has_many :users, through: :follows, dependent: :destroy
end
```

```ruby
# user.rb

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
# stores_controller.rb

before_action :set_store, only: %i[ store_unfollow store_follow]

def store_follow
  user_id = params[:follow_id]
  store_id = params[:follow_store_id]

  if Follow.create!(user_id: user_id, store_id: store_id)
    flash[:success] = 'Now following store'
  else
    flash[:success] = 'Not able to follow store'
  end

  respond_to do |format|
    format.js { render nothing: false }
  end
end

def store_unfollow
  current_user.follows.find_by(store_id: @store.id).destroy
  respond_to do |format|
    format.js { render nothing: false }
  end
end
```

## 3. Views

```ruby
# stores/_follow_store.html.erb

<div id="follow-<%= store.id %>">
  <% if current_user.stores.include?(store) %>
    <%= link_to "Unfollow store #{store.name}", store_unfollow_path(store), method: :delete, remote: true, class: "btn btn-primary" %>
  <% else %>
    <%= form_tag(store_follow_path(store), remote: true) do %>
      <%= hidden_field_tag :follow_id, current_user.id %>
      <%= hidden_field_tag :follow_store_id, store.id %>
      <%= submit_tag "Follow store #{store.name}", class: "btn btn-primary" %>
    <% end  %>
  <% end %>
</div>
```

```ruby
# stores/_followers.html.erb

<div id="store-<%= @store.id %>">
  <h4><%= @store.users.count %> followers</h4>
</div>
```

#### Follow store with Jquery or Vanilla js

```javascript
// stores/store_follow.js.erb

// Jquery
$("#follow-<%= @store.id %>").html("<%= j(render 'stores/follow_store', store: @store ) %>")
$("#followers-<%= @store.id %>").html("<%= j(render 'stores/followers', store: @store ) %>")

// Or use Vanilla Js
var follow = document.querySelector("#follow-<%= @store.id %>");
var followers = document.querySelector("#followers-<%= @store.id %>");

follow.innerHTML = "<%= j(render 'stores/follow_store', store: @store ) %>"
followers.innerHTML = "<%= j(render 'stores/followers', store: @store ) %>" 
```

```javascript
// follows/store_unfollow.js.erb

// Jquery
$("#follow-<%= @store.id %>").html("<%= j(render 'stores/follow_store', store: @store ) %>")
$("#followers-<%= @store.id %>").html("<%= j(render 'stores/followers', store: @store ) %>")

// Or use Vanilla Js
var follow = document.querySelector("#follow-<%= @store.id %>");
var followers = document.querySelector("#followers-<%= @store.id %>");

follow.innerHTML = "<%= j(render 'stores/follow_store', store: @store ) %>"
followers.innerHTML = "<%= j(render 'stores/followers', store: @store ) %>" 
```

#### Index view

```html
<!-- stores/index.html.erb -->

<% if user_signed_in? %>
  <div id="follow">
    <%= render 'follow_store', store: @store %>
  </div>
<% end %>

```

#### Show view

```html
<!-- stores/show.html.erb -->

<% if user_signed_in? %>
  <div id="follow">
    <%= render 'follow_store', store: @store %>
  </div>
<% end %>

<div>
  <div id="followers">
    <%= render 'followers', store: @store %>
  </div>
</div>
```

## 4. Routes

```ruby
# routes.rb

post '/follow/:id/store', to: 'stores#store_follow', as: "store_follow"
delete '/unfollow/:id/store', to: 'stores#store_unfollow', as: "store_unfollow"
```