
USE [FanHub_BD];
GO

-- 1. Clasificación de Ganancias (Último mes)
SELECT U.nickname AS Nickname, C.nombre AS Categoria, COUNT(DISTINCT S.idUsuario) AS [Total Suscriptores Activos], ISNULL(SUM(F.monto_total), 0) AS [Monto Facturado], dbo.fn_clasificar_ingreso(ISNULL(SUM(F.monto_total), 0)) AS [Clasificación] FROM Creador CR JOIN Usuario U ON CR.idUsuario = U.id JOIN Categoria C ON CR.idCategoria = C.id LEFT JOIN NivelSuscripcion N ON CR.idUsuario = N.idCreador LEFT JOIN Suscripcion S ON N.id = S.idNivel AND S.estado = 'Activa' LEFT JOIN Factura F ON S.id = F.idSuscripcion AND F.fecha_emision >= DATEADD(MONTH, -1, GETDATE()) GROUP BY U.nickname, C.nombre;

-- 2. Viralidad por Categoría (Max Puntaje)
WITH Puntajes AS (SELECT C.nombre AS Nombre_Categoria, P.titulo AS Titulo_Publicacion, U.nickname AS Creador, (ISNULL(Reacciones.Cant, 0) * 1.5) + (ISNULL(Comentarios.Cant, 0) * 3.0) AS Puntaje, ROW_NUMBER() OVER(PARTITION BY C.id ORDER BY (ISNULL(Reacciones.Cant, 0) * 1.5) + (ISNULL(Comentarios.Cant, 0) * 3.0) DESC) AS rn FROM Publicacion P JOIN Creador CR ON P.idCreador = CR.idUsuario JOIN Usuario U ON CR.idUsuario = U.id JOIN Categoria C ON CR.idCategoria = C.id OUTER APPLY (SELECT COUNT(*) AS Cant FROM UsuarioReaccionPublicacion URP WHERE URP.idPublicacion = P.id) Reacciones OUTER APPLY (SELECT COUNT(*) AS Cant FROM Comentario COM WHERE COM.idPublicacion = P.id) Comentarios)
SELECT Nombre_Categoria AS [Nombre Categoría], Titulo_Publicacion AS [Titulo Publicación], Creador, Puntaje AS [Puntaje Máximo] FROM Puntajes WHERE rn = 1;

-- 3. Análisis de Dominios de Correo (> 10 usuarios)
SELECT SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) AS Dominio, COUNT(*) AS [Cantidad Usuarios] FROM Usuario GROUP BY SUBSTRING(email, CHARINDEX('@', email) + 1, LEN(email)) HAVING COUNT(*) > 10;

-- 4. Promedio de Retención (Churn)
SELECT U.nickname AS [Nickname Creador], N.nombre AS [Nombre Nivel], AVG(DATEDIFF(DAY, S.fecha_inicio, S.fecha_fin)) AS [Promedio Días] FROM Suscripcion S JOIN NivelSuscripcion N ON S.idNivel = N.id JOIN Usuario U ON N.idCreador = U.id WHERE S.estado = 'Cancelada' AND S.fecha_fin IS NOT NULL GROUP BY U.nickname, N.nombre, N.orden ORDER BY U.nickname ASC, N.orden ASC;

-- 5. Tiempo y Peso de Contenido (Gaming)
WITH DatosGaming AS (SELECT U.nickname, V.duracion_seg, V.resolucion FROM Video V JOIN Publicacion P ON V.idPublicacion = P.id JOIN Creador CR ON P.idCreador = CR.idUsuario JOIN Categoria C ON CR.idCategoria = C.id JOIN Usuario U ON CR.idUsuario = U.id WHERE C.nombre = 'Gaming')
SELECT nickname AS Nickname, CAST(SUM(duracion_seg) / 3600 AS VARCHAR) + 'h ' + CAST((SUM(duracion_seg) % 3600) / 60 AS VARCHAR) + 'm' AS [Tiempo Total Formateado], SUM(CASE resolucion WHEN '4K' THEN (duracion_seg / 60.0) * 0.5 WHEN '1080p' THEN (duracion_seg / 60.0) * 0.1 ELSE (duracion_seg / 60.0) * 0.05 END) AS [Estimación GB] FROM DatosGaming GROUP BY nickname;

