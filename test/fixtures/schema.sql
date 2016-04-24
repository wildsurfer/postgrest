--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

-- Started on 2016-04-24 14:03:36 PDT

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

SET search_path = test, pg_catalog;

ALTER TABLE ONLY test.users_tasks DROP CONSTRAINT users_tasks_user_id_fkey;
ALTER TABLE ONLY test.users_tasks DROP CONSTRAINT users_tasks_task_id_fkey;
ALTER TABLE ONLY test.users_projects DROP CONSTRAINT users_projects_user_id_fkey;
ALTER TABLE ONLY test.users_projects DROP CONSTRAINT users_projects_project_id_fkey;
ALTER TABLE ONLY test.tasks DROP CONSTRAINT tasks_project_id_fkey;
ALTER TABLE ONLY test.projects DROP CONSTRAINT projects_client_id_fkey;
ALTER TABLE ONLY test.has_fk DROP CONSTRAINT has_fk_simple_fk_fkey;
ALTER TABLE ONLY test.has_fk DROP CONSTRAINT has_fk_fk_fkey;
ALTER TABLE ONLY test."ghostBusters" DROP CONSTRAINT "ghostBusters_escapeId_fkey";
ALTER TABLE ONLY test.comments DROP CONSTRAINT comments_task_id_fkey;
ALTER TABLE ONLY test.comments DROP CONSTRAINT comments_commenter_id_fkey;
SET search_path = private, pg_catalog;

ALTER TABLE ONLY private.article_stars DROP CONSTRAINT article_stars_user_id_fkey;
ALTER TABLE ONLY private.article_stars DROP CONSTRAINT article_stars_article_id_fkey;
SET search_path = test, pg_catalog;

DROP TRIGGER secrets_owner_track ON test.authors_only;
DROP TRIGGER insert_insertable_view_with_join ON test.insertable_view_with_join;
SET search_path = private, pg_catalog;

DROP TRIGGER articles_owner_track ON private.articles;
SET search_path = postgrest, pg_catalog;

DROP TRIGGER ensure_auth_role_exists ON postgrest.auth;
SET search_path = test, pg_catalog;

ALTER TABLE ONLY test."withUnique" DROP CONSTRAINT "withUnique_uni_key";
ALTER TABLE ONLY test.users DROP CONSTRAINT users_pkey;
ALTER TABLE ONLY test.tasks DROP CONSTRAINT tasks_pkey;
ALTER TABLE ONLY test.users_tasks DROP CONSTRAINT task_user;
ALTER TABLE ONLY test.projects DROP CONSTRAINT projects_pkey;
ALTER TABLE ONLY test.users_projects DROP CONSTRAINT project_user;
ALTER TABLE ONLY test.menagerie DROP CONSTRAINT menagerie_pkey;
ALTER TABLE ONLY test.items DROP CONSTRAINT items_pkey;
ALTER TABLE ONLY test.has_fk DROP CONSTRAINT has_fk_pkey;
ALTER TABLE ONLY test.simple_pk DROP CONSTRAINT contacts_pkey;
ALTER TABLE ONLY test.compound_pk DROP CONSTRAINT compound_pk_pkey;
ALTER TABLE ONLY test.complex_items DROP CONSTRAINT complex_items_pkey;
ALTER TABLE ONLY test.comments DROP CONSTRAINT comments_pkey;
ALTER TABLE ONLY test.clients DROP CONSTRAINT clients_pkey;
ALTER TABLE ONLY test.auto_incrementing_pk DROP CONSTRAINT auto_incrementing_pk_pkey;
ALTER TABLE ONLY test.authors_only DROP CONSTRAINT authors_only_pkey;
ALTER TABLE ONLY test."Escap3e;" DROP CONSTRAINT "Escap3e;_pkey";
SET search_path = private, pg_catalog;

ALTER TABLE ONLY private.article_stars DROP CONSTRAINT user_article;
ALTER TABLE ONLY private.articles DROP CONSTRAINT articles_pkey;
SET search_path = postgrest, pg_catalog;

ALTER TABLE ONLY postgrest.auth DROP CONSTRAINT auth_pkey;
SET search_path = test, pg_catalog;

ALTER TABLE test.items ALTER COLUMN id DROP DEFAULT;
ALTER TABLE test.has_fk ALTER COLUMN id DROP DEFAULT;
ALTER TABLE test.auto_incrementing_pk ALTER COLUMN id DROP DEFAULT;
SET search_path = "تست", pg_catalog;

DROP TABLE "تست"."موارد";
SET search_path = test, pg_catalog;

DROP TABLE test."withUnique";
DROP TABLE test.users_tasks;
DROP TABLE test.users;
DROP TABLE test.tsearch;
DROP TABLE test.simple_pk;
DROP VIEW test.projects_view;
DROP TABLE test.nullable_integer;
DROP TABLE test.no_pk;
DROP TABLE test.menagerie;
DROP MATERIALIZED VIEW test.materialized_view;
DROP TABLE test.json;
DROP SEQUENCE test.items_id_seq;
DROP TABLE test.insertonly;
DROP VIEW test.insertable_view_with_join;
DROP SEQUENCE test.has_fk_id_seq;
DROP TABLE test.has_fk;
DROP VIEW test.has_count_column;
DROP TABLE test."ghostBusters";
DROP VIEW test.filtered_tasks;
DROP TABLE test.users_projects;
DROP TABLE test.tasks;
DROP TABLE test.projects;
DROP TABLE test.empty_table;
DROP TABLE test.compound_pk;
DROP TABLE test.complex_items;
DROP TABLE test.comments;
DROP TABLE test.clients;
DROP SEQUENCE test.callcounter_count;
DROP SEQUENCE test.auto_incrementing_pk_id_seq;
DROP TABLE test.auto_incrementing_pk;
DROP TABLE test.authors_only;
DROP VIEW test.articles;
DROP VIEW test."articleStars";
DROP TABLE test."Escap3e;";
SET search_path = private, pg_catalog;

DROP TABLE private.articles;
DROP TABLE private.article_stars;
SET search_path = postgrest, pg_catalog;

DROP TABLE postgrest.auth;
SET search_path = test, pg_catalog;

DROP FUNCTION test.test_empty_rowset();
DROP FUNCTION test.sayhello(name text);
DROP FUNCTION test.reveal_big_jwt();
DROP FUNCTION test.problem();
DROP FUNCTION test.login(id text, pass text);
DROP FUNCTION test.jwt_test();
DROP FUNCTION test.insert_insertable_view_with_join();
DROP FUNCTION test.getitemrange(min bigint, max bigint);
DROP FUNCTION test.callcounter();
SET search_path = public, pg_catalog;

