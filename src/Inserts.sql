
USE [FanHub_BD];
GO

-- 1. CARGA DE CATÁLOGOS OFICIALES (Lookups.sql)
BEGIN TRY SET IDENTITY_INSERT Categoria ON; END TRY BEGIN CATCH END CATCH;
INSERT INTO Categoria (id, nombre, descripcion) VALUES
(1, 'Gaming', 'Transmisiones en vivo de videojuegos, eSports y speedruns.'),
(2, 'Fitness', 'Rutinas de ejercicio, nutrición, dietas y bienestar físico.'),
(3, 'Tecnología', 'Reseñas de gadgets, tutoriales de programación y software.'),
(4, 'Arte Digital', 'Ilustraciones, diseño gráfico, modelado 3D y animación.'),
(5, 'Música', 'Covers, composiciones originales, partituras y clases de instrumentos.'),
(6, 'Cocina', 'Recetas paso a paso, técnicas culinarias y repostería.'),
(7, 'Vlogs', 'Blogs en video sobre estilo de vida, moda y viajes alrededor del mundo.'),
(8, 'Educación', 'Cursos, apoyo académico, idiomas y divulgación científica.'),
(9, 'ASMR', 'Contenido auditivo y visual relajante (respuestas meridianas sensoriales).'),
(10, 'Comedia', 'Sketches, stand-up, parodias y contenido humorístico en general.'),
(11, 'Moda y Belleza', 'Maquillaje, cuidado de la piel, outfits y reseñas de productos.'),
(12, 'Viajes', 'Turismo, guías de ciudades, mochileros y reseñas de hoteles.'),
(13, 'Finanzas Personales', 'Inversiones, criptomonedas, ahorro y educación financiera.'),
(14, 'Deportes', 'Análisis de partidos, noticias deportivas y entrevistas a atletas.'),
(15, 'Cine y TV', 'Reseñas de películas, análisis de series y noticias de Hollywood.'),
(16, 'Literatura', 'Reseñas de libros, clubes de lectura y consejos de escritura.'),
(17, 'Manualidades', 'DIY, costura, carpintería y proyectos para el hogar.'),
(18, 'Política y Noticias', 'Análisis de actualidad, debates y reportajes de investigación.'),
(19, 'Mascotas', 'Adiestramiento canino, cuidados, acuarios y veterinaria básica.'),
(20, 'Astrología y Esoterismo', 'Horóscopos, tarot, espiritualidad y meditación.'),
(21, 'Cosplay', 'Creación de trajes, props, maquillaje FX y sesiones fotográficas temáticas.'),
(22, 'Fotografía y Modelaje', 'Sesiones de fotos profesionales, detrás de cámaras y poses.'),
(23, 'Anime y Manga', 'Reseñas, teorías, fan-fiction y discusión sobre cultura otaku.'),
(24, 'Podcasts', 'Programas de audio, entrevistas, storytelling y charlas en formato episódico.');
BEGIN TRY SET IDENTITY_INSERT Categoria OFF; END TRY BEGIN CATCH END CATCH;

BEGIN TRY SET IDENTITY_INSERT TipoReaccion ON; END TRY BEGIN CATCH END CATCH;
INSERT INTO TipoReaccion (id, nombre, emoji_code) VALUES
(1, 'Me gusta', '👍'), (2, 'Me encanta', '❤️'), (3, 'Me divierte', '😂'),
(4, 'Fuego', '🔥'), (5, 'Me entristece', '😢'), (6, 'Me asombra', '😲'), (7, 'Me enfurece', '😡');
BEGIN TRY SET IDENTITY_INSERT TipoReaccion OFF; END TRY BEGIN CATCH END CATCH;

