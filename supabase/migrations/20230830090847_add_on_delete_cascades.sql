ALTER TABLE parsed_documents DROP CONSTRAINT parsed_documents_dokument_id_fkey;

ALTER TABLE parsed_document_tables DROP CONSTRAINT parsed_document_tables_parsed_document_id_fkey;

ALTER TABLE parsed_document_sections DROP CONSTRAINT parsed_document_sections_parsed_document_id_fkey;

ALTER TABLE parsed_document_metadata DROP CONSTRAINT parsed_document_metadata_parsed_document_id_fkey;

ALTER TABLE vorgang DROP CONSTRAINT vorgang_export_id_fkey;

ALTER TABLE dokument DROP CONSTRAINT dokument_vorgang_id_fkey;

ALTER TABLE nebeneintrag DROP CONSTRAINT nebeneintrag_vorgang_id_fkey;

ALTER TABLE parsed_documents
	ADD FOREIGN KEY (dokument_id) REFERENCES dokument (id) ON DELETE CASCADE;

ALTER TABLE parsed_document_tables
	ADD FOREIGN KEY (parsed_document_id) REFERENCES parsed_documents (id) ON DELETE CASCADE;

ALTER TABLE parsed_document_sections
	ADD FOREIGN KEY (parsed_document_id) REFERENCES parsed_documents (id) ON DELETE CASCADE;

ALTER TABLE parsed_document_metadata
	ADD FOREIGN KEY (parsed_document_id) REFERENCES parsed_documents (id) ON DELETE CASCADE;

ALTER TABLE vorgang
	ADD FOREIGN KEY (export_id) REFERENCES export (id) ON DELETE CASCADE;

ALTER TABLE dokument
	ADD FOREIGN KEY (vorgang_id) REFERENCES vorgang (id) ON DELETE CASCADE;

ALTER TABLE nebeneintrag
	ADD FOREIGN KEY (vorgang_id) REFERENCES vorgang (id) ON DELETE CASCADE;