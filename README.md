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

### Dynamic Content

Here's the scenario: You have a page with a selector of the client on it, that modifies the content shown on the page.
However, determining the content is an expensive operation such that you don't want to push content down for all
clients but instead waint until the specific client has been selected.

In classical Svelte (if such a thing exists), you would use a combination of Javascript functions in the ```<script>```
section, combined with ```{@await}``` in the HTML.  This is where Inertia.js approach is much more like that of a classical
Rails app.  So you define what parameters you will feed into the page in the script page.

```sveltehtml
<script>
  export let clients = undefined;                       // provided by backend.  List of clients with id, name, etc. 
  export let details_for_specific_client = undefined;   // to be provided on demand by the backend
  
  let client;                                           // set by the page
</script>
```
And in the main HTML section:

```sveltehtml
    <select>
      <select name="client" bind:value={client} on:change={change_client}>
        {#each clients as client}
          <option value={client}>
            {client}
          </option>
        {/each}
      </select>
    </select>
```

The above code will allow the controller to provide a list of clients and details for a specific client.  However,
they can be left undefined by the backend as well.  The above code will invoke the function ```change_client()```
whenever the user selects a different client.

It is in this function that the magic of Inertia comes to the fore:

```sveltehtml
    function change_client() {
        router.get(window.location.href, { client: client }, { only: ["details_for_specific_client"] } );
    }
```

This asks Inertia to go back to the server, and request the page, but only load the information that will go into
the ```details_for_specific_client``` variable. Note, the second argument of ```router.get()``` allows us to pass in the
parameter of the client. The rest is classical Svelte. We will have HTML to render on the page the
details_for_specific_client data. Svelte and Inertia between them will work out what parts of the page need
re-rendering.

On the server side, we do something like:

```ruby
  def new
    props = { clients: ClientSerializer.render_as_json(Client.order(:name), view: :short_details) }

    client = params.fetch(:client, nil)  // allows for invocation without client set.
    if client
      details_for_specific_client = get_the_relevant_client_details(); 
      props[:details_for_specific_client] = ClientDetailsSerializer.render_as_json(details_for_specific_client)
    end

    render inertia: 'Invoices/New', props: {client:, details_for_specific_client:}
  end
```

### Selector for Child Relationships

For the Invoice, I want to be able to show a table of Client Sessions that have not yet been invoiced and
allow the user to choose which ones to apply to an invoice.  In implementing this, I learnt the power of a
number of great Svelte features.

First is ```bind:group=``` which provides a simple way to tie a group of HTML input elements to an array.
It looks something like this:

```sveltehtml
   {#each client_sessions as client_session}
        <tr>
            <td>
                <input type="checkbox" value="{client_session.id}" bind:group={client_session_ids} />
            </td>
            ... other elements
        </tr>
    {/each}
```

The other strong feature is the use of ```$:``` as a very simple way to make the Javascript reactive.  I
use this to create a Select All checkbox.  The HTML looks like this:

```sveltehtml
    <input type="checkbox" id="select_all_client_sessions" bind:checked={all_checked}/>
```

With my Select All checkbox bound to the ```all_checked``` variable, a few lines of Javascript does the
rest:

```javascript
$: all_checked, change_client_sessions();
$: client_session_ids, reset_client_sessions();

function change_client_sessions() {
  client_session_ids = [];

  if (all_checked) {
    client_sessions.forEach( (client_session) => client_session_ids.push(client_session.id));
  }

  console.log(client_session_ids);
}

function reset_client_sessions() {
  all_checked = (client_session_ids.length===client_sessions.length);
}
```

Now, when I uncheck a Client Session the Select All is also unticked.  And, if I select all Client Sessions
individually, the Select All will become ticked.

