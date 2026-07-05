--
-- PostgreSQL database dump
--

\restrict pIWXQjyGykn4wYLJzmyEDyAMlQI9We2Q6iQzDnxvomfIsXx37ktuamVG70SxZAD

-- Dumped from database version 17.4 (Postgres.app)
-- Dumped by pg_dump version 18.4

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
-- Data for Name: favorite_contacts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_contacts (id, user_id, contact_id, created_at) FROM stdin;
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.groups (id, name, announcement, avatar, owner_id, created_at, updated_at, deleted_at, all_muted, invite_confirmation, admin_only_edit_name, member_view_permission, agora_group_id) FROM stdin;
23	111	\N	\N	103	2025-11-24 19:23:07.556208	2025-11-24 19:23:07.556208	\N	f	f	f	t	\N
24	群组01	\N	\N	112	2025-11-25 14:27:47.605044	2025-11-25 14:27:47.605044	\N	f	f	f	t	\N
25	群测试02	\N	\N	107	2025-11-26 08:02:29.848503	2025-11-26 08:02:29.848503	\N	f	f	f	t	\N
26	群组测试3	\N	\N	113	2025-11-26 11:03:31.404564	2025-11-26 12:43:40.793218	\N	f	f	f	t	\N
27	测试群	\N	\N	116	2025-11-26 14:35:07.291999	2025-11-26 14:39:26.260618	\N	f	f	f	t	\N
28	测试2	\N	\N	116	2025-11-26 14:40:48.509173	2025-11-26 14:40:48.509173	\N	f	f	f	t	\N
29	测试群组05	\N	\N	103	2025-11-26 15:45:50.358678	2025-11-26 15:45:50.358678	\N	f	f	f	t	\N
30	test_group_06	\N	\N	113	2025-11-26 15:47:10.45277	2025-11-26 15:47:10.45277	\N	f	f	f	t	\N
31	群组07	\N	\N	113	2025-11-26 15:55:05.688749	2025-11-26 15:55:05.688749	\N	f	f	f	t	\N
32	群组9	\N	\N	113	2025-11-26 16:15:10.775466	2025-11-26 16:15:10.775466	\N	f	f	f	t	\N
33	test_group_10	\N	\N	113	2025-11-26 16:16:54.934576	2025-11-26 16:16:54.934576	\N	f	f	f	t	\N
34	群组11	\N	\N	113	2025-11-26 16:28:30.259332	2025-11-26 16:28:30.259332	\N	f	f	f	t	\N
35	群组12	\N	\N	113	2025-11-26 16:29:29.981185	2025-11-26 16:29:29.981185	\N	f	f	f	t	\N
36	群组13	\N	\N	113	2025-11-26 16:35:00.779698	2025-11-26 16:35:00.779698	\N	f	f	f	t	\N
37	qunz	\N	\N	103	2025-11-26 17:37:26.914977	2025-11-26 17:37:26.914977	\N	f	f	f	t	\N
38	群组测试333	\N	\N	103	2025-11-26 17:41:15.986786	2025-11-26 17:41:15.986786	\N	f	f	f	t	\N
39	qunzu222	\N	\N	113	2025-11-26 17:42:01.608414	2025-11-26 17:42:01.608414	\N	f	f	f	t	\N
40	qunzu123	\N	\N	103	2025-11-26 17:54:30.504349	2025-11-26 17:54:30.504349	\N	f	f	f	t	\N
41	qqqq	\N	\N	103	2025-11-26 17:55:11.626231	2025-11-26 17:55:11.626231	\N	f	f	f	t	\N
42	opopop	\N	\N	102	2025-11-26 18:53:50.895114	2025-11-26 18:53:50.895114	\N	f	f	f	t	\N
43	测试1	\N	\N	116	2025-11-27 16:53:21.974939	2025-11-27 16:53:21.974939	\N	f	f	f	t	\N
44	群组789	\N	\N	113	2025-11-28 11:01:02.564663	2025-11-28 11:01:02.564663	\N	f	f	f	t	\N
45	群组999	\N	\N	113	2025-11-28 11:02:01.077957	2025-11-28 11:02:01.077957	\N	f	f	f	t	\N
49	90901	\N	\N	126	2025-12-03 21:11:58.649087	2025-12-03 21:11:58.649087	\N	f	f	f	t	\N
47	测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2	测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2	\N	142	2025-11-30 15:27:59.067778	2025-12-01 22:35:20.951778	\N	f	f	f	t	\N
48	群组09901	\N	\N	128	2025-12-02 20:57:21.962926	2025-12-02 20:58:06.429503	\N	f	f	f	t	\N
50	测试群	\N	\N	145	2025-12-04 01:06:55.940785	2025-12-04 01:06:55.940785	\N	f	f	f	t	\N
51	一战成名	大家好，本人王志豪12345678998745632112365478998745632112334566789965441336995578635489669974599852542899647862216624896258632489328872985665897239847625845684499	\N	151	2025-12-06 11:01:34.735536	2025-12-06 11:21:02.033479	\N	f	t	f	f	\N
46	1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方	11大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方	\N	142	2025-11-29 06:25:05.177094	2025-12-05 16:13:53.630449	\N	f	t	f	t	\N
52	😀	\N	\N	149	2025-12-06 14:15:58.951302	2025-12-06 14:17:23.34506	\N	f	t	f	t	\N
53	测试	\N	\N	118	2025-12-06 15:13:55.367239	2025-12-06 15:13:55.367239	\N	f	f	f	t	\N
54	1	\N	\N	153	2025-12-06 15:18:19.664738	2025-12-06 15:18:19.664738	\N	f	f	f	t	\N
55	222	\N	\N	102	2025-12-19 09:42:38.780626	2025-12-19 09:42:38.780626	\N	f	f	f	t	\N
56	0104	\N	\N	159	2025-12-19 10:58:30.14733	2025-12-19 10:58:30.14733	\N	f	f	f	t	\N
57	ceshi0407	\N	\N	108	2025-12-19 13:15:24.737863	2025-12-19 13:15:24.737863	\N	f	f	f	t	\N
58	001	\N	\N	108	2025-12-19 13:48:24.89378	2025-12-19 13:48:24.89378	\N	f	f	f	t	\N
59	0102	\N	\N	103	2025-12-19 19:32:00.993461	2025-12-19 19:32:00.993461	\N	f	f	f	t	\N
60	0108	\N	\N	102	2025-12-19 22:22:01.769773	2025-12-19 22:22:01.769773	\N	f	f	f	t	\N
61	Cheshire -0108	\N	\N	102	2025-12-19 22:22:31.208619	2025-12-19 22:22:31.208619	\N	f	f	f	t	\N
62	Cheshire-0108-01	\N	\N	102	2025-12-19 22:39:54.188224	2025-12-19 22:39:54.188224	\N	f	f	f	t	\N
63	群组0102	\N	\N	103	2025-12-22 12:56:17.073109	2025-12-22 12:56:17.073109	\N	f	f	f	t	\N
64	test05 group	\N	\N	102	2026-06-27 18:23:58.682844	2026-06-27 18:23:58.682844	\N	f	f	f	t	\N
65	ceshi22 group	\N	\N	102	2026-06-28 20:05:31.673388	2026-06-28 20:05:32.809728	\N	f	f	f	t	317980600762369
66	ceshi05 group 01	\N	\N	102	2026-06-28 20:37:48.240955	2026-06-28 20:37:49.843963	\N	f	f	f	t	317982631854082
\.


