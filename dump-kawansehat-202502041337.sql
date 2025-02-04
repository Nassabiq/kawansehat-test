--
-- PostgreSQL database cluster dump
--

-- Started on 2025-02-04 13:37:08 WIB

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE postgres;
ALTER ROLE postgres WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS;

--
-- User Configurations
--








--
-- Databases
--

--
-- Database "kawansehat" dump
--

--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Ubuntu 17.2-1.pgdg24.04+1)
-- Dumped by pg_dump version 17.2 (Ubuntu 17.2-1.pgdg24.04+1)

-- Started on 2025-02-04 13:37:08 WIB

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 3466 (class 1262 OID 16389)
-- Name: kawansehat; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE kawansehat WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE kawansehat OWNER TO postgres;

\connect kawansehat

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- TOC entry 5 (class 2615 OID 17080)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 3467 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA public IS '';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 17100)
-- Name: File; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."File" (
    id integer NOT NULL,
    "folderId" integer NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    size character varying(255) NOT NULL,
    created_at timestamp(3) without time zone NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."File" OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 17099)
-- Name: File_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."File_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."File_id_seq" OWNER TO postgres;

--
-- TOC entry 3469 (class 0 OID 0)
-- Dependencies: 220
-- Name: File_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."File_id_seq" OWNED BY public."File".id;


--
-- TOC entry 219 (class 1259 OID 17093)
-- Name: Folder; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."Folder" (
    id integer NOT NULL,
    "parentId" integer,
    name character varying(255) NOT NULL,
    created_at timestamp(3) without time zone NOT NULL,
    updated_at timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Folder" OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 17092)
-- Name: Folder_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Folder_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Folder_id_seq" OWNER TO postgres;

--
-- TOC entry 3470 (class 0 OID 0)
-- Dependencies: 218
-- Name: Folder_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Folder_id_seq" OWNED BY public."Folder".id;


--
-- TOC entry 217 (class 1259 OID 17081)
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO postgres;

--
-- TOC entry 3302 (class 2604 OID 17103)
-- Name: File id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."File" ALTER COLUMN id SET DEFAULT nextval('public."File_id_seq"'::regclass);


--
-- TOC entry 3301 (class 2604 OID 17096)
-- Name: Folder id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Folder" ALTER COLUMN id SET DEFAULT nextval('public."Folder_id_seq"'::regclass);


--
-- TOC entry 3460 (class 0 OID 17100)
-- Dependencies: 221
-- Data for Name: File; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."File" (id, "folderId", name, type, size, created_at, updated_at) FROM stdin;
1	2	file 1	image	1024kb	2025-02-03 19:42:41.752	2025-02-03 19:42:41.752
2	2	file 2	image	1024kb	2025-02-03 19:42:41.752	2025-02-03 19:42:41.752
3	3	file 1	document	512kb	2025-02-03 19:42:41.752	2025-02-03 19:42:41.752
4	3	file 2	document	512kb	2025-02-03 19:42:41.752	2025-02-03 19:42:41.752
5	1	Screenshot from 2025-02-02 20-30-48.png	png	81344	2025-02-04 05:08:38.242	2025-02-04 05:08:38.242
6	1	Screenshot from 2025-02-02 20-30-48.png	png	81344	2025-02-04 06:09:52.466	2025-02-04 06:09:52.466
7	1	Screenshot from 2025-02-04 13-11-39.png	png	45074	2025-02-04 06:11:46.619	2025-02-04 06:11:46.619
\.


--
-- TOC entry 3458 (class 0 OID 17093)
-- Dependencies: 219
-- Data for Name: Folder; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."Folder" (id, "parentId", name, created_at, updated_at) FROM stdin;
1	\N	folder 1	2025-02-03 19:23:52.626	2025-02-03 19:23:52.626
2	1	folder 2	2025-02-03 19:23:52.626	2025-02-03 19:23:52.626
3	2	folder 3	2025-02-03 19:32:12.689	2025-02-03 19:32:12.689
5	\N	folder 5	2025-02-03 19:51:22.825	2025-02-03 19:51:22.825
6	\N	Folder UPdate	2025-02-03 20:49:26.553	2025-02-03 20:49:26.553
7	\N	test vue	2025-02-04 03:48:09.789	2025-02-04 03:48:09.789
8	\N	test vue 2	2025-02-04 03:49:13.639	2025-02-04 03:49:13.639
9	7	inside vue	2025-02-04 03:51:34.995	2025-02-04 03:51:34.995
10	7	inside vue 2	2025-02-04 03:52:32.262	2025-02-04 03:52:32.262
11	7	inside vue 3	2025-02-04 03:52:42.673	2025-02-04 03:52:42.673
12	2	folderrrrrr	2025-02-04 03:55:07.031	2025-02-04 03:55:07.031
13	1	folderr	2025-02-04 05:47:08.39	2025-02-04 05:47:08.39
4	1	folder editeddd	2025-02-03 19:36:42.156	2025-02-03 19:36:42.156
\.


--
-- TOC entry 3456 (class 0 OID 17081)
-- Dependencies: 217
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
e5f3a4ab-7b24-4339-8942-3a17e9f63181	aba6a673eea2eec331eb28f7d6bcef1ca678f211ff6a40cc89108115bbc19370	2025-02-03 19:21:35.739747+07	20250203122135_init	\N	\N	2025-02-03 19:21:35.71721+07	1
\.


--
-- TOC entry 3471 (class 0 OID 0)
-- Dependencies: 220
-- Name: File_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."File_id_seq"', 7, true);


--
-- TOC entry 3472 (class 0 OID 0)
-- Dependencies: 218
-- Name: Folder_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Folder_id_seq"', 13, true);


--
-- TOC entry 3308 (class 2606 OID 17107)
-- Name: File File_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."File"
    ADD CONSTRAINT "File_pkey" PRIMARY KEY (id);


--
-- TOC entry 3306 (class 2606 OID 17098)
-- Name: Folder Folder_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Folder"
    ADD CONSTRAINT "Folder_pkey" PRIMARY KEY (id);


--
-- TOC entry 3304 (class 2606 OID 17089)
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- TOC entry 3310 (class 2606 OID 17113)
-- Name: File File_folderId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."File"
    ADD CONSTRAINT "File_folderId_fkey" FOREIGN KEY ("folderId") REFERENCES public."Folder"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- TOC entry 3309 (class 2606 OID 17108)
-- Name: Folder Folder_parentId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."Folder"
    ADD CONSTRAINT "Folder_parentId_fkey" FOREIGN KEY ("parentId") REFERENCES public."Folder"(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- TOC entry 3468 (class 0 OID 0)
-- Dependencies: 5
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;


-- Completed on 2025-02-04 13:37:08 WIB

--
-- PostgreSQL database dump complete
--

-- Completed on 2025-02-04 13:37:08 WIB

--
-- PostgreSQL database cluster dump complete
--

