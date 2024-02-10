<script>
  import { useForm } from '@inertiajs/svelte'
  import ClientForm from "~/pages/Clients/ClientForm.svelte";

  export let client;
</script>

<ClientForm {client}/>
