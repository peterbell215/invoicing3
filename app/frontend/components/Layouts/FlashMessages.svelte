<script>
  import { page } from '@inertiajs/svelte'

  // list color classes to prevent purge by Tailwind
  // bg-red-50
  // text-red-400
  // text-red-800
  // bg-blue-50
  // text-blue-400
  // text-blue-800
  // bg-green-50
  // text-green-400
  // text-green-800

  let alert_type = 'alert-success'

  $: flash = $page.props.flash
  $: show = $page.props.has_flash

  let msg = ''

  $: if (show) {
    if (flash.alert) {
      alert_type = 'alert'
      msg = flash.alert
    }

    if (flash.notice) {
      alert_type = 'info'
      msg = flash.notice
    }
  }
</script>

<svg xmlns="http://www.w3.org/2000/svg" style="display: none;">
  <symbol id="info-fill" fill="currentColor" viewBox="0 0 16 16">
    <path d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412-1 4.705c-.07.34.029.533.304.533.194 0 .487-.07.686-.246l-.088.416c-.287.346-.92.598-1.465.598-.703 0-1.002-.422-.808-1.319l.738-3.468c.064-.293.006-.399-.287-.47l-.451-.081.082-.381 2.29-.287zM8 5.5a1 1 0 1 1 0-2 1 1 0 0 1 0 2z"/>
  </symbol>
  <symbol id="alert-fill" fill="currentColor" viewBox="0 0 16 16">
    <path d="M8.982 1.566a1.13 1.13 0 0 0-1.96 0L.165 13.233c-.457.778.091 1.767.98 1.767h13.713c.889 0 1.438-.99.98-1.767L8.982 1.566zM8 5c.535 0 .954.462.9.995l-.35 3.507a.552.552 0 0 1-1.1 0L7.1 5.995A.905.905 0 0 1 8 5zm.002 6a1 1 0 1 1 0 2 1 1 0 0 1 0-2z"/>
  </symbol>
</svg>

{#if show}
  <div class="alert alert-dismissible alert-{alert_type}" role="alert">
    <svg class="bi flex-shrink-0 me-2" width="24" height="24" role="img" aria-label="Success:"><use xlink:href="#{alert_type}-fill"/></svg>
    {msg}
    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
  </div>
{/if}