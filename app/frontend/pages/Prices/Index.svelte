<script>
    import {Link} from "@inertiajs/svelte";

    export let client;
    export let prices;
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
        {#each prices as price}
            <tr>
                <td>{price.from}</td>
                <td>{price?.to}</td>
                <td>{price.hourly_charge_rate_pence}</td>
            </tr>
        {/each}
    </tbody>
</table>
