<script>
    import { Link } from "@inertiajs/svelte";
    import Dinero from 'dinero.js';
    import { format_date } from '~/js/converters.js';
    export let client;
    export let fees;
</script>

<div class="mx-auto col-4 py-4">
    <div class="card mb-4">
        <div class="card-header py-3">
            <h5 class="mb-0">History of fees for {client.name}</h5>
        </div>
        <div class="card-body">
            <Link href="/clients/{client.id}" class="btn btn-primary">Back</Link>
            <table class="table table-striped">
                <thead>
                    <tr>
                        <th>From</th>
                        <th>To</th>
                        <th>Hourly Fee</th>
                    </tr>
                </thead>
                <tbody>
                    {#each fees as fee}
                        <tr>
                            <td>{format_date(fee.from)}</td>
                            <td>{format_date(fee.to)}</td>
                            <td>{Dinero(fee.hourly_charge_rate).toFormat('$0,0')}</td>
                        </tr>
                    {/each}
                </tbody>
            </table>
        </div>
    </div>
</div>

