CREATE OR REPLACE FUNCTION public.find_red_number_reports_with_missing_parsed_reports()
 RETURNS TABLE(id integer, doc_name text, doc_ref text, doc_size integer, red_number_report_id integer)
 LANGUAGE plpgsql
AS $function$
	#variable_conflict use_variable
BEGIN
	RETURN query

SELECT
	red_number_reports.*
FROM
	red_number_reports
	LEFT JOIN parsed_red_number_reports ON red_number_reports.id = parsed_red_number_reports.red_number_report_id
WHERE
	parsed_red_number_reports.red_number_report_id IS NULL;

END;
$function$