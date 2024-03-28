<script>
    import InvoiceForm from "~/pages/Invoices/InvoiceForm.svelte";

    export let client_id = undefined;
    export let clients = undefined;
    export let client_sessions = [];
</script>

<InvoiceForm {client_id} {clients} {client_sessions}/>