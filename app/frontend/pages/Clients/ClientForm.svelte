<script>
    import {Link, useForm} from '@inertiajs/svelte'
    import FormInput from "~/components/FormInput.svelte";
    import Dinero from "dinero.js";
    import {format_date} from "@/js/converters.js";

    export let client;
    export let readonly = false;

    let form = useForm({
        id: client?.id,
        name: client?.name,
        email: client?.email,
        address1: client?.address1,
        address2: client?.address2,
        town: client?.town,
        postcode: client?.postcode,
        current_rate: Dinero(client?.current_rate).toFormat('$0,0.00'),
        current_rate_since: format_date(client?.current_rate_since)
    });

    function submit() {
        if ($form.id === undefined) {
            $form.post('/clients', {
                onSuccess: () => {
                    $form.reset();
                }
            });
        } else {
            $form.put(`/clients/${$form.id}`, {
                onSuccess: () => {
                    $form.reset();
                }
            });
        }
    }

    function onBlur(event) {
        if (!form.postcode.match(/^[a-z]{1,2}\d[a-z\d]?\s*\d[a-z]{2}$/i)) {
            $form.errors.postcode = "Invalid Postcode"
        }
    }
</script>

<div class="mx-auto col-4 py-4">
    <div class="card mb-4">
        <div class="card-header py-3">
            <h5 class="mb-0">Client Details</h5>
        </div>
        <div class="card-body">
            <Link href="/clients/" class="btn btn-primary">Back</Link>
            <slot name="navigation-elements" />

            <form on:submit|preventDefault={submit} class='needs-validation' inert="{readonly}" novalidate >
                <FormInput {form} field="name" label_name="Name"/>
                <FormInput {form} field="email" type="email" label_name="Email"/>
                <FormInput {form} field="address1" label_name="Address Line 1"/>
                <FormInput {form} field="address2" label_name="Address Line 2"/>

                <div class="row">
                    <div class="col">
                        <FormInput {form} field="town" label_name="Town"/>
                    </div>
                    <div class="col">
                        <FormInput {form} field="postcode" label_name="Postcode" on:blur={onBlur}/>
                    </div>
                </div>

                <slot name="form-elements" {form} />

                {#if !readonly}
                    {#if $form.errors.title}
                        <div class="form-error">{$form.errors.title}</div>
                    {/if}
                    {#if $form.errors.body}
                        <div class="form-error">{$form.errors.body}</div>
                    {/if}
                    <button type="submit" class="btn btn-primary btn-block" disabled={$form.processing}>Submit</button>
                {/if}
            </form>
        </div>
    </div>
</div>

