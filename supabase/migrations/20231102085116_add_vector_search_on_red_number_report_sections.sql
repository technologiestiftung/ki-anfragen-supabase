CREATE OR REPLACE FUNCTION public.match_parsed_red_number_report_sections(embedding vector, match_threshold double precision, match_count integer, min_content_length integer, num_probes integer)
 RETURNS TABLE(id integer, parsed_red_number_report_id integer, heading text, content text, similarity double precision)
 LANGUAGE plpgsql
AS $function$
	#variable_conflict use_variable
BEGIN
	EXECUTE format('SET LOCAL ivfflat.probes = %s', num_probes);
	RETURN query
	SELECT
		parsed_red_number_report_sections.id,
		parsed_red_number_report_sections.parsed_red_number_report_id,
		parsed_red_number_report_sections.heading,
		parsed_red_number_report_sections.content,
		(parsed_red_number_report_sections.embedding <#> embedding) * -1 as similarity
		FROM
			parsed_red_number_report_sections
			-- We only care about sections that have a useful amount of content
		WHERE
			length(parsed_red_number_report_sections.content) >= min_content_length
			-- The dot product is negative because of a Postgres limitation, so we negate it
			and(parsed_red_number_report_sections.embedding <#> embedding) * -1 > match_threshold
				-- OpenAI embeddings are normalized to length 1, so
				-- cosine similarity and dot product will produce the same results.
				-- Using dot product which can be computed slightly faster.
				--
				-- For the different syntaxes, see https://github.com/pgvector/pgvector
			ORDER BY
				parsed_red_number_report_sections.embedding <#> embedding
			LIMIT match_count;
END;
$function$