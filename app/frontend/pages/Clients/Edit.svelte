<script>
  import { useForm } from '@inertiajs/svelte'
  import ClientForm from "~/pages/Clients/ClientForm.svelte";

  export let client;
</script>

<ClientForm {client}>
    <input slot="form-elements" type="hidden" name="id" bind:value={client.id} />
</ClientForm>
