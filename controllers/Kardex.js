const db = require('../database/db'); // Asegúrate de tener tu conexión a la base de datos configurada

// Mostrar formulario de creación
exports.createKardex = (req, res) => {
    db.query('SELECT * FROM productos', (err, productos) => {
        if (err) throw err;
        res.render('createKardex', { productos });
    });
};

// Crear un nuevo registro de kardex
exports.saveKardex = (req, res) => {
    const cantidadInicial = parseInt(req.body.CantidadInicial, 10);
    const cantidadVendida = parseInt(req.body.CantidadVendida, 10);
    const cantidadRecibida = parseInt(req.body.CantidadRecibida, 10);

    const CantidadExistente = cantidadInicial - cantidadVendida + cantidadRecibida;

    const IdProd = req.body.IdProd;
    const IdUsuario = req.user ? req.user.id : 1; 

    const sql = `INSERT INTO kardex (IdProd, CantidadInicial, CantidadVendida, CantidadRecibida, CantidadExistente, IdUsuario)
                 VALUES (?, ?, ?, ?, ?, ?)`;

    db.query(sql, [IdProd, cantidadInicial, cantidadVendida, cantidadRecibida, CantidadExistente, IdUsuario], (err) => {
        if (err) throw err;
        res.redirect('/verKardex');
    });
};


// Mostrar formulario de edición
exports.editKardex = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM kardex WHERE Id = ?', [id], (err, kardexData) => {
        if (err) throw err;
        db.query('SELECT * FROM productos', (err, productos) => {
            if (err) throw err;
            res.render('editKardex', { kardex: kardexData[0], productos });
        });
    });
};

// Actualizar registro de kardex
exports.updateKardex = (req, res) => {
    const { IdProd, CantidadInicial, CantidadVendida, CantidadRecibida } = req.body;
    
    const cantidadInicial = parseInt(CantidadInicial, 10);
    const cantidadVendida = parseInt(CantidadVendida, 10);
    const cantidadRecibida = parseInt(CantidadRecibida, 10);

    const CantidadExistente = cantidadInicial - cantidadVendida + cantidadRecibida;

    const Id = req.params.id; 

    const sql = `UPDATE kardex SET IdProd = ?, CantidadInicial = ?, CantidadVendida = ?, CantidadRecibida = ?, CantidadExistente = ?
                 WHERE Id = ?`;

    db.query(sql, [IdProd, cantidadInicial, cantidadVendida, cantidadRecibida, CantidadExistente, Id], (err) => {
        if (err) {
            console.error('Error al actualizar el kardex:', err);
            return res.status(500).send("Algo salió mal"); 
        }
        res.redirect('/verKardex');
    });
};

// Ver lista de kardex
exports.listKardex = (req, res) => {
    const sql = 'SELECT k.*, p.Nombre as NombreProducto FROM kardex k JOIN productos p ON k.IdProd = p.IdProd';
    db.query(sql, (err, kardexList) => {
        if (err) throw err;
        res.render('verKardex', { kardexList });
    });
};

// Eliminar un registro de kardex
exports.deleteKardex = (req, res) => {
    const { id } = req.params;
    db.query('DELETE FROM kardex WHERE Id = ?', [id], (err) => {
        if (err) throw err;
        res.redirect('/verKardex');
    });
};

// Controlador para mostrar el formulario de creación del Kardex
exports.mostrarFormularioKardex = async (req, res) => {
    try {
        // Consulta para obtener los productos
        const productos = await db.query('SELECT * FROM productos');

        // Renderiza la vista "crearKardex" y pasa los productos al frontend
        res.render('crearKardex', { productos });
    } catch (error) {
        console.error('Error al obtener los productos:', error);
        res.status(500).send('Error al cargar el formulario de Kardex.');
    }
};