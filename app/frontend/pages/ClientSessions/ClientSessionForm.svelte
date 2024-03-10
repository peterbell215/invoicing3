<script>
    import {Link, useForm} from '@inertiajs/svelte'
    import CurrencyFormInput from "@/components/CurrencyFormInput.svelte";
    import Dinero from "dinero.js";
    import DateTimeInput from "@/components/DateTimeInput.svelte";
    import FormInput from "@/components/FormInput.svelte";

    export let client_session;
    export let client = undefined;
    export let clients = undefined;
    export let readonly = false;

    let form = useForm({
        id: client_session?.id,
        start: new Date(client_session?.start),
        duration: client_session?.duration,
        client_id: client_session?.client_id,
        current_rate: calculate_current_rate()
    });

    function submit() {
        if ($form.id === undefined) {
            $form.transform((data) => {
                delete data.client_session;
                // data.current_rate = Dinero( { amount: parseInt($form.current_rate), currency: "GBP" } );
                data.start = `${data.start_date}T${data.start_time} ${new Date().getTimezoneOffset()}`
                delete data.start_date;
                delete data.start_time;
                return { client_session: data };
            }).post('/client_sessions', {
                onSuccess: () => {
                    $form.reset();
                }
            });
        } else {
/*
            $form.transform((data) => {
                delete data.client;
                delete data.current_rate;
                delete data.current_rate_since;
                if ($form.new_rate !== undefined) {
                    data.new_rate = Dinero( { amount: parseInt($form.new_rate), currency: "GBP" } );
                }
                if ($form.new_rate_from !== undefined) {
                    // Note, that using $form.new_rate_from gets the old default value.
                    data.new_rate_from = document.getElementById('new_rate_from').value // $form.new_rate_from.value;
                }
                return { client: data };
            }).put(`/clients/${$form.id}`, {
                onSuccess: () => {
                    $form.reset();
                }
            });
 */
        }
    }

    function calculate_current_rate() {
        if ((client_session?.current_rate !== undefined)) {
            return Dinero(client_session.current_rate);
        } else if (client_session?.client_id !== undefined) {
            let current_rate = clients.find((client) => { (client_session.client_id===client.id) } ).current_rate;
            return Dinero(current_rate);
        } else {
            return Dinero({amount: 50.00});
        }
    }

    console.log($form['start']);
</script>

<div class="mx-auto col-4 py-4">
    <div class="card mb-4">
        <div class="card-header py-3">
            <h3 class="mb-0">Client Session Details</h3>
        </div>
        <div class="card-body">
            <Link href="/client_sessions/" class="btn btn-primary">Back</Link>
            <slot name="navigation-elements" />

            <form on:submit|preventDefault={submit} class='needs-validation' inert="{readonly}" novalidate >
                {#if clients!==undefined}
                    <label for="client_id">Client</label>
                    <select name="client_id" class="form-select" bind:value={$form['client_id']}>
                        {#each clients as client}
                            <option value={client.id}>
                                {client.name}
                            </option>
                        {/each}
                    </select>
                {:else}
                    <div class="form-outline mb-4">
                        <label class="form-label" for="client_name">Client</label>
                        <input id="client_name" class="form-control" value={client.name} disabled="{readonly}"/>
                        <input type="hidden" name="client_id" bind:value={$form['client_id']} {readonly} />
                    </div>
                {/if}

                <fieldset class="form-group border p-3">
                    <legend class="w-auto px-2">Date & Time</legend>
                    <div class="row">
                        <DateTimeInput {form} field="start" time_label_name="Start Time" date_label_name="Start Date" {readonly}/>
                        <div class="col">
                            <FormInput {form} field="duration" type="number" label_name="Duration" {readonly}/>
                        </div>
                    </div>
                </fieldset>

                <div class="row">
                    <div class="col col-3">
                        <CurrencyFormInput {form} field="current_rate" label_name="Client session fee" {readonly}/>
                    </div>
                </div>

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