-- 6. Mapa de Calor Financiero (Participación global)
WITH TotalGlobal AS (SELECT SUM(monto_total) AS GranTotal FROM Factura)
SELECT U.pais AS País, SUM(F.monto_total) AS [Total Facturado], CAST(CAST((SUM(F.monto_total) / MIN(TG.GranTotal)) * 100 AS DECIMAL(5,2)) AS VARCHAR) + '%' AS [Share %] FROM Factura F JOIN Suscripcion S ON F.idSuscripcion = S.id JOIN Usuario U ON S.idUsuario = U.id CROSS JOIN TotalGlobal TG GROUP BY U.pais;

-- 7. Intereses Cruzados (Tecnología y Fitness, > $140 USD)
SELECT U.nickname AS [Nickname Usuario], SUM(F.monto_total) AS [Gasto Total Histórico] FROM Usuario U JOIN Suscripcion S ON U.id = S.idUsuario JOIN Factura F ON S.id = F.idSuscripcion WHERE EXISTS (SELECT 1 FROM Suscripcion S1 JOIN NivelSuscripcion N1 ON S1.idNivel = N1.id JOIN Creador CR1 ON N1.idCreador = CR1.idUsuario JOIN Categoria C1 ON CR1.idCategoria = C1.id WHERE S1.idUsuario = U.id AND C1.nombre = 'Tecnología') AND EXISTS (SELECT 1 FROM Suscripcion S2 JOIN NivelSuscripcion N2 ON S2.idNivel = N2.id JOIN Creador CR2 ON N2.idCreador = CR2.idUsuario JOIN Categoria C2 ON CR2.idCategoria = C2.id WHERE S2.idUsuario = U.id AND C2.nombre = 'Fitness') GROUP BY U.nickname HAVING SUM(F.monto_total) > 140;

-- 8. Generaciones (Gen Z, Millennials, X)
WITH ClasificacionGens AS (SELECT id, CASE WHEN YEAR(fecha_nacimiento) > 2000 THEN 'Gen Z' WHEN YEAR(fecha_nacimiento) BETWEEN 1981 AND 2000 THEN 'Millennials' ELSE 'X' END AS Generacion FROM Usuario WHERE esta_activo = 1)
SELECT CG.Generacion AS [Generación], COUNT(DISTINCT U.id) AS [Cantidad Usuarios Activos], ISNULL(SUM(F.monto_total) / NULLIF(COUNT(DISTINCT U.id), 0), 0) AS [Gasto Promedio Mensual] FROM ClasificacionGens CG JOIN Usuario U ON CG.id = U.id LEFT JOIN Suscripcion S ON U.id = S.idUsuario LEFT JOIN Factura F ON S.id = F.idSuscripcion AND F.fecha_emision >= DATEADD(MONTH, -1, GETDATE()) GROUP BY CG.Generacion;

-- 9. Creadores Polémicos (Ratio > 2.0)
WITH StatsCreador AS (SELECT P.idCreador, COUNT(P.id) AS Cant_Posts, SUM((SELECT COUNT(*) FROM Comentario C WHERE C.idPublicacion = P.id)) AS Total_Comentarios, SUM((SELECT COUNT(*) FROM UsuarioReaccionPublicacion R WHERE R.idPublicacion = P.id)) AS Total_Reacciones FROM Publicacion P GROUP BY P.idCreador)
SELECT U.nickname AS Nickname, S.Cant_Posts AS [Cantidad Posts Evaluados], CAST(S.Total_Comentarios AS DECIMAL(10,2)) / NULLIF(S.Total_Reacciones, 0) AS [Ratio Promedio] FROM StatsCreador S JOIN Usuario U ON S.idCreador = U.id WHERE CAST(S.Total_Comentarios AS DECIMAL(10,2)) / NULLIF(S.Total_Reacciones, 0) > 2.0;

