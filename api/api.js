const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');

const serviceAccount = require('./serviceAccountKey.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();
const recetasCol = db.collection('recetas');
const ingredientesCol = db.collection('ingredientes');

const app = express();
app.use(bodyParser.json());


const ingredientesBase = [
  { name: "Camarones", description: "Marisco fresco de la costa", calories: 99 },
  { name: "Cebolla", description: "Cebolla colorada fresca", calories: 40 },
  { name: "Tomate", description: "Tomate riñón jugoso", calories: 18 },
  { name: "Limón", description: "Limón sutil ácido", calories: 29 },
  { name: "Cilantro", description: "Hierba aromática fresca", calories: 23 },
  { name: "Yuca", description: "Tubérculo suave y almidonado", calories: 160 },
  { name: "Atún", description: "Pescado azul fresco (Albacora)", calories: 130 },
  { name: "Cerdo", description: "Carne de cerdo (Pierna o Lomo)", calories: 242 },
  { name: "Ajo", description: "Dientes de ajo frescos", calories: 149 },
  { name: "Mote", description: "Maíz blanco cocido", calories: 120 },
  { name: "Bacalao Seco", description: "Pescado salado y seco", calories: 290 },
  { name: "Frejol", description: "Granos tiernos", calories: 347 },
  { name: "Zapallo", description: "Calabaza ecuatoriana cremosa", calories: 26 },
  { name: "Leche", description: "Leche entera pasteurizada", calories: 60 },
  { name: "Papas", description: "Papa chola o superchola", calories: 77 },
  { name: "Queso Fresco", description: "Queso de mesa tradicional", calories: 260 },
  { name: "Maní", description: "Pasta de maní tostado", calories: 567 },
  { name: "Plátano Verde", description: "Plátano macho verde", calories: 122 }
];

const recetasBase = [
  {
    name: "Ceviche de Camarón",
    description: "Ceviche tradicional con salsa de tomate, limón y cebolla curtida.",
    country: "Ecuador",
    ingredients: [
      { name: "Camarones", quantity: 500, unit: "g" },
      { name: "Cebolla", quantity: 2, unit: "unidades" },
      { name: "Tomate", quantity: 3, unit: "unidades" },
      { name: "Limón", quantity: 10, unit: "unidades" },
      { name: "Cilantro", quantity: 1, unit: "atado" }
    ],
    steps: [
      "Pelar y limpiar los camarones.",
      "Hervir las cáscaras de camarón para hacer un fondo.",
      "Cocinar los camarones en el fondo hirviendo por 3 minutos.",
      "Picar la cebolla en pluma y curtirla con limón y sal.",
      "Rallar o licuar los tomates y mezclarlos con mostaza y el fondo frío.",
      "Mezclar todo y agregar cilantro picado al final."
    ]
  },
  {
    name: "Encebollado",
    description: "Sopa de pescado (albacora) con yuca y cebolla, ideal para el desayuno.",
    country: "Ecuador",
    ingredients: [
      { name: "Atún", quantity: 2, unit: "lb" },
      { name: "Yuca", quantity: 3, unit: "lb" },
      { name: "Cebolla", quantity: 2, unit: "unidades" },
      { name: "Cilantro", quantity: 1, unit: "atado" },
      { name: "Ajo", quantity: 3, unit: "dientes" }
    ],
    steps: [
      "Hacer un refrito con cebolla, tomate, pimiento y comino.",
      "Cocinar la albacora en agua con el refrito y cilantro.",
      "Separar el pescado y cocinar la yuca en ese mismo caldo.",
      "Licuar una parte de la yuca cocinada con el caldo para espesar.",
      "Servir la yuca picada, el pescado en láminas y la cebolla curtida encima."
    ]
  },
  {
    name: "Fanesca",
    description: "Sopa densa a base de granos tiernos y pescado seco, típica de Semana Santa.",
    country: "Ecuador",
    ingredients: [
      { name: "Bacalao Seco", quantity: 1, unit: "lb" },
      { name: "Frejol", quantity: 1, unit: "lb" },
      { name: "Zapallo", quantity: 500, unit: "g" },
      { name: "Leche", quantity: 1, unit: "litro" },
      { name: "Maní", quantity: 200, unit: "g" }
    ],
    steps: [
      "Desalar el bacalao en agua desde la noche anterior.",
      "Cocinar todos los granos por separado hasta que estén suaves.",
      "Hacer un refrito con cebolla blanca y achiote.",
      "Licuar el zapallo cocinado con leche y maní.",
      "Mezclar el refrito, el licuado y los granos en una olla grande.",
      "Cocinar a fuego lento y añadir el bacalao al final."
    ]
  },
  {
    name: "Llapingachos",
    description: "Tortillas de papa rellenas de queso, acompañadas de salsa de maní.",
    country: "Ecuador",
    ingredients: [
      { name: "Papas", quantity: 5, unit: "lb" },
      { name: "Queso Fresco", quantity: 1, unit: "lb" },
      { name: "Cebolla", quantity: 1, unit: "unidad" },
      { name: "Maní", quantity: 100, unit: "g" }
    ],
    steps: [
      "Cocinar las papas peladas en agua con sal hasta que estén suaves.",
      "Aplastar las papas calientes hasta obtener un puré sin grumos.",
      "Hacer un refrito de cebolla blanca y mezclar con el puré.",
      "Formar bolas, rellenar el centro con queso y aplanar.",
      "Dorar las tortillas en una plancha o sartén con poco aceite."
    ]
  }
];

app.get('/api/ingredientes', async (req, res) => {
  try {
    const snapshot = await ingredientesCol.orderBy('name').get();
    const data = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
    res.json(data);
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/ingredientes', async (req, res) => {
  try {
    const docRef = await ingredientesCol.add(req.body);
    res.status(201).json({ id: docRef.id, ...req.body });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.put('/api/ingredientes/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    delete data.id; 
    
    const docRef = ingredientesCol.doc(id);
    await docRef.update(data);
    
    res.json({ id, ...data });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.delete('/api/ingredientes/:id', async (req, res) => {
  try {
    await ingredientesCol.doc(req.params.id).delete();
    res.json({ success: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.get('/api/recetas', async (req, res) => {
  try {
    const snapshot = await recetasCol.get();
    res.json(snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() })));
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.post('/api/recetas', async (req, res) => {
  try {
    const docRef = await recetasCol.add(req.body);
    res.status(201).json({ id: docRef.id, ...req.body });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.put('/api/recetas/:id', async (req, res) => {
  try {
    const { id } = req.params;
    const data = req.body;
    delete data.id; 
    await recetasCol.doc(id).update(data);
    res.json({ id, ...data });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

app.delete('/api/recetas/:id', async (req, res) => {
  try {
    await recetasCol.doc(req.params.id).delete();
    res.json({ success: true });
  } catch (e) { res.status(500).json({ error: e.message }); }
});


app.post('/api/poblar', async (req, res) => {
  try {
    const batch = db.batch();

    ingredientesBase.forEach(ing => {
      const ref = ingredientesCol.doc();
      batch.set(ref, ing);
    });

    recetasBase.forEach(receta => {
      const ref = recetasCol.doc();
      batch.set(ref, receta);
    });

    await batch.commit();
    res.json({ 
      message: 'Base de datos poblada con éxito',
      ingredientes: ingredientesBase.length,
      recetas: recetasBase.length
    });
  } catch (e) { res.status(500).json({ error: e.message }); }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`API running on port ${PORT}`));