-- 2. USUARIOS (250)
INSERT INTO Usuario (email, password_hash, nickname, fecha_registro, fecha_nacimiento, pais, esta_activo) VALUES 
('juan.perez1@mail.com', 'a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6', 'juanperez89', '2023-01-15', '1989-05-12', 'Venezuela', 1),
('maria.gonzalez2@mail.com', 'b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7', 'mariagonz', '2023-02-20', '1995-08-22', 'Colombia', 1),
('carlos.lopez3@mail.com', 'c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8', 'carlopez', '2023-03-10', '1990-11-03', 'México', 1),
('ana.martinez4@mail.com', 'd4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9', 'anamart', '2023-04-05', '1985-02-14', 'España', 1),
('luis.rodriguez5@mail.com', 'e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0', 'luisrod', '2023-05-12', '1992-07-30', 'Argentina', 1),
('elena.sanchez6@mail.com', 'f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1', 'elenasan', '2023-06-18', '1988-09-18', 'Chile', 1),
('pedro.ramirez7@mail.com', 'g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2', 'pedroram', '2023-07-25', '1998-12-05', 'Perú', 1),
('laura.gomez8@mail.com', 'h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3', 'laurago', '2023-08-30', '1993-03-27', 'Ecuador', 1),
('miguel.diaz9@mail.com', 'i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4', 'migueldi', '2023-09-14', '1987-06-11', 'Venezuela', 1),
('sofia.torres10@mail.com', 'j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5', 'sofiator', '2023-10-02', '1996-01-25', 'Colombia', 1),
('javier.ruiz11@mail.com', 'k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6', 'javirui', '2023-11-20', '1991-04-16', 'México', 1),
('carmen.flores12@mail.com', 'l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7', 'carmenflo', '2023-12-11', '1984-10-08', 'España', 1),
('david.morales13@mail.com', 'm3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8', 'davidmor', '2024-01-05', '1994-05-29', 'Argentina', 1),
('isabel.ortiz14@mail.com', 'n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9', 'isabelort', '2024-02-28', '1989-12-14', 'Chile', 1),
('jorge.silva15@mail.com', 'o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0', 'jorgesil', '2024-03-15', '1997-08-02', 'Perú', 1),
('paula.romero16@mail.com', 'p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1', 'paularom', '2024-04-22', '1990-02-19', 'Ecuador', 1),
('manuel.vargas17@mail.com', 'q7r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2', 'manuvar', '2024-05-10', '1986-07-06', 'Venezuela', 1),
('lucia.castro18@mail.com', 'r8s9t0u1v2w3x4y5z6a7b8c9d0e1f2g3', 'luciacas', '2024-06-17', '1999-11-21', 'Colombia', 1),
('antonio.navarro19@mail.com', 's9t0u1v2w3x4y5z6a7b8c9d0e1f2g3h4', 'antonava', '2024-07-08', '1983-09-10', 'México', 1),
('sara.mendoza20@mail.com', 't0u1v2w3x4y5z6a7b8c9d0e1f2g3h4i5', 'saramen', '2024-08-01', '1995-04-04', 'España', 1);

DECLARE @i INT = 21;
DECLARE @email VARCHAR(100), @nickname VARCHAR(100), @pais VARCHAR(100);
DECLARE @paises TABLE (idx INT, nombre VARCHAR(100));
INSERT INTO @paises VALUES (1,'Venezuela'),(2,'Colombia'),(3,'México'),(4,'España'),(5,'Argentina');

WHILE @i <= 250
BEGIN
    SET @email = 'usuario' + CAST(@i AS VARCHAR) + '@mail.com';
    SET @nickname = 'user_fan_' + CAST(@i AS VARCHAR);
    SELECT @pais = nombre FROM @paises WHERE idx = (@i % 5) + 1;
    INSERT INTO Usuario (email, password_hash, nickname, fecha_registro, fecha_nacimiento, pais, esta_activo) 
    VALUES (@email, 'HASH_SIMULADO', @nickname, DATEADD(DAY, -@i, '2025-10-01'), DATEADD(DAY, -(@i*10), '2005-01-01'), @pais, 1);
    SET @i = @i + 1;
END;

-- 3. CREADORES (20)
INSERT INTO Creador (idUsuario, biografia, banco_nombre, banco_cuenta, es_nsfw, idCategoria) VALUES 
(1, 'Artista digital enfocada en hiperrealismo.', 'Banco Provincial', '01080001001234567890', 0, 4),
(2, 'Productor musical indie, subiendo stems.', 'Banesco', '01340002001234567891', 0, 5),
(3, 'Escritor de novelas oscuras y thrillers.', 'Mercantil', '01050003001234567892', 1, 16),
(4, 'Streamer de juegos retro y speedruns.', 'BBVA', '01140004001234567893', 0, 1),
(5, 'Fotógrafo de paisajes y naturaleza salvaje.', 'Santander', '01150005001234567894', 0, 22),
(6, 'Tutor de programación y desarrollo web.', 'Banco de Bogotá', '01160006001234567895', 0, 8),
(7, 'Chef de comida exótica.', 'Bancolombia', '01170007001234567896', 1, 6),
(8, 'Entrenador personal y rutinas HIIT.', 'Banamex', '01180008001234567897', 0, 2),
(9, 'Reviews de hardware.', 'CaixaBank', '01190009001234567898', 0, 3),
(10, 'Humorista y creador de stand-ups.', 'Banco Galicia', '01200010001234567899', 0, 10),
(11, 'Ilustrador 3D y modelado.', 'Banco de Chile', '01210011001234567900', 0, 4),
(12, 'Compositor de bandas sonoras.', 'BCP', '01220012001234567901', 1, 5),
(13, 'Poetisa contemporánea.', 'Interbank', '01230013001234567902', 0, 16),
(14, 'Jugador competitivo eSports.', 'Banco Pichincha', '01240014001234567903', 0, 1),
(15, 'Sesiones fotográficas urbanas.', 'Banco Guayaquil', '01250015001234567904', 0, 22),
(16, 'Clases de bases de datos.', 'Banco Nacional', '01260016001234567905', 1, 8),
(17, 'Repostería creativa.', 'Banesco', '01270017001234567906', 0, 6),
(18, 'Yoga y meditación guiada.', 'Mercantil', '01280018001234567907', 0, 2),
(19, 'Programación IA.', 'Banco Provincial', '01290019001234567908', 1, 3),
(20, 'Parodias de películas.', 'BBVA', '01300020001234567909', 0, 10);

