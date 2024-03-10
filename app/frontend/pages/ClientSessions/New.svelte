<script>
    import ClientSessionForm from "~/pages/ClientSessions/ClientSessionForm.svelte";

    export let client = undefined;
    export let clients;
    export let client_session;
    export let default_current_rate;
</script>

<ClientSessionForm {client_session} {clients} {client} {default_current_rate} />
