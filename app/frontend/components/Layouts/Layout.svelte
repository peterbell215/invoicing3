<script>
  import MainNav from "./MainNav.svelte";
  // import FlashMessages from "./FlashMessages.svelte";
</script>

<div class="bg-white">
  <MainNav />

  <main>
    <div>
      <slot />
    </div>
  </main>
</div>