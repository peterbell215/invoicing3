<script>
    export let form;
    export let type = "text";
    export let field;
    export let label_name;

    function typeAction(node) {
        node.type = type;
    }
</script>

<div class="form-outline mb-4">
    <label class="form-label" for="name">{label_name}</label>
    <input use:typeAction id="{field}"
           class="form-control {($form[field] != null) ? 'active' : ''}"
           bind:value={$form[field]} />
    {#if $form.errors[field]!==undefined}
        <div class="invalid-feedback">{$form.errors[field]}</div>
    {/if}
</div>

