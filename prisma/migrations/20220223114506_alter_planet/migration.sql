-- DropForeignKey
ALTER TABLE "Planet" DROP CONSTRAINT "Planet_launchId_fkey";

-- AlterTable
ALTER TABLE "Planet" ALTER COLUMN "launchId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "Planet" ADD CONSTRAINT "Planet_launchId_fkey" FOREIGN KEY ("launchId") REFERENCES "Launch"("id") ON DELETE SET NULL ON UPDATE CASCADE;
