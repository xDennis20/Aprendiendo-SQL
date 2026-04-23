-- Ver las conexiones de amistad de cada integrante en orden.
SELECT followers.leader_id,
       followers.follower_id,
       u.name as leader_name,
       f.name as follower_name
FROM followers
         INNER JOIN "user" u on u.id = followers.leader_id
         INNER JOIN "user" f on f.id = followers.follower_id;

-- Ejecucion de ver los followers de una persona sin recursividad.

SELECT *
FROM followers
WHERE leader_id in (SELECT follower_id
                    FROM followers
                    WHERE leader_id = 1);

/*
 Ejercicio 1:
 Objetivo: Queremos saber quiénes son los autores estrella de nuestra plataforma.
Tablas a usar: users, posts, claps.

El Problema: Necesitamos un reporte que muestre el name del usuario, y la suma total de counter (aplausos) que han recibido todos sus posts publicados (published = true).
Queremos ver solo el Top 3 de autores con más aplausos.
 */

WITH claps_for_post AS (SELECT sum(counter) as count_claps,
                               post_id
                        FROM claps
                        GROUP BY post_id),
     claps_for_autor AS (SELECT created_by,
                                SUM(a.count_claps) as total_claps
                         FROM posts
                                  INNER JOIN claps_for_post a ON a.post_id = posts.post_id
                         GROUP BY created_by)
SELECT a.name,
       b.total_claps
FROM users as a
         JOIN claps_for_autor as b ON b.created_by = a.user_id
ORDER BY total_claps DESC
LIMIT 3;

/*
 Ejercicio 2:
 Objetivo: Trazar la jerarquía corporativa hacia arriba.
Tabla a usar: employees (Tiene id, name, y report_to que es la clave foránea hacia el propio id).
 */

WITH RECURSIVE bosses AS (SELECT id, name, report_to, 1 as level
                          FROM employees
                          WHERE id = 5
                          UNION
                          SELECT a.id, a.name, a.report_to, level + 1
                          FROM employees a
                                   INNER JOIN bosses b ON a.id = b.report_to)
SELECT *
FROM bosses;

/*
 Ejercicio 3:
 CTE Recursivo Nivel Boss (El Hilo de Comentarios estilo Reddit)
 Objetivo: Reconstruir un árbol de respuestas.
 Tabla a usar: comments (Fíjate en comment_id y comment_parent_id).
 */

WITH recursive comments_replies AS (SELECT comment_id, 0 as level, comment_parent_id, content
                                    FROM comments
                                    WHERE comment_id = 1
                                    UNION ALL
                                    SELECT a.comment_id, b.level + 1, a.comment_parent_id, a.content
                                    FROM comments as a
                                             INNER JOIN comments_replies b ON a.comment_parent_id = b.comment_id)
SELECT comment_id,
       REPEAT('---', level) || ' ' || content as replies
FROM comments_replies;

/*
 Ejercicio 4:
El Problema: Queremos un reporte que nos diga qué usuarios están guardando cosas.
Necesitamos el name del usuario, el title de su lista,
y cuántos posts en total tiene guardados dentro de esa lista específica.

 */

WITH report_list_post AS (SELECT count(a.post_id) as total_posts,
                                 a.user_list_id
                          FROM user_list_entry a
                          GROUP BY a.user_list_id)
SELECT a.name,
       b.title,
       c.total_posts
FROM users a
         INNER JOIN user_lists b on a.user_id = b.user_id
         INNER JOIN report_list_post c ON c.user_list_id = b.user_list_id;

/*
 Ejercicio 5:
 Queremos premiar (o castigar) al autor que genera más debate.
 Queremos ver el title del post, el name del autor de ese post, y la cantidad total de comentarios que recibió,
 pero solo del post que tenga la mayor cantidad de comentarios en toda la plataforma (Limit 1).
 */
WITH total_replies as (SELECT count(*) as total_replie,
                              post_id
                       FROM comments
                       GROUP BY post_id)
SELECT b.title,
       a.name as autor,
       c.total_replie
FROM users a
         INNER JOIN posts b on a.user_id = b.created_by
         INNER JOIN total_replies c ON b.post_id = c.post_id
ORDER BY c.total_replie DESC
LIMIT 1;

/*
 Ejercicio 6:
 Invertir el ejercicio 3
 */
WITH RECURSIVE bosses AS (SELECT id, name, report_to, 0 as level
                          FROM employees
                          WHERE report_to is null
                          UNION
                          SELECT a.id, a.name, a.report_to, level + 1
                          FROM employees a
                                   INNER JOIN bosses b ON a.report_to = b.id)
SELECT *
FROM bosses;