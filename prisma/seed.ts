import { prisma } from "../src/lib/prisma"
async function seed() {
  await prisma.event.create({
    data: {
      id: '06978dae-b254-49a4-9499-47831a2113e9',
      title: 'Unite Summit',
      slug: 'unite-summit',
      details: 'Um evento para devs apaixonado por código',
      maximumAttendees: 120,
    }
  })
}

seed().then(() => {
  console.log('Database seeded!')
  prisma.$disconnect()
})