/**
 * Converts the string from the Rails backend into locale
 *
 * @param {string} date_string
 * @return {string}
 */
export function format_date(date_string) {
    return new Date(date_string)?.toLocaleDateString(undefined, { dateStyle: "medium"}) || "";
}
