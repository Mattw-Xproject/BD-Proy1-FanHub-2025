
IF DB_ID('FanHub_BD') IS NULL
BEGIN
    CREATE DATABASE FanHub_BD;
END
GO

USE FanHub_BD;
GO

CREATE TABLE Usuario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    email VARCHAR(255) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    nickname VARCHAR(100) NOT NULL UNIQUE,
    fecha_registro DATE NOT NULL,
    fecha_nacimiento DATE NOT NULL CHECK (fecha_nacimiento <= '2013-01-01'),
    pais VARCHAR(100) NOT NULL,
    esta_activo BIT NOT NULL
);

CREATE TABLE Categoria (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE Creador (
    idUsuario INT PRIMARY KEY,
    biografia VARCHAR(MAX),
    banco_nombre VARCHAR(100) NOT NULL,
    banco_cuenta VARCHAR(50) NOT NULL,
    es_nsfw BIT NOT NULL,
    idCategoria INT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id),
    FOREIGN KEY (idCategoria) REFERENCES Categoria(id)
);

CREATE TABLE MetodoPago (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    ultimos_4_digitos CHAR(4) NOT NULL,
    marca VARCHAR(20) NOT NULL CHECK (marca IN ('Visa', 'Mastercard', 'Amex')),
    titular VARCHAR(150) NOT NULL,
    fecha_expiracion DATE NOT NULL,
    es_predeterminado BIT NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id)
);

CREATE TABLE NivelSuscripcion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCreador INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio_actual DECIMAL(10,2) NOT NULL CHECK (precio_actual >= 0),
    esta_activo BIT NOT NULL,
    orden INT NOT NULL,
    FOREIGN KEY (idCreador) REFERENCES Creador(idUsuario)
);

CREATE TABLE Suscripcion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    idNivel INT NOT NULL,
    fecha_inicio DATE NOT NULL,
    fecha_renovacion DATE,
    fecha_fin DATE,
    estado VARCHAR(20) NOT NULL CHECK (estado IN ('Activa', 'Cancelada', 'Vencida')),
    precio_pactado DECIMAL(10,2) NOT NULL CHECK (precio_pactado >= 0),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id),
    FOREIGN KEY (idNivel) REFERENCES NivelSuscripcion(id)
);

CREATE TABLE Factura (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idSuscripcion INT NOT NULL,
    codigo_transaccion VARCHAR(100) NOT NULL UNIQUE,
    fecha_emision DATETIME NOT NULL,
    sub_total DECIMAL(10,2) NOT NULL CHECK (sub_total >= 0),
    monto_impuesto DECIMAL(10,2) NOT NULL CHECK (monto_impuesto >= 0),
    monto_total DECIMAL(10,2) NOT NULL CHECK (monto_total >= 0),
    FOREIGN KEY (idSuscripcion) REFERENCES Suscripcion(id)
);

CREATE TABLE Publicacion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idCreador INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    fecha_publicacion DATETIME NOT NULL,
    es_publica BIT NOT NULL,
    tipo_contenido VARCHAR(20) NOT NULL CHECK (tipo_contenido IN ('VIDEO', 'TEXTO', 'IMAGEN')),
    FOREIGN KEY (idCreador) REFERENCES Creador(idUsuario)
);

CREATE TABLE Video (
    idPublicacion INT PRIMARY KEY,
    duracion_seg INT NOT NULL,
    resolucion VARCHAR(10) NOT NULL CHECK (resolucion IN ('720p', '1080p', '4K')),
    url_stream VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id)
);

CREATE TABLE Texto (
    idPublicacion INT PRIMARY KEY,
    contenido_html VARCHAR(MAX) NOT NULL,
    resumen_gratuito VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id)
);

CREATE TABLE Imagen (
    idPublicacion INT PRIMARY KEY,
    ancho INT NOT NULL,
    alto INT NOT NULL,
    formato VARCHAR(10) NOT NULL,
    alt_text VARCHAR(255) NOT NULL,
    url_imagen VARCHAR(MAX) NOT NULL,
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id)
);

CREATE TABLE Comentario (
    id INT IDENTITY(1,1) PRIMARY KEY,
    idUsuario INT NOT NULL,
    idPublicacion INT NOT NULL,
    idComentarioPadre INT NULL,
    texto VARCHAR(MAX) NOT NULL,
    fecha DATETIME NOT NULL,
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id),
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id),
    FOREIGN KEY (idComentarioPadre) REFERENCES Comentario(id)
);

CREATE TABLE TipoReaccion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    emoji_code VARCHAR(20) NOT NULL
);

CREATE TABLE UsuarioReaccionPublicacion (
    idUsuario INT NOT NULL,
    idPublicacion INT NOT NULL,
    idTipoReaccion INT NOT NULL,
    fecha_reaccion DATETIME NOT NULL,
    PRIMARY KEY (idUsuario, idPublicacion),
    FOREIGN KEY (idUsuario) REFERENCES Usuario(id),
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id),
    FOREIGN KEY (idTipoReaccion) REFERENCES TipoReaccion(id)
);

CREATE TABLE Etiqueta (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE PublicacionEtiqueta (
    idPublicacion INT NOT NULL,
    idEtiqueta INT NOT NULL,
    PRIMARY KEY (idPublicacion, idEtiqueta),
    FOREIGN KEY (idPublicacion) REFERENCES Publicacion(id),
    FOREIGN KEY (idEtiqueta) REFERENCES Etiqueta(id)
);
GO