<script>
  import { Link, page, inertia } from '@inertiajs/svelte'
</script>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
  <div class="container-fluid">
    <p class="navbar-brand">Katy's Invoicing</p>
    <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarResponsive" aria-controls="navbarResponsive" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbar">
      <ul class="navbar-nav">
        <li class="nav-item">
          <Link class="nav-link {$page.url === '/clients' ? 'nav-item active' : 'nav-item'}" href="/clients">Clients</Link>
        </li>
        <li class="nav-item">
          <Link class="nav-link {$page.url === '/client_sessions' ? 'nav-item active' : 'nav-item'}" href="/client_sessions">Client Sessions</Link>
        </li>
      </ul>
    </div>
  </div>

  <div>
    {#if $page.props.auth}
      <button use:inertia="{{ href: '/logout', method: 'delete' }}"
              type="button">
        Sign out
      </button>
    {:else}
      <Link href="/login">Sign in</Link>
    {/if}
  </div>
</nav>