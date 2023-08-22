CREATE TABLE "public"."parsed_document_metadata"(
	"id" bigint GENERATED BY DEFAULT AS IDENTITY NOT NULL,
	"parsed_document_id" bigint,
	"raw_metadata" json,
	"token_count" integer,
	"embedding" vector(1536)
);

ALTER TABLE "public"."parsed_document_metadata"
	ADD CONSTRAINT "parsed_document_metadata_parsed_document_id_fkey" FOREIGN KEY (parsed_document_id) REFERENCES parsed_documents(id) NOT valid;