--
-- Data for Name: favorite_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite_groups (id, user_id, group_id, created_at) FROM stdin;
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorites (id, user_id, message_id, content, message_type, file_name, sender_id, sender_name, created_at, server_id, sync_status) FROM stdin;
76	143	\N	11	text	\N	142	规范规定112	2025-12-11 11:59:15.787975	\N	synced
77	143	\N	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764556414_屏幕截图 2025-08-12 125412.png	image	\N	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	2025-12-11 11:59:30.941254	\N	synced
78	143	\N	67890	text	\N	144	cesfffff	2025-12-17 11:39:41.292715	\N	synced
79	143	3132	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765943581_image_0DD5F000-CAD9-4133-9914-CF8F5E8B9BAB_1765943582.png	image	\N	143	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	2025-12-17 11:53:12.185654	\N	synced
80	102	\N	222	text	\N	102	test01	2026-06-28 17:17:16.420737	\N	synced
\.


--
-- Data for Name: file_assistant_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.file_assistant_messages (id, user_id, content, message_type, file_name, quoted_message_id, quoted_message_content, status, created_at, server_id) FROM stdin;
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.group_members (id, group_id, user_id, nickname, remark, role, joined_at, is_muted, approval_status, do_not_disturb) FROM stdin;
121	23	103	\N	\N	owner	2025-11-24 19:23:07.594289	f	approved	f
123	23	104	\N	\N	member	2025-11-24 22:06:28.895463	f	approved	f
122	23	102	\N	\N	member	2025-11-24 19:23:07.614398	f	approved	f
124	24	112	\N	\N	owner	2025-11-25 14:27:47.606821	f	approved	f
125	24	102	\N	\N	member	2025-11-25 14:27:47.60855	f	approved	f
126	25	107	\N	\N	owner	2025-11-26 08:02:29.84972	f	approved	f
127	25	114	\N	\N	member	2025-11-26 08:02:29.850555	f	approved	f
129	26	103	\N	\N	member	2025-11-26 11:03:31.407531	f	approved	f
128	26	113	\N	\N	owner	2025-11-26 11:03:31.406152	f	approved	f
130	26	114	\N	\N	member	2025-11-26 12:43:40.79702	f	approved	f
209	48	127	aaaa	\N	member	2025-12-02 20:57:21.967555	f	approved	f
132	27	118	\N	\N	member	2025-11-26 14:35:07.296636	f	approved	f
133	27	117	\N	\N	member	2025-11-26 14:35:07.297849	f	approved	f
205	47	144	\N	\N	member	2025-12-01 11:13:21.182534	f	approved	f
131	27	116	\N	\N	owner	2025-11-26 14:35:07.29525	f	approved	f
134	28	116	\N	\N	owner	2025-11-26 14:40:48.513336	f	approved	f
135	28	118	\N	\N	member	2025-11-26 14:40:48.514671	f	approved	f
136	28	117	\N	\N	member	2025-11-26 14:40:48.515675	f	approved	f
137	29	103	\N	\N	owner	2025-11-26 15:45:50.361692	f	approved	f
138	29	114	\N	\N	member	2025-11-26 15:45:50.362849	f	approved	f
139	29	113	\N	\N	member	2025-11-26 15:45:50.363869	f	approved	f
140	30	113	\N	\N	owner	2025-11-26 15:47:10.457002	f	approved	f
141	30	104	\N	\N	member	2025-11-26 15:47:10.458312	f	approved	f
142	30	103	\N	\N	member	2025-11-26 15:47:10.459351	f	approved	f
143	30	114	\N	\N	member	2025-11-26 15:47:10.460341	f	approved	f
144	31	113	\N	\N	owner	2025-11-26 15:55:05.692722	f	approved	f
145	31	104	\N	\N	member	2025-11-26 15:55:05.693758	f	approved	f
146	31	103	\N	\N	member	2025-11-26 15:55:05.694729	f	approved	f
147	31	114	\N	\N	member	2025-11-26 15:55:05.69568	f	approved	f
148	32	113	\N	\N	owner	2025-11-26 16:15:10.77959	f	approved	f
149	32	104	\N	\N	member	2025-11-26 16:15:10.780801	f	approved	f
150	32	103	\N	\N	member	2025-11-26 16:15:10.781927	f	approved	f
151	32	114	\N	\N	member	2025-11-26 16:15:10.782899	f	approved	f
152	33	113	\N	\N	owner	2025-11-26 16:16:54.937505	f	approved	f
153	33	104	\N	\N	member	2025-11-26 16:16:54.938419	f	approved	f
154	33	103	\N	\N	member	2025-11-26 16:16:54.939408	f	approved	f
155	33	114	\N	\N	member	2025-11-26 16:16:54.940383	f	approved	f
156	34	113	\N	\N	owner	2025-11-26 16:28:30.26224	f	approved	f
157	34	104	\N	\N	member	2025-11-26 16:28:30.263169	f	approved	f
158	34	103	\N	\N	member	2025-11-26 16:28:30.264052	f	approved	f
159	35	113	\N	\N	owner	2025-11-26 16:29:29.984087	f	approved	f
160	35	104	\N	\N	member	2025-11-26 16:29:29.984965	f	approved	f
161	35	103	\N	\N	member	2025-11-26 16:29:29.985812	f	approved	f
162	35	114	\N	\N	member	2025-11-26 16:29:29.986646	f	approved	f
163	36	113	\N	\N	owner	2025-11-26 16:35:00.782051	f	approved	f
164	36	104	\N	\N	member	2025-11-26 16:35:00.783331	f	approved	f
165	36	103	\N	\N	member	2025-11-26 16:35:00.784333	f	approved	f
166	37	103	\N	\N	owner	2025-11-26 17:37:26.919014	f	approved	f
167	37	113	\N	\N	member	2025-11-26 17:37:26.920368	f	approved	f
168	37	114	\N	\N	member	2025-11-26 17:37:26.921386	f	approved	f
169	38	103	\N	\N	owner	2025-11-26 17:41:15.989707	f	approved	f
170	38	113	\N	\N	member	2025-11-26 17:41:15.990952	f	approved	f
171	38	114	\N	\N	member	2025-11-26 17:41:15.992114	f	approved	f
172	39	113	\N	\N	owner	2025-11-26 17:42:01.611324	f	approved	f
173	39	109	\N	\N	member	2025-11-26 17:42:01.61222	f	approved	f
174	39	108	\N	\N	member	2025-11-26 17:42:01.613079	f	approved	f
175	39	103	\N	\N	member	2025-11-26 17:42:01.613927	f	approved	f
176	40	103	\N	\N	owner	2025-11-26 17:54:30.507409	f	approved	f
177	40	113	\N	\N	member	2025-11-26 17:54:30.508729	f	approved	f
178	40	114	\N	\N	member	2025-11-26 17:54:30.509745	f	approved	f
179	41	103	\N	\N	owner	2025-11-26 17:55:11.629101	f	approved	f
180	41	113	\N	\N	member	2025-11-26 17:55:11.630156	f	approved	f
182	42	102	\N	\N	owner	2025-11-26 18:53:50.899516	f	approved	f
183	42	104	\N	\N	member	2025-11-26 18:53:50.900953	f	approved	f
184	42	103	\N	\N	member	2025-11-26 18:53:50.902185	f	approved	f
185	42	119	\N	\N	member	2025-11-26 18:53:50.903188	f	approved	f
186	43	116	\N	\N	owner	2025-11-27 16:53:21.978045	f	approved	f
187	43	117	\N	\N	member	2025-11-27 16:53:21.979434	f	approved	f
188	44	113	\N	\N	owner	2025-11-28 11:01:02.565984	f	approved	f
189	44	109	\N	\N	member	2025-11-28 11:01:02.567469	f	approved	f
190	44	127	\N	\N	member	2025-11-28 11:01:02.568655	f	approved	f
191	45	113	\N	\N	owner	2025-11-28 11:02:01.08204	f	approved	f
192	45	127	\N	\N	member	2025-11-28 11:02:01.083196	f	approved	f
193	45	109	\N	\N	member	2025-11-28 11:02:01.084343	f	approved	f
208	48	128	bbbb	\N	owner	2025-12-02 20:57:21.966189	f	approved	f
211	49	126	\N	\N	owner	2025-12-03 21:11:58.653497	f	approved	f
181	41	114	kkkkk	\N	member	2025-11-26 17:55:11.631186	f	approved	f
198	47	142	测试群组233	\N	owner	2025-11-30 15:27:59.07208	f	approved	f
206	47	143	\N	\N	member	2025-12-01 22:35:20.955275	f	approved	f
212	49	127	\N	\N	member	2025-12-03 21:11:58.654981	f	approved	f
215	50	126	\N	\N	member	2025-12-04 20:28:22.453744	f	approved	f
213	50	145	\N	\N	owner	2025-12-04 01:06:55.943941	f	approved	f
210	46	144	\N	\N	member	2025-12-02 21:40:23.674993	f	pending	f
214	50	116	\N	\N	member	2025-12-04 01:06:55.94529	f	approved	f
216	50	141	\N	\N	member	2025-12-04 20:28:22.458117	f	approved	f
217	50	117	\N	\N	member	2025-12-04 20:28:22.459185	f	approved	f
195	46	142	规范规定112	\N	owner	2025-11-29 06:25:05.182684	f	approved	f
203	46	143	弄一下嘻嘻	\N	member	2025-12-01 11:01:38.254952	f	approved	f
218	51	151	王总先生	\N	owner	2025-12-06 11:01:34.738874	f	approved	f
221	51	147	\N	\N	member	2025-12-06 11:09:24.542831	f	approved	f
222	51	150	\N	\N	member	2025-12-06 11:09:24.544707	f	approved	f
223	51	149	\N	\N	member	2025-12-06 11:09:24.54582	f	approved	f
230	52	148	\N	\N	admin	2025-12-06 14:20:19.025834	f	approved	f
220	51	148	\N	\N	admin	2025-12-06 11:01:34.741487	f	approved	f
219	51	146	\N	\N	member	2025-12-06 11:01:34.740391	f	approved	f
224	52	149	\N	\N	owner	2025-12-06 14:15:58.954522	f	approved	f
226	52	150	\N	\N	member	2025-12-06 14:15:58.956982	f	approved	f
225	52	147	\N	\N	member	2025-12-06 14:15:58.955831	f	approved	f
231	53	118	\N	\N	owner	2025-12-06 15:13:55.371391	f	approved	f
232	53	152	\N	\N	member	2025-12-06 15:13:55.372737	f	approved	f
233	53	153	\N	\N	member	2025-12-06 15:14:19.236688	f	approved	f
234	54	153	\N	\N	owner	2025-12-06 15:18:19.669024	f	approved	f
235	54	152	\N	\N	member	2025-12-06 15:18:19.670425	f	approved	f
236	51	155	\N	\N	member	2025-12-14 10:23:20.149818	f	approved	f
237	55	102	\N	\N	owner	2025-12-19 09:42:38.784149	f	approved	f
238	55	103	\N	\N	member	2025-12-19 09:42:38.787483	f	approved	f
239	56	159	\N	\N	owner	2025-12-19 10:58:30.148675	f	approved	f
240	56	105	\N	\N	member	2025-12-19 10:58:30.149806	f	approved	f
241	56	102	\N	\N	member	2025-12-19 10:58:30.150609	f	approved	f
242	57	108	\N	\N	owner	2025-12-19 13:15:24.739874	f	approved	f
243	57	105	\N	\N	member	2025-12-19 13:15:24.741318	f	approved	f
244	57	107	\N	\N	member	2025-12-19 13:15:24.742292	f	approved	f
245	58	108	\N	\N	owner	2025-12-19 13:48:24.896287	f	approved	f
246	58	105	\N	\N	member	2025-12-19 13:48:24.897717	f	approved	f
247	58	107	\N	\N	member	2025-12-19 13:48:24.898599	f	approved	f
248	58	103	\N	\N	member	2025-12-19 14:40:10.719523	f	approved	f
249	59	103	\N	\N	owner	2025-12-19 19:32:00.995888	f	approved	f
250	59	102	\N	\N	member	2025-12-19 19:32:00.999509	f	approved	f
251	60	102	\N	\N	owner	2025-12-19 22:22:01.770877	f	approved	f
252	60	109	\N	\N	member	2025-12-19 22:22:01.772031	f	approved	f
253	61	102	\N	\N	owner	2025-12-19 22:22:31.210019	f	approved	f
254	61	109	\N	\N	member	2025-12-19 22:22:31.211163	f	approved	f
255	62	102	\N	\N	owner	2025-12-19 22:39:54.189351	f	approved	f
256	62	109	\N	\N	member	2025-12-19 22:39:54.190219	f	approved	f
257	63	103	\N	\N	owner	2025-12-22 12:56:17.077432	f	approved	f
258	63	102	\N	\N	member	2025-12-22 12:56:17.080698	f	approved	f
259	64	102	\N	\N	owner	2026-06-27 18:23:58.686219	f	approved	f
260	64	106	\N	\N	member	2026-06-27 18:23:58.690084	f	approved	f
261	65	102	\N	\N	owner	2026-06-28 20:05:31.681603	f	approved	f
262	65	113	\N	\N	member	2026-06-28 20:05:31.687119	f	approved	f
263	66	102	\N	\N	owner	2026-06-28 20:37:48.242898	f	approved	f
264	66	126	\N	\N	member	2026-06-28 20:37:48.244856	f	approved	f
265	66	106	\N	\N	member	2026-06-28 20:37:48.245912	f	approved	f
\.


