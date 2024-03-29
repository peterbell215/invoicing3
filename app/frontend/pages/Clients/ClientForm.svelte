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
        current_rate: Dinero( (client!==undefined) ? client.current_rate : {amount: 6000, currency: "GBP"} ),
        current_rate_since: (client!==undefined) ? format_date(client.current_rate_since) : 'Now'
    });

    function submit() {
        if ($form.id === undefined) {
            $form.post('/clients', {
                onSuccess: () => {
                    $form.reset();
                }
            });
        } else {
            $form.transform((data) => {
                delete data.client;
                // if we are doing editing, then we don't need the current_rate, but instead need to deal with
                // a new_rate if entered.
                delete data.current_rate;
                delete data.current_rate_since;
                data['new_rate'] = $form['new_rate'];
                data['new_rate_from'] = $form['new_rate_from'];
                return { client: data };
            }).put(`/clients/${$form.id}`, {
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
                <FormInput {form} field="name" label_name="Name" {readonly}/>
                <FormInput {form} field="email" type="email" label_name="Email" {readonly}/>
                <FormInput {form} field="address1" label_name="Address Line 1" {readonly}/>
                <FormInput {form} field="address2" label_name="Address Line 2" {readonly}/>

                <div class="row">
                    <div class="col">
                        <FormInput {form} field="town" label_name="Town" {readonly}/>
                    </div>
                    <div class="col">
                        <FormInput {form} field="postcode" label_name="Postcode" {readonly} on:blur={onBlur}/>
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

