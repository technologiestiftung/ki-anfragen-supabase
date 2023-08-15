ALTER TABLE "public"."dokument"
	ALTER COLUMN "dokdat" SET data TYPE text USING "dokdat"::text;

ALTER TABLE "public"."dokument"
	ALTER COLUMN "vkdat" SET data TYPE text USING "vkdat"::text;

