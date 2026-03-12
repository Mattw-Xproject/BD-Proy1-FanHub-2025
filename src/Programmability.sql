
USE [FanHub_BD];
GO

-- 1. FUNCIONES (UDF)
CREATE OR ALTER FUNCTION fn_calcular_impuesto (@monto DECIMAL(10,2))
RETURNS DECIMAL(10,2) AS BEGIN RETURN @monto * 0.16; END;
GO

CREATE OR ALTER FUNCTION fn_clasificar_ingreso (@monto DECIMAL(10,2))
RETURNS NVARCHAR(20) AS BEGIN
    DECLARE @clasificacion NVARCHAR(20);
    IF @monto > 1000.00 SET @clasificacion = 'Diamante';
    ELSE IF @monto >= 500.00 AND @monto <= 1000.00 SET @clasificacion = 'Oro';
    ELSE SET @clasificacion = 'Plata';
    RETURN @clasificacion;
END;
GO

CREATE OR ALTER FUNCTION fn_calcular_reputacion (@idCreador INT)
RETURNS DECIMAL(5,2) AS BEGIN
    DECLARE @reputacion DECIMAL(5,2) = 0;
    DECLARE @total_suscriptores INT = (SELECT COUNT(*) FROM Suscripcion S INNER JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE N.idCreador = @idCreador AND S.estado = 'Activa');
    DECLARE @total_reacciones_mes INT = (SELECT COUNT(*) FROM UsuarioReaccionPublicacion URP INNER JOIN Publicacion P ON URP.idPublicacion = P.id WHERE P.idCreador = @idCreador AND URP.fecha_reaccion >= DATEADD(MONTH, -1, GETDATE()));
    DECLARE @meses_antiguedad INT = (SELECT DATEDIFF(MONTH, fecha_registro, GETDATE()) FROM Usuario WHERE id = @idCreador);
    
    SET @reputacion = (@total_suscriptores * 0.5) + (@total_reacciones_mes * 0.1) + (@meses_antiguedad * 2.0);
    IF @reputacion > 100.00 SET @reputacion = 100.00;
    RETURN @reputacion;
END;
GO

-- 2. TRIGGERS
CREATE OR ALTER TRIGGER tr_auditoria_precios ON NivelSuscripcion AFTER UPDATE AS BEGIN
    SET NOCOUNT ON;
    IF UPDATE(precio_actual) BEGIN
        DECLARE @precio_viejo DECIMAL(10,2), @precio_nuevo DECIMAL(10,2);
        SELECT @precio_viejo = d.precio_actual, @precio_nuevo = i.precio_actual FROM deleted d INNER JOIN inserted i ON d.id = i.id;
        IF (@precio_nuevo > @precio_viejo * 1.5) OR (@precio_nuevo < @precio_viejo * 0.5) BEGIN
            RAISERROR('Operación cancelada: El cambio de precio supera el 50%% permitido por seguridad.', 16, 1);
            ROLLBACK TRANSACTION;
        END
    END
END;
GO

