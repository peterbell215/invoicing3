/**
 * Converts the string from the Rails backend into locale
 *
 * @param {string} date_string
 * @return {string}
 */
export function format_date(date_string) {
    return (date_string!=null) ? new Date(date_string).toLocaleDateString([], { dateStyle: "medium" }) : "N/A";
}

export function format_time(time_string) {
    const time_format = new Intl.DateTimeFormat(undefined, { dateStyle: "medium", timeStyle: "short" });
    return (time_string!=null) ? time_format.format(new Date(time_string)) : "N/A";
}

export function format_date_for_input_field(date) {
    const year = date.getFullYear().toFixed().padStart(4, "0");
    const _month = date.getMonth() + 1;
    const month = _month.toFixed().padStart(2, "0");
    const day = date.getDate().toFixed().padStart(2, "0");

    return `${year}-${month}-${day}`;
}