--
-- Data for Name: scheduled_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.scheduled_messages (id, sender_id, receiver_id, message_type, title, send_time, send_type, content, status, created_at, updated_at, send_date) FROM stdin;
1	102	103	private	test1	19:06	once	111111122222	sent	2026-01-10 19:04:54.000738+08	2026-01-10 19:07:00.014438+08	\N
2	102	103	private	333	19:29	once	111	sent	2026-01-10 19:26:52.967479+08	2026-01-10 19:30:00.006553+08	\N
3	102	103	private	2222	19:39	once	22222	sent	2026-01-10 19:38:51.371223+08	2026-01-10 19:40:00.00534+08	\N
4	102	103	private	555	19:47	once	5555	deleted	2026-01-10 19:48:08.724377+08	2026-01-10 19:50:26.486049+08	\N
5	102	103	private	6666	19:50	once	666	deleted	2026-01-10 19:50:41.304065+08	2026-01-10 19:50:51.148451+08	\N
6	102	103	private	7777	19:57	once	7777	sent	2026-01-10 19:56:32.076569+08	2026-01-10 19:58:00.004605+08	\N
7	102	63	group	8888	20:00	once	888	deleted	2026-01-10 20:01:03.109791+08	2026-01-10 20:05:48.946582+08	\N
8	102	63	group	99999	20:07	once	9999	sent	2026-01-10 20:06:14.376509+08	2026-01-10 20:07:00.008393+08	\N
9	102	103	private	123123	20:16	once	123123	sent	2026-01-10 20:14:32.749727+08	2026-01-10 20:16:00.007583+08	\N
10	102	63	group	00000	20:18	once	00000	sent	2026-01-10 20:16:44.408548+08	2026-01-10 20:18:00.00744+08	\N
11	102	103	private	ceshi34	17:35	once	343434	sent	2026-01-11 17:32:55.710115+08	2026-01-11 17:35:00.00989+08	2026-01-11
12	102	106	private	ceshi00000	17:35	once	(6789644	sent	2026-01-11 17:33:26.738173+08	2026-01-11 17:35:00.016104+08	2026-01-11
\.


--
-- Data for Name: synced_group_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.synced_group_messages (id, agora_msg_id, group_id, sender_id, sender_name, sender_nickname, sender_full_name, content, message_type, file_name, voice_duration, call_type, quoted_message_content, status, created_at, synced_at) FROM stdin;
\.


--
-- Data for Name: synced_messages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.synced_messages (id, agora_msg_id, sender_id, sender_name, receiver_id, receiver_name, content, message_type, file_name, voice_duration, call_type, quoted_message_content, status, is_read, created_at, synced_at) FROM stdin;
\.


--
-- Data for Name: user_relations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_relations (id, user_id, friend_id, created_at, approval_status, is_blocked, is_deleted, blocked_by_user_id, deleted_by_user_id) FROM stdin;
203	150	149	2025-12-06 10:33:54.364921	approved	f	f	\N	\N
204	151	148	2025-12-06 10:43:47.182563	approved	f	f	\N	\N
205	151	146	2025-12-06 10:47:12.1819	approved	f	f	\N	\N
208	147	148	2025-12-06 10:51:43.317568	approved	f	f	\N	\N
209	149	151	2025-12-06 11:27:10.351488	approved	f	f	\N	\N
210	147	151	2025-12-06 11:30:48.561039	approved	f	f	\N	\N
211	150	151	2025-12-06 13:02:49.292598	approved	f	f	\N	\N
152	125	103	2025-11-27 13:30:53.39725	rejected	f	f	\N	\N
206	147	150	2025-12-06 10:51:17.582547	approved	f	f	\N	\N
186	113	114	2025-11-29 23:46:06.624171	approved	f	f	\N	\N
153	112	103	2025-11-27 13:33:26.684819	rejected	f	f	\N	\N
154	117	116	2025-11-27 16:52:37.378663	approved	f	f	\N	\N
155	103	102	2025-11-28 05:51:18.966185	approved	f	f	\N	\N
202	150	148	2025-12-06 10:33:43.261161	approved	f	f	\N	\N
156	127	126	2025-11-28 05:55:16.383984	approved	f	f	\N	\N
212	153	152	2025-12-06 14:56:41.37324	approved	f	f	\N	\N
158	130	128	2025-11-28 06:23:49.826032	approved	f	f	\N	\N
159	131	128	2025-11-28 06:25:05.494917	approved	f	f	\N	\N
190	143	144	2025-11-30 15:59:37.056308	approved	f	f	\N	\N
160	132	131	2025-11-28 06:27:14.934372	approved	f	f	\N	\N
213	118	152	2025-12-06 15:13:05.975755	approved	f	f	\N	\N
161	127	131	2025-11-28 06:41:25.901967	approved	f	f	\N	\N
191	144	142	2025-12-01 10:20:30.668372	rejected	f	f	\N	\N
162	133	131	2025-11-28 06:42:46.039836	approved	f	f	\N	\N
163	131	134	2025-11-28 06:47:04.223265	pending	f	f	\N	\N
214	155	148	2025-12-14 10:22:31.529207	approved	f	f	\N	\N
164	133	130	2025-11-28 07:04:05.780006	approved	f	f	\N	\N
215	147	149	2025-12-14 10:57:16.661393	approved	f	f	\N	\N
165	135	130	2025-11-28 07:05:18.968385	approved	f	f	\N	\N
193	143	142	2025-12-02 21:19:46.15966	approved	f	f	\N	\N
166	136	130	2025-11-28 07:09:13.701575	approved	f	f	\N	\N
216	141	117	2025-12-15 23:47:48.000676	approved	f	f	\N	\N
167	137	130	2025-11-28 07:10:26.530876	approved	f	f	\N	\N
168	138	130	2025-11-28 07:13:39.896943	approved	f	f	\N	\N
169	139	130	2025-11-28 07:16:19.910272	approved	f	f	\N	\N
170	113	109	2025-11-28 07:58:01.848238	approved	f	f	\N	\N
171	140	109	2025-11-28 07:59:27.524487	approved	f	f	\N	\N
172	117	109	2025-11-28 08:03:28.952867	approved	f	f	\N	\N
196	126	116	2025-12-03 21:53:04.755974	approved	f	f	\N	\N
173	116	141	2025-11-28 08:04:35.720429	approved	f	f	\N	\N
197	145	116	2025-12-04 00:35:32.516601	approved	f	f	\N	\N
198	118	120	2025-12-05 21:11:03.877862	approved	f	f	\N	\N
199	132	127	2025-12-05 21:24:14.094224	approved	f	f	\N	\N
157	127	128	2025-11-28 06:11:34.087193	approved	f	f	\N	\N
174	127	113	2025-11-28 11:00:12.071125	approved	t	f	127	\N
201	148	149	2025-12-06 10:28:01.33934	approved	f	f	\N	\N
217	158	102	2025-12-19 09:55:08.086142	approved	f	f	\N	\N
218	112	102	2025-12-19 10:04:29.479031	approved	f	f	\N	\N
219	113	102	2025-12-19 10:08:13.510517	approved	f	f	\N	\N
220	114	102	2025-12-19 10:10:36.043376	approved	f	f	\N	\N
221	159	102	2025-12-19 10:50:37.963897	approved	f	f	\N	\N
222	105	159	2025-12-19 10:51:18.604843	approved	f	f	\N	\N
224	106	105	2025-12-19 10:59:34.86096	approved	f	f	\N	\N
225	107	105	2025-12-19 11:07:54.563706	approved	f	f	\N	\N
226	108	107	2025-12-19 11:15:22.995853	approved	f	f	\N	\N
227	105	108	2025-12-19 11:16:01.528789	approved	f	f	\N	\N
228	108	103	2025-12-19 14:39:26.778398	approved	f	f	\N	\N
229	108	102	2025-12-19 14:48:19.552803	approved	f	f	\N	\N
223	106	102	2025-12-19 10:59:20.980405	approved	f	f	\N	\N
230	107	102	2025-12-19 21:36:58.2449	approved	f	f	\N	\N
238	109	102	2025-12-19 22:20:52.257901	approved	f	f	\N	\N
239	104	102	2026-06-28 14:51:51.016041	approved	f	f	\N	\N
240	102	110	2026-06-28 15:39:26.196701	approved	f	f	\N	\N
241	119	102	2026-06-28 15:44:59.426175	approved	f	f	\N	\N
242	102	124	2026-06-28 16:29:06.832331	approved	f	f	\N	\N
243	102	660	2026-06-28 17:02:58.61483	approved	f	f	\N	\N
244	102	126	2026-06-28 17:12:39.508408	approved	f	f	\N	\N
\.


--
-- Name: favorite_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorite_contacts_id_seq', 3, true);


--
-- Name: favorite_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorite_groups_id_seq', 4, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.favorites_id_seq', 80, true);


--
-- Name: file_assistant_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.file_assistant_messages_id_seq', 11, true);


--
-- Name: group_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.group_members_id_seq', 265, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.groups_id_seq', 66, true);


--
-- Name: scheduled_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.scheduled_messages_id_seq', 12, true);


--
-- Name: synced_group_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.synced_group_messages_id_seq', 1, false);


--
-- Name: synced_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.synced_messages_id_seq', 2, true);


--
-- Name: user_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_relations_id_seq', 244, true);


--
-- PostgreSQL database dump complete
--

\unrestrict pIWXQjyGykn4wYLJzmyEDyAMlQI9We2Q6iQzDnxvomfIsXx37ktuamVG70SxZAD

