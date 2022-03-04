/*
  Warnings:

  - You are about to drop the column `launchId` on the `Planet` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Planet" DROP CONSTRAINT "Planet_launchId_fkey";

-- DropIndex
DROP INDEX "Planet_launchId_key";

-- AlterTable
ALTER TABLE "Launch" ADD COLUMN     "targetId" TEXT;

-- AlterTable
ALTER TABLE "Planet" DROP COLUMN "launchId";

-- AddForeignKey
ALTER TABLE "Launch" ADD CONSTRAINT "Launch_targetId_fkey" FOREIGN KEY ("targetId") REFERENCES "Planet"("kepler_name") ON DELETE SET NULL ON UPDATE CASCADE;
