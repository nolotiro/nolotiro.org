SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: unaccent; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS unaccent WITH SCHEMA public;


--
-- Name: EXTENSION unaccent; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION unaccent IS 'text search dictionary that removes accents';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ads (
    id bigint NOT NULL,
    title character varying(100) NOT NULL,
    body text NOT NULL,
    user_owner bigint NOT NULL,
    type bigint NOT NULL,
    woeid_code bigint NOT NULL,
    created_at timestamp without time zone NOT NULL,
    ip character varying(15),
    photo character varying(100),
    status bigint,
    comments_enabled integer,
    updated_at timestamp without time zone,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size bigint,
    image_updated_at timestamp without time zone,
    readed_count bigint DEFAULT 1,
    published_at timestamp without time zone NOT NULL
);


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.ads_id_seq OWNED BY public.ads.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.announcements (
    id bigint NOT NULL,
    message text,
    starts_at timestamp without time zone,
    ends_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    locale character varying(255)
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.announcements_id_seq OWNED BY public.announcements.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blockings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blockings (
    id bigint NOT NULL,
    blocker_id bigint NOT NULL,
    blocked_id bigint NOT NULL
);


--
-- Name: blockings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blockings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blockings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blockings_id_seq OWNED BY public.blockings.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.comments (
    id bigint NOT NULL,
    ads_id bigint NOT NULL,
    body text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    user_owner bigint NOT NULL,
    ip character varying(15) NOT NULL,
    updated_at timestamp without time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.comments_id_seq OWNED BY public.comments.id;


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.conversations (
    id bigint NOT NULL,
    subject character varying(255) DEFAULT ''::character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    originator_id bigint,
    recipient_id bigint
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.conversations_id_seq OWNED BY public.conversations.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.countries (
    id bigint NOT NULL,
    iso character varying(2) NOT NULL,
    name character varying(173) NOT NULL,
    geoname_id integer
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.countries_id_seq OWNED BY public.countries.id;


--
-- Name: dismissals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.dismissals (
    id bigint NOT NULL,
    announcement_id bigint,
    user_id bigint
);


--
-- Name: dismissals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.dismissals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dismissals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.dismissals_id_seq OWNED BY public.dismissals.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.friendships (
    id bigint NOT NULL,
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL
);


--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.friendships_id_seq OWNED BY public.friendships.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.identities (
    id bigint NOT NULL,
    provider character varying(255),
    uid character varying(255),
    user_id bigint
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.identities_id_seq OWNED BY public.identities.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id bigint NOT NULL,
    body text,
    subject character varying(255) DEFAULT ''::character varying,
    sender_id bigint,
    conversation_id bigint,
    updated_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.messages_id_seq OWNED BY public.messages.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.receipts (
    id bigint NOT NULL,
    receiver_id bigint,
    notification_id bigint NOT NULL,
    is_read boolean DEFAULT false,
    trashed boolean DEFAULT false,
    deleted boolean DEFAULT false,
    mailbox_type character varying(25),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    delivery_method character varying(255),
    message_id character varying(255)
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.receipts_id_seq OWNED BY public.receipts.id;


--
-- Name: reports; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reports (
    id bigint NOT NULL,
    reported_id integer,
    reporter_id integer,
    dismissed_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: reports_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reports_id_seq OWNED BY public.reports.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.states (
    id bigint NOT NULL,
    name character varying(173) NOT NULL,
    country_id bigint NOT NULL,
    geoname_id integer
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.states_id_seq OWNED BY public.states.id;


--
-- Name: towns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.towns (
    id bigint NOT NULL,
    name character varying(173) NOT NULL,
    state_id bigint,
    country_id bigint NOT NULL,
    geoname_id integer
);


--
-- Name: towns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.towns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: towns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.towns_id_seq OWNED BY public.towns.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying(63) NOT NULL,
    legacy_password_hash character varying(255),
    email character varying(100) NOT NULL,
    created_at date NOT NULL,
    active integer DEFAULT 0 NOT NULL,
    role integer DEFAULT 0 NOT NULL,
    woeid bigint,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count bigint DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    ads_count bigint DEFAULT 0,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    failed_attempts bigint,
    unlock_token character varying(255),
    locked_at timestamp without time zone,
    unconfirmed_email character varying(255),
    banned_at timestamp without time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads ALTER COLUMN id SET DEFAULT nextval('public.ads_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements ALTER COLUMN id SET DEFAULT nextval('public.announcements_id_seq'::regclass);


--
-- Name: blockings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockings ALTER COLUMN id SET DEFAULT nextval('public.blockings_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments ALTER COLUMN id SET DEFAULT nextval('public.comments_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations ALTER COLUMN id SET DEFAULT nextval('public.conversations_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries ALTER COLUMN id SET DEFAULT nextval('public.countries_id_seq'::regclass);


--
-- Name: dismissals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dismissals ALTER COLUMN id SET DEFAULT nextval('public.dismissals_id_seq'::regclass);


--
-- Name: friendships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships ALTER COLUMN id SET DEFAULT nextval('public.friendships_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities ALTER COLUMN id SET DEFAULT nextval('public.identities_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts ALTER COLUMN id SET DEFAULT nextval('public.receipts_id_seq'::regclass);


--
-- Name: reports id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports ALTER COLUMN id SET DEFAULT nextval('public.reports_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states ALTER COLUMN id SET DEFAULT nextval('public.states_id_seq'::regclass);


--
-- Name: towns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.towns ALTER COLUMN id SET DEFAULT nextval('public.towns_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: ads ads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT ads_pkey PRIMARY KEY (id);


--
-- Name: announcements announcements_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.announcements
    ADD CONSTRAINT announcements_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blockings blockings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockings
    ADD CONSTRAINT blockings_pkey PRIMARY KEY (id);


--
-- Name: comments comments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT comments_pkey PRIMARY KEY (id);


--
-- Name: conversations conversations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.conversations
    ADD CONSTRAINT conversations_pkey PRIMARY KEY (id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: dismissals dismissals_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dismissals
    ADD CONSTRAINT dismissals_pkey PRIMARY KEY (id);


--
-- Name: friendships friendships_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.friendships
    ADD CONSTRAINT friendships_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: receipts receipts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_pkey PRIMARY KEY (id);


--
-- Name: reports reports_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT reports_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: towns towns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT towns_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: idx_16388_index_ads_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_index_ads_on_status ON public.ads USING btree (status);


--
-- Name: idx_16388_index_ads_on_user_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_index_ads_on_user_owner ON public.ads USING btree (user_owner);


--
-- Name: idx_16388_woeid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_woeid ON public.ads USING btree (woeid_code);


--
-- Name: idx_16407_fk_rails_8b7920d779; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16407_fk_rails_8b7920d779 ON public.blockings USING btree (blocked_id);


--
-- Name: idx_16407_fk_rails_feb742f250; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16407_fk_rails_feb742f250 ON public.blockings USING btree (blocker_id);


--
-- Name: idx_16413_ads_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16413_ads_id ON public.comments USING btree (ads_id);


--
-- Name: idx_16413_index_comments_on_user_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16413_index_comments_on_user_owner ON public.comments USING btree (user_owner);


--
-- Name: idx_16422_index_conversations_on_originator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16422_index_conversations_on_originator_id ON public.conversations USING btree (originator_id);


--
-- Name: idx_16422_index_conversations_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16422_index_conversations_on_recipient_id ON public.conversations USING btree (recipient_id);


--
-- Name: idx_16429_index_dismissals_on_announcement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16429_index_dismissals_on_announcement_id ON public.dismissals USING btree (announcement_id);


--
-- Name: idx_16429_index_dismissals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16429_index_dismissals_on_user_id ON public.dismissals USING btree (user_id);


--
-- Name: idx_16435_iduser_idfriend; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16435_iduser_idfriend ON public.friendships USING btree (user_id, friend_id);


--
-- Name: idx_16441_index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16441_index_identities_on_user_id ON public.identities USING btree (user_id);


--
-- Name: idx_16450_index_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16450_index_messages_on_conversation_id ON public.messages USING btree (conversation_id);


--
-- Name: idx_16450_index_messages_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16450_index_messages_on_sender_id ON public.messages USING btree (sender_id);


--
-- Name: idx_16460_index_receipts_on_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16460_index_receipts_on_notification_id ON public.receipts USING btree (notification_id);


--
-- Name: idx_16460_index_receipts_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16460_index_receipts_on_receiver_id ON public.receipts USING btree (receiver_id);


--
-- Name: idx_16475_index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: idx_16475_index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_email ON public.users USING btree (email);


--
-- Name: idx_16475_index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: idx_16475_index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_username ON public.users USING btree (username);


--
-- Name: index_countries_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_countries_on_name_trigram ON public.countries USING gin (name public.gin_trgm_ops);


--
-- Name: index_reports_on_reported_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reports_on_reported_id ON public.reports USING btree (reported_id);


--
-- Name: index_reports_on_reporter_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_reports_on_reporter_id ON public.reports USING btree (reporter_id);


--
-- Name: index_states_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_states_on_country_id ON public.states USING btree (country_id);


--
-- Name: index_states_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_states_on_name_trigram ON public.states USING gin (name public.gin_trgm_ops);


--
-- Name: index_towns_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_country_id ON public.towns USING btree (country_id);


--
-- Name: index_towns_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_name_trigram ON public.towns USING gin (name public.gin_trgm_ops);


--
-- Name: index_towns_on_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_state_id ON public.towns USING btree (state_id);


--
-- Name: comments fk_rails_0df6b78f0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_0df6b78f0a FOREIGN KEY (ads_id) REFERENCES public.ads(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: dismissals fk_rails_3f72da71a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dismissals
    ADD CONSTRAINT fk_rails_3f72da71a5 FOREIGN KEY (announcement_id) REFERENCES public.announcements(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: states fk_rails_40bd891262; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.states
    ADD CONSTRAINT fk_rails_40bd891262 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: identities fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: reports fk_rails_6de8c16dd2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_rails_6de8c16dd2 FOREIGN KEY (reported_id) REFERENCES public.users(id);


--
-- Name: blockings fk_rails_8b7920d779; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockings
    ADD CONSTRAINT fk_rails_8b7920d779 FOREIGN KEY (blocked_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: towns fk_rails_987f8e3a85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT fk_rails_987f8e3a85 FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: dismissals fk_rails_9a28d19d09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.dismissals
    ADD CONSTRAINT fk_rails_9a28d19d09 FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ads fk_rails_9ce39f9139; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ads
    ADD CONSTRAINT fk_rails_9ce39f9139 FOREIGN KEY (user_owner) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: reports fk_rails_c4cb6e6463; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reports
    ADD CONSTRAINT fk_rails_c4cb6e6463 FOREIGN KEY (reporter_id) REFERENCES public.users(id);


--
-- Name: towns fk_rails_de137abc76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.towns
    ADD CONSTRAINT fk_rails_de137abc76 FOREIGN KEY (state_id) REFERENCES public.states(id);


--
-- Name: comments fk_rails_e9eda2acf7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.comments
    ADD CONSTRAINT fk_rails_e9eda2acf7 FOREIGN KEY (user_owner) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: blockings fk_rails_feb742f250; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blockings
    ADD CONSTRAINT fk_rails_feb742f250 FOREIGN KEY (blocker_id) REFERENCES public.users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: messages notifications_on_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT notifications_on_conversation_id FOREIGN KEY (conversation_id) REFERENCES public.conversations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: receipts receipts_on_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.receipts
    ADD CONSTRAINT receipts_on_notification_id FOREIGN KEY (notification_id) REFERENCES public.messages(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20160816164211'),
('20160825201238'),
('20160902112213'),
('20160904155629'),
('20160904155856'),
('20160921193632'),
('20160923223216'),
('20160924163454'),
('20160924163658'),
('20160930235635'),
('20161001185104'),
('20161007014256'),
('20161019233040'),
('20161117184138'),
('20161117184157'),
('20161122140853'),
('20161127103220'),
('20170905120853'),
('20170909120825');


