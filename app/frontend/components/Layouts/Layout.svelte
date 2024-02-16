<script>
  import MainNav from "./MainNav.svelte";
  import FlashMessages from "~/components/Layouts/FlashMessages.svelte";
  // import FlashMessages from "./FlashMessages.svelte";
</script>

<main>
  <MainNav />
  <FlashMessages />
  <div class="mx-auto col-md-8 mb-4 py-4">
    <slot />
  </div>
</main>
