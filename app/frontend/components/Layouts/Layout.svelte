<script>
  import MainNav from "./MainNav.svelte";
  // import FlashMessages from "./FlashMessages.svelte";
</script>

<main>
  <MainNav />

  <div>
    <slot />
  </div>
</main>
