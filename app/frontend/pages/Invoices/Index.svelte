<script>
    import { inertia, page, Link } from '@inertiajs/svelte'
    import Dinero from "dinero.js";

    let admin = $page.props.auth;

    export let invoices;
    export let client;
</script>

<div class="mx-auto col-6 py-6">
    <div class="card mb-6">
        <div class="card-header py-3">
            {#if client!==undefined}
                <h1 class="mb-0">Invoices for {client.name}</h1>
            {:else}
                <h1 class="mb-0">Invoices</h1>
            {/if}
        </div>
        <div class="card-body">
            {#if admin}
                <Link href="/invoices/new" class="btn btn-primary">New</Link>
            {/if}

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Number</th>
                        <th>Client</th>
                        <th>Date</th>
                        <th>Amount</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {#each invoices as invoice}
                        <tr>
                            <td><Link href="/invoices/{invoice.id}">{invoice.id}</Link></td>
                            <td><Link href="/clients/{invoice.client.id}">{invoice.client.name}</Link></td>
                            <td>{ new Date(Date.parse(invoice.date)).toLocaleString() }</td>
                            <td>{ Dinero(invoice.amount).toFormat('$0,0.00') }</td>
                            <td>
                                <button class="btn btn-primary" use:inertia="{{ href: '/client_session/'+client_session.id, method: 'delete' }}" type="button">Delete</button>
                                <Link href="{`/client_sessions/${client_session.id}/edit`}"  class="btn btn-primary">Edit</Link>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>
</div>