DROP FUNCTION public.anti_id(test.items);
DROP FUNCTION public.always_true(test.items);
SET search_path = test, pg_catalog;

DROP TABLE test.items;
SET search_path = postgrest, pg_catalog;

DROP FUNCTION postgrest.update_owner();
DROP FUNCTION postgrest.set_authors_only_owner();
DROP FUNCTION postgrest.check_role_exists();
SET search_path = test, pg_catalog;

DROP TYPE test.enum_menagerie_type;
SET search_path = public, pg_catalog;

DROP TYPE public.jwt_claims;
DROP TYPE public.big_jwt_claims;
DROP EXTENSION plpgsql;
DROP SCHEMA "تست";
DROP SCHEMA test;
DROP SCHEMA public;
DROP SCHEMA private;
DROP SCHEMA postgrest;
--
-- TOC entry 9 (class 2615 OID 33952)
-- Name: postgrest; Type: SCHEMA; Schema: -; Owner: postgrest_test
--

CREATE SCHEMA postgrest;


ALTER SCHEMA postgrest OWNER TO postgrest_test;

--
-- TOC entry 7 (class 2615 OID 33953)
-- Name: private; Type: SCHEMA; Schema: -; Owner: postgrest_test
--

CREATE SCHEMA private;


ALTER SCHEMA private OWNER TO postgrest_test;

--
-- TOC entry 8 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: j
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO j;

--
-- TOC entry 2627 (class 0 OID 0)
-- Dependencies: 8
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: j
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 11 (class 2615 OID 33954)
-- Name: test; Type: SCHEMA; Schema: -; Owner: postgrest_test
--

CREATE SCHEMA test;


ALTER SCHEMA test OWNER TO postgrest_test;

--
-- TOC entry 10 (class 2615 OID 33955)
-- Name: تست; Type: SCHEMA; Schema: -; Owner: postgrest_test
--

CREATE SCHEMA "تست";


ALTER SCHEMA "تست" OWNER TO postgrest_test;

--
-- TOC entry 1 (class 3079 OID 12623)
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- TOC entry 2631 (class 0 OID 0)
-- Dependencies: 1
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- TOC entry 609 (class 1247 OID 33961)
-- Name: big_jwt_claims; Type: TYPE; Schema: public; Owner: postgrest_test
--

CREATE TYPE big_jwt_claims AS (
	iss text,
	sub text,
	aud text,
	exp integer,
	nbf integer,
	iat integer,
	jti text,
	role text,
	"http://postgrest.com/foo" boolean
);


ALTER TYPE big_jwt_claims OWNER TO postgrest_test;

--
-- TOC entry 606 (class 1247 OID 33958)
-- Name: jwt_claims; Type: TYPE; Schema: public; Owner: postgrest_test
--

CREATE TYPE jwt_claims AS (
	role text,
	id text
);


ALTER TYPE jwt_claims OWNER TO postgrest_test;

SET search_path = test, pg_catalog;

--
-- TOC entry 612 (class 1247 OID 33963)
-- Name: enum_menagerie_type; Type: TYPE; Schema: test; Owner: postgrest_test
--

CREATE TYPE enum_menagerie_type AS ENUM (
    'foo',
    'bar'
);


ALTER TYPE enum_menagerie_type OWNER TO postgrest_test;

SET search_path = postgrest, pg_catalog;

--
-- TOC entry 226 (class 1255 OID 33967)
-- Name: check_role_exists(); Type: FUNCTION; Schema: postgrest; Owner: postgrest_test
--

CREATE FUNCTION check_role_exists() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
if not exists (select 1 from pg_roles as r where r.rolname = new.rolname) then
   raise foreign_key_violation using message = 'Cannot create user with unknown role: ' || new.rolname;
   return null;
 end if;
 return new;
end
$$;


ALTER FUNCTION postgrest.check_role_exists() OWNER TO postgrest_test;

--
-- TOC entry 227 (class 1255 OID 33968)
-- Name: set_authors_only_owner(); Type: FUNCTION; Schema: postgrest; Owner: postgrest_test
--

CREATE FUNCTION set_authors_only_owner() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  NEW.owner = current_setting('postgrest.claims.id');
  RETURN NEW;
end
$$;


ALTER FUNCTION postgrest.set_authors_only_owner() OWNER TO postgrest_test;

--
-- TOC entry 228 (class 1255 OID 33969)
-- Name: update_owner(); Type: FUNCTION; Schema: postgrest; Owner: postgrest_test
--

CREATE FUNCTION update_owner() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
   NEW.owner = current_user;
   RETURN NEW;
END;
$$;


ALTER FUNCTION postgrest.update_owner() OWNER TO postgrest_test;

SET search_path = test, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- TOC entry 187 (class 1259 OID 33970)
-- Name: items; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE items (
    id bigint NOT NULL
);


ALTER TABLE items OWNER TO postgrest_test;

SET search_path = public, pg_catalog;

--
-- TOC entry 229 (class 1255 OID 33973)
-- Name: always_true(test.items); Type: FUNCTION; Schema: public; Owner: postgrest_test
--

CREATE FUNCTION always_true(test.items) RETURNS boolean
    LANGUAGE sql STABLE
    AS $$ SELECT true $$;


ALTER FUNCTION public.always_true(test.items) OWNER TO postgrest_test;

--
-- TOC entry 230 (class 1255 OID 33974)
-- Name: anti_id(test.items); Type: FUNCTION; Schema: public; Owner: postgrest_test
--

CREATE FUNCTION anti_id(test.items) RETURNS bigint
    LANGUAGE sql STABLE
    AS $_$ SELECT $1.id * -1 $_$;


ALTER FUNCTION public.anti_id(test.items) OWNER TO postgrest_test;

SET search_path = test, pg_catalog;

