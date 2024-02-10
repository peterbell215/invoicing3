<script>
  import { inertia, page, Link } from '@inertiajs/svelte'

  let admin = $page.props.auth;

  export let clients
</script>

<h1>All Clients</h1>

{#if admin}
  <button type="button" use:inertia="{{ href: '/clients/new' }}" class="btn btn-primary">
    New
  </button>
{/if}

<table class="table table-striped">
  <tbody>
    {#each clients as client}
      <tr>
        <td><Link href="/clients/{client.id}">{client.name}</Link>
        <td><button class="btn btn-primary" use:inertia="{{ href: '/clients/'+clients.id, method: 'delete' }}" type="button">Delete</button></td>
      </tr>
    {/each}
  </tbody>

</table>

