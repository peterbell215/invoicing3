<script>
    import Dinero from "dinero.js";
    import getSymbolFromCurrency from 'currency-symbol-map';

    export let form;
    export let field;
    export let label_name = undefined;
    export let readonly = false;

    function nameAction(node) {
        node.name = field;
    }

    // Extract the actual value from the Dinero object.
    let amount = $form[field]?.toUnit();
    let currency = $form[field]?.getCurrency() || 'GBP';

    function updateForm() {
        $form[field] = (amount !== undefined) ? Dinero({ amount: Number(amount * 100), currency: currency}) : undefined;
    }
    $: amount, updateForm();
</script>

<div class="form-outline mb-4" data-testid="{field}">
    {#if label_name!==undefined}
        <label class="form-label" for="{field}">{label_name}</label>
    {/if}

    <div class="input-group mb-3">
        <span class="input-group-text" id="currency-symbol">{getSymbolFromCurrency(currency)}</span>

        {#if !readonly}
            <input use:nameAction id="{field}"
                   class="form-control" class:is-invalid={$form.errors[field]!==undefined}
                   type="number" bind:value={amount} />
        {:else}
            <input use:nameAction id="{field}" class="form-control" value="{amount}" disabled />
        {/if}
    </div>
</div>