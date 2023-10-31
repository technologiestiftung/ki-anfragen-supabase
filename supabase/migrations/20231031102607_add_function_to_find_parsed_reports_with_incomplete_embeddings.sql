CREATE OR REPLACE FUNCTION public.find_parsed_reports_with_incomplete_embeddings(requested_doktyp text)
 RETURNS TABLE(id int, checksum text, meta jsonb, red_number_report_id int)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        pr.*
    FROM
        parsed_red_number_reports pr
    WHERE
        pr.id IN (
            SELECT
                pr1.id
            FROM
                parsed_red_number_reports pr1
            LEFT JOIN parsed_red_number_report_sections prs ON pr1.id = prs.parsed_red_number_report_id
            WHERE
                prs.parsed_red_number_report_id IS NULL
        );
END;
$function$
