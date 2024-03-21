<script>
    import {router, Link, useForm} from '@inertiajs/svelte';
    import axios from 'axios';

    import CurrencyFormInput from "@/components/CurrencyFormInput.svelte";
    import Dinero from "dinero.js";
    import FormInput from "@/components/FormInput.svelte";

    export let invoice;
    export let client_id;
    export let clients;
    export let readonly = false;

    export let client_sessions = [];

    let form = useForm({
        id: invoice?.id,
        date: new Date(invoice?.date),
        client_id: client_id,
    });

    function change_client() {
        router.get(window.location.href, { client_id: client_id }, { only: ["client_sessions"] } );
        // axios.get('/client_sessions', { params: { client_id: $form["client_id"] } } )
        //    .then(response => console.log(response));
    }
    function submit() {
/*        if ($form.id === undefined) {
            $form.transform((data) => {
                delete data.client_session;
                return { client_session: data };
            }).post('/client_sessions', {
                onSuccess: () => {
                    $form.reset();
                }
            });
        } else {
            $form.transform((data) => {
                delete data.client_session;
                return { client_session: data };
            }).put(`/client_sessions/${$form.id}`, {
                onSuccess: () => {
                    $form.reset();
                }
            });
        }*/
    }

    function calculate_amount() {
/*        if ((client_session?.current_rate !== undefined)) {
            return Dinero(client_session.current_rate);
        } else if (client_session?.client_id !== undefined) {
            let current_rate = clients.find((client) => { (client_session.client_id===client.id) } ).current_rate;
            return Dinero(current_rate);
        } else {
            return Dinero(default_current_rate);
        }*/
    }
</script>

<div class="mx-auto col-4 py-4">
    <div class="card mb-4">
        <div class="card-header py-3">
            <h3 class="mb-0">Invoice Details</h3>
        </div>
        <div class="card-body">
            <Link href="/client_sessions/" class="btn btn-primary">Back</Link>
            <slot name="navigation-elements" />

            <form on:submit|preventDefault={submit} class='needs-validation' inert="{readonly}" novalidate >

                <label for="client_id">Client</label>
                <select name="client_id" class="form-select" bind:value={client_id} on:change={change_client}>
                    <option disabled selected value> -- select an option -- </option>
                    {#each clients as client}
                        <option value={client.id}>
                            {client.name}
                        </option>
                    {/each}
                </select>


                <div class="row">
                    <div class="col">
                        <FormInput {form} type="date" field="date" label_name="Invoice Date" />
                    </div>
                </div>

                <table class="table table-striped">
                    <tbody>
                        {#each client_sessions as client_session}
                            <tr>
                                <td>{new Date(Date.parse(client_session.start)).toLocaleString()}</td>
                                <td>{client_session.duration}</td>
                                <td>{Dinero(client_session.current_rate).toFormat('$0,0.00')}</td>
                            </tr>
                        {/each}
                    </tbody>


                </table>

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
