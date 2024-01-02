# README

Application uses RoR for the backend and Svelte.js for the frontend.  Designed to test out some new ideas on how to
build a modern SPA using these.  In order to make these work together it also uses Vite and Inertia.js.  The approach
was originally described [Setting up a new Rails 7 app with Vite, Inertia, and Svelte](https://dev.to/buhrmi/setting-up-a-new-rails-7-app-with-vite-inertia-and-svelte-c9e).
Some ideas, particularly around the structure of the Svelte setup within the Rails, are lifted from here:
[Creating your first Inertia Rails app](https://way-too-mainstream.vercel.app/articles/creating-first-inertia-rails-app)

In order to keep the Javascript side as easy as possible, we use npm in preferrence to yarn.

We use Docker to run the database.  This allows us to have different databases for different branches.

