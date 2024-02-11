<script>
    import {Link} from "@inertiajs/svelte";

    export let client;
    export let meeting_charges;
</script>

<h1>History of charges for {client.name}</h1>

<table class="table table-striped">
    <thead>
        <tr>
            <th>From</th>
            <th>To</th>
            <th>Hourly Charge Rate</th>
        </tr>
    </thead>
    <tbody>
        {#each meeting_charges as meeting_charge}
            <tr>
                <td>{meeting_charge.from}</td>
                <td>{meeting_charge?.to}</td>
                <td>{meeting_charge.hourly_charge_rate_pence}</td>
            </tr>
        {/each}
    </tbody>
</table>
