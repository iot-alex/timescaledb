-- Copyright (c) 2016-2018  Timescale, Inc. All Rights Reserved.
--
-- This file is licensed under the Apache License,
-- see LICENSE-APACHE at the top level directory.

\ir include/insert_two_partitions.sql

SELECT * FROM hypertable_relation_size('"public"."two_Partitions"');
SELECT * FROM hypertable_relation_size_pretty('"public"."two_Partitions"');
SELECT * FROM chunk_relation_size('"public"."two_Partitions"');
SELECT * FROM chunk_relation_size_pretty('"public"."two_Partitions"');
SELECT * FROM indexes_relation_size('"public"."two_Partitions"');
SELECT * FROM indexes_relation_size_pretty('"public"."two_Partitions"');

CREATE TABLE timestamp_partitioned(time TIMESTAMP, value TEXT);
SELECT * FROM create_hypertable('timestamp_partitioned', 'time', 'value', 2);

INSERT INTO timestamp_partitioned VALUES('2004-10-19 10:23:54', '10');
INSERT INTO timestamp_partitioned VALUES('2004-12-19 10:23:54', '30');
SELECT * FROM chunk_relation_size('timestamp_partitioned');
SELECT * FROM chunk_relation_size_pretty('timestamp_partitioned');


CREATE TABLE timestamp_partitioned_2(time TIMESTAMP, value CHAR(9));
SELECT * FROM create_hypertable('timestamp_partitioned_2', 'time', 'value', 2);

INSERT INTO timestamp_partitioned_2 VALUES('2004-10-19 10:23:54', '10');
INSERT INTO timestamp_partitioned_2 VALUES('2004-12-19 10:23:54', '30');
SELECT * FROM chunk_relation_size('timestamp_partitioned_2');
SELECT * FROM chunk_relation_size_pretty('timestamp_partitioned_2');

CREATE TABLE toast_test(time TIMESTAMP, value TEXT);
-- Set storage type to EXTERNAL to prevent PostgreSQL from compressing my
-- easily compressable string and instead store it with TOAST
ALTER TABLE toast_test ALTER COLUMN value SET STORAGE EXTERNAL;
SELECT * FROM create_hypertable('toast_test', 'time');

INSERT INTO toast_test VALUES('2004-10-19 10:23:54', $$
this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k. this must be over 2k.
$$);
SELECT * FROM chunk_relation_size('toast_test');
SELECT * FROM chunk_relation_size_pretty('toast_test');

CREATE TABLE approx_count(time TIMESTAMP, value int);
SELECT * FROM create_hypertable('approx_count', 'time');
INSERT INTO approx_count VALUES('2004-01-01 10:00:01', 1);
INSERT INTO approx_count VALUES('2004-01-01 10:00:02', 2);
INSERT INTO approx_count VALUES('2004-01-01 10:00:03', 3);
INSERT INTO approx_count VALUES('2004-01-01 10:00:04', 4);
INSERT INTO approx_count VALUES('2004-01-01 10:00:05', 5);
INSERT INTO approx_count VALUES('2004-01-01 10:00:06', 6);
INSERT INTO approx_count VALUES('2004-01-01 10:00:07', 7);
INSERT INTO approx_count VALUES('2004-01-01 10:00:08', 8);
INSERT INTO approx_count VALUES('2004-01-01 10:00:09', 9);
INSERT INTO approx_count VALUES('2004-01-01 10:00:10', 10);
ANALYZE approx_count;

SELECT * FROM hypertable_approximate_row_count('approx_count');

-- all hypertables
SELECT * FROM hypertable_approximate_row_count();
