<script>
    export let form;
    export let type = "text";
    export let field;
    export let label_name = undefined;
    export let readonly = false;

    function typeAction(node) {
        node.type = type;
    }

    function nameAction(node) {
        node.name = field;
    }
</script>

<div class="form-outline mb-4" data-testid="{field}">
    {#if label_name!==undefined}
        <label class="form-label" for="{field}">{label_name}</label>
    {/if}

    <input use:typeAction use:nameAction id="{field}"
           class="form-control" class:is-invalid={$form.errors[field]!==undefined}
           bind:value={$form[field]}
           disabled = {readonly} />
    {#if $form.errors[field]!==undefined}
        <div class="invalid-feedback">{$form.errors[field]}</div>
    {/if}
</div>

