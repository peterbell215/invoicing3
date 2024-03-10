/**
 * Converts the string from the Rails backend into locale
 *
 * @param {string} date_string
 * @return {string}
 */
export function format_date(date_string) {
    return (date_string!=null) ? new Date(date_string).toLocaleDateString(undefined, { dateStyle: "medium" }) : "N/A";
}

export function format_date_for_input_field(date) {
    const year = date.getFullYear().toFixed().padStart(4, "0");
    const month = date.getMonth().toFixed().padStart(2, "0");
    const day = date.getDay().toFixed().padStart(2, "0");

    return `${year}-${month}-${day}`;
}