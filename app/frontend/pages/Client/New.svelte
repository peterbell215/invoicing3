<script>
  import { useForm } from '@inertiajs/svelte'

  let form = useForm({
    name: null,
    address1: null,
    address2: null,
    town: null,
    postcode: null
  })

  function submit() {
    $form.post('/clients')
  }
</script>

<form on:submit|preventDefault={submit}>
  <label />
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