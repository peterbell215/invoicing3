<script>
    import { useForm } from '@inertiajs/svelte'
    import ClientForm from "~/pages/Client/ClientForm.svelte";

    let form = useForm({
        name: null,
        email: null,
        address1: null,
        address2: null,
        town: null,
        postcode: null
    })

</script>

<ClientForm form="{form}" />
