<script>
    import ClientForm from "~/pages/Clients/ClientForm.svelte";
    import FormInput from "@/components/FormInput.svelte";

    export let client;
</script>

<ClientForm client="{client}">
    <fieldset slot="form-elements" let:form class="form-group border p-3">
        <legend class="w-auto px-2">Fees</legend>
        <div class="row">
            <div class="col">
                <FormInput {form} field="current_rate" label_name="Current Hourly Charge" />
            </div>
            <div class="col">
                <FormInput {form} field="current_rate_since" label_name="From" value="Now" readonly="true" />
            </div>
        </div>
    </fieldset>
</ClientForm>
