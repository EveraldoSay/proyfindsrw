// controllers/CatProd.js

const db = require('../database/db'); // Asegúrate de que este sea el archivo de conexión a la base de datos

// Listar todas las categorías
exports.listCatProd = (req, res) => {
    db.query('SELECT * FROM categorias', (err, results) => {
        if (err) throw err;
        res.render('verCatProd', { data: results });
    });
};

// Renderizar el formulario de creación de categoría
exports.createCatProd = (req, res) => {
    res.render('createCatProd');
};

// Guardar una nueva categoría
exports.saveCatProd = (req, res) => {
    const { Nombre } = req.body;
    db.query('INSERT INTO categorias (Nombre) VALUES (?)', [Nombre], (err) => {
        if (err) throw err;
        res.redirect('/verCatProd');
    });
};

// Editar una categoría existente
exports.editCatProd = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM categorias WHERE IdCategoria = ?', [id], (err, results) => {
        if (err) throw err;
        res.render('editCatProd', { categoria: results[0] }); // Usar 'categoria' en lugar de 'categorias'
    });
};

// Actualizar una categoría
exports.updateCatProd = (req, res) => {
    const { Id, Nombre } = req.body; 
    db.query('UPDATE categorias SET Nombre = ? WHERE IdCategoria = ?', [Nombre, Id], (err) => {
        if (err) throw err;
        res.redirect('/verCatProd');
    });
};

// Eliminar una categoría
exports.deleteCatProd = (req, res) => {
    const id = req.params.id;
    db.query('DELETE FROM categorias WHERE IdCategoria = ?', [id], (err) => {
        if (err) {
            console.error('Error al eliminar categoría:', err);
            return res.status(500).send('Error al eliminar categoría');
        }
        res.redirect('/verCatProd');
    });
};
