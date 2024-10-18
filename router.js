const express = require('express');
const router = express.Router();
const conexion = require('./database/db');

//IMPORTANDO CONTROLADORES
const clientes = require('./controllers/clientes');
const CatProd = require('./controllers/CatProd');
const Bancos = require('./controllers/Bancos');
const Productos = require('./controllers/Productos');
const Usuarios = require('./controllers/Usuarios');
const isAuthenticated = require('./middleware/auth');
const Devoluciones = require('./controllers/Devoluciones');
const InformeDevoluciones = require('./controllers/InformeDevoluciones');
const ventas = require('./controllers/ventas');
const kardex = require('./controllers/Kardex');


                    //CLIENTES

// RUTA PARA MOSTRAR TODOS LOS REGISTROS
router.get('/', (req, res) => { 
    conexion.query('SELECT * FROM clientes', (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('verCliente.ejs', { data: results });
        }
    });
});

// RUTA QUE NOS LLEVA AL FORMULARIO PARA DAR DE ALTA UN NUEVO REGISTRO
router.get('/createCliente', (req, res) => {
    res.render('createCliente');
});

// RUTA PARA EDITAR UN REGISTRO SELECCIONADO
router.get('/editCliente/:id', (req, res) => {
    const id = req.params.id;
    conexion.query('SELECT * FROM clientes WHERE IdCliente = ?', [id], (error, results) => {
        if (error) {
            throw error;
        } else {
            res.render('editCliente.ejs', { cliente: results[0] });
        }
    });
});



// RUTA PARA ELIMINAR UN REGISTRO SELECCIONADO
router.get('/deleteCliente/:id', clientes.deleteCliente);
// Invocamos los métodos para el CRUD
router.post('/saveCliente', clientes.saveCliente);
router.post('/updateCliente', clientes.updateCliente);

router.post('deleteCliente/:id', (req, res) => {
    clientes.deleteCliente(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});






module.exports = router;


                    //CATEGORIAS PRODUCTOS

// Rutas para el CRUD CATEGORIAS PRODUCTOS
router.get('/verCatProd', CatProd.listCatProd);
router.get('/createCatProd', CatProd.createCatProd);
router.post('/createCatProd', CatProd.saveCatProd);
router.get('/editCatProd/:id', CatProd.editCatProd);
router.post('/updateCatProd', CatProd.updateCatProd);
router.get('/deleteCatProd/:id', CatProd.deleteCatProd);


router.post('deleteCatProd/:id', (req, res) => {
    CatProd.deleteCatProd(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});



                    //BANCOS

// Rutas para el CRUD BANCOS
router.get('/verBanco', Bancos.listBanco);
router.get('/createBanco', Bancos.createBanco);
router.post('/createBanco', Bancos.saveBanco);
router.get('/editBanco/:id', Bancos.editBanco);
router.post('/updateBanco', Bancos.updateBanco);
router.get('/deleteBanco/:id', Bancos.deleteBanco);


router.post('deleteBanco/:id', (req, res) => {
    Bancos.deleteBanco(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});





                    //PRODUCTOS

// Rutas para el CRUD PRODUCTOS
router.get('/verProducto', Productos.listProducto);
router.get('/createProducto', Productos.createProducto);
router.post('/createProducto', Productos.saveProducto);
router.get('/editProducto/:id', Productos.editProducto);
router.post('/updateProducto', Productos.updateProducto);
router.get('/deleteProducto/:id', Productos.deleteProducto);


router.post('deleteProducto/:id', (req, res) => {
    Productos.deleteProducto(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});



                   // RUTAS USUARIOS
router.get('/verUsuario', Usuarios.listUsuarios);
router.get('/createUsuario', Usuarios.createUsuario);
router.post('/saveUsuario', Usuarios.saveUsuario);
router.get('/editUsuario/:id', Usuarios.editUsuario);
router.post('/updateUsuario', Usuarios.updateUsuario);
router.get('/deleteUsuario/:id', Usuarios.deleteUsuario);

router.post('/deleteUsuario/:id', (req, res) => {
    Usuarios.deleteUsuario(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});

// RUTAS LOGIN (INICIO Y CIERRE)
router.get('/login', Usuarios.loginUsuario);
router.post('/authUsuario', Usuarios.authUsuario, (req, res) => {
    res.redirect('/verBanco'); 
});
router.get('/verBanco', isAuthenticated, (req, res) => {
    res.render('verBanco', { user: req.session.user }); // Renderiza la vista verCliente
});
router.get('/logout', Usuarios.logoutUsuario);





                    //RUTAS DEVOLUCIONES

router.get('/verDevolucion', Devoluciones.listDevolucion);
router.get('/createDevolucion', Devoluciones.createDevolucion);
router.post('/createDevolucion', Devoluciones.saveDevolucion);
router.get('/editDevolucion/:id', Devoluciones.editDevolucion);
router.post('/updateDevolucion', Devoluciones.updateDevolucion);
router.get('/deleteDevolucion/:id', Devoluciones.deleteDevolucion);


router.post('deleteDevolucion/:id', (req, res) => {
    Devoluciones.deleteProducto(req, res).catch(err => {
        console.error('Error al manejar la eliminación:', err); 
        res.status(500).send('Error al procesar la solicitud de eliminación');
    });
});


                    // RUTA INFORME DEVOLUCIONES PDF

// Ruta para ver la vista de informes
router.get('/verInformes', (req, res) => {
    res.render('verInformes'); // Renderiza la vista 'verInformes'
});

// Ruta para generar informe de devoluciones
router.get('/generarInformeDevoluciones', InformeDevoluciones.generarInformeDevoluciones);




                    //VENTAS

//router.get('/verVentas', ventas.mostrarVentas);
router.get('/createVenta', ventas.mostrarFormularioVenta);
router.post('/guardarVenta', ventas.guardarVenta);
router.get('/regenerarFactura/:IdVenta', ventas.regenerarFactura);



// Rutas para el CRUD de Kardex
router.get('/verKardex', kardex.listKardex);
router.get('/createKardex', kardex.createKardex);
router.post('/createKardex', kardex.saveKardex);
router.get('/editKardex/:id', kardex.editKardex);
router.post('//updateKardex/:id', kardex.updateKardex);
router.get('/deleteKardex/:id', kardex.deleteKardex);


