<svelte:head>
  <title>Login</title>
</svelte:head>

<script>
  import { useForm } from '@inertiajs/svelte'

  let form = useForm({
    user: {
      email: null,
      password: null,
      remember: false,
    }
  })

  function submit() {
    $form.post('/login')
  }
</script>

<div class="container d-flex mt-5">
  <div class="col-3 mx-auto text-center border">
    <form on:submit|preventDefault={submit}>
      <!-- Email input -->
      <div class="form-outline mb-4">
        <input type="email" id="email" class="form-control" bind:value={$form.user.email} />
        <label class="form-label" for="email">Email address</label>
      </div>
      {#if $form.errors.email}
        <div class="form-error">{$form.errors.email}</div>
      {/if}

      <!-- Password input -->
      <div class="form-outline mb-4">
        <input type="password" id="password" class="form-control" bind:value={$form.user.password}/>
        <label class="form-label" for="password">Password</label>
      </div>
      {#if $form.errors.password}
        <div class="form-error">{$form.errors.password}</div>
      {/if}

      <!-- 2 column grid layout for inline styling -->
      <div class="row mb-4">
        <div class="col d-flex justify-content-center">
          <!-- Checkbox -->
          <div class="form-check">
            <input class="form-check-input" type="checkbox" bind:checked={$form.user.remember} value="" id="rememberMe" />
            <label class="form-check-label" for="rememberMe">Remember me </label>
          </div>
        </div>

        <div class="col">
          <!-- Simple link -->
          <a href="#!">Forgot password?</a>
        </div>
      </div>

      <button type="submit" class="btn btn-primary btn-block" disabled={$form.processing}>Sign in</button>
    </form>
  </div>
</div>
