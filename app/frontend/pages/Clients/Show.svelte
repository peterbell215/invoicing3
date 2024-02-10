<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";

    export let client;
</script>

<ClientForm {client} readonly=true />
