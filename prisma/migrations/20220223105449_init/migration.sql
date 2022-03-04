-- CreateEnum
CREATE TYPE "Disposition" AS ENUM ('CONFIRMED');

-- CreateTable
CREATE TABLE "Launch" (
    "id" SERIAL NOT NULL,
    "mission" TEXT NOT NULL,
    "rocket" TEXT NOT NULL,
    "launchDate" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "upcoming" BOOLEAN NOT NULL DEFAULT true,
    "success" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Launch_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Customer" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "launchId" INTEGER,

    CONSTRAINT "Customer_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Planet" (
    "kepler_name" TEXT NOT NULL,
    "launchId" INTEGER NOT NULL,
    "koi_disposition" "Disposition" NOT NULL DEFAULT E'CONFIRMED',
    "koi_insol" TEXT NOT NULL,
    "koi_prad" TEXT NOT NULL,

    CONSTRAINT "Planet_pkey" PRIMARY KEY ("kepler_name")
);

-- CreateIndex
CREATE UNIQUE INDEX "Launch_mission_key" ON "Launch"("mission");

-- CreateIndex
CREATE UNIQUE INDEX "Planet_launchId_key" ON "Planet"("launchId");

-- AddForeignKey
ALTER TABLE "Customer" ADD CONSTRAINT "Customer_launchId_fkey" FOREIGN KEY ("launchId") REFERENCES "Launch"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Planet" ADD CONSTRAINT "Planet_launchId_fkey" FOREIGN KEY ("launchId") REFERENCES "Launch"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
