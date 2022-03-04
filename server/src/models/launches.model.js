const axios = require("axios");
const {PrismaClient} = require("@prisma/client");

const prisma = new PrismaClient();
const SPACEX_URL_API = "https://api.spacexdata.com/v4/launches/query";

async function loadLaunchesData() {
    const response = await axios.post(SPACEX_URL_API, {
        query: {},
        options: {
            pagination: false,
            populate: [
                {
                    path: "rocket",
                    select: {
                        name: 1
                    }
                },
                {
                    path: "payloads",
                    select: {
                        "customers": 1
                    }
                }
            ]
        }
    });

    const launchDocs = response.data.docs;

    for (const launchDoc of launchDocs) {
        const payloads = launchDoc["payloads"];
        const customers = payloads.flatMap((payload) => {
            return payload["customers"];
        });

        const launch = {
            flightNumber: launchDoc["flight_number"],
            mission: launchDoc["name"],
            rocket: launchDoc["rocket"]["name"],
            launchDate: launchDoc["date_local"],
            upcoming: launchDoc["upcoming"],
            success: launchDoc["success"],
            customers,
        };

        console.log(`${launch.flightNumber} ${launch.mission}`);
    }
}


function existsLaunchWithId(launchId) {
    const prisma = new PrismaClient();

    const existsLaunch = prisma.$exists.launch({
        id: launchId,
    });

    return existsLaunch;
}

function getAllLaunches() {
    return prisma.launch.findMany();
}

async function addNewLaunch(launch) {
    return await prisma.launch.create({
        data: {
            planetId: launch.target,
            mission: launch.mission,
            rocket: launch.rocket,
            launchDate: new Date(launch.launchDate),
            customers: {
                create: [
                    {
                        name: "Customer1",
                    },
                    {
                        name: "Customer2",
                    }
                ],
            }
        }
    })
}

async function abortLaunchById(launchId) {
    return await prisma.launch.delete({
        where: {
            id: launchId,
        },
    })
    .catch(err => console.error(err));
}

module.exports = {
    loadLaunchesData,
    getAllLaunches,
    addNewLaunch,
    abortLaunchById,
    existsLaunchWithId
}