CREATE OR REPLACE FUNCTION public.find_dokuments_with_missing_embeddings(requested_doktyp text)
 RETURNS TABLE(id integer, reihnr text, dherk text, dherkl text, wp text, dokart text, dokartl text, doktyp text, doktypl text, nrintyp text, desk text, titel text, doknr text, dokdat text, lokurl text, sb text, vkdat text, hnr text, jg text, abstract text, urheber text, vorgang_id integer)
 LANGUAGE plpgsql
AS $function$
	#variable_conflict use_variable
BEGIN
	RETURN query

SELECT
	dokument.*
FROM
	dokument
	LEFT JOIN parsed_documents ON dokument.id = parsed_documents.dokument_id
WHERE
	dokument.doktyp = requested_doktyp AND
	parsed_documents.dokument_id IS NULL;

END;
$function$