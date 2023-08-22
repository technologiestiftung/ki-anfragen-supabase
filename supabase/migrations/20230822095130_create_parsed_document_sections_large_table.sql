CREATE TABLE "public"."parsed_document_sections_large"(
	"id" bigint GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	"parsed_document_id" bigint,
	"content" text,
	"token_count" integer,
	"embedding" vector(1536),
	"heading" text
);

CREATE UNIQUE INDEX parsed_document_sections_large_pkey ON public.parsed_document_sections_large USING btree(id);

ALTER TABLE "public"."parsed_document_sections_large"
	ADD CONSTRAINT "parsed_document_sections_large_pkey" PRIMARY KEY USING INDEX "parsed_document_sections_large_pkey";

ALTER TABLE "public"."parsed_document_sections_large"
	ADD CONSTRAINT "parsed_document_sections_large_parsed_document_id_fkey" FOREIGN KEY (parsed_document_id) REFERENCES parsed_documents(id) NOT valid;

ALTER TABLE "public"."parsed_document_sections_large" validate CONSTRAINT "parsed_document_sections_large_parsed_document_id_fkey";