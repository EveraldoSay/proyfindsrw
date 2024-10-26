const express = require('express');
const path = require('path');
const bodyParser = require('body-parser');
const session = require('express-session'); 
const app = express();
const router = require('./router');

// Configuración del motor de plantillas
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

// Middleware
app.use(bodyParser.urlencoded({ extended: true })); // Para manejar datos de formularios
app.use(bodyParser.json()); // Para manejar datos JSON si es necesario
app.use(express.static(path.join(__dirname, 'public'))); // Para servir archivos estáticos

// Configuración de la sesión
app.use(session({
    secret: '19a8d12c6ae280739cf1a06e6b5e90ec2d1dbca90351e21491895a88669ce6e86224bdece575797518a94debe8c9f3d1e57ea7f4a08c35bb8d18f8972a82c939',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true }
}));

// Ruta principal
app.use('/', router); 

// Middleware de manejo de errores
app.use((err, req, res, next) => {
    console.error(err.stack); // Muestramos el error en la consola
    res.status(500).send('Algo salió mal.'); // Envia un mensaje de error
});

// Puerto PARA USAR SISTEMA
const PORT = process.env.PORT || 10000;
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
});