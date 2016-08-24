--
-- PostgreSQL database dump
--

-- Dumped from database version 9.5.2
-- Dumped by pg_dump version 9.5.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: adopt; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA adopt;


ALTER SCHEMA adopt OWNER TO postgres;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = adopt, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: adopters; Type: TABLE; Schema: adopt; Owner: postgres
--

CREATE TABLE adopters (
    id bigint NOT NULL,
    shelter_fk integer NOT NULL,
    organization character varying(100) NOT NULL,
    contact character varying(50) NOT NULL,
    phone character varying(14),
    email character varying(50),
    decal integer DEFAULT 0 NOT NULL,
    supplies integer DEFAULT 0 NOT NULL,
    start date,
    expires date,
    CONSTRAINT adopters_decal_check CHECK (((decal >= 0) AND (decal <= 1))),
    CONSTRAINT adopters_supplies_check CHECK (((supplies >= 0) AND (supplies <= 1)))
);


ALTER TABLE adopters OWNER TO postgres;

--
-- Name: adopters_id_seq; Type: SEQUENCE; Schema: adopt; Owner: postgres
--

CREATE SEQUENCE adopters_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE adopters_id_seq OWNER TO postgres;

--
-- Name: adopters_id_seq; Type: SEQUENCE OWNED BY; Schema: adopt; Owner: postgres
--

ALTER SEQUENCE adopters_id_seq OWNED BY adopters.id;


--
-- Name: shelters; Type: TABLE; Schema: adopt; Owner: postgres
--

CREATE TABLE shelters (
    gid integer NOT NULL,
    id smallint,
    name character varying(100),
    geom public.geometry(Point,4326)
);


ALTER TABLE shelters OWNER TO postgres;

--
-- Name: shelter_adopters; Type: VIEW; Schema: adopt; Owner: postgres
--

CREATE VIEW shelter_adopters AS
 SELECT s.id,
    s.name,
    public.st_asgeojson(s.geom) AS geometry,
    a.organization,
    a.contact,
    a.phone,
    a.email,
    a.decal,
    a.supplies,
    a.start,
    a.expires
   FROM (shelters s
     LEFT JOIN adopters a ON ((s.id = a.shelter_fk)));


ALTER TABLE shelter_adopters OWNER TO postgres;

--
-- Name: shelters_gid_seq; Type: SEQUENCE; Schema: adopt; Owner: postgres
--

CREATE SEQUENCE shelters_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE shelters_gid_seq OWNER TO postgres;

--
-- Name: shelters_gid_seq; Type: SEQUENCE OWNED BY; Schema: adopt; Owner: postgres
--

ALTER SEQUENCE shelters_gid_seq OWNED BY shelters.gid;


--
-- Name: id; Type: DEFAULT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY adopters ALTER COLUMN id SET DEFAULT nextval('adopters_id_seq'::regclass);


--
-- Name: gid; Type: DEFAULT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY shelters ALTER COLUMN gid SET DEFAULT nextval('shelters_gid_seq'::regclass);


--
-- Data for Name: adopters; Type: TABLE DATA; Schema: adopt; Owner: postgres
--

COPY adopters (id, shelter_fk, organization, contact, phone, email, decal, supplies, start, expires) FROM stdin;
2	9914	COR	Justin	9199999999	Justin.Greco@raleighnc.gov	0	0	2016-08-24	2017-08-24
\.


--
-- Name: adopters_id_seq; Type: SEQUENCE SET; Schema: adopt; Owner: postgres
--

SELECT pg_catalog.setval('adopters_id_seq', 2, true);


--
-- Data for Name: shelters; Type: TABLE DATA; Schema: adopt; Owner: postgres
--

