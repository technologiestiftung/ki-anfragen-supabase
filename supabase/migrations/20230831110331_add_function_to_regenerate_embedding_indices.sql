CREATE OR REPLACE FUNCTION public.regenerate_embedding_indices()
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN

DO $$
DECLARE
    numRows INT;
BEGIN
    SELECT ROUND(COUNT(*) / 1000) INTO numRows FROM parsed_document_sections;
    EXECUTE 'CREATE INDEX ON parsed_document_sections USING ivfflat (embedding vector_l2_ops) WITH (lists = ' || numRows || ')';
	EXECUTE 'CREATE INDEX ON parsed_document_sections USING ivfflat (embedding vector_ip_ops) WITH (lists = ' || numRows || ')';
	EXECUTE 'CREATE INDEX ON parsed_document_sections USING ivfflat (embedding vector_cosine_ops) WITH (lists = ' || numRows || ')';
END $$;

END;
$function$
