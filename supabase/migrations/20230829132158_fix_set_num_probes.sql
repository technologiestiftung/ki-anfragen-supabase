CREATE OR REPLACE FUNCTION public.match_parsed_dokument_sections(embedding vector, match_threshold double precision, match_count integer, min_content_length integer, num_probes integer)
 RETURNS TABLE(id bigint, parsed_document_id bigint, heading text, content text, similarity double precision)
 LANGUAGE plpgsql
AS $function$
	#variable_conflict use_variable
BEGIN
	EXECUTE format('SET LOCAL ivfflat.probes = %s', num_probes);
	RETURN query
	SELECT
		parsed_document_sections.id,
		parsed_document_sections.parsed_document_id,
		parsed_document_sections.heading,
		parsed_document_sections.content,
		(parsed_document_sections.embedding <#> embedding) * -1 as similarity
		FROM
			parsed_document_sections
			-- We only care about sections that have a useful amount of content
		WHERE
			length(parsed_document_sections.content) >= min_content_length
			-- The dot product is negative because of a Postgres limitation, so we negate it
			and(parsed_document_sections.embedding <#> embedding) * -1 > match_threshold
				-- OpenAI embeddings are normalized to length 1, so
				-- cosine similarity and dot product will produce the same results.
				-- Using dot product which can be computed slightly faster.
				--
				-- For the different syntaxes, see https://github.com/pgvector/pgvector
			ORDER BY
				parsed_document_sections.embedding <#> embedding
			LIMIT match_count;
END;
$function$