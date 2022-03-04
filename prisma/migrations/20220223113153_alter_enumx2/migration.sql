/*
  Warnings:

  - The values [REJECTED] on the enum `Disposition` will be removed. If these variants are still used in the database, this will fail.

*/
-- AlterEnum
BEGIN;
CREATE TYPE "Disposition_new" AS ENUM ('CONFIRMED', 'FALSE POSITIVE');
ALTER TABLE "Planet" ALTER COLUMN "koi_disposition" DROP DEFAULT;
ALTER TABLE "Planet" ALTER COLUMN "koi_disposition" TYPE "Disposition_new" USING ("koi_disposition"::text::"Disposition_new");
ALTER TYPE "Disposition" RENAME TO "Disposition_old";
ALTER TYPE "Disposition_new" RENAME TO "Disposition";
DROP TYPE "Disposition_old";
ALTER TABLE "Planet" ALTER COLUMN "koi_disposition" SET DEFAULT 'CONFIRMED';
COMMIT;
