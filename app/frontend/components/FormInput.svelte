<script>
    export let form;
    export let type = "text";
    export let field;
    export let label_name;
    export let disabled = false;

    function typeAction(node) {
        node.type = type;
    }

    function nameAction(node) {
        node.name = field;
    }
</script>

<div class="form-outline mb-4" data-testid="{field}">
    <label class="form-label" for="name">{label_name}</label>
    <input use:typeAction use:nameAction id="{field}"
           class="form-control" class:is-invalid={$form.errors[field]!==undefined}
           bind:value={$form[field]}
           disabled = {disabled} />
    {#if $form.errors[field]!==undefined}
        <div class="invalid-feedback">{$form.errors[field]}</div>
    {/if}
</div>

