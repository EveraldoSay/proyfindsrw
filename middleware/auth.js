// middleware/auth.js
function isAuthenticated(req, res, next) {
    if (req.session.loggedIn) {
        // Si el usuario está autenticado, continuar con la siguiente función de middleware
        return next();
    } else {
        // Si no está autenticado, redirigir al inicio de sesión
        return res.redirect('/login'); // Asegúrate de que esta ruta apunte a tu página de inicio de sesión
    }
}

module.exports = isAuthenticated;