COPY shelters (gid, id, name, geom) FROM stdin;
18	8359	Glenwood at The Tribute	0101000020E6100000515A78AB4EAC53C0566D262CB4EC4140
19	8174	Glenwood at Glen	0101000020E61000001CD1650858A953C098F4B4F6D0E64140
20	8180	Glenwood at Johnson	0101000020E610000024E697A56DA953C0560F22B4BDE44140
21	8207	Timber at Crabtree	0101000020E6100000DDFA156D30A753C07D636CC30CE74140
22	8056	Blount at Cedar	0101000020E61000006D7105A9AFA853C025D30B009DE54140
23	8057	Blount at Delway	0101000020E6100000C959B804B2A853C017787F1E4EE54140
24	8059	Salisbury at Lane	0101000020E61000009E926146F5A853C0CEE8012B7EE44140
25	8520	Oakwood at Tarboro	0101000020E61000001C8C1703B8A753C089F4E4D862E44140
26	8003	Wilmington at Jones	0101000020E610000034B39058D4A853C09F3A68A012E44140
27	8061	Salisbury at Jones	0101000020E6100000DC288B5DF6A853C0755CA4DF2FE44140
29	8641	Falstaff at Swinburne	0101000020E61000001E45CF7B78A553C0846CAD9C14E44140
30	8881	State at Bragg	0101000020E61000004E476B49F9A753C087825571F6E14140
31	9190	Chavis at Noble Oak	0101000020E6100000A951174236A853C06F7BD1E39BE24140
32	9657	Pecan at Wilmington WB	0101000020E6100000F35ED5C13EA953C07C059479CDDF4140
33	9367	Carolina Pines at S Saunders WB	0101000020E61000008BC7C0F097A953C080ACD1D0DDDF4140
34	9333	Lake Wheeler at Tryon	0101000020E61000000D46FAFC7AAB53C0452B687438DF4140
35	9343	Carolina Pines at S Saunders EB	0101000020E6100000D2BDA37399A953C079813A13DADF4140
36	9656	Pecan at Wilmington EB	0101000020E6100000F9F477333FA953C0DEE1E48FC9DF4140
37	8300	Sanderford at Rock Quarry	0101000020E61000009A557A0A2AA753C01BEC153610E04140
38	8304	Idlewood Village at Gumtree	0101000020E61000006BCE4AA733A753C0D5605E7B96DE4140
40	8626	New Bern at King Charles OB	0101000020E6100000C12C7D76D6A653C0EE1D2495C8E34140
41	8627	New Bern at Farris	0101000020E6100000CFF5FFE2AAA653C0DE2F45FFCCE34140
42	8648	New Bern at Clarendon Crescent	0101000020E61000007DBE3D6C8EA653C0F06FF890D8E34140
43	8650	New Bern at King Charles IB	0101000020E6100000436CF482F0A653C0D787B598D0E34140
44	8652	New Bern at Raleigh	0101000020E6100000FBA2C8A54EA753C0124915BFD9E34140
45	8653	New Bern at Hill	0101000020E61000006819FEAA8CA753C088CA5BD9D9E34140
46	8654	Edenton at Tarboro IB	0101000020E61000009BAF35FECBA753C0F51A9BC9E8E34140
47	8660	Edenton at Person	0101000020E61000001BE0B9A99DA853C0D6296492FBE34140
48	8822	Keeter Center at Wilmington	0101000020E6100000AA4EF40CF1A853C0F294CCDC8AE14140
50	8414	Wilmington Street Service Rd at Tryon	0101000020E6100000D98BB04A9CA953C0BF7C06F97FDD4140
53	9787	Purser at Rupert	0101000020E61000007F30EE1C35AA53C0912A8F8DDEDB4140
51	9766	Lake Wheeler at Stewart	0101000020E6100000D547358A55AB53C05FC0B67F73DF4140
52	9356	Cross Link at Merrick	0101000020E610000087A2768845A753C039DF855891E04140
55	8529	Avent Ferry at Crest	0101000020E61000007091C403EDAB53C07D064F7EC4E24140
56	8531	Avent Ferry Shopping Center at	0101000020E6100000C2C38CF290AC53C077B7B6062FE24140
57	8565	Avent Ferry at Centennial	0101000020E6100000B00468F86CAB53C064368A8D70E34140
58	8027	Capital at Spring Forest OB	0101000020E610000099D455192AA553C09BABB96441ED4140
59	8127	Falls of the Neuse at Spring Forest	0101000020E6100000CE26DA73B7A753C075477719FFEE4140
60	9111	Spring Forest at Casa Del Rey	0101000020E610000057CCDEFBE8A453C03E7934367CED4140
1	8126	Carlos at Falls of the Neuse	0101000020E610000087743B239FA753C06952F640ACEE4140
2	8160	Wake Forest at Navaho	0101000020E6100000B055F817B4A753C0AB9EED49EFE94140
3	8170	Pine at Whitaker Mill	0101000020E6100000A0F08467B9A853C06133F13C65E74140
4	8035	Capital at Spring Forest IB	0101000020E61000008DD14D2A31A553C05D485D443BED4140
5	8038	Capital at Calvary	0101000020E61000006EB0968E1FA553C0B4DAFA91FBEB4140
6	8039	Capital at Deana	0101000020E61000009BFB686F30A553C033849CA63BEB4140
7	8040	Capital at New Hope Church	0101000020E6100000922801C955A553C06883BFACC3EA4140
8	8044	Capital at Huntleigh	0101000020E6100000062B2F5FE6A553C0835FCBA910E94140
9	8046	Capital at Glenridge	0101000020E6100000D08795975BA653C07F34959EA5E84140
11	8471	Six Forks at Millbrook	0101000020E61000008174D86708A953C053D6F023A4ED4140
12	8475	Six Forks at Northbrook	0101000020E610000046D000AF3BA953C08479381949EC4140
13	8487	St. Marys at Wade	0101000020E610000056C03186C7A953C0344DA1A902E64140
15	8588	Beryl at Method	0101000020E6100000A39752F255AC53C08BF7C5BBB1E54140
16	8066	Gorman at Marcom	0101000020E61000004DB9B47DFAAB53C06C68EF9DB5E34140
17	8595	Gorman at Sherman	0101000020E6100000C1770EEFF7AB53C02FFF4DD94BE44140
61	8036	Capital at Millbrook	0101000020E6100000A937D27829A553C06ADD5847ADEC4140
62	8163	Wake Forest at Six Forks	0101000020E6100000DBCAA787FBA753C0EBA47656C6E84140
63	8362	Glenwood at Deblyn	0101000020E6100000F8752B0CB7AC53C06638A3A646ED4140
64	8373	Oak Park at Glenwood	0101000020E61000008A7FD6A0E8AC53C06E5499B077ED4140
65	8263	Lake Boone at Myron	0101000020E61000000E1BE93663AC53C09AAC4D5B66E84140
68	8636	Calumet at Holston	0101000020E61000000D650FC62AA553C0B7B4BA06E6E44140
69	8637	Holston at Calumet	0101000020E61000005DE2A0392BA553C0990E7B7E99E44140
70	9923	New Bern at WakeMed ER IB	0101000020E6100000CFB9978CB6A553C09ECE8F71A6E44140
71	8645	New Bern at Peartree	0101000020E610000085C41A0DE8A553C093F4F0C149E44140
72	8518	Oakwood at Fisher	0101000020E61000009C15835456A753C0C6D8D0E55EE44140
73	9914	Morgan at Dawson	0101000020E6100000CF98561932A953C0E537B713CDE34140
74	9916	Cabarrus at McDowell	0101000020E6100000725CD74726A953C0E3B718EB1CE34140
75	9902	Wilmington at Cabarrus	0101000020E6100000A8E1A060DAA853C0EABB39FA26E34140
76	8388	Glenwood at Oberlin	0101000020E6100000FB49C5C649AA53C0458C89E683E84140
77	8154	Falls of the Neuse at Old Wake Forest	0101000020E610000080B0DE5F2AA753C0B335148AACEB4140
78	8156	Wake Forest at Hardimont	0101000020E6100000C5578C883DA753C0F168A94535EB4140
80	8911	Rock Quarry at Cross Link	0101000020E6100000CAF266F332A753C039394D74A5E04140
82	8280	Hillsborough at YMCA	0101000020E610000093E59B792FAA53C0A48EA6206EE44140
83	9507	Glenbrook at Dacian	0101000020E6100000AF573E7497A653C0CCFC8ED156E24140
84	8699	Creedmoor at Lynn	0101000020E610000022A0B23080AB53C0DC8A27A2BAEF4140
85	9222	Poole at Shellum	0101000020E6100000D8F6DA4FDDA653C081D2C7213CE34140
95	9208	Poole Rd at Bus Way	0101000020E6100000319413ED2AA453C07593180456E24140
96	9207	Bus Way at Poole Rd	0101000020E61000008B71FE2614A453C0E700C11C3DE24140
97	8235	Hillsborough St at Forest Rd	0101000020E610000039B9DFA128AA53C0EA95B20C71E44140
98	8240	Hillsborough St at Brooks Ave	0101000020E6100000D07EA4880CAB53C0CC4065FCFBE44140
99	8175	Glenwood Ave at Harvey St	0101000020E61000005A8121AB5BA953C0A64412BD8CE64140
39	8315	Rock Quarry at Proctor	0101000020E6100000F0AC377C2FA753C0046855ADABE04140
86	8371	St. Giles at Deep Hollow	0101000020E61000001E7FFF5B2DAD53C00455E0D467ED4140
87	9608	Martin Luther King Jr. at Raleigh	0101000020E6100000389CD32346A753C0DCE60FFF95E24140
88	8421	South Saunders at Dorothea	0101000020E610000002BC100178A953C06C94471FB0E24140
89	9401	Method at Western	0101000020E610000040F2E78169AC53C0BAE7642E71E44140
90	9145	New Bern at Trawick	0101000020E610000095B82AC3D5A453C0256228842EE64140
91	8620	New Bern at Tarboro OB	0101000020E6100000AD8628BDE1A753C0BA3ED294D0E34140
92	8270	Dixie at O'Berry	0101000020E61000000DAAE4BA49AB53C00997B48666E64140
93	9282	Birch Ridge at Rock Bridge	0101000020E6100000EC7A1330EDA453C064FD815825E24140
94	8032	Triangle Town Center at Barnes and Noble	0101000020E610000068A40F00DDA453C0006BEB80CAEE4140
101	9569	Sungate Blvd at Sunnybrook Rd	0101000020E61000008C84B69C4BA553C00FD1E80E62E34140
9925	8005	Capital Blvd at Crabtree Blvd	0101000020E6100000B6D617096DA753C048BF7D1D38E74140
9926	8020	Capital Blvd at Trawick Rd	0101000020E610000056BC9179E4A553C0D482177D05E94140
9927	8030	Triangle Town Center Mall at Orvis (Park and Ride)	0101000020E6100000543A58FFE7A453C00AA2EE0390EE4140
9928	8048	Capital Blvd at Crabtree Blvd	0101000020E610000033FE7DC685A753C0DE02098A1FE74140
9929	8049	Capital Blvd at Tillery Pl	0101000020E6100000BDC62E51BDA753C0E6965643E2E64140
9930	8104	Wake Forest Rd at Navaho Dr	0101000020E610000041BCAE5FB0A753C0BD3AC780ECE94140
9931	8254	Rex Hospital (Outbound)	0101000020E610000005DD5ED218AD53C078280AF489E84140
9932	8273	Hillsborough St at Friendly Dr	0101000020E610000009C03FA54AAB53C04C38F4160FE54140
9933	8276	Hillsborough St at Horne St	0101000020E610000010070951BEAA53C0247CEF6FD0E44140
9934	8277	Hillsborough St at NCSU Belltower	0101000020E6100000F0A31AF67BAA53C0209C4F1DABE44140
9935	8408	Garner Station Blvd at South Station	0101000020E6100000320395F1EFA953C0C68A1A4CC3DC4140
9936	8449	North Hills Mall at N State Bank	0101000020E610000068CF656A12A953C0359BC76130EB4140
9937	8450	North Hills Mall at Total Wine	0101000020E6100000B0E3BF4010A953C09FCC3FFA26EB4140
9938	8505	N King Charles Rd at Glascock St	0101000020E610000023BC3D0801A753C0B28174B169E54140
9939	8524	Western Blvd at Ashe Ave	0101000020E61000008061F9F36DAA53C099654F029BE34140
9940	8525	Morrill Dr at adoptes Ave (Outbound)	0101000020E61000008159A148F7AA53C059A2B3CC22E44140
9941	8564	Avent Ferry Rd at Centennial View Ln	0101000020E6100000618E1EBFB7AB53C0F35487DC0CE34140
9942	8568	Western Blvd at Bilyeu St	0101000020E6100000FC00A43671AA53C0B5F97FD591E34140
9943	8577	Cameron St at Woodburn Rd	0101000020E6100000D7F7E12021AA53C097E13FDD40E54140
9944	8578	Cameron St at Daniels St	0101000020E610000014200A664CAA53C0925852EE3EE54140
9945	8624	New Bern Ave at Raleigh Blvd	0101000020E61000007104A9143BA753C0F645425BCEE34140
9946	8631	WakeMed Perimeter Rd at Galahad Dr	0101000020E610000068B3EA73B5A553C0A3923A014DE44140
9947	8632	WakeMed at Wake Tech	0101000020E610000032B08EE387A553C06F10AD156DE44140
9948	8633	WakeMed at the Andrews Center	0101000020E6100000842A357BA0A553C0713D0AD7A3E44140
9949	8642	Swinburne Rd at Kidd Rd (WCDSS)	0101000020E61000005BEF37DA71A553C06A6CAF05BDE34140
9950	8668	Rex Hospital (Inbound)	0101000020E6100000705F07CE19AD53C01B0DE02D90E84140
9951	8685	Creedmoor Rd at Plaza Pl	0101000020E6100000541EDD088BAB53C082E50819C8ED4140
9952	8861	Cameron St at Daniels St	0101000020E6100000AABA473657AA53C0302FC03E3AE54140
9953	8862	Cameron St at Woodburn Rd	0101000020E6100000C2887D0228AA53C0D0F23CB83BE54140
9954	8885	Lenoir St at Freeman St	0101000020E610000067614F3BFCA753C097917A4FE5E24140
9955	8903	Wake Tech Community College	0101000020E6100000DB6CACC43CAD53C03BE3FBE252D34140
9956	8927	MLK Jr Blvd at S East St	0101000020E61000009911DE1E84A853C0D26D895C70E24140
9957	9170	Oberlin Rd at Clark Ave	0101000020E610000026C808A870AA53C0FBCA83F414E54140
9958	9179	Sunnybrook Rd at Calumet Dr (WakeMed Medical Park)	0101000020E6100000E42CEC6987A553C0F8AA9509BFE44140
9959	9329	Capital Blvd at Spring Forest Rd	0101000020E61000009A94826E2FA553C007CF842689ED4140
9960	9366	Pecan Rd at S Saunders St	0101000020E61000008789062978A953C0CD0358E4D7DF4140
9961	9443	Capital Blvd at Capital Square Shopping Center	0101000020E6100000DBDC989EB0A553C0BC5983F755E94140
9962	9602	Trailwood Dr at Lineberry Dr	0101000020E6100000959F54FB74AC53C0A31EA2D11DE04140
9964	9613	Dunn Ave at Jeter Dr	0101000020E61000008D28ED0DBEAA53C04E62105839E44140
9965	9623	New Hope Commons Wal-Mart	0101000020E61000009D9FE238F0A353C061E3FA777DE64140
9966	9625	Corporation Pkwy at New Bern Ave	0101000020E6100000227024D060A453C0B13385CE6BE64140
9967	9736	Glen Royal Rd at Brownleigh Dr	0101000020E610000095D5743DD1AF53C010CCD1E3F7F04140
9968	9759	Rush St at Shelden Dr	0101000020E6100000EF37DA71C3A853C02EE57CB1F7DE4140
9969	9908	Wilmington St at Edenton St	0101000020E6100000A01B9AB2D3A853C07923F3C81FE44140
9970	9913	Morgan St at West St	0101000020E6100000E17D552E54A953C0259694BBCFE34140
9971	9924	Avent Ferry Rd at Avery Close Apt	0101000020E6100000DCF63DEAAFAB53C002BC051214E34140
9972	8947	Homewood Banks Dr. at Solis Crabtree Apts.	0101000020E610000026361FD786AB53C0C3D7D7BAD4EA4140
\.


