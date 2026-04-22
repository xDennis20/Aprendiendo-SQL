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