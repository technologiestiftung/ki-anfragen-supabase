set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.match_parsed_dokument_sections(embedding vector, match_threshold double precision, match_count integer, min_content_length integer)
 RETURNS TABLE(id bigint, parsed_document_id bigint, heading text, content text, similarity double precision)
 LANGUAGE plpgsql
AS $function$
	#variable_conflict use_variable
BEGIN
	RETURN query
	SELECT
		parsed_documents_section.id,
		parsed_documents_section.page_id,
		parsed_documents_section.heading,
		parsed_documents_section.content,
		(parsed_documents_section.embedding < #> embedding) * -1 as similarity
		FROM
			parsed_documents_section
			-- We only care about sections that have a useful amount of content
		WHERE
			length(parsed_documents_section.content) >= min_content_length
			-- The dot product is negative because of a Postgres limitation, so we negate it
			and(parsed_documents_section.embedding <#> embedding) * -1 > match_threshold
				-- OpenAI embeddings are normalized to length 1, so
				-- cosine similarity and dot product will produce the same results.
				-- Using dot product which can be computed slightly faster.
				--
				-- For the different syntaxes, see https://github.com/pgvector/pgvector
			ORDER BY
				parsed_documents_section.embedding <#> embedding
			LIMIT match_count;
END;
$function$
;


