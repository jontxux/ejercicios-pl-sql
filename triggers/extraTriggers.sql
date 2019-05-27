-- 6. Definir un trigger de base de datos de nombre ALTA_PROV que controle las operaciones de inserción en la tabla Proveedores.

 

-- Este trigger debe dispararse para todo registro que quiera ser insertado en la tabla y cumpla que el código de provincia a insertar es no nulo.

 

-- En el caso en que dicho código de provincia no coincida con alguno de los existentes en la tabla provincias, insertar la nueva provincia en la tabla provincias, con descripcion 'SIN NOMBRE' y prefijo 0.
CREATE OR REPLACE TRIGGER ALTA_PROV
BEFORE INSERT
ON PROVEEDORES
FOR EACH ROW
WHEN(NEW.PROVINCIA IS NOT NULL)

DECLARE
    PRO PROVINCIAS.PROVINCIA%TYPE
BEGIN
    SELECT PROVINCIA INTO PRO
    FROM PROVEEDORES
    WHERE PROVINCIA = :NEW.PROVINCIA;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        INSERT INTO PROVINCIAS
        VALUES(:NEW.PROVINCIA, 'SIN NOMBRE', 0);
END;


-- 7. Modificar el trigger anterior para que además audite dicha operación en una tabla de nombre AUDITAR que contiene una columna de nombre línea y que debe guardar la información siguiente:

-- ·         Fecha y hora.

-- ·         Número proveedor nuevo.

-- ·         Provincia nueva.

--  8. Crear un trigger de nombre MIS_FECHAS que controle la inserción de la cabecera de cada albarán siempre que alguna de las fechas sea nula y proceda de la siguiente manera:

--     Asigne para cada fecha nula la fecha del sistema.

 

-- Estado de la entrega
-- Estado de la entrega 	No entregado
-- Estado de la calificación 	Sin calificar
-- Fecha de entrega 	viernes, 24 de mayo de 2019, 14:35
-- Tiempo restante 	3 horas 41 minutos
-- Última modificación 	-
-- Comentarios de la entrega 	
-- ComentariosComentarios (0)
-- Realizar cambios en la entrega
-- Omitir Navegación
-- Ocultar bloque Navegación
-- Navegación

--     Página Principal

--         Área personal

--         Páginas del sitio

--         Curso actual

--             reto1DM15

--                 Participantes

--                 Insignias

--                 General

--                 Reto 15: EXPLOTACIÓN DE LA BASE DE DATOS AVANZADO

--                     TareaActivar el equipo

--                     ForoDiario Semanal

--                     ArchivoReto 15 Alumno BdD

--                     Tarea¿Cuál puede ser el resultado final del reto?

--                     TareaConocimientos y necesidades de aprendizaje

--                     ArchivoApuntes PL-SQL

--                     TareaSubir Ejercicios de Inicio y Cursores Implícitos

--                     ArchivoMiniprueba PL-SQL Cursores implícitos

--                     TareaSubir miniprueba cursores implícitos

--                     TareaSubir Ejercicios Extra Cursores Implícitos

--                     TareaSubir Ejercicios de Cursores Explícitos

--                     TareaSubir Ejercicios de Uso de Cursores para Actualiza...

--                     TareaSubir Ejercicios de Triggers

--                     TareaSubir Ejercicios Extra Cursores Explícitos y Triggers

--                 Tema 2

--         Mis cursos

-- Omitir Administración
-- Ocultar bloque Administración
-- Administración

--     Administración del curso