CREATE OR ALTER TRIGGER tr_proteccion_menores ON Suscripcion INSTEAD OF INSERT AS BEGIN
    SET NOCOUNT ON;
    DECLARE @idUsuario INT, @idNivel INT, @edad_usuario INT, @es_nsfw BIT;
    DECLARE cur_insert CURSOR FOR SELECT idUsuario, idNivel FROM inserted;
    OPEN cur_insert;
    FETCH NEXT FROM cur_insert INTO @idUsuario, @idNivel;
    WHILE @@FETCH_STATUS = 0 BEGIN
        SELECT @edad_usuario = DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) FROM Usuario WHERE id = @idUsuario;
        SELECT @es_nsfw = C.es_nsfw FROM NivelSuscripcion N INNER JOIN Creador C ON N.idCreador = C.idUsuario WHERE N.id = @idNivel;
        IF (@es_nsfw = 1 AND @edad_usuario < 18) BEGIN
            RAISERROR('Contenido restringido por edad.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END
        FETCH NEXT FROM cur_insert INTO @idUsuario, @idNivel;
    END
    CLOSE cur_insert; DEALLOCATE cur_insert;
    INSERT INTO Suscripcion (idUsuario, idNivel, fecha_inicio, fecha_renovacion, fecha_fin, estado, precio_pactado)
    SELECT idUsuario, idNivel, fecha_inicio, fecha_renovacion, fecha_fin, estado, precio_pactado FROM inserted;
END;
GO

-- 3. PROCEDIMIENTOS ALMACENADOS
CREATE OR ALTER PROCEDURE sp_generar_factura_pago @idSuscripcion INT AS BEGIN
    SET NOCOUNT ON;
    DECLARE @sub_total DECIMAL(10,2), @impuesto DECIMAL(10,2), @codigo_transaccion VARCHAR(100);
    DECLARE @idUsuario INT, @idNivel INT, @idCreador INT, @fecha_actual_str VARCHAR(8);
    SELECT @sub_total = S.precio_pactado, @idUsuario = S.idUsuario, @idNivel = S.idNivel, @idCreador = N.idCreador FROM Suscripcion S INNER JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE S.id = @idSuscripcion;
    SET @impuesto = dbo.fn_calcular_impuesto(@sub_total);
    SET @fecha_actual_str = CONVERT(VARCHAR, GETDATE(), 112); 
    SET @codigo_transaccion = @fecha_actual_str + '-' + CAST(@idUsuario AS VARCHAR) + '-' + CAST(@idSuscripcion AS VARCHAR) + '-' + CAST(@idNivel AS VARCHAR) + '-' + CAST(@idCreador AS VARCHAR);
    INSERT INTO Factura (idSuscripcion, codigo_transaccion, fecha_emision, sub_total, monto_impuesto, monto_total) VALUES (@idSuscripcion, @codigo_transaccion, GETDATE(), @sub_total, @impuesto, @sub_total + @impuesto);
END;
GO

CREATE OR ALTER PROCEDURE sp_crear_suscripcion @idUsuario INT, @idNivel INT, @idMetodoPago INT AS BEGIN
    SET NOCOUNT ON;
    DECLARE @idCreadorDestino INT, @precio_actual DECIMAL(10,2), @nueva_suscripcion_id INT;
    BEGIN TRY
        BEGIN TRANSACTION;
        SELECT @idCreadorDestino = idCreador, @precio_actual = precio_actual FROM NivelSuscripcion WHERE id = @idNivel;
        IF EXISTS (SELECT 1 FROM Suscripcion S INNER JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE S.idUsuario = @idUsuario AND N.idCreador = @idCreadorDestino AND S.estado = 'Activa') BEGIN
            RAISERROR('El usuario ya posee una suscripción activa con este creador.', 16, 1);
        END
        INSERT INTO Suscripcion (idUsuario, idNivel, fecha_inicio, fecha_renovacion, estado, precio_pactado) VALUES (@idUsuario, @idNivel, GETDATE(), DATEADD(MONTH, 1, GETDATE()), 'Activa', @precio_actual);
        SET @nueva_suscripcion_id = SCOPE_IDENTITY();
        EXEC sp_generar_factura_pago @idSuscripcion = @nueva_suscripcion_id;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE(); RAISERROR (@ErrorMessage, 16, 1);
    END CATCH
END;
GO

CREATE OR ALTER PROCEDURE sp_dashboard_creador @idCreador INT, @fechaInicio DATE, @fechaFin DATE AS BEGIN
    SET NOCOUNT ON;
    SELECT (SELECT ISNULL(SUM(F.monto_total), 0) FROM Factura F INNER JOIN Suscripcion S ON F.idSuscripcion = S.id INNER JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE N.idCreador = @idCreador AND F.fecha_emision BETWEEN @fechaInicio AND @fechaFin) AS Total_Ganado,
           (SELECT COUNT(*) FROM Suscripcion S INNER JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE N.idCreador = @idCreador AND S.fecha_inicio BETWEEN @fechaInicio AND @fechaFin) AS Total_Nuevos_Subs;

    SELECT TOP 5 U.nickname, COUNT(C.id) + COUNT(R.idUsuario) AS Total_Interacciones FROM Usuario U LEFT JOIN Comentario C ON U.id = C.idUsuario AND C.idPublicacion IN (SELECT id FROM Publicacion WHERE idCreador = @idCreador) AND C.fecha BETWEEN @fechaInicio AND @fechaFin LEFT JOIN UsuarioReaccionPublicacion R ON U.id = R.idUsuario AND R.idPublicacion IN (SELECT id FROM Publicacion WHERE idCreador = @idCreador) AND R.fecha_reaccion BETWEEN @fechaInicio AND @fechaFin GROUP BY U.nickname ORDER BY Total_Interacciones DESC;

    SELECT TOP 1 P.titulo, P.tipo_contenido, (SELECT COUNT(*) FROM Comentario C WHERE C.idPublicacion = P.id) + (SELECT COUNT(*) FROM UsuarioReaccionPublicacion R WHERE R.idPublicacion = P.id) AS Rendimiento_Total FROM Publicacion P WHERE P.idCreador = @idCreador AND P.fecha_publicacion BETWEEN @fechaInicio AND @fechaFin ORDER BY Rendimiento_Total DESC;
END;
GO

CREATE OR ALTER PROCEDURE sp_publicar_con_etiquetas @idCreador INT, @titulo VARCHAR(255), @es_publica BIT, @tipo_contenido VARCHAR(20), @cadena_etiquetas VARCHAR(MAX) AS BEGIN
    SET NOCOUNT ON;
    DECLARE @idPublicacionNueva INT;
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO Publicacion (idCreador, titulo, fecha_publicacion, es_publica, tipo_contenido) VALUES (@idCreador, @titulo, GETDATE(), @es_publica, @tipo_contenido);
        SET @idPublicacionNueva = SCOPE_IDENTITY();
        
        DECLARE @tag_actual VARCHAR(50);
        DECLARE cur_tags CURSOR FOR SELECT LTRIM(RTRIM(value)) FROM STRING_SPLIT(@cadena_etiquetas, ',');
        OPEN cur_tags; FETCH NEXT FROM cur_tags INTO @tag_actual;
        WHILE @@FETCH_STATUS = 0 BEGIN
            IF @tag_actual <> '' BEGIN
                DECLARE @idEtiquetaActual INT;
                SELECT @idEtiquetaActual = id FROM Etiqueta WHERE nombre = @tag_actual;
                IF @idEtiquetaActual IS NULL BEGIN
                    INSERT INTO Etiqueta (nombre) VALUES (@tag_actual);
                    SET @idEtiquetaActual = SCOPE_IDENTITY();
                END
                INSERT INTO PublicacionEtiqueta (idPublicacion, idEtiqueta) VALUES (@idPublicacionNueva, @idEtiquetaActual);
            END
            FETCH NEXT FROM cur_tags INTO @tag_actual;
        END
        CLOSE cur_tags; DEALLOCATE cur_tags;
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        DECLARE @ErrorMsg NVARCHAR(4000) = ERROR_MESSAGE(); RAISERROR (@ErrorMsg, 16, 1);
    END CATCH
END;
GO