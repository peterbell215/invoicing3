<script>
    import {Link, useForm} from '@inertiajs/svelte'
    import FormInput from "~/components/FormInput.svelte";
    import Dinero from "dinero.js";
    import {format_date} from "@/js/converters.js";

    export let meeting;
    export let clients;
    export let readonly = false;

    let form = useForm({
        id: meeting?.id,
        start_date: meeting?.start,
        start_time: meeting?.start_time,
        duration: meeting?.duration,
        client_id: meeting?.client_id,
        current_rate: calculate_current_rate()
    });

    function submit() {
        if ($form.id === undefined) {
            $form.transform((data) => {
                delete data.meeting;
                data.current_rate = Dinero( { amount: parseInt($form.current_rate), currency: "GBP" } );
                data.start = `${data.start_date}T${data.start_time} ${new Date().getTimezoneOffset()}`
                delete data.start_date;
                delete data.start_time;
                return { meeting: data };
            }).post('/meetings', {
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
        if ((meeting?.current_rate !== undefined)) {
            return Dinero(meeting.current_rate).toUnit();
        } else if (meeting?.client_id !== undefined) {
            let current_rate = clients.find((client) => { (meeting.client_id===client.id) } );
            return Dinero(current_rate).toUnit();
        } else {
            return 60.00
        }
    }

    function start_times() {
        let times = Array((21-6)*4).fill(0)
        let h, m, i;

        for(h=6, i=0; h<=21; h++) {
            for(m=0; m<60; m+=15, i++) {
                times[i] = `${h.toString().padStart(2, 0)}:${m.toString().padStart(2, 0)}`
            }
        }

        return times;
    }
</script>

<div class="mx-auto col-4 py-4">
    <div class="card mb-4">
        <div class="card-header py-3">
            <h5 class="mb-0">Meeting Details</h5>
        </div>
        <div class="card-body">
            <Link href="/meetings/" class="btn btn-primary">Back</Link>
            <slot name="navigation-elements" />

            <form on:submit|preventDefault={submit} class='needs-validation' inert="{readonly}" novalidate >
                <label for="client_id">Client</label>
                <select name="client_id" class="form-select" bind:value={$form['client_id']}>
                    {#each clients as client}
                        <option value={client.id}>
                            {client.name}
                        </option>
                    {/each}
                </select>

                <fieldset class="form-group border p-3">
                    <legend class="w-auto px-2">Date & Time</legend>
                    <div class="row">
                        <div class="col">
                            <label for="client_id">Client</label>
                        </div>
                        <div class="col">
                            <label for="client_id">Start Time</label>
                        </div>
                        <div class="col">
                            <label for="duration">Duration</label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col">
                            <FormInput {form} field="start_date" type="date"/>
                        </div>
                        <div class="col">
                            <select id="start_time" name="start_time" class="form-select" bind:value={$form['start_time']}>
                                {#each start_times() as start_time}
                                    <option value={start_time}>{start_time}</option>
                                {/each}
                            </select>
                        </div>
                        <div class="col">
                            <input type="number" id="duration"
                                   class="form-control"
                                   min="0" max="120" step="15" default="60"
                                   bind:value={$form['duration']}
                                   disabled = {readonly} />
                        </div>
                    </div>
                </fieldset>

                <div class="row">
                    <div class="col">
                        <FormInput {form} field="current_rate" type="number" label_name="Meeting Rate"/>
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

