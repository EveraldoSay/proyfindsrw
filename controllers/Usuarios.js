const db = require('../database/db');
const bcrypt = require('bcryptjs'); // Para encriptar contraseñas
const session = require('express-session'); // Para manejar la sesión

// Configuración de la sesión
const app = require('express')();
app.use(session({
    secret: 'your-secret-key',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: false } // Cambiar a true si usaremos HTTPS
}));

// Crear un nuevo usuario
exports.createUsuario = (req, res) => {
    res.render('createUsuario');
};

// Guardar un nuevo usuario
exports.saveUsuario = (req, res) => {
    const { NombreUsuario, Contrasena, Rol, Nombre, Apellido, Email, Telefono } = req.body;
    const hashedPassword = bcrypt.hashSync(Contrasena, 10); // Encripta la contraseña

    const query = 'INSERT INTO usuarios (NombreUsuario, Contrasena, Rol, Nombre, Apellido, Email, Telefono, FechaRegistro) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())';
    db.query(query, [NombreUsuario, hashedPassword, Rol, Nombre, Apellido, Email, Telefono], (err) => {
        if (err) throw err;
        res.redirect('/verUsuario');
    });
};

// Renderizar vista de inicio de sesión (login)
exports.loginUsuario = (req, res) => {
    res.render('login');
};

// Autenticar usuario
exports.authUsuario = (req, res) => {
    const { NombreUsuario, Contrasena } = req.body;

    const query = 'SELECT * FROM usuarios WHERE NombreUsuario = ?';
    db.query(query, [NombreUsuario], (err, results) => {
        if (err) {
            console.error(err);
            return res.status(500).send('Error en la base de datos');
        }

        if (results.length > 0) {
            const user = results[0];

            // Compararemos la contraseña ingresada con la almacenada
            if (bcrypt.compareSync(Contrasena, user.Contrasena)) {
                // Contraseña correcta, guardar sesión del usuario
                req.session.loggedIn = true;
                req.session.user = user;

                // Redirigir a verCliente después de iniciar sesión
                return res.redirect('/verBanco');
            } else {
                // Contraseña incorrecta, renderiza la vista con un mensaje de error
                return res.render('login', { error: 'Contraseña incorrecta' });
            }
        } else {
            // Usuario no encontrado, renderiza la vista con un mensaje de error
            return res.render('login', { error: 'Usuario no encontrado' });
        }
    });
};

// Cerrar sesión
exports.logoutUsuario = (req, res) => {
    req.session.destroy((err) => {
        if (err) {
            return console.log(err);
        }
        res.redirect('/login');
    });
};

// Listar todos los usuarios
// controllers/Usuarios.js

exports.listUsuarios = (req, res) => {
    db.query('SELECT IdUsuario, NombreUsuario, Rol, Nombre, Apellido, Email, Telefono, FechaRegistro FROM usuarios', (err, results) => {
        if (err) throw err;
        res.render('verUsuario', { data: results });
    });
};


// Editar un usuario
exports.editUsuario = (req, res) => {
    const { id } = req.params;
    db.query('SELECT * FROM usuarios WHERE IdUsuario = ?', [id], (err, results) => {
        if (err) throw err;
        res.render('editUsuario', { usuario: results[0] });
    });
};

// Actualizar un usuario
exports.updateUsuario = (req, res) => {
    const { IdUsuario, NombreUsuario, Rol, Nombre, Apellido, Email, Telefono } = req.body;
    db.query('UPDATE usuarios SET NombreUsuario = ?, Rol = ?, Nombre = ?, Apellido = ?, Email = ?, Telefono = ? WHERE IdUsuario = ?', 
    [NombreUsuario, Rol, Nombre, Apellido, Email, Telefono, IdUsuario], (err) => {
        if (err) throw err;
        res.redirect('/verUsuario');
    });
};

// Eliminar un usuario
exports.deleteUsuario = (req, res) => {
    const id = req.params.id;
    db.query('DELETE FROM usuarios WHERE IdUsuario = ?', [id], (err) => {
        if (err) throw err;
        res.redirect('/verUsuario');
    });
};
