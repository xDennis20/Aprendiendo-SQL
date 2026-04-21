WITH post_per_2024 AS (SELECT date_trunc('weeks', posts.created_at) as weeks,
                              count(DISTINCT posts.created_at)      as total_posts,
                              sum(c.counter)                        as sum_claps
                       FROM posts
                                INNER JOIN claps c on posts.post_id = c.post_id
                       GROUP BY weeks
                       ORDER BY weeks DESC)
SELECT *
FROM post_per_2024
WHERE weeks BETWEEN '2024-01-01' AND '2024-12-31';