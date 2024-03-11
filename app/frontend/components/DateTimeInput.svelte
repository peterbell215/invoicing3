<script>
    import FormInput from "@/components/FormInput.svelte";
    import {format_date_for_input_field} from "@/js/converters.js";

    export let form;
    export let field;
    export let date_label_name = undefined;
    export let time_label_name = undefined;
    export let readonly = false;

    function nameAction(node) {
        node.name = field;
    }

    let date_field = format_date_for_input_field($form[field]);
    let time_field = $form[field].toLocaleTimeString(undefined, { timeStyle: "short" });
    let date_field_name = `${field}-date`;
    let time_field_name = `${field}-time`;

    function updateForm() {
        $form[field] = `${date_field}T${time_field} ${new Date().getTimezoneOffset()}`;
    }

    $: date_field, updateForm();
    $: time_field, updateForm();

    function times() {
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

<div class="col">
    <div class="form-outline mb-4" data-testid={`${field}_date`}>
        {#if date_label_name!==undefined}
            <label class="form-label" for="{date_field_name}">{date_label_name}</label>
        {/if}

        <input id="{date_field_name}"
               class="form-control" class:is-invalid={$form.errors[field]!==undefined} type="date"
               bind:value={date_field} disabled = {readonly} />
        {#if $form.errors[field]!==undefined}
            <div class="invalid-feedback">{$form.errors[field]}</div>
        {/if}
    </div>
</div>

<div class="col">
    <div class="form-outline mb-4" data-testid="{field}">
        {#if time_label_name!==undefined}
            <label class="form-label" for="{field}">{time_label_name}</label>
        {/if}

        {#if !readonly}
            <select id="{time_field_name}" name="{time_field_name}" class="form-select" bind:value="{time_field}">
                {#each times() as time}
                    <option value={time} selected={time===time_field}>{time}</option>
                {/each}
            </select>
        {:else}
            <input id="{time_field_name}" class="form-control" value={time_field} disabled/>
        {/if}
        {#if $form.errors[field]!==undefined}
            <div class="invalid-feedback">{$form.errors[field]}</div>
        {/if}
    </div>
</div>