--
-- Name: shelters_gid_seq; Type: SEQUENCE SET; Schema: adopt; Owner: postgres
--

SELECT pg_catalog.setval('shelters_gid_seq', 1, false);


SET search_path = public, pg_catalog;

--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY spatial_ref_sys  FROM stdin;
\.


SET search_path = adopt, pg_catalog;

--
-- Name: adopters_pkey; Type: CONSTRAINT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY adopters
    ADD CONSTRAINT adopters_pkey PRIMARY KEY (id);


--
-- Name: id_unique; Type: CONSTRAINT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY shelters
    ADD CONSTRAINT id_unique UNIQUE (id);


--
-- Name: shelters_pkey; Type: CONSTRAINT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY shelters
    ADD CONSTRAINT shelters_pkey PRIMARY KEY (gid);


--
-- Name: shelters_geom_gist; Type: INDEX; Schema: adopt; Owner: postgres
--

CREATE INDEX shelters_geom_gist ON shelters USING gist (geom);


--
-- Name: fk_shelters; Type: FK CONSTRAINT; Schema: adopt; Owner: postgres
--

ALTER TABLE ONLY adopters
    ADD CONSTRAINT fk_shelters FOREIGN KEY (shelter_fk) REFERENCES shelters(id);


--
-- Name: adopt; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA adopt FROM PUBLIC;
REVOKE ALL ON SCHEMA adopt FROM postgres;
GRANT ALL ON SCHEMA adopt TO postgres;
GRANT ALL ON SCHEMA adopt TO adopt;


