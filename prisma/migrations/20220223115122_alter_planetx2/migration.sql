/*
  Warnings:

  - You are about to drop the column `targetId` on the `Launch` table. All the data in the column will be lost.

*/
-- DropForeignKey
ALTER TABLE "Launch" DROP CONSTRAINT "Launch_targetId_fkey";

-- AlterTable
ALTER TABLE "Launch" DROP COLUMN "targetId",
ADD COLUMN     "planetId" TEXT;

-- AddForeignKey
ALTER TABLE "Launch" ADD CONSTRAINT "Launch_planetId_fkey" FOREIGN KEY ("planetId") REFERENCES "Planet"("kepler_name") ON DELETE SET NULL ON UPDATE CASCADE;
