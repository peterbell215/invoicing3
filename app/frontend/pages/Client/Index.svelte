<script>
  import New from './New.svelte'
  import { inertia, page, Link } from '@inertiajs/svelte'

  let admin = $page.props.auth;
  let show = false;

  function toggleShow() {
    show = !show;
  }

  function hideNewClient() {
    show = false;
  }
  export let clients
</script>

<h1>All Clients</h1>

{#if admin}
  <button on:click={toggleShow}>New Client</button>
  {#if show}
    <New on:successfulSubmit={hideNewClient}/>
  {/if}
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

