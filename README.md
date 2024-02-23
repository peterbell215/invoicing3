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

### Forms
This has been a difficult area.  I am using Bootstrap for styling.  There are a few component libraries that provide
nice styling with Bootstrap of forms - particularly to highlight errors.
[Sveltestrap](https://sveltestrap.js.org/?path=/docs/sveltestrap-overview--docs) and
[mdbsvelte](https://github.com/mdbootstrap/mdbsvelte) are two I had a go at using.  However, both expect Svelte to work
in a specific way that is different from how Inertia.js does.  In the end, I found that the best approach has been to
use Svelte natively and use standard Bootstrap styling for showing errors.

Another confusing area around validation is which classes to apply where.  Key conclusions from several hours of
experimentation:
- the form needs to include the `novalidate` tag.  OTherwise, the browser may insert extra stuff in.
- the form must not include the class 'was-validated' as this seems to set all fields by default to show as having
  passed validation, even when individual fields are flagged as failing validation
- any field failing validation needs to have the class `is-invalid` set.  This makes the surrounding box red and puts a
  warning in the box.
- the error feedback `<div>` needs to have the class `invalid-feedback`

I have created my own component `FormInput.svelte` to provide error display.  The ClientForm.svelte component now has
two slot elements: `navigation-elements` that is a place to put buttons at the top of the form, and `form-elements` that
is used to place extra fields into the form when required.

To make sure the correct info is passed from frontend to the backend, I make good use of Interia.js `transform()` callback
ahead of sending the data.

### Passing Structured data between frontend and backend
This has been another difficult area.  We use currency in the app.  For the frontend, I found the Dinero package to
give me all I needed.  For the backend, the `money-rails` gem does the job.  The issue is that although both apps
take an almost identical approach to how they manage money (both use integer to represent the amount in pence/cents and
a currency field with the ISO name in it), they call the fields different things.  I decided that the JSON passed
between backend and frontend would adopt the naming of the frontend.  However, I found the rails #as_json method not
flexible enough, so have moved to using the 'blueprinter' gem instead.
