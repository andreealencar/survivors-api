
s1=Survivor.create({ name: 'Finn', gender: 'male', age: 22, last_location_attributes: { lat: 123.41, lng: 321.47 } })
s2=Survivor.create({ name: 'Rey', gender: 'female', age: 25, last_location_attributes: { lat: 412.21, lng: 76.17 } })
s3=Survivor.create({ name: 'Marcus', gender: 'male', age: 42, last_location_attributes: { lat: 134.87, lng: 32.22 } })
s4=Survivor.create({ name: 'Mario', gender: 'male', age: 56, last_location_attributes: { lat: 134.87, lng: 32.22 } })

i1=Item.create({ name: 'Ammunition', points: 1 })
i2=Item.create({ name: 'Medication', points: 2 })
i3=Item.create({ name: 'Food', points: 3 })
i4=Item.create({ name: 'Water', points: 4 })

ContaminationReport.create({ suspect: s1, accuser: s2 })
ContaminationReport.create({ suspect: s1, accuser: s3 })
ContaminationReport.create({ suspect: s1, accuser: s4 })

InventoryItem.create([
  { survivor: s1, item: i1, quantity: 5},
  { survivor: s2, item: i1, quantity: 4},
  { survivor: s3, item: i1, quantity: 5},
  { survivor: s1, item: i2, quantity: 2},
  { survivor: s2, item: i2, quantity: 4},
  { survivor: s3, item: i2, quantity: 3},
  { survivor: s1, item: i3, quantity: 3},
  { survivor: s2, item: i3, quantity: 3},
])