-- 4. MÉTODOS DE PAGO (150)
DECLARE @j INT = 1;
DECLARE @idUsr INT, @ult4 CHAR(4), @marca VARCHAR(20);
DECLARE @marcas TABLE (idm INT, nombre VARCHAR(20));
INSERT INTO @marcas VALUES (1, 'Visa'), (2, 'Mastercard'), (3, 'Amex');

WHILE @j <= 150
BEGIN
    SET @idUsr = ((@j * 7) % 250) + 1;
    SET @ult4 = RIGHT('0000' + CAST((@j * 1234) % 10000 AS VARCHAR), 4);
    SELECT @marca = nombre FROM @marcas WHERE idm = (@j % 3) + 1;
    INSERT INTO MetodoPago (idUsuario, ultimos_4_digitos, marca, titular, fecha_expiracion, es_predeterminado)
    VALUES (@idUsr, @ult4, @marca, 'Titular ' + CAST(@idUsr AS VARCHAR), DATEADD(MONTH, (@j % 48) + 12, '2025-01-01'), CASE WHEN @j % 5 = 0 THEN 0 ELSE 1 END);
    SET @j = @j + 1;
END;

-- 5. NIVELES DE SUSCRIPCIÓN (40 Niveles)
DECLARE @c INT = 1;
WHILE @c <= 20
BEGIN
    INSERT INTO NivelSuscripcion (idCreador, nombre, descripcion, precio_actual, esta_activo, orden)
    VALUES 
    (@c, 'Fan Básico', 'Acceso al feed general', 5.00, 1, 1),
    (@c, 'Super Fan VIP', 'Contenido exclusivo', 15.00, 1, 2);
    SET @c = @c + 1;
END;

-- 6. PUBLICACIONES (800)
DECLARE @p INT = 1;
DECLARE @tipo VARCHAR(20), @pub_es_publica BIT, @idCrea INT;

WHILE @p <= 800
BEGIN
    SET @idCrea = (@p % 20) + 1;
    SET @pub_es_publica = CASE WHEN (@p % 10) < 3 THEN 0 ELSE 1 END; 
    SET @tipo = CASE WHEN @p % 3 = 0 THEN 'VIDEO' WHEN @p % 3 = 1 THEN 'TEXTO' ELSE 'IMAGEN' END; 

    INSERT INTO Publicacion (idCreador, titulo, fecha_publicacion, es_publica, tipo_contenido)
    VALUES (@idCrea, 'Contenido ' + CAST(@p AS VARCHAR), DATEADD(DAY, -(@p % 300), GETDATE()), @pub_es_publica, @tipo);

    IF @tipo = 'VIDEO'
        INSERT INTO Video (idPublicacion, duracion_seg, resolucion, url_stream) 
        VALUES (@p, 120 + (@p % 600), CASE WHEN @p % 2 = 0 THEN '1080p' ELSE '4K' END, 'https://fanhub.com/stream/v' + CAST(@p AS VARCHAR));
    ELSE IF @tipo = 'TEXTO'
        INSERT INTO Texto (idPublicacion, contenido_html, resumen_gratuito) 
        VALUES (@p, '<p>Post completo ' + CAST(@p AS VARCHAR) + '</p>', 'Resumen ' + CAST(@p AS VARCHAR));
    ELSE
        INSERT INTO Imagen (idPublicacion, ancho, alto, formato, alt_text, url_imagen) 
        VALUES (@p, 1920, 1080, CASE WHEN @p % 2 = 0 THEN 'PNG' ELSE 'JPG' END, 'Img ' + CAST(@p AS VARCHAR), 'https://fanhub.com/media/i' + CAST(@p AS VARCHAR));
    SET @p = @p + 1;
END;

