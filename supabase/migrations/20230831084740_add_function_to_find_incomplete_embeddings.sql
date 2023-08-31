CREATE OR REPLACE FUNCTION public.find_parsed_documents_with_incomplete_embeddings(requested_doktyp text)
 RETURNS TABLE(id bigint, filename text, checksum text, meta jsonb, dokument_id bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        pd.*
    FROM
        parsed_documents pd
    WHERE
        pd.id IN (
            SELECT
                pd1.id
            FROM
                parsed_documents pd1
            LEFT JOIN parsed_document_sections pds ON pd1.id = pds.parsed_document_id
            WHERE
                pds.parsed_document_id IS NULL
            UNION
            SELECT
                pd2.id
            FROM
                parsed_documents pd2
            LEFT JOIN parsed_document_metadata pdm ON pd2.id = pdm.parsed_document_id
            WHERE
                pdm.parsed_document_id IS NULL
        );
END;
$function$
