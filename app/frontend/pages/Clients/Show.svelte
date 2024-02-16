<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";
    import {Link} from "@inertiajs/svelte";

    export let client;
</script>

<ClientForm {client} readonly=true>
    <svelte:fragment slot="navigation-elements">
        <Link href="/clients/{client.id}/edit" class="btn btn-primary">Edit</Link>
        <Link href="/clients/{client.id}/prices" class="btn btn-primary">Price History</Link>
    </svelte:fragment>
</ClientForm>