-- 7. SUSCRIPCIONES Y FACTURAS (500)
DECLARE @s INT = 1;
DECLARE @usr INT, @niv INT, @estado VARCHAR(20), @precio DECIMAL(10,2), @fechaInicio DATE, @sub_total DECIMAL(10,2), @impuesto DECIMAL(10,2), @idCreadorFactura INT;

WHILE @s <= 500
BEGIN
    SET @usr = (@s % 230) + 21; 
    SET @niv = (@s % 40) + 1;   
    SELECT @precio = precio_actual, @idCreadorFactura = idCreador FROM NivelSuscripcion WHERE id = @niv;
    SET @fechaInicio = DATEADD(DAY, -(@s % 200) - 30, GETDATE());
    SET @estado = CASE WHEN @s % 4 = 0 THEN 'Cancelada' WHEN @s % 5 = 0 THEN 'Vencida' ELSE 'Activa' END;

    INSERT INTO Suscripcion (idUsuario, idNivel, fecha_inicio, fecha_renovacion, fecha_fin, estado, precio_pactado)
    VALUES (@usr, @niv, @fechaInicio, 
            CASE WHEN @estado = 'Activa' THEN DATEADD(MONTH, 1, @fechaInicio) ELSE NULL END, 
            CASE WHEN @estado IN ('Cancelada', 'Vencida') THEN DATEADD(MONTH, 1, @fechaInicio) ELSE NULL END, 
            @estado, @precio);

    SET @sub_total = @precio;
    SET @impuesto = @sub_total * 0.16;

    INSERT INTO Factura (idSuscripcion, codigo_transaccion, fecha_emision, sub_total, monto_impuesto, monto_total)
    VALUES (@s, CONVERT(VARCHAR, @fechaInicio, 112) + '-' + CAST(@usr AS VARCHAR) + '-' + CAST(@s AS VARCHAR) + '-' + CAST(@niv AS VARCHAR) + '-' + CAST(@idCreadorFactura AS VARCHAR), 
            @fechaInicio, @sub_total, @impuesto, @sub_total + @impuesto);
    SET @s = @s + 1;
END;

-- 8. INTERACCIONES (1500 Reacciones, 1000 Comentarios)
DECLARE @r INT = 1;
DECLARE @usrR INT, @pubR INT, @tipoR INT;

WHILE @r <= 1500
BEGIN
    SET @usrR = (@r % 250) + 1;
    SET @pubR = (@r % 800) + 1;
    SET @tipoR = (@r % 6) + 1;
    IF NOT EXISTS (SELECT 1 FROM UsuarioReaccionPublicacion WHERE idUsuario = @usrR AND idPublicacion = @pubR)
    BEGIN
        INSERT INTO UsuarioReaccionPublicacion (idUsuario, idPublicacion, idTipoReaccion, fecha_reaccion)
        VALUES (@usrR, @pubR, @tipoR, DATEADD(DAY, -(@r % 100), GETDATE()));
    END
    SET @r = @r + 1;
END;

DECLARE @com INT = 1;
WHILE @com <= 900
BEGIN
    INSERT INTO Comentario (idUsuario, idPublicacion, idComentarioPadre, texto, fecha)
    VALUES ((@com % 250) + 1, (@com % 800) + 1, NULL, '¡Gran post! #' + CAST(@com AS VARCHAR), DATEADD(DAY, -(@com % 50), GETDATE()));
    SET @com = @com + 1;
END;

DECLARE @hilo INT = 1;
WHILE @hilo <= 100
BEGIN
    INSERT INTO Comentario (idUsuario, idPublicacion, idComentarioPadre, texto, fecha)
    VALUES ((@hilo % 250) + 1, (@hilo % 800) + 1, @hilo, 'De acuerdo.', GETDATE());
    SET @hilo = @hilo + 1;
END;

-- 9. ETIQUETAS (50)
DECLARE @t INT = 1;
WHILE @t <= 50
BEGIN
    INSERT INTO Etiqueta (nombre) VALUES ('Tag_' + CAST(@t AS VARCHAR));
    SET @t = @t + 1;
END;

DECLARE @pe INT = 1;
DECLARE @pubE INT, @tagE INT;
WHILE @pe <= 1000
BEGIN
    SET @pubE = (@pe % 800) + 1;
    SET @tagE = (@pe % 50) + 1;
    IF NOT EXISTS (SELECT 1 FROM PublicacionEtiqueta WHERE idPublicacion = @pubE AND idEtiqueta = @tagE)
    BEGIN
        INSERT INTO PublicacionEtiqueta (idPublicacion, idEtiqueta) VALUES (@pubE, @tagE);
    END
    SET @pe = @pe + 1;
END;
GO