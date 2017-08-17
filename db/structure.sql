SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ads (
    id bigint NOT NULL,
    title character varying(100) NOT NULL,
    body text NOT NULL,
    user_owner bigint NOT NULL,
    type bigint NOT NULL,
    woeid_code bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    ip character varying(15),
    photo character varying(100),
    status bigint,
    comments_enabled integer,
    updated_at timestamp with time zone,
    image_file_name character varying(255),
    image_content_type character varying(255),
    image_file_size bigint,
    image_updated_at timestamp with time zone,
    readed_count bigint DEFAULT 1,
    published_at timestamp with time zone NOT NULL
);


--
-- Name: ads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE ads_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: ads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE ads_id_seq OWNED BY ads.id;


--
-- Name: announcements; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE announcements (
    id bigint NOT NULL,
    message text,
    starts_at timestamp with time zone,
    ends_at timestamp with time zone,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    locale character varying(255)
);


--
-- Name: announcements_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE announcements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: announcements_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE announcements_id_seq OWNED BY announcements.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: blockings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE blockings (
    id bigint NOT NULL,
    blocker_id bigint NOT NULL,
    blocked_id bigint NOT NULL
);


--
-- Name: blockings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE blockings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blockings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE blockings_id_seq OWNED BY blockings.id;


--
-- Name: comments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE comments (
    id bigint NOT NULL,
    ads_id bigint NOT NULL,
    body text NOT NULL,
    created_at timestamp with time zone NOT NULL,
    user_owner bigint NOT NULL,
    ip character varying(15) NOT NULL,
    updated_at timestamp with time zone
);


--
-- Name: comments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE comments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: comments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE comments_id_seq OWNED BY comments.id;


--
-- Name: conversations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE conversations (
    id bigint NOT NULL,
    subject character varying(255) DEFAULT ''::character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    originator_id bigint,
    recipient_id bigint
);


--
-- Name: conversations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE conversations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: conversations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE conversations_id_seq OWNED BY conversations.id;


