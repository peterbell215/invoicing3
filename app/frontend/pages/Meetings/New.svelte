<script>
    import { useForm } from '@inertiajs/svelte'
    import MeetingForm from "~/pages/Meetings/MeetingForm.svelte";
    import FormInput from "@/components/FormInput.svelte";

    export let clients;
    export let meeting;
</script>

<MeetingForm {meeting} {clients}>
    <fieldset slot="form-elements" let:form class="form-group border p-3">
        <legend class="w-auto px-2">Fees</legend>
        <div class="row">
            <div class="col">
                <FormInput {form} field="current_rate" label_name="Current Hourly Charge" />
            </div>
        </div>
    </fieldset>
</MeetingForm>