--
-- Name: public; Type: ACL; Schema: -; Owner: grecoj
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM grecoj;
GRANT ALL ON SCHEMA public TO grecoj;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: adopters; Type: ACL; Schema: adopt; Owner: postgres
--

REVOKE ALL ON TABLE adopters FROM PUBLIC;
REVOKE ALL ON TABLE adopters FROM postgres;
GRANT ALL ON TABLE adopters TO postgres;
GRANT ALL ON TABLE adopters TO adopt;


--
-- Name: adopters_id_seq; Type: ACL; Schema: adopt; Owner: postgres
--

REVOKE ALL ON SEQUENCE adopters_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE adopters_id_seq FROM postgres;
GRANT ALL ON SEQUENCE adopters_id_seq TO postgres;
GRANT ALL ON SEQUENCE adopters_id_seq TO adopt;


--
-- Name: shelters; Type: ACL; Schema: adopt; Owner: postgres
--

REVOKE ALL ON TABLE shelters FROM PUBLIC;
REVOKE ALL ON TABLE shelters FROM postgres;
GRANT ALL ON TABLE shelters TO postgres;
GRANT ALL ON TABLE shelters TO adopt;


--
-- Name: shelter_adopters; Type: ACL; Schema: adopt; Owner: postgres
--

REVOKE ALL ON TABLE shelter_adopters FROM PUBLIC;
REVOKE ALL ON TABLE shelter_adopters FROM postgres;
GRANT ALL ON TABLE shelter_adopters TO postgres;
GRANT ALL ON TABLE shelter_adopters TO adopt;


--
-- Name: shelters_gid_seq; Type: ACL; Schema: adopt; Owner: postgres
--

REVOKE ALL ON SEQUENCE shelters_gid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE shelters_gid_seq FROM postgres;
GRANT ALL ON SEQUENCE shelters_gid_seq TO postgres;
GRANT ALL ON SEQUENCE shelters_gid_seq TO adopt;


--
-- PostgreSQL database dump complete
--