--
-- TOC entry 250 (class 1255 OID 33987)
-- Name: callcounter(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION callcounter() RETURNS bigint
    LANGUAGE sql
    AS $$
    SELECT nextval('test.callcounter_count');
$$;


ALTER FUNCTION test.callcounter() OWNER TO postgrest_test;

--
-- TOC entry 231 (class 1255 OID 33978)
-- Name: getitemrange(bigint, bigint); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION getitemrange(min bigint, max bigint) RETURNS SETOF items
    LANGUAGE sql
    AS $_$
    SELECT * FROM test.items WHERE id > $1 AND id <= $2;
$_$;


ALTER FUNCTION test.getitemrange(min bigint, max bigint) OWNER TO postgrest_test;

--
-- TOC entry 232 (class 1255 OID 33979)
-- Name: insert_insertable_view_with_join(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION insert_insertable_view_with_join() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
  INSERT INTO test.auto_incrementing_pk (nullable_string, non_nullable_string) VALUES (NEW.nullable_string, NEW.non_nullable_string);
  RETURN NEW;
end;
$$;


ALTER FUNCTION test.insert_insertable_view_with_join() OWNER TO postgrest_test;

--
-- TOC entry 234 (class 1255 OID 33981)
-- Name: jwt_test(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION jwt_test() RETURNS public.big_jwt_claims
    LANGUAGE sql SECURITY DEFINER
    AS $$
SELECT 'joe'::text as iss, 'fun'::text as sub, 'everyone'::text as aud,
       1300819380 as exp, 1300819380 as nbf, 1300819380 as iat,
       'foo'::text as jti, 'postgrest_test'::text as role,
       true as "http://postgrest.com/foo";
$$;


ALTER FUNCTION test.jwt_test() OWNER TO postgrest_test;

--
-- TOC entry 233 (class 1255 OID 33980)
-- Name: login(text, text); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION login(id text, pass text) RETURNS public.jwt_claims
    LANGUAGE sql SECURITY DEFINER
    AS $$
SELECT rolname::text, id::text FROM postgrest.auth WHERE id = id AND pass = pass;
$$;


ALTER FUNCTION test.login(id text, pass text) OWNER TO postgrest_test;

--
-- TOC entry 248 (class 1255 OID 33983)
-- Name: problem(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION problem() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
      RAISE 'bad thing';
END;
$$;


ALTER FUNCTION test.problem() OWNER TO postgrest_test;

--
-- TOC entry 247 (class 1255 OID 33982)
-- Name: reveal_big_jwt(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION reveal_big_jwt() RETURNS TABLE(iss text, sub text, aud text, exp bigint, nbf bigint, iat bigint, jti text, "http://postgrest.com/foo" boolean)
    LANGUAGE sql SECURITY DEFINER
    AS $$
SELECT current_setting('postgrest.claims.iss') as iss,
       current_setting('postgrest.claims.sub') as sub,
       current_setting('postgrest.claims.aud') as aud,
       current_setting('postgrest.claims.exp')::bigint as exp,
       current_setting('postgrest.claims.nbf')::bigint as nbf,
       current_setting('postgrest.claims.iat')::bigint as iat,
       current_setting('postgrest.claims.jti') as jti,
       -- role is not included in the claims list
       current_setting('postgrest.claims.http://postgrest.com/foo')::boolean
         as "http://postgrest.com/foo";
$$;


ALTER FUNCTION test.reveal_big_jwt() OWNER TO postgrest_test;

--
-- TOC entry 249 (class 1255 OID 33984)
-- Name: sayhello(text); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION sayhello(name text) RETURNS text
    LANGUAGE sql
    AS $_$
    SELECT 'Hello, ' || $1;
$_$;


ALTER FUNCTION test.sayhello(name text) OWNER TO postgrest_test;

--
-- TOC entry 251 (class 1255 OID 33988)
-- Name: test_empty_rowset(); Type: FUNCTION; Schema: test; Owner: postgrest_test
--

CREATE FUNCTION test_empty_rowset() RETURNS SETOF integer
    LANGUAGE sql
    AS $$
    SELECT null::int FROM (SELECT 1) a WHERE false;
$$;


ALTER FUNCTION test.test_empty_rowset() OWNER TO postgrest_test;

SET search_path = postgrest, pg_catalog;

--
-- TOC entry 190 (class 1259 OID 33989)
-- Name: auth; Type: TABLE; Schema: postgrest; Owner: postgrest_test
--

CREATE TABLE auth (
    id character varying NOT NULL,
    rolname name DEFAULT 'postgrest_test_author'::name NOT NULL,
    pass character(60) NOT NULL
);


ALTER TABLE auth OWNER TO postgrest_test;

SET search_path = private, pg_catalog;

--
-- TOC entry 191 (class 1259 OID 33996)
-- Name: article_stars; Type: TABLE; Schema: private; Owner: postgrest_test
--

CREATE TABLE article_stars (
    article_id integer NOT NULL,
    user_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE article_stars OWNER TO postgrest_test;

--
-- TOC entry 192 (class 1259 OID 34000)
-- Name: articles; Type: TABLE; Schema: private; Owner: postgrest_test
--

CREATE TABLE articles (
    id integer NOT NULL,
    body text,
    owner name NOT NULL
);


ALTER TABLE articles OWNER TO postgrest_test;

SET search_path = test, pg_catalog;

--
-- TOC entry 223 (class 1259 OID 34149)
-- Name: Escap3e;; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE "Escap3e;" (
    "so6meIdColumn" integer NOT NULL
);


ALTER TABLE "Escap3e;" OWNER TO postgrest_test;

--
-- TOC entry 193 (class 1259 OID 34006)
-- Name: articleStars; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW "articleStars" AS
 SELECT article_stars.article_id AS "articleId",
    article_stars.user_id AS "userId",
    article_stars.created_at AS "createdAt"
   FROM private.article_stars;


ALTER TABLE "articleStars" OWNER TO postgrest_test;

--
-- TOC entry 194 (class 1259 OID 34010)
-- Name: articles; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW articles AS
 SELECT articles.id,
    articles.body,
    articles.owner
   FROM private.articles;


ALTER TABLE articles OWNER TO postgrest_test;

--
-- TOC entry 195 (class 1259 OID 34014)
-- Name: authors_only; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE authors_only (
    owner character varying NOT NULL,
    secret character varying NOT NULL
);


ALTER TABLE authors_only OWNER TO postgrest_test;

--
-- TOC entry 196 (class 1259 OID 34020)
-- Name: auto_incrementing_pk; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE auto_incrementing_pk (
    id integer NOT NULL,
    nullable_string character varying,
    non_nullable_string character varying NOT NULL,
    inserted_at timestamp with time zone DEFAULT now()
);


ALTER TABLE auto_incrementing_pk OWNER TO postgrest_test;

--
-- TOC entry 197 (class 1259 OID 34027)
-- Name: auto_incrementing_pk_id_seq; Type: SEQUENCE; Schema: test; Owner: postgrest_test
--

CREATE SEQUENCE auto_incrementing_pk_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auto_incrementing_pk_id_seq OWNER TO postgrest_test;

--
-- TOC entry 2638 (class 0 OID 0)
-- Dependencies: 197
-- Name: auto_incrementing_pk_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgrest_test
--

ALTER SEQUENCE auto_incrementing_pk_id_seq OWNED BY auto_incrementing_pk.id;


--
-- TOC entry 189 (class 1259 OID 33985)
-- Name: callcounter_count; Type: SEQUENCE; Schema: test; Owner: postgrest_test
--

CREATE SEQUENCE callcounter_count
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE callcounter_count OWNER TO postgrest_test;

--
-- TOC entry 198 (class 1259 OID 34029)
-- Name: clients; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE clients (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE clients OWNER TO postgrest_test;

--
-- TOC entry 199 (class 1259 OID 34035)
-- Name: comments; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE comments (
    id integer NOT NULL,
    commenter_id integer NOT NULL,
    user_id integer NOT NULL,
    task_id integer NOT NULL,
    content text NOT NULL
);


ALTER TABLE comments OWNER TO postgrest_test;

--
-- TOC entry 200 (class 1259 OID 34041)
-- Name: complex_items; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE complex_items (
    id bigint NOT NULL,
    name text,
    settings pg_catalog.json,
    arr_data integer[]
);


ALTER TABLE complex_items OWNER TO postgrest_test;

--
-- TOC entry 201 (class 1259 OID 34047)
-- Name: compound_pk; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE compound_pk (
    k1 integer NOT NULL,
    k2 integer NOT NULL,
    extra integer
);


ALTER TABLE compound_pk OWNER TO postgrest_test;

--
-- TOC entry 202 (class 1259 OID 34050)
-- Name: empty_table; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE empty_table (
    k character varying NOT NULL,
    extra character varying NOT NULL
);


ALTER TABLE empty_table OWNER TO postgrest_test;

--
-- TOC entry 214 (class 1259 OID 34105)
-- Name: projects; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE projects (
    id integer NOT NULL,
    name text NOT NULL,
    client_id integer
);


ALTER TABLE projects OWNER TO postgrest_test;

--
-- TOC entry 218 (class 1259 OID 34124)
-- Name: tasks; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE tasks (
    id integer NOT NULL,
    name text NOT NULL,
    project_id integer
);


ALTER TABLE tasks OWNER TO postgrest_test;

--
-- TOC entry 217 (class 1259 OID 34121)
-- Name: users_projects; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE users_projects (
    user_id integer NOT NULL,
    project_id integer NOT NULL
);


ALTER TABLE users_projects OWNER TO postgrest_test;

--
-- TOC entry 219 (class 1259 OID 34130)
-- Name: filtered_tasks; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW filtered_tasks AS
 SELECT tasks.id AS "myId",
    tasks.name,
    tasks.project_id AS "projectID"
   FROM tasks
  WHERE ((tasks.project_id IN ( SELECT projects.id
           FROM projects
          WHERE (projects.id = 1))) AND (tasks.project_id IN ( SELECT users_projects.project_id
           FROM users_projects
          WHERE (users_projects.user_id = 1))));


ALTER TABLE filtered_tasks OWNER TO postgrest_test;

--
-- TOC entry 224 (class 1259 OID 34154)
-- Name: ghostBusters; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE "ghostBusters" (
    "escapeId" integer NOT NULL
);


ALTER TABLE "ghostBusters" OWNER TO postgrest_test;

--
-- TOC entry 203 (class 1259 OID 34056)
-- Name: has_count_column; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW has_count_column AS
 SELECT 1 AS count;


ALTER TABLE has_count_column OWNER TO postgrest_test;

--
-- TOC entry 204 (class 1259 OID 34060)
-- Name: has_fk; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE has_fk (
    id bigint NOT NULL,
    auto_inc_fk integer,
    simple_fk character varying(255)
);


ALTER TABLE has_fk OWNER TO postgrest_test;

--
-- TOC entry 205 (class 1259 OID 34063)
-- Name: has_fk_id_seq; Type: SEQUENCE; Schema: test; Owner: postgrest_test
--

CREATE SEQUENCE has_fk_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE has_fk_id_seq OWNER TO postgrest_test;

--
-- TOC entry 2652 (class 0 OID 0)
-- Dependencies: 205
-- Name: has_fk_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgrest_test
--

ALTER SEQUENCE has_fk_id_seq OWNED BY has_fk.id;


--
-- TOC entry 206 (class 1259 OID 34065)
-- Name: insertable_view_with_join; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW insertable_view_with_join AS
 SELECT has_fk.id,
    has_fk.auto_inc_fk,
    has_fk.simple_fk,
    auto_incrementing_pk.nullable_string,
    auto_incrementing_pk.non_nullable_string,
    auto_incrementing_pk.inserted_at
   FROM (has_fk
     JOIN auto_incrementing_pk USING (id));


ALTER TABLE insertable_view_with_join OWNER TO postgrest_test;

--
-- TOC entry 213 (class 1259 OID 34099)
-- Name: insertonly; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE insertonly (
    v text NOT NULL
);


ALTER TABLE insertonly OWNER TO postgrest_test;

--
-- TOC entry 207 (class 1259 OID 34069)
-- Name: items_id_seq; Type: SEQUENCE; Schema: test; Owner: postgrest_test
--

CREATE SEQUENCE items_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE items_id_seq OWNER TO postgrest_test;

--
-- TOC entry 2655 (class 0 OID 0)
-- Dependencies: 207
-- Name: items_id_seq; Type: SEQUENCE OWNED BY; Schema: test; Owner: postgrest_test
--

ALTER SEQUENCE items_id_seq OWNED BY items.id;


--
-- TOC entry 208 (class 1259 OID 34071)
-- Name: json; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE json (
    data pg_catalog.json
);


ALTER TABLE json OWNER TO postgrest_test;

--
-- TOC entry 209 (class 1259 OID 34077)
-- Name: materialized_view; Type: MATERIALIZED VIEW; Schema: test; Owner: postgrest_test
--

CREATE MATERIALIZED VIEW materialized_view AS
 SELECT version() AS version
  WITH NO DATA;


ALTER TABLE materialized_view OWNER TO postgrest_test;

--
-- TOC entry 210 (class 1259 OID 34084)
-- Name: menagerie; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE menagerie (
    "integer" integer NOT NULL,
    double double precision NOT NULL,
    "varchar" character varying NOT NULL,
    "boolean" boolean NOT NULL,
    date date NOT NULL,
    money money NOT NULL,
    enum enum_menagerie_type NOT NULL
);


ALTER TABLE menagerie OWNER TO postgrest_test;

--
-- TOC entry 211 (class 1259 OID 34090)
-- Name: no_pk; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE no_pk (
    a character varying,
    b character varying
);


ALTER TABLE no_pk OWNER TO postgrest_test;

--
-- TOC entry 212 (class 1259 OID 34096)
-- Name: nullable_integer; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE nullable_integer (
    a integer
);


ALTER TABLE nullable_integer OWNER TO postgrest_test;

--
-- TOC entry 215 (class 1259 OID 34111)
-- Name: projects_view; Type: VIEW; Schema: test; Owner: postgrest_test
--

CREATE VIEW projects_view AS
 SELECT projects.id,
    projects.name,
    projects.client_id
   FROM projects;


ALTER TABLE projects_view OWNER TO postgrest_test;

--
-- TOC entry 216 (class 1259 OID 34115)
-- Name: simple_pk; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE simple_pk (
    k character varying NOT NULL,
    extra character varying NOT NULL
);


ALTER TABLE simple_pk OWNER TO postgrest_test;

--
-- TOC entry 220 (class 1259 OID 34134)
-- Name: tsearch; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE tsearch (
    text_search_vector tsvector
);


ALTER TABLE tsearch OWNER TO postgrest_test;

--
-- TOC entry 221 (class 1259 OID 34140)
-- Name: users; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE users (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE users OWNER TO postgrest_test;

--
-- TOC entry 222 (class 1259 OID 34146)
-- Name: users_tasks; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE users_tasks (
    user_id integer NOT NULL,
    task_id integer NOT NULL
);


ALTER TABLE users_tasks OWNER TO postgrest_test;

--
-- TOC entry 225 (class 1259 OID 34162)
-- Name: withUnique; Type: TABLE; Schema: test; Owner: postgrest_test
--

CREATE TABLE "withUnique" (
    uni text,
    extra text
);


ALTER TABLE "withUnique" OWNER TO postgrest_test;

SET search_path = "تست", pg_catalog;

--
-- TOC entry 188 (class 1259 OID 33975)
-- Name: موارد; Type: TABLE; Schema: تست; Owner: postgrest_test
--

CREATE TABLE "موارد" (
    "هویت" bigint NOT NULL
);


ALTER TABLE "موارد" OWNER TO postgrest_test;

SET search_path = test, pg_catalog;

--
-- TOC entry 2441 (class 2604 OID 38647)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY auto_incrementing_pk ALTER COLUMN id SET DEFAULT nextval('auto_incrementing_pk_id_seq'::regclass);


--
-- TOC entry 2442 (class 2604 OID 38648)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY has_fk ALTER COLUMN id SET DEFAULT nextval('has_fk_id_seq'::regclass);


--
-- TOC entry 2437 (class 2604 OID 38649)
-- Name: id; Type: DEFAULT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY items ALTER COLUMN id SET DEFAULT nextval('items_id_seq'::regclass);


SET search_path = postgrest, pg_catalog;

--
-- TOC entry 2446 (class 2606 OID 34174)
-- Name: auth_pkey; Type: CONSTRAINT; Schema: postgrest; Owner: postgrest_test
--

ALTER TABLE ONLY auth
    ADD CONSTRAINT auth_pkey PRIMARY KEY (id);


SET search_path = private, pg_catalog;

--
-- TOC entry 2450 (class 2606 OID 34176)
-- Name: articles_pkey; Type: CONSTRAINT; Schema: private; Owner: postgrest_test
--

ALTER TABLE ONLY articles
    ADD CONSTRAINT articles_pkey PRIMARY KEY (id);


--
-- TOC entry 2448 (class 2606 OID 34178)
-- Name: user_article; Type: CONSTRAINT; Schema: private; Owner: postgrest_test
--

ALTER TABLE ONLY article_stars
    ADD CONSTRAINT user_article PRIMARY KEY (article_id, user_id);


SET search_path = test, pg_catalog;

--
-- TOC entry 2480 (class 2606 OID 34153)
-- Name: Escap3e;_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY "Escap3e;"
    ADD CONSTRAINT "Escap3e;_pkey" PRIMARY KEY ("so6meIdColumn");


--
-- TOC entry 2452 (class 2606 OID 34180)
-- Name: authors_only_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY authors_only
    ADD CONSTRAINT authors_only_pkey PRIMARY KEY (secret);


--
-- TOC entry 2454 (class 2606 OID 34182)
-- Name: auto_incrementing_pk_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY auto_incrementing_pk
    ADD CONSTRAINT auto_incrementing_pk_pkey PRIMARY KEY (id);


--
-- TOC entry 2456 (class 2606 OID 34184)
-- Name: clients_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY clients
    ADD CONSTRAINT clients_pkey PRIMARY KEY (id);


--
-- TOC entry 2458 (class 2606 OID 34186)
-- Name: comments_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- TOC entry 2460 (class 2606 OID 34188)
-- Name: complex_items_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY complex_items
    ADD CONSTRAINT complex_items_pkey PRIMARY KEY (id);


--
-- TOC entry 2462 (class 2606 OID 34190)
-- Name: compound_pk_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY compound_pk
    ADD CONSTRAINT compound_pk_pkey PRIMARY KEY (k1, k2);


--
-- TOC entry 2470 (class 2606 OID 34192)
-- Name: contacts_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY simple_pk
    ADD CONSTRAINT contacts_pkey PRIMARY KEY (k);


--
-- TOC entry 2464 (class 2606 OID 34194)
-- Name: has_fk_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY has_fk
    ADD CONSTRAINT has_fk_pkey PRIMARY KEY (id);


--
-- TOC entry 2444 (class 2606 OID 34196)
-- Name: items_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY items
    ADD CONSTRAINT items_pkey PRIMARY KEY (id);


--
-- TOC entry 2466 (class 2606 OID 34198)
-- Name: menagerie_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY menagerie
    ADD CONSTRAINT menagerie_pkey PRIMARY KEY ("integer");


--
-- TOC entry 2472 (class 2606 OID 34200)
-- Name: project_user; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT project_user PRIMARY KEY (project_id, user_id);


--
-- TOC entry 2468 (class 2606 OID 34202)
-- Name: projects_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- TOC entry 2478 (class 2606 OID 34204)
-- Name: task_user; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT task_user PRIMARY KEY (task_id, user_id);


--
-- TOC entry 2474 (class 2606 OID 34206)
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- TOC entry 2476 (class 2606 OID 34208)
-- Name: users_pkey; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- TOC entry 2482 (class 2606 OID 34169)
-- Name: withUnique_uni_key; Type: CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY "withUnique"
    ADD CONSTRAINT "withUnique_uni_key" UNIQUE (uni);


SET search_path = postgrest, pg_catalog;

--
-- TOC entry 2496 (class 2620 OID 34210)
-- Name: ensure_auth_role_exists; Type: TRIGGER; Schema: postgrest; Owner: postgrest_test
--

CREATE CONSTRAINT TRIGGER ensure_auth_role_exists AFTER INSERT OR UPDATE ON auth NOT DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE PROCEDURE check_role_exists();


SET search_path = private, pg_catalog;

--
-- TOC entry 2497 (class 2620 OID 34211)
-- Name: articles_owner_track; Type: TRIGGER; Schema: private; Owner: postgrest_test
--

CREATE TRIGGER articles_owner_track BEFORE INSERT OR UPDATE ON articles FOR EACH ROW EXECUTE PROCEDURE postgrest.update_owner();


SET search_path = test, pg_catalog;

--
-- TOC entry 2499 (class 2620 OID 34212)
-- Name: insert_insertable_view_with_join; Type: TRIGGER; Schema: test; Owner: postgrest_test
--

CREATE TRIGGER insert_insertable_view_with_join INSTEAD OF INSERT ON insertable_view_with_join FOR EACH ROW EXECUTE PROCEDURE insert_insertable_view_with_join();


--
-- TOC entry 2498 (class 2620 OID 34213)
-- Name: secrets_owner_track; Type: TRIGGER; Schema: test; Owner: postgrest_test
--

CREATE TRIGGER secrets_owner_track BEFORE INSERT OR UPDATE ON authors_only FOR EACH ROW EXECUTE PROCEDURE postgrest.set_authors_only_owner();


SET search_path = private, pg_catalog;

--
-- TOC entry 2483 (class 2606 OID 34214)
-- Name: article_stars_article_id_fkey; Type: FK CONSTRAINT; Schema: private; Owner: postgrest_test
--

ALTER TABLE ONLY article_stars
    ADD CONSTRAINT article_stars_article_id_fkey FOREIGN KEY (article_id) REFERENCES articles(id);


--
-- TOC entry 2484 (class 2606 OID 34219)
-- Name: article_stars_user_id_fkey; Type: FK CONSTRAINT; Schema: private; Owner: postgrest_test
--

ALTER TABLE ONLY article_stars
    ADD CONSTRAINT article_stars_user_id_fkey FOREIGN KEY (user_id) REFERENCES test.users(id);


SET search_path = test, pg_catalog;

--
-- TOC entry 2485 (class 2606 OID 34224)
-- Name: comments_commenter_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_commenter_id_fkey FOREIGN KEY (commenter_id) REFERENCES users(id);


--
-- TOC entry 2486 (class 2606 OID 34229)
-- Name: comments_task_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT comments_task_id_fkey FOREIGN KEY (task_id, user_id) REFERENCES users_tasks(task_id, user_id);


--
-- TOC entry 2495 (class 2606 OID 34157)
-- Name: ghostBusters_escapeId_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY "ghostBusters"
    ADD CONSTRAINT "ghostBusters_escapeId_fkey" FOREIGN KEY ("escapeId") REFERENCES "Escap3e;"("so6meIdColumn");


--
-- TOC entry 2487 (class 2606 OID 34234)
-- Name: has_fk_fk_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY has_fk
    ADD CONSTRAINT has_fk_fk_fkey FOREIGN KEY (auto_inc_fk) REFERENCES auto_incrementing_pk(id);


--
-- TOC entry 2488 (class 2606 OID 34239)
-- Name: has_fk_simple_fk_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY has_fk
    ADD CONSTRAINT has_fk_simple_fk_fkey FOREIGN KEY (simple_fk) REFERENCES simple_pk(k);


--
-- TOC entry 2489 (class 2606 OID 34244)
-- Name: projects_client_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY projects
    ADD CONSTRAINT projects_client_id_fkey FOREIGN KEY (client_id) REFERENCES clients(id);


--
-- TOC entry 2492 (class 2606 OID 34249)
-- Name: tasks_project_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_project_id_fkey FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- TOC entry 2490 (class 2606 OID 34254)
-- Name: users_projects_project_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT users_projects_project_id_fkey FOREIGN KEY (project_id) REFERENCES projects(id);


--
-- TOC entry 2491 (class 2606 OID 34259)
-- Name: users_projects_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_projects
    ADD CONSTRAINT users_projects_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2493 (class 2606 OID 34264)
-- Name: users_tasks_task_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT users_tasks_task_id_fkey FOREIGN KEY (task_id) REFERENCES tasks(id);


--
-- TOC entry 2494 (class 2606 OID 34269)
-- Name: users_tasks_user_id_fkey; Type: FK CONSTRAINT; Schema: test; Owner: postgrest_test
--

ALTER TABLE ONLY users_tasks
    ADD CONSTRAINT users_tasks_user_id_fkey FOREIGN KEY (user_id) REFERENCES users(id);


--
-- TOC entry 2626 (class 0 OID 0)
-- Dependencies: 9
-- Name: postgrest; Type: ACL; Schema: -; Owner: postgrest_test
--

REVOKE ALL ON SCHEMA postgrest FROM PUBLIC;
REVOKE ALL ON SCHEMA postgrest FROM postgrest_test;
GRANT ALL ON SCHEMA postgrest TO postgrest_test;
GRANT USAGE ON SCHEMA postgrest TO postgrest_test_anonymous;


--
-- TOC entry 2628 (class 0 OID 0)
-- Dependencies: 8
-- Name: public; Type: ACL; Schema: -; Owner: j
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM j;
GRANT ALL ON SCHEMA public TO j;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- TOC entry 2629 (class 0 OID 0)
-- Dependencies: 11
-- Name: test; Type: ACL; Schema: -; Owner: postgrest_test
--

REVOKE ALL ON SCHEMA test FROM PUBLIC;
REVOKE ALL ON SCHEMA test FROM postgrest_test;
GRANT ALL ON SCHEMA test TO postgrest_test;
GRANT USAGE ON SCHEMA test TO postgrest_test_anonymous;
GRANT USAGE ON SCHEMA test TO postgrest_test_author;


--
-- TOC entry 2630 (class 0 OID 0)
-- Dependencies: 10
-- Name: تست; Type: ACL; Schema: -; Owner: postgrest_test
--

REVOKE ALL ON SCHEMA "تست" FROM PUBLIC;
REVOKE ALL ON SCHEMA "تست" FROM postgrest_test;
GRANT ALL ON SCHEMA "تست" TO postgrest_test;
GRANT USAGE ON SCHEMA "تست" TO postgrest_test_anonymous;


--
-- TOC entry 2632 (class 0 OID 0)
-- Dependencies: 187
-- Name: items; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE items FROM PUBLIC;
REVOKE ALL ON TABLE items FROM postgrest_test;
GRANT ALL ON TABLE items TO postgrest_test;
GRANT ALL ON TABLE items TO postgrest_test_anonymous;


--
-- TOC entry 2633 (class 0 OID 0)
-- Dependencies: 223
-- Name: Escap3e;; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE "Escap3e;" FROM PUBLIC;
REVOKE ALL ON TABLE "Escap3e;" FROM postgrest_test;
GRANT ALL ON TABLE "Escap3e;" TO postgrest_test;
GRANT ALL ON TABLE "Escap3e;" TO postgrest_test_anonymous;


--
-- TOC entry 2634 (class 0 OID 0)
-- Dependencies: 193
-- Name: articleStars; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE "articleStars" FROM PUBLIC;
REVOKE ALL ON TABLE "articleStars" FROM postgrest_test;
GRANT ALL ON TABLE "articleStars" TO postgrest_test;
GRANT ALL ON TABLE "articleStars" TO postgrest_test_anonymous;


--
-- TOC entry 2635 (class 0 OID 0)
-- Dependencies: 194
-- Name: articles; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE articles FROM PUBLIC;
REVOKE ALL ON TABLE articles FROM postgrest_test;
GRANT ALL ON TABLE articles TO postgrest_test;
GRANT ALL ON TABLE articles TO postgrest_test_anonymous;


--
-- TOC entry 2636 (class 0 OID 0)
-- Dependencies: 195
-- Name: authors_only; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE authors_only FROM PUBLIC;
REVOKE ALL ON TABLE authors_only FROM postgrest_test;
GRANT ALL ON TABLE authors_only TO postgrest_test;
GRANT ALL ON TABLE authors_only TO postgrest_test_author;


--
-- TOC entry 2637 (class 0 OID 0)
-- Dependencies: 196
-- Name: auto_incrementing_pk; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE auto_incrementing_pk FROM PUBLIC;
REVOKE ALL ON TABLE auto_incrementing_pk FROM postgrest_test;
GRANT ALL ON TABLE auto_incrementing_pk TO postgrest_test;
GRANT ALL ON TABLE auto_incrementing_pk TO postgrest_test_anonymous;


--
-- TOC entry 2639 (class 0 OID 0)
-- Dependencies: 197
-- Name: auto_incrementing_pk_id_seq; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON SEQUENCE auto_incrementing_pk_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE auto_incrementing_pk_id_seq FROM postgrest_test;
GRANT ALL ON SEQUENCE auto_incrementing_pk_id_seq TO postgrest_test;
GRANT USAGE ON SEQUENCE auto_incrementing_pk_id_seq TO postgrest_test_anonymous;


--
-- TOC entry 2640 (class 0 OID 0)
-- Dependencies: 189
-- Name: callcounter_count; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON SEQUENCE callcounter_count FROM PUBLIC;
REVOKE ALL ON SEQUENCE callcounter_count FROM postgrest_test;
GRANT ALL ON SEQUENCE callcounter_count TO postgrest_test;
GRANT USAGE ON SEQUENCE callcounter_count TO postgrest_test_anonymous;


--
-- TOC entry 2641 (class 0 OID 0)
-- Dependencies: 198
-- Name: clients; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE clients FROM PUBLIC;
REVOKE ALL ON TABLE clients FROM postgrest_test;
GRANT ALL ON TABLE clients TO postgrest_test;
GRANT ALL ON TABLE clients TO postgrest_test_anonymous;


--
-- TOC entry 2642 (class 0 OID 0)
-- Dependencies: 199
-- Name: comments; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE comments FROM PUBLIC;
REVOKE ALL ON TABLE comments FROM postgrest_test;
GRANT ALL ON TABLE comments TO postgrest_test;
GRANT ALL ON TABLE comments TO postgrest_test_anonymous;


--
-- TOC entry 2643 (class 0 OID 0)
-- Dependencies: 200
-- Name: complex_items; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE complex_items FROM PUBLIC;
REVOKE ALL ON TABLE complex_items FROM postgrest_test;
GRANT ALL ON TABLE complex_items TO postgrest_test;
GRANT ALL ON TABLE complex_items TO postgrest_test_anonymous;


--
-- TOC entry 2644 (class 0 OID 0)
-- Dependencies: 201
-- Name: compound_pk; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE compound_pk FROM PUBLIC;
REVOKE ALL ON TABLE compound_pk FROM postgrest_test;
GRANT ALL ON TABLE compound_pk TO postgrest_test;
GRANT ALL ON TABLE compound_pk TO postgrest_test_anonymous;


--
-- TOC entry 2645 (class 0 OID 0)
-- Dependencies: 214
-- Name: projects; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE projects FROM PUBLIC;
REVOKE ALL ON TABLE projects FROM postgrest_test;
GRANT ALL ON TABLE projects TO postgrest_test;
GRANT ALL ON TABLE projects TO postgrest_test_anonymous;


--
-- TOC entry 2646 (class 0 OID 0)
-- Dependencies: 218
-- Name: tasks; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE tasks FROM PUBLIC;
REVOKE ALL ON TABLE tasks FROM postgrest_test;
GRANT ALL ON TABLE tasks TO postgrest_test;
GRANT ALL ON TABLE tasks TO postgrest_test_anonymous;


--
-- TOC entry 2647 (class 0 OID 0)
-- Dependencies: 217
-- Name: users_projects; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE users_projects FROM PUBLIC;
REVOKE ALL ON TABLE users_projects FROM postgrest_test;
GRANT ALL ON TABLE users_projects TO postgrest_test;
GRANT ALL ON TABLE users_projects TO postgrest_test_anonymous;


--
-- TOC entry 2648 (class 0 OID 0)
-- Dependencies: 219
-- Name: filtered_tasks; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE filtered_tasks FROM PUBLIC;
REVOKE ALL ON TABLE filtered_tasks FROM postgrest_test;
GRANT ALL ON TABLE filtered_tasks TO postgrest_test;
GRANT ALL ON TABLE filtered_tasks TO postgrest_test_anonymous;


--
-- TOC entry 2649 (class 0 OID 0)
-- Dependencies: 224
-- Name: ghostBusters; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE "ghostBusters" FROM PUBLIC;
REVOKE ALL ON TABLE "ghostBusters" FROM postgrest_test;
GRANT ALL ON TABLE "ghostBusters" TO postgrest_test;
GRANT ALL ON TABLE "ghostBusters" TO postgrest_test_anonymous;


--
-- TOC entry 2650 (class 0 OID 0)
-- Dependencies: 203
-- Name: has_count_column; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE has_count_column FROM PUBLIC;
REVOKE ALL ON TABLE has_count_column FROM postgrest_test;
GRANT ALL ON TABLE has_count_column TO postgrest_test;
GRANT ALL ON TABLE has_count_column TO postgrest_test_anonymous;


--
-- TOC entry 2651 (class 0 OID 0)
-- Dependencies: 204
-- Name: has_fk; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE has_fk FROM PUBLIC;
REVOKE ALL ON TABLE has_fk FROM postgrest_test;
GRANT ALL ON TABLE has_fk TO postgrest_test;
GRANT ALL ON TABLE has_fk TO postgrest_test_anonymous;


--
-- TOC entry 2653 (class 0 OID 0)
-- Dependencies: 206
-- Name: insertable_view_with_join; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE insertable_view_with_join FROM PUBLIC;
REVOKE ALL ON TABLE insertable_view_with_join FROM postgrest_test;
GRANT ALL ON TABLE insertable_view_with_join TO postgrest_test;
GRANT ALL ON TABLE insertable_view_with_join TO postgrest_test_anonymous;


--
-- TOC entry 2654 (class 0 OID 0)
-- Dependencies: 213
-- Name: insertonly; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE insertonly FROM PUBLIC;
REVOKE ALL ON TABLE insertonly FROM postgrest_test;
GRANT ALL ON TABLE insertonly TO postgrest_test;
GRANT INSERT ON TABLE insertonly TO postgrest_test_anonymous;


--
-- TOC entry 2656 (class 0 OID 0)
-- Dependencies: 207
-- Name: items_id_seq; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON SEQUENCE items_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE items_id_seq FROM postgrest_test;
GRANT ALL ON SEQUENCE items_id_seq TO postgrest_test;
GRANT USAGE ON SEQUENCE items_id_seq TO postgrest_test_anonymous;


--
-- TOC entry 2657 (class 0 OID 0)
-- Dependencies: 208
-- Name: json; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE json FROM PUBLIC;
REVOKE ALL ON TABLE json FROM postgrest_test;
GRANT ALL ON TABLE json TO postgrest_test;
GRANT ALL ON TABLE json TO postgrest_test_anonymous;


--
-- TOC entry 2658 (class 0 OID 0)
-- Dependencies: 209
-- Name: materialized_view; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE materialized_view FROM PUBLIC;
REVOKE ALL ON TABLE materialized_view FROM postgrest_test;
GRANT ALL ON TABLE materialized_view TO postgrest_test;
GRANT ALL ON TABLE materialized_view TO postgrest_test_anonymous;


--
-- TOC entry 2659 (class 0 OID 0)
-- Dependencies: 210
-- Name: menagerie; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE menagerie FROM PUBLIC;
REVOKE ALL ON TABLE menagerie FROM postgrest_test;
GRANT ALL ON TABLE menagerie TO postgrest_test;
GRANT ALL ON TABLE menagerie TO postgrest_test_anonymous;


--
-- TOC entry 2660 (class 0 OID 0)
-- Dependencies: 211
-- Name: no_pk; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE no_pk FROM PUBLIC;
REVOKE ALL ON TABLE no_pk FROM postgrest_test;
GRANT ALL ON TABLE no_pk TO postgrest_test;
GRANT ALL ON TABLE no_pk TO postgrest_test_anonymous;


--
-- TOC entry 2661 (class 0 OID 0)
-- Dependencies: 212
-- Name: nullable_integer; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE nullable_integer FROM PUBLIC;
REVOKE ALL ON TABLE nullable_integer FROM postgrest_test;
GRANT ALL ON TABLE nullable_integer TO postgrest_test;
GRANT ALL ON TABLE nullable_integer TO postgrest_test_anonymous;


--
-- TOC entry 2662 (class 0 OID 0)
-- Dependencies: 215
-- Name: projects_view; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE projects_view FROM PUBLIC;
REVOKE ALL ON TABLE projects_view FROM postgrest_test;
GRANT ALL ON TABLE projects_view TO postgrest_test;
GRANT ALL ON TABLE projects_view TO postgrest_test_anonymous;


--
-- TOC entry 2663 (class 0 OID 0)
-- Dependencies: 216
-- Name: simple_pk; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE simple_pk FROM PUBLIC;
REVOKE ALL ON TABLE simple_pk FROM postgrest_test;
GRANT ALL ON TABLE simple_pk TO postgrest_test;
GRANT ALL ON TABLE simple_pk TO postgrest_test_anonymous;


--
-- TOC entry 2664 (class 0 OID 0)
-- Dependencies: 220
-- Name: tsearch; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE tsearch FROM PUBLIC;
REVOKE ALL ON TABLE tsearch FROM postgrest_test;
GRANT ALL ON TABLE tsearch TO postgrest_test;
GRANT ALL ON TABLE tsearch TO postgrest_test_anonymous;


--
-- TOC entry 2665 (class 0 OID 0)
-- Dependencies: 221
-- Name: users; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgrest_test;
GRANT ALL ON TABLE users TO postgrest_test;
GRANT ALL ON TABLE users TO postgrest_test_anonymous;


--
-- TOC entry 2666 (class 0 OID 0)
-- Dependencies: 222
-- Name: users_tasks; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE users_tasks FROM PUBLIC;
REVOKE ALL ON TABLE users_tasks FROM postgrest_test;
GRANT ALL ON TABLE users_tasks TO postgrest_test;
GRANT ALL ON TABLE users_tasks TO postgrest_test_anonymous;


--
-- TOC entry 2667 (class 0 OID 0)
-- Dependencies: 225
-- Name: withUnique; Type: ACL; Schema: test; Owner: postgrest_test
--

REVOKE ALL ON TABLE "withUnique" FROM PUBLIC;
REVOKE ALL ON TABLE "withUnique" FROM postgrest_test;
GRANT ALL ON TABLE "withUnique" TO postgrest_test;
GRANT ALL ON TABLE "withUnique" TO postgrest_test_anonymous;


SET search_path = "تست", pg_catalog;

--
-- TOC entry 2668 (class 0 OID 0)
-- Dependencies: 188
-- Name: موارد; Type: ACL; Schema: تست; Owner: postgrest_test
--

REVOKE ALL ON TABLE "موارد" FROM PUBLIC;
REVOKE ALL ON TABLE "موارد" FROM postgrest_test;
GRANT ALL ON TABLE "موارد" TO postgrest_test;
GRANT ALL ON TABLE "موارد" TO postgrest_test_anonymous;


-- Completed on 2016-04-24 14:03:36 PDT

--
-- PostgreSQL database dump complete
--

