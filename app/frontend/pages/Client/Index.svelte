<script>
  import New from './New.svelte'
  import { inertia, page, Link } from '@inertiajs/svelte'

  let admin = $page.props.auth
  let show = false

  function toggleShow() {
    show = !show
  }

  export let clients
</script>

<h1 class="font-bold text-2xl mb-6">All Clients</h1>

{#if admin}
  <button on:click={toggleShow} >New Client</button>
  {#if show}
    <New/>
  {/if}
{/if}

<div class="mt-6">
  {#each clients as client}
    <div>
      <Link href="/clients/{client.id}">{client.title}</Link>
      <Link href="/client/{client.id}/edit">Edit</Link>
      <button use:inertia="{{ href: '/clients/'+clients.id, method: 'delete' }}" type="button"
              className="text-indigo-600 hover:text-indigo-900">Delete
      </button>
    </div>
  {/each}
</div>
