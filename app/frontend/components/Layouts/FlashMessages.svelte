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
      alert_type = 'alert-alert'
      msg = flash.alert
    }

    if (flash.notice) {
      alert_type = 'alert-info'
      msg = flash.notice
    }

    if (flash.success) {
      alert_type = 'alert-success'
      msg = flash.success
    }
  }
</script>

{#if show}
  <div class="alert {alert_type}" role="alert">
    {msg}
  </div>
{/if}