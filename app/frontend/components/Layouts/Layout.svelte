<script>
  import MainNav from "./MainNav.svelte";
  import FlashMessages from "~/components/Layouts/FlashMessages.svelte";
  // import FlashMessages from "./FlashMessages.svelte";
</script>

<main>
  <MainNav />
  <FlashMessages />

  <div>
    <slot />
  </div>
</main>
