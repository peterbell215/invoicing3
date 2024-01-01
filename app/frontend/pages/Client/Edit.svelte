<script>
  import { useForm } from '@inertiajs/svelte'

  export let client

  let form = useForm({
    name: client.name,
    address1: client.address1,
    address2: client.address2,
    town: client.town,
    postcode: client.postcode
  })

  function submit() {
    $form.post('/clients')
  }
</script>

<form on:submit|preventDefault={submit}>
  <input type="text" bind:value={$form.name} />
  <input type="text" bind:value={$form.address1} />
  <input type="text" bind:value={$form.address2} />
  <input type="text" bind:value={$form.town} />,
  <input type="text" bind:value={$form.postcode} />,
  <input type="text" bind:value={$form.title} />
  {#if $form.errors.title}
    <div class="form-error">{$form.errors.title}</div>
  {/if}
  {#if $form.errors.body}
    <div class="form-error">{$form.errors.body}</div>
  {/if}
  <button type="submit" disabled={$form.processing}>Submit</button>
</form>