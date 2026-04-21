CREATE MATERIALIZED VIEW  comments_per_weeks_mat AS
(SELECT date_trunc('weeks', posts.created_at) as weeks,
       count(DISTINCT posts.created_at) as total_posts,
       sum(c.counter) as sum_claps
FROM posts
INNER JOIN claps c on posts.post_id = c.post_id
GROUP BY weeks
ORDER BY weeks DESC); -- Esto es una vista materializada,
-- A diferencia de una vista normal este cuando lo creamos
-- Este guarda los datos de ese momento como una tabla y cuando lo llamamos ya no ejecuta el query
-- Por lo que lo hace mas eficiente al momento de hacer consultas.


CREATE OR REPLACE VIEW  comments_per_weeks AS
(SELECT date_trunc('weeks', posts.created_at) as weeks,
        count(DISTINCT posts.created_at) as total_posts,
        sum(c.counter) as sum_claps
FROM posts
         INNER JOIN claps c on posts.post_id = c.post_id
GROUP BY weeks
ORDER BY weeks DESC); -- Esto es una vista,
-- sirve para guardar un query como si fuera una tabla pero no lo es ya que
-- cada vez que lo llamamos ejecuta todo el query por lo que no es tan eficiente

SELECT * FROM comments_per_weeks;

SELECT * FROM comments_per_weeks_mat;

REFRESH MATERIALIZED VIEW comments_per_weeks_mat; -- Esto sirve para actualizar los datos de la vista materializada

ALTER VIEW comments_per_weeks RENAME TO post_per_weeks; -- Cambiar de nombre una vista

ALTER MATERIALIZED VIEW comments_per_weeks_mat RENAME TO post_per_weeks_mat; -- Cambiar de nombre una vista materializada