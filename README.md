# README

## Introduction
Application uses RoR for the backend and Svelte.js for the frontend.  Designed to test out some new ideas on how to
build a modern SPA using these.  In order to make these work together it also uses Vite and Inertia.js.  The approach
was originally described [Setting up a new Rails 7 app with Vite, Inertia, and Svelte](https://dev.to/buhrmi/setting-up-a-new-rails-7-app-with-vite-inertia-and-svelte-c9e).
Some ideas, particularly around the structure of the Svelte setup within the Rails, are lifted from here:
[Creating your first Inertia Rails app](https://way-too-mainstream.vercel.app/articles/creating-first-inertia-rails-app).  [Adding Authentication to Inertia Rails app](https://way-too-mainstream.vercel.app/articles/add-auth-to-inertia-rails-app)
shows how to use Devise with Svelte for authentication.  This shows how to use Devise for authentication.
Once that is working, best to switch to using Pundit to perform authorization.  This removes the need for
authenication calls to Devise.  Details in
[Adding Authorization and Flash Messages to Inertia Rails app](https://way-too-mainstream.vercel.app/articles/add-authorization-flash-to-inertia-rails-app).


In order to keep the Javascript side as easy as possible, we use npm in preferrence to yarn.

We use Docker to run the database.  This allows us to have different databases for different branches.



## Gotchas Found

### Top level CSS file
Originally, I started with main.css being in the `stylesheets` directory.  While this worked fine for development, when
running in test mode, I was getting an error saying that main.css could not be found.  Much Googling and experimentation
later, discovered that Vite.js, when pre-building, requires the entry level css file (in my case `main.css`) to be
pre-packed by vite.js, it needs to be in the `entrypoints` directory instead.

### CSRF tokens in testing
Another issue I ran into while developing tests for the controllers (since replaced with system tests) is that I was
getting errors.  Have much digging, I discovered that CSRF generation must be enabled in config/environments/test.rb:

```ruby
  # Enable request forgery protection in test environment as required by Svelte
  config.action_controller.allow_forgery_protection = true
```

### Feature vs System tests
I was struggling to get complete end-to-end testing working with Devise.  After much researching, I discovered that
_feature_ tests and _system_ tests are distinct and different.  _Feature_ tests were introduced as a method in Rspec
when Rails did not yet support the concept.  _System_ tests were introduced in the core Rails 5 system.

Most of the on-line guides about how to get Devise working using RSpec for doing end-to-end tests describe it using
Feature test.  However, feature tests are much more fidely to setup.  By contrast, system tests generally work well
out-of-the-box.  Devise and Warden also provides some nice test helpers for system tests. 