--
-- Name: countries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE countries (
    id integer NOT NULL,
    iso character varying(2) NOT NULL,
    name character varying(173) NOT NULL,
    geoname_id integer
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: countries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE countries_id_seq OWNED BY countries.id;


--
-- Name: dismissals; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE dismissals (
    id bigint NOT NULL,
    announcement_id bigint,
    user_id bigint
);


--
-- Name: dismissals_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE dismissals_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: dismissals_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE dismissals_id_seq OWNED BY dismissals.id;


--
-- Name: friendships; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE friendships (
    user_id bigint NOT NULL,
    friend_id bigint NOT NULL,
    id bigint NOT NULL
);


--
-- Name: friendships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE friendships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: friendships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE friendships_id_seq OWNED BY friendships.id;


--
-- Name: identities; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE identities (
    id bigint NOT NULL,
    provider character varying(255),
    uid character varying(255),
    user_id bigint
);


--
-- Name: identities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE identities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: identities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE identities_id_seq OWNED BY identities.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE messages (
    id bigint NOT NULL,
    body text,
    subject character varying(255) DEFAULT ''::character varying,
    sender_id bigint,
    conversation_id bigint,
    updated_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: receipts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE receipts (
    id bigint NOT NULL,
    receiver_id bigint,
    notification_id bigint NOT NULL,
    is_read boolean DEFAULT false,
    trashed boolean DEFAULT false,
    deleted boolean DEFAULT false,
    mailbox_type character varying(25),
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    delivery_method character varying(255),
    message_id character varying(255)
);


--
-- Name: receipts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE receipts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: receipts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE receipts_id_seq OWNED BY receipts.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: states; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE states (
    id integer NOT NULL,
    name character varying(173) NOT NULL,
    country_id integer NOT NULL,
    geoname_id integer
);


--
-- Name: states_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE states_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: states_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE states_id_seq OWNED BY states.id;


--
-- Name: towns; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE towns (
    id integer NOT NULL,
    name character varying(173) NOT NULL,
    state_id integer,
    country_id integer NOT NULL,
    geoname_id integer
);


--
-- Name: towns_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE towns_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: towns_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE towns_id_seq OWNED BY towns.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE users (
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
    reset_password_sent_at timestamp with time zone,
    remember_created_at timestamp with time zone,
    sign_in_count bigint DEFAULT '0'::bigint NOT NULL,
    current_sign_in_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    current_sign_in_ip character varying(255),
    last_sign_in_ip character varying(255),
    ads_count bigint DEFAULT '0'::bigint,
    confirmation_token character varying(255),
    confirmed_at timestamp with time zone,
    confirmation_sent_at timestamp with time zone,
    failed_attempts bigint,
    unlock_token character varying(255),
    locked_at timestamp with time zone,
    unconfirmed_email character varying(255),
    banned_at timestamp with time zone
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: ads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads ALTER COLUMN id SET DEFAULT nextval('ads_id_seq'::regclass);


--
-- Name: announcements id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY announcements ALTER COLUMN id SET DEFAULT nextval('announcements_id_seq'::regclass);


--
-- Name: blockings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY blockings ALTER COLUMN id SET DEFAULT nextval('blockings_id_seq'::regclass);


--
-- Name: comments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments ALTER COLUMN id SET DEFAULT nextval('comments_id_seq'::regclass);


--
-- Name: conversations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY conversations ALTER COLUMN id SET DEFAULT nextval('conversations_id_seq'::regclass);


--
-- Name: countries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries ALTER COLUMN id SET DEFAULT nextval('countries_id_seq'::regclass);


--
-- Name: dismissals id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY dismissals ALTER COLUMN id SET DEFAULT nextval('dismissals_id_seq'::regclass);


--
-- Name: friendships id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendships ALTER COLUMN id SET DEFAULT nextval('friendships_id_seq'::regclass);


--
-- Name: identities id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities ALTER COLUMN id SET DEFAULT nextval('identities_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: receipts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY receipts ALTER COLUMN id SET DEFAULT nextval('receipts_id_seq'::regclass);


--
-- Name: states id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY states ALTER COLUMN id SET DEFAULT nextval('states_id_seq'::regclass);


--
-- Name: towns id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY towns ALTER COLUMN id SET DEFAULT nextval('towns_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: ads idx_16388_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT idx_16388_primary PRIMARY KEY (id);


--
-- Name: announcements idx_16398_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY announcements
    ADD CONSTRAINT idx_16398_primary PRIMARY KEY (id);


--
-- Name: blockings idx_16407_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blockings
    ADD CONSTRAINT idx_16407_primary PRIMARY KEY (id);


--
-- Name: comments idx_16413_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT idx_16413_primary PRIMARY KEY (id);


--
-- Name: conversations idx_16422_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY conversations
    ADD CONSTRAINT idx_16422_primary PRIMARY KEY (id);


--
-- Name: dismissals idx_16429_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dismissals
    ADD CONSTRAINT idx_16429_primary PRIMARY KEY (id);


--
-- Name: friendships idx_16435_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY friendships
    ADD CONSTRAINT idx_16435_primary PRIMARY KEY (id);


--
-- Name: identities idx_16441_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT idx_16441_primary PRIMARY KEY (id);


--
-- Name: messages idx_16450_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT idx_16450_primary PRIMARY KEY (id);


--
-- Name: receipts idx_16460_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY receipts
    ADD CONSTRAINT idx_16460_primary PRIMARY KEY (id);


--
-- Name: users idx_16475_primary; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY users
    ADD CONSTRAINT idx_16475_primary PRIMARY KEY (id);


--
-- Name: states states_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY states
    ADD CONSTRAINT states_pkey PRIMARY KEY (id);


--
-- Name: towns towns_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY towns
    ADD CONSTRAINT towns_pkey PRIMARY KEY (id);


--
-- Name: idx_16388_index_ads_on_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_index_ads_on_status ON ads USING btree (status);


--
-- Name: idx_16388_index_ads_on_user_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_index_ads_on_user_owner ON ads USING btree (user_owner);


--
-- Name: idx_16388_woeid; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16388_woeid ON ads USING btree (woeid_code);


--
-- Name: idx_16407_fk_rails_8b7920d779; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16407_fk_rails_8b7920d779 ON blockings USING btree (blocked_id);


--
-- Name: idx_16407_fk_rails_feb742f250; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16407_fk_rails_feb742f250 ON blockings USING btree (blocker_id);


--
-- Name: idx_16413_ads_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16413_ads_id ON comments USING btree (ads_id);


--
-- Name: idx_16413_index_comments_on_user_owner; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16413_index_comments_on_user_owner ON comments USING btree (user_owner);


--
-- Name: idx_16422_index_conversations_on_originator_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16422_index_conversations_on_originator_id ON conversations USING btree (originator_id);


--
-- Name: idx_16422_index_conversations_on_recipient_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16422_index_conversations_on_recipient_id ON conversations USING btree (recipient_id);


--
-- Name: idx_16429_index_dismissals_on_announcement_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16429_index_dismissals_on_announcement_id ON dismissals USING btree (announcement_id);


--
-- Name: idx_16429_index_dismissals_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16429_index_dismissals_on_user_id ON dismissals USING btree (user_id);


--
-- Name: idx_16435_iduser_idfriend; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16435_iduser_idfriend ON friendships USING btree (user_id, friend_id);


--
-- Name: idx_16441_index_identities_on_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16441_index_identities_on_user_id ON identities USING btree (user_id);


--
-- Name: idx_16450_index_messages_on_conversation_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16450_index_messages_on_conversation_id ON messages USING btree (conversation_id);


--
-- Name: idx_16450_index_messages_on_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16450_index_messages_on_sender_id ON messages USING btree (sender_id);


--
-- Name: idx_16460_index_receipts_on_notification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16460_index_receipts_on_notification_id ON receipts USING btree (notification_id);


--
-- Name: idx_16460_index_receipts_on_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_16460_index_receipts_on_receiver_id ON receipts USING btree (receiver_id);


--
-- Name: idx_16470_unique_schema_migrations; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16470_unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: idx_16475_index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: idx_16475_index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_email ON users USING btree (email);


--
-- Name: idx_16475_index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: idx_16475_index_users_on_username; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_16475_index_users_on_username ON users USING btree (username);


--
-- Name: index_countries_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_countries_on_name_trigram ON countries USING gin (name gin_trgm_ops);


--
-- Name: index_states_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_states_on_country_id ON states USING btree (country_id);


--
-- Name: index_states_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_states_on_name_trigram ON states USING gin (name gin_trgm_ops);


--
-- Name: index_towns_on_country_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_country_id ON towns USING btree (country_id);


--
-- Name: index_towns_on_name_trigram; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_name_trigram ON towns USING gin (name gin_trgm_ops);


--
-- Name: index_towns_on_state_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_towns_on_state_id ON towns USING btree (state_id);


--
-- Name: comments fk_rails_0df6b78f0a; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_0df6b78f0a FOREIGN KEY (ads_id) REFERENCES ads(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: dismissals fk_rails_3f72da71a5; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dismissals
    ADD CONSTRAINT fk_rails_3f72da71a5 FOREIGN KEY (announcement_id) REFERENCES announcements(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: states fk_rails_40bd891262; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY states
    ADD CONSTRAINT fk_rails_40bd891262 FOREIGN KEY (country_id) REFERENCES countries(id);


--
-- Name: identities fk_rails_5373344100; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY identities
    ADD CONSTRAINT fk_rails_5373344100 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: blockings fk_rails_8b7920d779; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blockings
    ADD CONSTRAINT fk_rails_8b7920d779 FOREIGN KEY (blocked_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: towns fk_rails_987f8e3a85; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY towns
    ADD CONSTRAINT fk_rails_987f8e3a85 FOREIGN KEY (country_id) REFERENCES countries(id);


--
-- Name: dismissals fk_rails_9a28d19d09; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY dismissals
    ADD CONSTRAINT fk_rails_9a28d19d09 FOREIGN KEY (user_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: ads fk_rails_9ce39f9139; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY ads
    ADD CONSTRAINT fk_rails_9ce39f9139 FOREIGN KEY (user_owner) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: towns fk_rails_de137abc76; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY towns
    ADD CONSTRAINT fk_rails_de137abc76 FOREIGN KEY (state_id) REFERENCES states(id);


--
-- Name: comments fk_rails_e9eda2acf7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY comments
    ADD CONSTRAINT fk_rails_e9eda2acf7 FOREIGN KEY (user_owner) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: blockings fk_rails_feb742f250; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY blockings
    ADD CONSTRAINT fk_rails_feb742f250 FOREIGN KEY (blocker_id) REFERENCES users(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: messages notifications_on_conversation_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT notifications_on_conversation_id FOREIGN KEY (conversation_id) REFERENCES conversations(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: receipts receipts_on_notification_id; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY receipts
    ADD CONSTRAINT receipts_on_notification_id FOREIGN KEY (notification_id) REFERENCES messages(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


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
('20161122140853');


