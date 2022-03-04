const parse = require('csv-parse');
const path = require("path");
const fs = require('fs');
const {PrismaClient} = require("@prisma/client");

const prisma = new PrismaClient();

function isHabitablePlanet(planet) {
    return planet['koi_disposition'] === 'CONFIRMED'
        && planet['koi_insol'] > 0.36 && planet['koi_insol'] < 1.11
        && planet['koi_prad'] < 1.6;
}

function loadPlanetsData() {
    return new Promise((resolve, reject) => {
        fs.createReadStream(path.join(__dirname, "..", "..", "data", "kepler_data.csv"))
            .pipe(parse({
                comment: '#',
                columns: true,
            }))
            .on('data', async (data) => {
                if (isHabitablePlanet(data)) {
                    savePlanet(data);
                }
            })
            .on('error', (err) => {
                reject(err);
            })
            .on('end', async () => {
                const numberOfPlanets = await prisma.planet.count();
                console.log(`${numberOfPlanets} habitable planets found!`);
                resolve();
            });
    });
}

async function getAllPlanets() {
    return await prisma.planet.findMany();
}

async function savePlanet(data) {
    await prisma.planet.upsert({
        where: {
            kepler_name: data["kepler_name"],
        },
        update: {
            koi_disposition: data["koi_disposition"],
            koi_insol: data["koi_insol"],
            koi_prad: data["koi_prad"]
        },
        create: {
            kepler_name: data["kepler_name"],
            koi_disposition: data["koi_disposition"],
            koi_insol: data["koi_insol"],
            koi_prad: data["koi_prad"]},
    });
}

module.exports = {
    loadPlanetsData,
    getAllPlanets,
};