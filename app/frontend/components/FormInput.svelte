<script>
    import {format_date_for_input_field} from "@/js/converters.js";

    export let form;
    export let type = "text";
    export let field;
    export let label_name = undefined;
    export let readonly = false;

    let value = (type !== "date") ? $form[field] : format_date_for_input_field($form[field])

    function typeAction(node) {
        node.type = type;
    }

    function nameAction(node) {
        node.name = field;
    }

    $: value, update_value_to_form()

    function update_value_to_form() {
        $form[field] = (type !== "date") ? value : new Date(value)
    }
</script>

<div class="form-outline mb-4" data-testid="{field}">
    {#if label_name!==undefined}
        <label class="form-label" for="{field}">{label_name}</label>
    {/if}

    <input use:typeAction use:nameAction id="{field}"
           class="form-control" class:is-invalid={$form.errors[field]!==undefined}
           bind:value={value}
           disabled = {readonly} />

    {#if $form.errors[field]!==undefined}
        <div class="invalid-feedback">{$form.errors[field]}</div>
    {/if}
</div>

