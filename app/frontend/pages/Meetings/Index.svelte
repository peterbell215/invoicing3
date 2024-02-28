<script>
    import { inertia, page, Link } from '@inertiajs/svelte'
    import Dinero from "dinero.js";

    let admin = $page.props.auth;

    export let meetings;
</script>

<div class="mx-auto col-6 py-6">
    <div class="card mb-6">
        <div class="card-header py-3">
            <h1 class="mb-0">Meeting List</h1>
        </div>
        <div class="card-body">
            {#if admin}
                <button type="button" use:inertia="{{ href: '/meetings/new' }}" class="btn btn-primary">
                    New
                </button>
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
                {#each meetings as meeting}
                    <tr>
                        <td><Link href="/meeting/{meeting.id}">{meeting.client.name}</Link>
                        <td>{ new Date(Date.parse(meeting.start)).toLocaleString() }</td>
                        <td>{ meeting.duration }</td>
                        <td>{ Dinero(meeting.current_rate).toFormat('$0,0.00') }</td>
                        <td><button class="btn btn-primary" use:inertia="{{ href: '/meeting/'+meeting.id, method: 'delete' }}" type="button">Delete</button></td>
                    </tr>
                {/each}
                </tbody>
            </table>
        </div>
    </div>
</div>