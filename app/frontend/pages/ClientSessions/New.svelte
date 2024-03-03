<script>
    import ClientSessionForm from "~/pages/ClientSessions/ClientSessionForm.svelte";

    export let client;
    export let clients;
    export let client_session;
</script>

<ClientSessionForm {client_session} {clients}>

</ClientSessionForm>
