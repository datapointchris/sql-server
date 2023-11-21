IF OBJECT_ID('tempdb..#AllIntegers') IS NOT NULL
    DROP TABLE #AllIntegers;

IF OBJECT_ID('tempdb..#Even') IS NOT NULL
    DROP TABLE #Even;

IF OBJECT_ID('tempdb..#MultipleOf3') IS NOT NULL
    DROP TABLE #MultipleOf3;

IF OBJECT_ID('tempdb..#MultipleOf5') IS NOT NULL
    DROP TABLE #MultipleOf5;

CREATE TABLE #AllIntegers (
    id INT IDENTITY(1,1) PRIMARY KEY,
    match_id INT
);

INSERT INTO #AllIntegers (match_id) VALUES
    (1), (2), (3), (4), (5),
    (6), (7), (8), (9), (10),
    (11), (12), (13), (14), (15),
    (16), (17), (18), (19), (20),
    (21), (22), (23), (24), (25),
    (26), (27), (28), (29), (30);

CREATE TABLE #Even (
    id INT IDENTITY(1,1) PRIMARY KEY,
    match_id INT
);

INSERT INTO #Even (match_id) VALUES
    (2), (4), (6), (8), (10),
    (12), (14), (16), (18), (20),
    (22), (24), (26), (28), (30);

CREATE TABLE #MultipleOf3 (
    id INT IDENTITY(1,1) PRIMARY KEY,
    match_id INT
);

INSERT INTO #MultipleOf3 (match_id) VALUES
    (3), (6), (9), (12), (15),
    (18), (21), (24), (27), (30);

CREATE TABLE #MultipleOf5 (
    id INT IDENTITY(1,1) PRIMARY KEY,
    match_id INT
);

INSERT INTO #MultipleOf5 (match_id) VALUES
    (5), (10), (15), (20), (25),
    (30);

SELECT
    a.match_id as num,
    inner_first.join_order AS A_inner_first,
    inner_mixed.join_order AS A_inner_mixed,
    inner_last.join_order AS A_inner_last,
    inner_first_where.join_order AS B_inner_first_where,
    inner_mixed_where.join_order AS B_inner_mixed_where,
    inner_last_where.join_order AS B_inner_last_where,
    inner_first_where_or.join_order AS C_inner_first_where_or,
    inner_mixed_where_or.join_order AS C_inner_mixed_where_or,
    inner_last_where_or.join_order AS C_inner_last_where_or,
    all_lefts.join_order AS D_all_lefts,
    all_lefts_mixed.join_order AS D_all_lefts_mixed,
    all_lefts_last.join_order AS D_all_lefts_last,
    all_lefts_where.join_order AS E_all_lefts_where,
    all_lefts_mixed_where.join_order AS E_all_lefts_mixed_where,
    all_lefts_last_where.join_order AS E_all_lefts_last_where,
    all_lefts_where_or.join_order AS F_all_lefts_where_or,
    all_lefts_mixed_where_or.join_order AS F_all_lefts_mixed_where_or,
    all_lefts_last_where_or.join_order AS F_all_lefts_last_where_or

FROM #AllIntegers a
    FULL JOIN
    (SELECT
        'inner_first' AS join_order,
        a.match_id
    FROM #AllIntegers a
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id) inner_first
    ON a.match_id = inner_first.match_id
    FULL JOIN
    (SELECT
        'inner_mixed' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id) inner_mixed
    ON a.match_id = inner_mixed.match_id
    FULL JOIN
    (SELECT
        'inner_last' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        JOIN #Even e ON a.match_id = e.match_id) inner_last
    ON a.match_id = inner_last.match_id
    FULL JOIN
    (SELECT
        'inner_first_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL) inner_first_where
    ON a.match_id = inner_first_where.match_id
    FULL JOIN
    (SELECT
        'inner_mixed_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL) inner_mixed_where
    ON a.match_id = inner_mixed_where.match_id
    FULL JOIN
    (SELECT
        'inner_last_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        JOIN #Even e ON a.match_id = e.match_id
    WHERE m3.match_id IS NOT NULL) inner_last_where
    ON a.match_id = inner_last_where.match_id
    FULL JOIN
    (SELECT
        'inner_first_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) inner_first_where_or
    ON a.match_id = inner_first_where_or.match_id
    FULL JOIN
    (SELECT
        'inner_mixed_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) inner_mixed_where_or
    ON a.match_id = inner_mixed_where_or.match_id
    FULL JOIN
    (SELECT
        'inner_last_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        JOIN #Even e ON a.match_id = e.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) inner_last_where_or
    ON a.match_id = inner_last_where_or.match_id
    FULL JOIN
    (SELECT
        'all_lefts' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id) all_lefts
    ON a.match_id = all_lefts.match_id
    FULL JOIN
    (SELECT
        'all_lefts_mixed' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id) all_lefts_mixed
    ON a.match_id = all_lefts_mixed.match_id
    FULL JOIN
    (SELECT
        'all_lefts_last' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id) all_lefts_last
    ON a.match_id = all_lefts_last.match_id
    FULL JOIN
    (SELECT
        'all_lefts_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL) all_lefts_where
    ON a.match_id = all_lefts_where.match_id
    FULL JOIN
    (SELECT
        'all_lefts_mixed_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL) all_lefts_mixed_where
    ON a.match_id = all_lefts_mixed_where.match_id
    FULL JOIN
    (SELECT
        'all_lefts_last_where' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id
    WHERE m3.match_id IS NOT NULL) all_lefts_last_where
    ON a.match_id = all_lefts_last_where.match_id
    FULL JOIN
    (SELECT
        'all_lefts_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) all_lefts_where_or
    ON a.match_id = all_lefts_where_or.match_id
    FULL JOIN
    (SELECT
        'all_lefts_mixed_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) all_lefts_mixed_where_or
    ON a.match_id = all_lefts_mixed_where_or.match_id
    FULL JOIN
    (SELECT
        'all_lefts_last_where_or' AS join_order,
        a.match_id
    FROM #AllIntegers a
        LEFT JOIN #MultipleOf5 m5 ON a.match_id = m5.match_id
        LEFT JOIN #Even e ON a.match_id = e.match_id
        LEFT JOIN #MultipleOf3 m3 ON a.match_id = m3.match_id
    WHERE m3.match_id IS NOT NULL
        OR m5.match_id IS NOT NULL) all_lefts_last_where_or
    ON a.match_id = all_lefts_last_where_or.match_id
ORDER BY num;






IF OBJECT_ID('tempdb..#AllIntegers') IS NOT NULL
    DROP TABLE #AllIntegers;

IF OBJECT_ID('tempdb..#Even') IS NOT NULL
    DROP TABLE #Even;

IF OBJECT_ID('tempdb..#MultipleOf3') IS NOT NULL
    DROP TABLE #MultipleOf3;

IF OBJECT_ID('tempdb..#MultipleOf5') IS NOT NULL
    DROP TABLE #MultipleOf5;
