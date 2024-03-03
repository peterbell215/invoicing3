<script>
  import ClientForm from "~/pages/Clients/ClientForm.svelte";
  import FormInput from "@/components/FormInput.svelte";

  export let client;
</script>

<ClientForm {client}>
    <svelte:fragment slot="form-elements" let:form >
        <input type="hidden" name="id" bind:value={client.id} />
        <fieldset class="form-group border p-3">
            <legend class="w-auto px-2">Fees</legend>
            <div class="row">
                <div class="col">
                    <FormInput {form} field="current_rate" label_name="Current Hourly Fee" readonly=true />
                </div>
                <div class="col"></div>
            </div>
            <div class="row">
                <div class="col">
                    <FormInput {form} type="date" field="new_rate_from" label_name="New Hourly Fee From" />
                </div>
                <div class="col">
                    <FormInput {form} type="number" field="new_rate" label_name="New Hourly Fee"/>
                </div>
            </div>
        </fieldset>
    </svelte:fragment>
</ClientForm>
