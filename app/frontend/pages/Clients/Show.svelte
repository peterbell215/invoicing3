<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";
    import {Link} from "@inertiajs/svelte";

    export let client;
</script>

<ClientForm {client} readonly=true>
    <Link href="/clients/{client.id}/prices" class="btn btn-primary">Price History</Link>
</ClientForm>
