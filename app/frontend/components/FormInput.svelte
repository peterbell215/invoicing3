<script>
    export let form;
    export let type = "text";
    export let field;
    export let label_name;

    function typeAction(node) {
        node.type = type;
    }
</script>

<div data-mdb-input-init class="form-outline mb-4">
    <input use:typeAction id="{field}"
           class="form-control {($form[field] != null) ? 'active' : ''}"
           bind:value={$form[field]} />
    <label class="form-label" for="name">{label_name}</label>
</div>