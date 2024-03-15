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

### DateTime and Date fields

Ruby (including RoR) has a class for Dates.  Likewise, Javascript has a Date class.  They also have corresponding
DateTime classes.  Sadly, neither the DOM nor JSON play nicely with these.  In both cases, dates are represented as
ISO8601 strings.

In the RoR backend we use the standard behaviour of the JSON Serializer to convert it to a string.  When this is
received by the frontend Svelte component (```*Form.svelte```) it is turned into a Javascript ```Date``` or
```DateTime``` object.

Because I didn't like the standard way that the browser form renders the selector for ```DateTime``` fields, I have
created my own component ```DateTimeInput.svelte```.  This is passed the field holding the Javascript DateTime object.
It unpacks the object into two fields: a Date field and a drop down for the Time field.  Any changes in either field
causes the Javascript object in the ```$form``` object to be updated.

On submitting the form, the whole ```$form``` object is simply sent to the backend.

My Capybara test was failing for the #new_rate_from field.  Frustratingly, running in dev mode, it all seemed to work.
After much experimentation, found that ```fill_in 'new_rate_from', with: '2028-02-26'``` was not actually leading to
the correct element being updated in the ```$form``` object.  Not sure why, but now I use a DOM Javascript query
to extract the info before sending on to the backend.

### Handling Currency types between frontend and backend

We use currency in the app. As everyone knows, it is bad to use a float to represent currency. Ruby has the
```Money``` gem which does a good job of managing currency. Javascript has a similar challenge, and there are a
few good packages to allow manipulation of currency. After a few tries, I have alighted on the Dinero package.
Dinero represents currency in an almost identical way to the Money gem (amount stored as integer in pence/cents, a
currency field using ISO string). Sadly, the name of the fields differ between Money and Dinero.

To address this, the JSON generated by the backend uses the Dinero field names.  Likewise, on the Post/Put from the
frontend, the fields use the Dinero names.  These are mapped into Money gem fields in the backend.

Similar to Date fields above, the ```$form``` object holds currencies using Dinero objects.  The ```CurrencyFormInput.svelte```
converts between String representation with a '.' at the right position and the Dinero object that is stored in the
```$form```.

### SCSS/SASS Usage
I decided I wanted to use SCSS/SASS in the application.  The primary driver was that I wanted to apply the same margins to
all form labels on a specific page.  This is not possible with standard CSS, but is relatively easy using the ```@extend```
operator in SCSS/SASS.

However, it turned into a bit of a nightmare.  To be fare to both Svelte and Vite, they do provide easy mechanisms for getting
SCSS integrated, just the documentation (and particularly Stackoverflow answers) are both out-of-date.  I would see one
of three outcomes:
- under certain configurations the system would flag the ```@extend``` keyword would be flagged, telling me I needed
  to configue the SCCS pre-processor,
- under other configurations the pre-processor would see the ```@extend``` but did not recognise the ```py-3``` css
  class,
- under yet another configuration the preprocessor would run, the ```py-3``` css class, but when the page was rendered
  in the browser, no bootstrap styling had been applied.

My conclusions are that you almost need to treat the pre-complitation stage as a completely separate process to the
serving the pages to the browser for rendering.

So here is how I got it working:

- We need a ```svelte.config.js``` file to instruct Svelte to use the Vite preprocessor.  This naturally adds the tools needed
  for SCSS/SASS preprocessing.
```ruby
import { vitePreprocess } from "@sveltejs/vite-plugin-svelte";

const config = {
  preprocess: [vitePreprocess({})],
};

export default config;
```
- We need to make the following changes to the vite.config.js to provide options to the preprocessing engine so that
  the precessor knows about Bootstrap and can therefore ```@extend``` the css style.
```ruby
  css: {
    preprocessorOptions: {
      scss: {
        additionalData: `@import 'bootstrap/scss/bootstrap'; `,
      },
    },
  },
```
- Finally, in order to ensure that Bootstrap is served to the broswer, we need the ```application.html.erb``` to include 
  the ```main.css``` ahead of serving the Svelte app itself:
```html
    <%= vite_client_tag %>
    <%= vite_stylesheet_tag 'main.scss' %>
    <%= vite_javascript_tag 'application' %>
```

We are now able to do the following in the main css file:
```css
@import "bootstrap/scss/bootstrap.scss";
@import '@fortawesome/fontawesome-free/css/all.min.css';

label {
  @extend .py-2;
}
```

What I was not able to get working was to apply the ```@extend``` at the individual page.  I suspect, if I included
the relevant Bootstrap style this would overcome the issue. 