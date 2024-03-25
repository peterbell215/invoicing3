<script>
    import {router, Link, useForm} from '@inertiajs/svelte';
    import axios from 'axios';

    import Dinero from "dinero.js";
    import FormInput from "@/components/FormInput.svelte";

    export let invoice;
    export let client_id;
    export let clients;
    export let readonly = false;
    export let client_sessions = [];

    let client_session_ids = [];
    let all_checked = false;

    let form = useForm({
        id: invoice?.id,
        date: new Date(invoice?.date),
        client_id: client_id,
        amount: Dinero(invoice?.amount)
    });

    function change_client() {
        router.get(window.location.href, { client_id: client_id }, { only: ["client_sessions"] } );
    }

    $: all_checked, select_all_or_none_client_sessions();
    $: client_session_ids, update_client_sessions();

    function select_all_or_none_client_sessions() {
        client_session_ids = [];

        if (all_checked) {
            client_sessions.forEach( (client_session) => client_session_ids.push(client_session.id));
        }
    }

    function update_client_sessions() {
        all_checked = (client_session_ids.length===client_sessions.length);

        $form['amount'] =
            client_sessions.reduce( (amount, client_session) => {
                return (client_session_ids.includes(client_session.id)) ? amount.add(Dinero(client_session.current_rate)) : amount;
            }, Dinero({amount: 0, currency: 'GBP'}));
    }

    function submit() {
       if ($form.id === undefined) {
            $form.transform((data) => {
                data['client_id'] = client_id;
                data['client_session_ids'] = client_session_ids;
                return { invoice: data };
            }).post('/invoices', {
                onSuccess: () => {
                    $form.reset();
                }
            });
        } else {

        }
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
                    <thead>
                        <tr>
                            <th>
                                <input type="checkbox" id="select_all_client_sessions" bind:checked={all_checked}/>
                                Select All
                            </th>
                            <th>Date</th>
                            <th>Duration</th>
                            <th>Hourly Rate</th>
                        </tr>
                    </thead>

                    <tbody>
                        {#each client_sessions as client_session}
                            <tr>
                                <td>
                                    <input type="checkbox" value="{client_session.id}" bind:group={client_session_ids} />
                                </td>
                                <td>{new Date(Date.parse(client_session.start)).toLocaleString()}</td>
                                <td>{client_session.duration}</td>
                                <td>{Dinero(client_session.current_rate).toFormat('$0,0.00')}</td>
                            </tr>
                        {/each}
                        <tr>
                            <td colspan="3">Total Amount</td>
                            <td>{$form['amount'].toFormat('$0,0.00')}</td>
                         </tr>
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
