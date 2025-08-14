CREATE TABLE "auth-2-better-auth_verification" (
	"id" text PRIMARY KEY NOT NULL,
	"identifier" text NOT NULL,
	"value" text NOT NULL,
	"expires_at" timestamp with time zone NOT NULL,
	"created_at" timestamp with time zone,
	"updated_at" timestamp with time zone
);
--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" DROP CONSTRAINT "auth-2-better-auth_account_provider_providerAccountId_pk";--> statement-breakpoint
/* 
    Unfortunately in current drizzle-kit version we can't automatically get name for primary key.
    We are working on making it available!

    Meanwhile you can:
        1. Check pk name in your database, by running
            SELECT constraint_name FROM information_schema.table_constraints
            WHERE table_schema = 'public'
                AND table_name = 'auth-2-better-auth_session'
                AND constraint_type = 'PRIMARY KEY';
        2. Uncomment code below and paste pk name manually
        
    Hope to release this update as soon as possible
*/

-- ALTER TABLE "auth-2-better-auth_session" DROP CONSTRAINT "<constraint_name>";--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" DROP CONSTRAINT "auth-2-better-auth_session_pkey";

-- First create the columns (allowing NULL initially)
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "id" text;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "access_token_expires_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "refresh_token_expires_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "password" text;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "created_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD COLUMN "updated_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD COLUMN "id" text;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD COLUMN "ip_address" text;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD COLUMN "user_agent" text;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD COLUMN "created_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD COLUMN "updated_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ADD COLUMN "email_verified" boolean;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ADD COLUMN "created_at" timestamp with time zone;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ADD COLUMN "updated_at" timestamp with time zone;

UPDATE "auth-2-better-auth_account" SET "id" = "provider" || '_' || "providerAccountId" WHERE "id" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_account" SET "access_token_expires_at" = to_timestamp("expires_at") WHERE "expires_at" IS NOT NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_account" SET "created_at" = CURRENT_TIMESTAMP WHERE "created_at" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_account" SET "updated_at" = CURRENT_TIMESTAMP WHERE "updated_at" IS NULL;--> statement-breakpoint

UPDATE "auth-2-better-auth_session" SET "id" = "sessionToken" WHERE "id" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_session" SET "created_at" = CURRENT_TIMESTAMP WHERE "created_at" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_session" SET "updated_at" = CURRENT_TIMESTAMP WHERE "updated_at" IS NULL;--> statement-breakpoint

UPDATE "auth-2-better-auth_user" SET "email_verified" = false WHERE "email_verified" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_user" SET "created_at" = CURRENT_TIMESTAMP WHERE "created_at" IS NULL;--> statement-breakpoint
UPDATE "auth-2-better-auth_user" SET "updated_at" = CURRENT_TIMESTAMP WHERE "updated_at" IS NULL;--> statement-breakpoint


ALTER TABLE "auth-2-better-auth_account" ALTER COLUMN "id" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ADD PRIMARY KEY ("id");--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ALTER COLUMN "created_at" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_account" ALTER COLUMN "updated_at" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ALTER COLUMN "id" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ADD PRIMARY KEY ("id");--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ALTER COLUMN "created_at" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_session" ALTER COLUMN "updated_at" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ALTER COLUMN "email_verified" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ALTER COLUMN "created_at" SET NOT NULL;--> statement-breakpoint
ALTER TABLE "auth-2-better-auth_user" ALTER COLUMN "updated_at" SET NOT NULL;