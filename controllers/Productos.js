const db = require('../database/db');

// Listar todos los producto
exports.listProducto = (req, res) => {
    db.query('SELECT * FROM productos', (err, results) => {
        if (err) throw err;
        res.render('verProducto', { data: results });
    });
};

// Renderizar el formulario de creación de producto
exports.createProducto = (req, res) => {
    // Obtener categorias para el selector
    db.query('SELECT * FROM categorias', (err, categorias) => { 
        if (err) throw err;
        res.render('createProducto', { categorias });
    });
};


// Guardar una nueva producto
exports.saveProducto = (req, res) => {
    const { IdCategoria, CodigoProducto, Nombre, Descripcion, Precio, Impuestos, NumeroSerie, Stock } = req.body;
    db.query('INSERT INTO productos (IdCategoria, CodigoProducto, Nombre, Descripcion, Precio, Impuestos, NumeroSerie, Stock) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', 
    [IdCategoria, CodigoProducto, Nombre, Descripcion, Precio, Impuestos, NumeroSerie, Stock], 
    (err) => {
        if (err) throw err;
        res.redirect('/verProducto');
    });
};


// Renderizar el formulario de edición de producto
exports.editProducto = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM productos WHERE IdProd = ?', [id], (err, results) => {
        if (err) throw err;
        // Obtener categorias para el selector
        db.query('SELECT * FROM categorias', (err, categorias) => {
            if (err) throw err;
            res.render('editProducto', { producto: results[0], categorias });
        });
    });
};

// Actualizar una producto
exports.updateProducto = (req, res) => {
    const { IdProd, IdCategoria, CodigoProducto, Nombre, descripcion, Precio, Impuestos, NumeroSerie, Stock } = req.body;
    db.query('UPDATE productos SET IdCategoria = ?, CodigoProducto = ?, Nombre = ?, Descripcion = ?, Precio = ?, Impuestos = ?, NumeroSerie = ?, Stock = ? WHERE IdProd = ?', 
    [IdProd, IdCategoria, CodigoProducto, Nombre, descripcion, Precio, Impuestos, NumeroSerie, Stock], 
    (err) => {
        if (err) throw err;
        res.redirect('/verProducto');
    });
};

// Eliminar un producto
exports.deleteProducto = (req, res) => {
    const id = req.params.id; 
    db.query('DELETE FROM productos WHERE idProd = ?', [id], (err) => {
        if (err) {
            console.error('Error al eliminar producto:', err);
            return res.status(500).send('Error al eliminar producto');
        }
        res.redirect('/verProducto'); 
    });
};
