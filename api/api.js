// server.js
const express = require('express');
const bodyParser = require('body-parser');

const app = express();
app.use(bodyParser.json());

/*
  {
    id,
    name,
    description,
    country,
    ingredients: [{ name, quantity, unit }],
    steps: [ ]
  }
*/

// Sample Data
const recetas = [
  {
    id: "60048a393469f246b699",
    name: "Ceviche de Camarón",
    description: "Delicioso ceviche de camarón con limón, tomate y cebolla, típico de la costa ecuatoriana.",
    country: "Ecuador",
    ingredients: [
      { name: "Camarones", quantity: 500, unit: "g" },
      { name: "Cebolla", quantity: 1, unit: "unidad" },
      { name: "Tomate", quantity: 2, unit: "unidades" },
      { name: "Limón", quantity: 5, unit: "unidades" },
      { name: "Cilantro", quantity: 1, unit: "puñado" },
      { name: "Sal", quantity: 1, unit: "cucharadita" },
      { name: "Pimienta", quantity: 1, unit: "cucharadita" }
    ],
    steps: [
      "Cocer los camarones hasta que estén rosados.",
      "Picar la cebolla y el tomate en cubos pequeños.",
      "Mezclar los camarones con la cebolla, tomate y cilantro.",
      "Agregar jugo de limón, sal y pimienta al gusto.",
      "Dejar reposar 10 minutos antes de servir."
    ]
  },
  {
    id: "1db6c36508271466dbba",
    name: "Encebollado",
    description: "Sopa de pescado y yuca con cebolla encurtida, muy popular en la costa ecuatoriana.",
    country: "Ecuador",
    ingredients: [
      { name: "Atún fresco", quantity: 400, unit: "g" },
      { name: "Yuca", quantity: 500, unit: "g" },
      { name: "Cebolla", quantity: 1, unit: "unidad" },
      { name: "Tomate", quantity: 2, unit: "unidades" },
      { name: "Jugo de limón", quantity: 2, unit: "cucharadas" },
      { name: "Cilantro", quantity: 1, unit: "puñado" },
      { name: "Sal y pimienta", quantity: 1, unit: "al gusto" }
    ],
    steps: [
      "Cocer el pescado y reservar el caldo.",
      "Hervir la yuca hasta que esté blanda y cortarla en trozos.",
      "Mezclar el caldo con tomate y cebolla picados.",
      "Agregar el pescado y la yuca al caldo.",
      "Servir con cilantro y jugo de limón."
    ]
  },
  {
    id: "763c47c2b4dce60770bb",
    name: "Hornado",
    description: "Cerdo asado al horno, típico de la sierra ecuatoriana, acompañado de mote y llapingachos.",
    country: "Ecuador",
    ingredients: [
      { name: "Cerdo", quantity: 2, unit: "kg" },
      { name: "Ajo", quantity: 4, unit: "dientes" },
      { name: "Cebolla", quantity: 2, unit: "unidades" },
      { name: "Comino", quantity: 1, unit: "cucharadita" },
      { name: "Sal y pimienta", quantity: 1, unit: "al gusto" },
      { name: "Mote cocido", quantity: 500, unit: "g" },
      { name: "Llapingachos", quantity: 6, unit: "unidades" }
    ],
    steps: [
      "Frotar el cerdo con ajo, cebolla, comino, sal y pimienta.",
      "Hornear a 180°C durante 3 horas hasta que esté dorado.",
      "Preparar los llapingachos y el mote.",
      "Servir el cerdo acompañado de mote y llapingachos."
    ]
  },
  {
    id: "c7301d2d795ad321d869",
    name: "Fanesca",
    description: "Sopa tradicional ecuatoriana de Semana Santa, hecha con granos, pescado seco y verduras.",
    country: "Ecuador",
    ingredients: [
      { name: "Bacalao seco", quantity: 500, unit: "g" },
      { name: "Frejol", quantity: 100, unit: "g" },
      { name: "Choclo", quantity: 100, unit: "g" },
      { name: "Zapallo", quantity: 200, unit: "g" },
      { name: "Leche", quantity: 1, unit: "litro" },
      { name: "Cebolla", quantity: 1, unit: "unidad" },
      { name: "Ajo", quantity: 2, unit: "dientes" },
      { name: "Huevos duros", quantity: 4, unit: "unidades" },
      { name: "Aceitunas negras", quantity: 12, unit: "unidades" }
    ],
    steps: [
      "Remojar el bacalao y hervirlo.",
      "Cocer los granos por separado hasta que estén tiernos.",
      "Hacer un sofrito con cebolla, ajo y zapallo.",
      "Agregar los granos y el bacalao al sofrito, luego la leche.",
      "Servir caliente con huevo duro y aceitunas."
    ]
  },
  {
    id: "c419fa44cd17ad3e48ac",
    name: "Llapingachos",
    description: "Tortillas de papa rellenas de queso, típicas de la sierra ecuatoriana.",
    country: "Ecuador",
    ingredients: [
      { name: "Papas", quantity: 500, unit: "g" },
      { name: "Queso fresco", quantity: 150, unit: "g" },
      { name: "Aceite", quantity: 3, unit: "cucharadas" },
      { name: "Sal", quantity: 1, unit: "cucharadita" }
    ],
    steps: [
      "Hervir las papas y hacer un puré.",
      "Formar bolitas de puré y rellenarlas con queso.",
      "Aplanar las bolitas para formar tortitas.",
      "Freír en aceite hasta que estén doradas por ambos lados.",
      "Servir calientes como acompañamiento."
    ]
  }
];

app.get('/api/recetas', (req, res) => {
  res.json(recetas);
});

app.get('/api/recetas/:pais', (req, res) => {
  const { pais } = req.params;

  const recetasFiltradas = recetas.filter(r => 
    r.country.toLowerCase() === pais.toLowerCase()
  );

  if (recetasFiltradas.length === 0) {
    return res.status(404).json({ message: `No se encontraron recetas para el país: ${pais}` });
  }

  res.json(recetasFiltradas);
});


app.post('/api/recetas', (req, res) => {
  const { name, description, country, ingredients, steps } = req.body;

  // Validación básica
  if (!name || !description || !country || !Array.isArray(ingredients) || !Array.isArray(steps)) {
    return res.status(400).json({ message: 'Name, description, country, ingredients and steps are required' });
  }

  const newReceta = {
    id: Date.now(), // ID simple
    name,
    description,
    country,
    ingredients,
    steps
  };

  recetas.push(newReceta);
  res.status(201).json(newReceta);
});

app.put('/api/recetas/:id', (req, res) => {
  const { id } = req.params;
  const { name, description, country, ingredients, steps } = req.body;

  const i = recetas.findIndex(r => r.id === id);
  if (i === -1) return res.status(404).json({ message: 'Receta not found' });

  if (name) recetas[i].name = name;
  if (description) recetas[i].description = description;
  if (country) recetas[i].country = country;
  if (Array.isArray(ingredients)) recetas[i].ingredients = ingredients;
  if (Array.isArray(steps)) recetas[i].steps = steps;

  res.json(recetas[i]);
});

app.delete('/api/recetas/:id', (req, res) => {
  const { id } = req.params;
  const index = recetas.findIndex(r => r.id === id);

  if (index === -1) return res.status(404).json({ message: 'Receta not found' });

  const deleted = recetas.splice(index, 1);
  res.json(deleted[0]);
});


const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Recetas API running on http://localhost:${PORT}`);
});