-- 10. Ranking de Creadores (Reputación, solo multimedia, no NSFW)
SELECT U.nickname AS Nickname, (SELECT COUNT(*) FROM Suscripcion S JOIN NivelSuscripcion N ON S.idNivel = N.id WHERE N.idCreador = CR.idUsuario AND S.estado = 'Activa') AS [Total Suscriptores], dbo.fn_calcular_reputacion(CR.idUsuario) AS [Puntaje Reputación] FROM Creador CR JOIN Usuario U ON CR.idUsuario = U.id WHERE CR.es_nsfw = 0 AND NOT EXISTS (SELECT 1 FROM Publicacion P WHERE P.idCreador = CR.idUsuario AND P.tipo_contenido = 'TEXTO') AND EXISTS (SELECT 1 FROM Publicacion P WHERE P.idCreador = CR.idUsuario AND P.tipo_contenido IN ('VIDEO', 'IMAGEN')) ORDER BY [Puntaje Reputación] DESC;

-- 11. Usuarios "Lurkers" (Sin interacciones)
SELECT U.nickname AS Nickname, MAX(S.fecha_inicio) AS [Fecha Última Suscripción], SUM(F.monto_total) AS [Monto Gastado (Estimado)] FROM Usuario U JOIN Suscripcion S ON U.id = S.idUsuario JOIN Factura F ON S.id = F.idSuscripcion WHERE S.estado = 'Activa' AND NOT EXISTS (SELECT 1 FROM Comentario C WHERE C.idUsuario = U.id) AND NOT EXISTS (SELECT 1 FROM UsuarioReaccionPublicacion R WHERE R.idUsuario = U.id) GROUP BY U.nickname;

-- 12. Tendencias (Tags: Top 3 último mes)
SELECT TOP 3 E.nombre AS [Nombre Etiqueta], COUNT(PE.idPublicacion) AS [Cantidad Publicaciones] FROM Etiqueta E JOIN PublicacionEtiqueta PE ON E.id = PE.idEtiqueta JOIN Publicacion P ON PE.idPublicacion = P.id WHERE P.fecha_publicacion >= DATEADD(MONTH, -1, GETDATE()) GROUP BY E.nombre ORDER BY [Cantidad Publicaciones] DESC;

-- 13. Cobertura Total de Reacciones
SELECT U.nickname AS Nickname, COUNT(DISTINCT URP.idTipoReaccion) AS [Total Reacciones Realizadas] FROM Usuario U JOIN UsuarioReaccionPublicacion URP ON U.id = URP.idUsuario GROUP BY U.nickname HAVING COUNT(DISTINCT URP.idTipoReaccion) = (SELECT COUNT(*) FROM TipoReaccion);

-- 14. Reporte de Nómina (Liquidación mes actual)
SELECT CR.banco_nombre AS [Nombre Banco], CR.banco_cuenta AS [Cuenta Bancaria], U.nickname AS [Beneficiario (Nickname)], ISNULL(SUM(F.sub_total), 0) AS [Total Facturado (Bruto)], ISNULL(SUM(F.sub_total), 0) * 0.20 AS [Comisión FanHub], ISNULL(SUM(F.sub_total), 0) * 0.80 AS [Monto a Transferir (Neto)] FROM Creador CR JOIN Usuario U ON CR.idUsuario = U.id JOIN NivelSuscripcion N ON CR.idUsuario = N.idCreador JOIN Suscripcion S ON N.id = S.idNivel JOIN Factura F ON S.id = F.idSuscripcion WHERE MONTH(F.fecha_emision) = MONTH(GETDATE()) AND YEAR(F.fecha_emision) = YEAR(GETDATE()) GROUP BY CR.banco_nombre, CR.banco_cuenta, U.nickname;
GO