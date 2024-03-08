<script>
    import ClientSessionForm from "~/pages/ClientSessions/ClientSessionForm.svelte";
    import {Link} from "@inertiajs/svelte";

    export let client;
    export let client_session;
</script>

<ClientSessionForm {client_session} {client} readonly="true">
    <svelte:fragment slot="navigation-elements">
        <Link href="/client_sessions/{client_session.id}/edit" class="btn btn-primary">Edit</Link>
    </svelte:fragment>
</ClientSessionForm>
