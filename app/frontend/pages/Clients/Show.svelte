<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";
    import {Link} from "@inertiajs/svelte";
    import FormInput from "@/components/FormInput.svelte";

    export let client;
</script>

<ClientForm {client} readonly=true>
    <svelte:fragment slot="navigation-elements">
        <Link href="/clients/{client.id}/edit" class="btn btn-primary">Edit</Link>
        <Link href="/clients/{client.id}/fees" class="btn btn-primary">Fee History</Link>
        <Link href="/client_sessions" data={ {client_id: client.id} } class="btn btn-primary">Client Sessions</Link>
    </svelte:fragment>

    <fieldset slot="form-elements" let:form class="form-group border p-3">
        <legend class="w-auto px-2">Fees</legend>
        <div class="row">
            <div class="col">
                <FormInput {form} field="current_rate" label_name="Current Hourly Charge" readonly="true"/>
            </div>
            <div class="col">
                <FormInput {form} field="current_rate_since" label_name="Since" readonly="true"/>
            </div>
        </div>
    </fieldset>
</ClientForm>
