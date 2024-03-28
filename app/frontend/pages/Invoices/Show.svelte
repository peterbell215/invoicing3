<script>
    import InvoiceForm from "~/pages/Invoices/InvoiceForm.svelte";

    export let invoice;
</script>

<InvoiceForm {invoice} readonly=true/>