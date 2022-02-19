
puts "Gears deleted"
Gear.create!(name: "Piece of rag",
            attack: 2,
            defence: 1,
            speed_attack: 1,
            level: 2)
Gear.create!(name: "Ring",
            attack: 4,
            defence: 1,
            speed_attack: 1,
          level: 2
          )
Gear.create!(name: "Rusty sword",
            attack: 4,
            defence: 1,
            speed_attack: 3,
          level: 4)
Gear.create!(name: "Sledge hammer",
            attack: 3,
            defence: 1,
            speed_attack: 1,
          level: 2)
Gear.create!(name: "Sneakers",
            attack: 0,
            defence: 0,
            speed_attack: 25,
          level: 12)
Gear.create!(name: "Heavy helmet",
            attack: 0,
            defence: 15,
            speed_attack: 3,
          level: 10)
Gear.create!(name: "Helmet",
            attack: 0,
            defence: 8,
            speed_attack: 2,
          level: 6)
Gear.create!(name: "Socks",
            attack: 1,
            defence: 1,
            speed_attack: 10,
          level: 8)
Gear.create!(name: "Wooden Shield",
            attack:1 ,
            defence: 4,
            speed_attack: 3,
          level: 4)
Gear.create!(name: "Knife",
            attack: 16,
            defence: 1,
            speed_attack: 2,
          level: 10)
Gear.create!(name: "Bandana",
            attack: 3,
            defence: 2,
            speed_attack: 5,
          level: 8)
Gear.create!(name: "Light jacket",
            attack: 3,
            defence: 5,
            speed_attack: 3,
          level: 6)
Gear.create!(name: "Heavy Jacket",
            attack: 3,
            defence: 10,
            speed_attack: 2,
          level: 10)
Gear.create!(name: "Heavy sword",
            attack: 8,
            defence: 1,
            speed_attack: 5,
          level: 8)
Gear.create!(name: "Rock",
            attack: 3,
            defence: 1,
            speed_attack: 2,
          level: 4)
Gear.create!(name: "Wooden board",
            attack: 3,
            defence: 3,
            speed_attack: 0,
          level: 4)
Gear.create!(name: "Baseball bat",
            attack: 8,
            defence: 3,
            speed_attack: 2,
          level: 8)
Gear.create!(name: "Pants",
            attack: 0,
            defence: 8,
            speed_attack: 1,
          level: 6)
Gear.create!(name: "Underwears",
            attack: 0,
            defence: 4,
            speed_attack: 2,
          level: 4)
Gear.create!(name: "Club",
            attack: 12,
            defence: 5,
            speed_attack: 2,
          level: 10)
Gear.create!(name: "Bottle of Rhum",
            attack: 8,
            defence: 3,
            speed_attack: 1,
          level: 6)
Gear.create!(name: "Excalibur",
            attack: 50,
            defence: 0,
            speed_attack: 10,
          level: 16)
Gear.create!(name: "Darth Vador laser-saber",
            attack: 70,
            defence: 0,
            speed_attack: 0,
          level: 16)
Gear.create!(name: "Grenade",
            attack: 15,
            defence: 15,
            speed_attack: 15,
          level: 14)
Gear.create!(name: "Bear trap",
            attack: 20,
            defence: 0,
            speed_attack: 10,
          level: 12)
Gear.create!(name: "AK-47",
            attack: 100,
            defence: 0,
            speed_attack: 0,
          level: 18)
Gear.create!(name: "Police shield",
            attack: 0,
            defence: 120,
            speed_attack: 0,
          level: 20)
Gear.create!(name: "JackHammer",
            attack: 70,
            defence: 25,
            speed_attack: -30,
          level: 18)
Gear.create!(name: "Overboard",
            attack: 0,
            defence: 0,
            speed_attack: 150,
          level: 20)
Gear.create!(name: "Power of love",
            attack: 50,
            defence: 50,
            speed_attack: 50,
          level: 20)

puts "#{Gear.count}Gears created"
