<script>
    import { page, Link, router } from '@inertiajs/svelte';
    import Dinero from "dinero.js";
    import {format_time} from "@/js/converters.js";

    let admin = $page.props.auth;

    export let client_sessions;
    export let client;

    function confirmDelete(client_session) {
        if (window.confirm('Confirm Delete?')) {
            router.delete('/client_sessions/'+client_session.client_session.id);
        }
    }
</script>

<div class="mx-auto col-6 py-6">
    <div class="card mb-6">
        <div class="card-header py-3">
            {#if client!==undefined}
                <h1 class="mb-0">Client Sessions List for {client.name}</h1>
            {:else}
                <h1 class="mb-0">Client Sessions List</h1>
            {/if}
        </div>
        <div class="card-body">
            {#if admin}
                <Link href="/client_sessions/new" class="btn btn-primary">New</Link>
            {/if}

            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>Client</th>
                        <th>Start Date & Time</th>
                        <th>Duration (mins)</th>
                        <th>Fees</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    {#each client_sessions as client_session}
                        <tr>
                            <td><Link href="/client_sessions/{client_session.id}">{client_session.client.name}</Link>
                            <td>{ format_time(client_session.start) }</td>
                            <td>{ client_session.duration }</td>
                            <td>{ Dinero(client_session.current_rate).toFormat('$0,0.00') }</td>
                            <td>
                                <Link href="{`/client_sessions/${client_session.id}/edit`}"  class="btn btn-primary">Edit</Link>
                                <button class="btn btn-primary" type="button" on:click={() => confirmDelete({client_session})}>Delete</button>
                            </td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>
</div>