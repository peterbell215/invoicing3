<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";
    import {Link} from "@inertiajs/svelte";
    import FormInput from "@/components/FormInput.svelte";

    export let client;
</script>

<ClientForm {client} readonly=true>
    <svelte:fragment slot="navigation-elements">
        <Link href="/clients/{client.id}/edit" class="btn btn-primary">Edit</Link>
        <Link href="/clients/{client.id}/prices" class="btn btn-primary">Price History</Link>
    </svelte:fragment>

    <fieldset slot="form-elements" let:form class="form-group border p-3">
        {@debug form}

        <legend class="w-auto px-2">Pricing</legend>
        <div class="row">
            <div class="col">
                <FormInput {form} field="current_rate_as_dinero" label_name="Current Hourly Charge"/>
            </div>
            <div class="col">
                <FormInput {form} field="current_price_since" label_name="Since"/>
            </div>
        </div>
    </fieldset>
</ClientForm>
