<script>
  import { useForm } from '@inertiajs/svelte'
  import FormInput from "~/components/FormInput.svelte";

  let form = useForm({
    name: null,
    email: null,
    address1: null,
    address2: null,
    town: null,
    postcode: null
  })

  function submit() {
    $form.post('/clients')
  }

  function onBlur(event) {
    if (!form.postcode.match(/^[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}$/i)) {
      $form.errors.postcode = "Invalid Postcode"
    }
  }
</script>

<div class="row">
  <div class="col-md-8 mb-4">
    <div class="card mb-4">
      <div class="card-header py-3">
        <h5 class="mb-0">Billing Details</h5>
      </div>
      <div class="card-body">
        <form on:submit|preventDefault={submit}>

          <!-- Email input -->
          <FormInput {form} field="name" label_name="Name"/>
          <FormInput {form} field="email" type="email" label_name="Email"/>
          <FormInput {form} field="address1" label_name="Address Line 1"/>
          <FormInput {form} field="address2" label_name="Address Line 2"/>

          <div class="row mb-4">
            <div class="col">
              <FormInput {form} field="town" label_name="Town"/>
            </div>
            <div class="col">
              <FormInput {form} field="postcode" label_name="Postcode" on:blur={onBlur}/>
            </div>
          </div>


          {#if $form.errors.title}
            <div class="form-error">{$form.errors.title}</div>
          {/if}
          {#if $form.errors.body}
            <div class="form-error">{$form.errors.body}</div>
          {/if}
          <button type="submit" class="btn btn-primary btn-block" disabled={$form.processing}>Submit</button>
        </form>
      </div>
    </div>
  </div>
</div>