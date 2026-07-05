--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4 (Postgres.app)
-- Dumped by pg_dump version 17.5 (Homebrew)

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

ALTER TABLE IF EXISTS ONLY public.user_relations DROP CONSTRAINT IF EXISTS user_relations_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.user_relations DROP CONSTRAINT IF EXISTS user_relations_friend_id_fkey;
ALTER TABLE IF EXISTS ONLY public.messages DROP CONSTRAINT IF EXISTS messages_sender_id_fkey;
ALTER TABLE IF EXISTS ONLY public.messages DROP CONSTRAINT IF EXISTS messages_receiver_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invite_codes DROP CONSTRAINT IF EXISTS invite_codes_used_by_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invite_code_usages DROP CONSTRAINT IF EXISTS invite_code_usages_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.invite_code_usages DROP CONSTRAINT IF EXISTS invite_code_usages_invite_code_id_fkey;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_owner_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_messages DROP CONSTRAINT IF EXISTS group_messages_sender_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_messages DROP CONSTRAINT IF EXISTS group_messages_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_message_reads DROP CONSTRAINT IF EXISTS group_message_reads_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_message_reads DROP CONSTRAINT IF EXISTS group_message_reads_group_message_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_members DROP CONSTRAINT IF EXISTS group_members_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.group_members DROP CONSTRAINT IF EXISTS group_members_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.file_assistant_messages DROP CONSTRAINT IF EXISTS file_assistant_messages_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorites DROP CONSTRAINT IF EXISTS favorites_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorites DROP CONSTRAINT IF EXISTS favorites_sender_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorites DROP CONSTRAINT IF EXISTS favorites_message_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorite_groups DROP CONSTRAINT IF EXISTS favorite_groups_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorite_groups DROP CONSTRAINT IF EXISTS favorite_groups_group_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorite_contacts DROP CONSTRAINT IF EXISTS favorite_contacts_user_id_fkey;
ALTER TABLE IF EXISTS ONLY public.favorite_contacts DROP CONSTRAINT IF EXISTS favorite_contacts_contact_id_fkey;
DROP TRIGGER IF EXISTS update_users_updated_at ON public.users;
DROP TRIGGER IF EXISTS update_server_settings_updated_at ON public.server_settings;
DROP INDEX IF EXISTS public.idx_verification_codes_expires_at;
DROP INDEX IF EXISTS public.idx_verification_codes_account;
DROP INDEX IF EXISTS public.idx_users_voip_token;
DROP INDEX IF EXISTS public.idx_users_username;
DROP INDEX IF EXISTS public.idx_users_phone;
DROP INDEX IF EXISTS public.idx_users_invited_by_code;
DROP INDEX IF EXISTS public.idx_users_invite_code;
DROP INDEX IF EXISTS public.idx_users_email;
DROP INDEX IF EXISTS public.idx_users_active_token;
DROP INDEX IF EXISTS public.idx_user_relations_user_id;
DROP INDEX IF EXISTS public.idx_user_relations_is_deleted;
DROP INDEX IF EXISTS public.idx_user_relations_is_blocked;
DROP INDEX IF EXISTS public.idx_user_relations_friend_id;
DROP INDEX IF EXISTS public.idx_user_relations_approval_status;
DROP INDEX IF EXISTS public.idx_scheduled_messages_status;
DROP INDEX IF EXISTS public.idx_scheduled_messages_sender_receiver;
DROP INDEX IF EXISTS public.idx_scheduled_messages_sender_id;
DROP INDEX IF EXISTS public.idx_scheduled_messages_send_time;
DROP INDEX IF EXISTS public.idx_scheduled_messages_send_date;
DROP INDEX IF EXISTS public.idx_scheduled_messages_receiver_id;
DROP INDEX IF EXISTS public.idx_messages_status;
DROP INDEX IF EXISTS public.idx_messages_server_id;
DROP INDEX IF EXISTS public.idx_messages_sender_receiver;
DROP INDEX IF EXISTS public.idx_messages_sender_name;
DROP INDEX IF EXISTS public.idx_messages_sender_id;
DROP INDEX IF EXISTS public.idx_messages_receiver_name;
DROP INDEX IF EXISTS public.idx_messages_receiver_id;
DROP INDEX IF EXISTS public.idx_messages_is_read;
DROP INDEX IF EXISTS public.idx_messages_created_at;
DROP INDEX IF EXISTS public.idx_invite_code_usages_user_id;
DROP INDEX IF EXISTS public.idx_invite_code_usages_invite_code_id;
DROP INDEX IF EXISTS public.idx_groups_owner_id;
DROP INDEX IF EXISTS public.idx_group_messages_server_id;
DROP INDEX IF EXISTS public.idx_group_messages_sender_id;
DROP INDEX IF EXISTS public.idx_group_messages_group_id;
DROP INDEX IF EXISTS public.idx_group_messages_created_at;
DROP INDEX IF EXISTS public.idx_group_messages_channel_name;
DROP INDEX IF EXISTS public.idx_group_messages_call_type;
DROP INDEX IF EXISTS public.idx_group_message_reads_user_id;
DROP INDEX IF EXISTS public.idx_group_message_reads_group_message_id;
DROP INDEX IF EXISTS public.idx_group_members_user_id;
DROP INDEX IF EXISTS public.idx_group_members_group_id;
DROP INDEX IF EXISTS public.idx_file_assistant_messages_user_id;
DROP INDEX IF EXISTS public.idx_file_assistant_messages_status;
DROP INDEX IF EXISTS public.idx_file_assistant_messages_created_at;
DROP INDEX IF EXISTS public.idx_favorites_user_id;
DROP INDEX IF EXISTS public.idx_favorites_created_at;
DROP INDEX IF EXISTS public.idx_favorite_groups_user_id;
DROP INDEX IF EXISTS public.idx_favorite_groups_group_id;
DROP INDEX IF EXISTS public.idx_favorite_groups_created_at;
DROP INDEX IF EXISTS public.idx_favorite_contacts_user_id;
DROP INDEX IF EXISTS public.idx_favorite_contacts_created_at;
DROP INDEX IF EXISTS public.idx_favorite_contacts_contact_id;
DROP INDEX IF EXISTS public.idx_device_uuid;
DROP INDEX IF EXISTS public.idx_device_platform;
DROP INDEX IF EXISTS public.idx_device_installed_at;
DROP INDEX IF EXISTS public.idx_app_versions_status;
DROP INDEX IF EXISTS public.idx_app_versions_platform_status;
DROP INDEX IF EXISTS public.idx_app_versions_platform;
ALTER TABLE IF EXISTS ONLY public.verification_codes DROP CONSTRAINT IF EXISTS verification_codes_pkey;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_username_key;
ALTER TABLE IF EXISTS ONLY public.users DROP CONSTRAINT IF EXISTS users_pkey;
ALTER TABLE IF EXISTS ONLY public.user_relations DROP CONSTRAINT IF EXISTS user_relations_user_id_friend_id_key;
ALTER TABLE IF EXISTS ONLY public.user_relations DROP CONSTRAINT IF EXISTS user_relations_pkey;
ALTER TABLE IF EXISTS ONLY public.server_settings DROP CONSTRAINT IF EXISTS server_settings_pkey;
ALTER TABLE IF EXISTS ONLY public.server_settings DROP CONSTRAINT IF EXISTS server_settings_key_key;
ALTER TABLE IF EXISTS ONLY public.scheduled_messages DROP CONSTRAINT IF EXISTS scheduled_messages_pkey;
ALTER TABLE IF EXISTS ONLY public.private_message_synced DROP CONSTRAINT IF EXISTS private_message_synced_pkey;
ALTER TABLE IF EXISTS ONLY public.private_message_synced DROP CONSTRAINT IF EXISTS private_message_synced_message_id_user_id_key;
ALTER TABLE IF EXISTS ONLY public.messages DROP CONSTRAINT IF EXISTS messages_pkey;
ALTER TABLE IF EXISTS ONLY public.invite_codes DROP CONSTRAINT IF EXISTS invite_codes_pkey;
ALTER TABLE IF EXISTS ONLY public.invite_codes DROP CONSTRAINT IF EXISTS invite_codes_code_key;
ALTER TABLE IF EXISTS ONLY public.invite_code_usages DROP CONSTRAINT IF EXISTS invite_code_usages_pkey;
ALTER TABLE IF EXISTS ONLY public.invite_code_usages DROP CONSTRAINT IF EXISTS invite_code_usages_invite_code_id_user_id_key;
ALTER TABLE IF EXISTS ONLY public.groups DROP CONSTRAINT IF EXISTS groups_pkey;
ALTER TABLE IF EXISTS ONLY public.group_messages DROP CONSTRAINT IF EXISTS group_messages_pkey;
ALTER TABLE IF EXISTS ONLY public.group_message_reads DROP CONSTRAINT IF EXISTS group_message_reads_pkey;
ALTER TABLE IF EXISTS ONLY public.group_message_reads DROP CONSTRAINT IF EXISTS group_message_reads_group_message_id_user_id_key;
ALTER TABLE IF EXISTS ONLY public.group_members DROP CONSTRAINT IF EXISTS group_members_pkey;
ALTER TABLE IF EXISTS ONLY public.group_members DROP CONSTRAINT IF EXISTS group_members_group_id_user_id_key;
ALTER TABLE IF EXISTS ONLY public.file_assistant_messages DROP CONSTRAINT IF EXISTS file_assistant_messages_pkey;
ALTER TABLE IF EXISTS ONLY public.favorites DROP CONSTRAINT IF EXISTS favorites_pkey;
ALTER TABLE IF EXISTS ONLY public.favorite_groups DROP CONSTRAINT IF EXISTS favorite_groups_user_id_group_id_key;
ALTER TABLE IF EXISTS ONLY public.favorite_groups DROP CONSTRAINT IF EXISTS favorite_groups_pkey;
ALTER TABLE IF EXISTS ONLY public.favorite_contacts DROP CONSTRAINT IF EXISTS favorite_contacts_user_id_contact_id_key;
ALTER TABLE IF EXISTS ONLY public.favorite_contacts DROP CONSTRAINT IF EXISTS favorite_contacts_pkey;
ALTER TABLE IF EXISTS ONLY public.device_registrations DROP CONSTRAINT IF EXISTS device_registrations_uuid_key;
ALTER TABLE IF EXISTS ONLY public.device_registrations DROP CONSTRAINT IF EXISTS device_registrations_pkey;
ALTER TABLE IF EXISTS ONLY public.app_versions DROP CONSTRAINT IF EXISTS app_versions_version_platform_key;
ALTER TABLE IF EXISTS ONLY public.app_versions DROP CONSTRAINT IF EXISTS app_versions_pkey;
ALTER TABLE IF EXISTS public.verification_codes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.users ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.user_relations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.server_settings ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.scheduled_messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.private_message_synced ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.invite_codes ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.invite_code_usages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.groups ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.group_messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.group_message_reads ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.group_members ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.file_assistant_messages ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.favorites ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.favorite_groups ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.favorite_contacts ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.device_registrations ALTER COLUMN id DROP DEFAULT;
ALTER TABLE IF EXISTS public.app_versions ALTER COLUMN id DROP DEFAULT;
DROP SEQUENCE IF EXISTS public.verification_codes_id_seq;
DROP TABLE IF EXISTS public.verification_codes;
DROP SEQUENCE IF EXISTS public.users_id_seq;
DROP TABLE IF EXISTS public.users;
DROP SEQUENCE IF EXISTS public.user_relations_id_seq;
DROP TABLE IF EXISTS public.user_relations;
DROP SEQUENCE IF EXISTS public.server_settings_id_seq;
DROP TABLE IF EXISTS public.server_settings;
DROP SEQUENCE IF EXISTS public.scheduled_messages_id_seq;
DROP TABLE IF EXISTS public.scheduled_messages;
DROP SEQUENCE IF EXISTS public.private_message_synced_id_seq;
DROP TABLE IF EXISTS public.private_message_synced;
DROP SEQUENCE IF EXISTS public.messages_id_seq;
DROP TABLE IF EXISTS public.messages;
DROP SEQUENCE IF EXISTS public.invite_codes_id_seq;
DROP TABLE IF EXISTS public.invite_codes;
DROP SEQUENCE IF EXISTS public.invite_code_usages_id_seq;
DROP TABLE IF EXISTS public.invite_code_usages;
DROP SEQUENCE IF EXISTS public.groups_id_seq;
DROP TABLE IF EXISTS public.groups;
DROP SEQUENCE IF EXISTS public.group_messages_id_seq;
DROP TABLE IF EXISTS public.group_messages;
DROP SEQUENCE IF EXISTS public.group_message_reads_id_seq;
DROP TABLE IF EXISTS public.group_message_reads;
DROP SEQUENCE IF EXISTS public.group_members_id_seq;
DROP TABLE IF EXISTS public.group_members;
DROP SEQUENCE IF EXISTS public.file_assistant_messages_id_seq;
DROP TABLE IF EXISTS public.file_assistant_messages;
DROP SEQUENCE IF EXISTS public.favorites_id_seq;
DROP TABLE IF EXISTS public.favorites;
DROP SEQUENCE IF EXISTS public.favorite_groups_id_seq;
DROP TABLE IF EXISTS public.favorite_groups;
DROP SEQUENCE IF EXISTS public.favorite_contacts_id_seq;
DROP TABLE IF EXISTS public.favorite_contacts;
DROP SEQUENCE IF EXISTS public.device_registrations_id_seq;
DROP TABLE IF EXISTS public.device_registrations;
DROP SEQUENCE IF EXISTS public.app_versions_id_seq;
DROP TABLE IF EXISTS public.app_versions;
DROP FUNCTION IF EXISTS public.update_updated_at_column();
DROP FUNCTION IF EXISTS public.clean_expired_verification_codes();
-- *not* dropping schema, since initdb creates it
--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

-- *not* creating schema, since initdb creates it


--
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON SCHEMA public IS '';


--
-- Name: clean_expired_verification_codes(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.clean_expired_verification_codes() RETURNS void
    LANGUAGE plpgsql
    AS $$
BEGIN
    DELETE FROM verification_codes WHERE expires_at < CURRENT_TIMESTAMP;
END;
$$;


--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: app_versions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.app_versions (
    id integer NOT NULL,
    version character varying(50) NOT NULL,
    platform character varying(20) NOT NULL,
    distribution_type character varying(20) DEFAULT 'oss'::character varying,
    package_url text,
    oss_object_key character varying(500),
    release_notes text,
    status character varying(20) DEFAULT 'draft'::character varying,
    is_force_update boolean DEFAULT false,
    min_supported_version character varying(50),
    file_size bigint DEFAULT 0,
    file_hash character varying(128),
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    published_at timestamp with time zone,
    created_by character varying(100)
);


--
-- Name: TABLE app_versions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.app_versions IS 'Application version upgrade information table';


--
-- Name: COLUMN app_versions.version; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.version IS 'Version number';


--
-- Name: COLUMN app_versions.platform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.platform IS 'Platform: windows, android, ios';


--
-- Name: COLUMN app_versions.distribution_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.distribution_type IS 'Distribution type: oss(OSS file), url(external link like TestFlight)';


--
-- Name: COLUMN app_versions.package_url; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.package_url IS 'Upgrade package download address/distribution address';


--
-- Name: COLUMN app_versions.oss_object_key; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.oss_object_key IS 'OSS object storage key (only for oss type)';


--
-- Name: COLUMN app_versions.release_notes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.release_notes IS 'Upgrade description information';


--
-- Name: COLUMN app_versions.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.status IS 'Status: draft, published, deprecated';


--
-- Name: COLUMN app_versions.is_force_update; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.is_force_update IS 'Whether to force update';


--
-- Name: COLUMN app_versions.min_supported_version; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.min_supported_version IS 'Minimum supported version';


--
-- Name: COLUMN app_versions.file_size; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.file_size IS 'File size (bytes, only for oss type)';


--
-- Name: COLUMN app_versions.file_hash; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.app_versions.file_hash IS 'File hash value (only for oss type)';


--
-- Name: app_versions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.app_versions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: app_versions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.app_versions_id_seq OWNED BY public.app_versions.id;


--
-- Name: device_registrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.device_registrations (
    id integer NOT NULL,
    uuid character varying(255) NOT NULL,
    request_ip character varying(50) NOT NULL,
    platform character varying(20) NOT NULL,
    system_info jsonb NOT NULL,
    installed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: TABLE device_registrations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.device_registrations IS 'Device registration table: records device information on first app startup';


--
-- Name: COLUMN device_registrations.uuid; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_registrations.uuid IS 'Database encryption key UUID (original UUID, not MD5 encrypted)';


--
-- Name: COLUMN device_registrations.request_ip; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_registrations.request_ip IS 'Client request IP address';


--
-- Name: COLUMN device_registrations.platform; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_registrations.platform IS 'Operating system platform: android, ios, windows, macos, linux';


--
-- Name: COLUMN device_registrations.system_info; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_registrations.system_info IS 'System detailed information in JSON format, includes device model, OS version, etc';


--
-- Name: COLUMN device_registrations.installed_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.device_registrations.installed_at IS 'Application first installation/startup time';


--
-- Name: device_registrations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.device_registrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: device_registrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.device_registrations_id_seq OWNED BY public.device_registrations.id;


--
-- Name: favorite_contacts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorite_contacts (
    id integer NOT NULL,
    user_id integer NOT NULL,
    contact_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE favorite_contacts; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.favorite_contacts IS 'Favorite Contacts Table';


--
-- Name: COLUMN favorite_contacts.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_contacts.user_id IS 'User ID';


--
-- Name: COLUMN favorite_contacts.contact_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_contacts.contact_id IS 'Favorite contact ID';


--
-- Name: COLUMN favorite_contacts.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_contacts.created_at IS 'Created at';


--
-- Name: favorite_contacts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorite_contacts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorite_contacts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorite_contacts_id_seq OWNED BY public.favorite_contacts.id;


--
-- Name: favorite_groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorite_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE favorite_groups; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.favorite_groups IS 'Favorite Groups Table';


--
-- Name: COLUMN favorite_groups.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_groups.user_id IS 'User ID';


--
-- Name: COLUMN favorite_groups.group_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_groups.group_id IS 'Favorite group ID';


--
-- Name: COLUMN favorite_groups.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorite_groups.created_at IS 'Created at';


--
-- Name: favorite_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorite_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorite_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorite_groups_id_seq OWNED BY public.favorite_groups.id;


--
-- Name: favorites; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.favorites (
    id integer NOT NULL,
    user_id integer NOT NULL,
    message_id integer,
    content text NOT NULL,
    message_type character varying(50) DEFAULT 'text'::character varying,
    file_name character varying(255),
    sender_id integer NOT NULL,
    sender_name character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    server_id integer,
    sync_status character varying(20) DEFAULT 'synced'::character varying
);


--
-- Name: TABLE favorites; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.favorites IS 'User Favorite Messages Table';


--
-- Name: COLUMN favorites.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.user_id IS 'User ID who favorited this message';


--
-- Name: COLUMN favorites.message_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.message_id IS 'Favorited message ID (nullable if original message is deleted)';


--
-- Name: COLUMN favorites.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.content IS 'Message content';


--
-- Name: COLUMN favorites.message_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.message_type IS 'Message type: text, image, file, quoted';


--
-- Name: COLUMN favorites.file_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.file_name IS 'File name (for file type)';


--
-- Name: COLUMN favorites.sender_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.sender_id IS 'Original message sender ID';


--
-- Name: COLUMN favorites.sender_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.sender_name IS 'Original message sender name';


--
-- Name: COLUMN favorites.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.favorites.created_at IS 'Favorited at';


--
-- Name: favorites_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.favorites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: favorites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.favorites_id_seq OWNED BY public.favorites.id;


--
-- Name: file_assistant_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.file_assistant_messages (
    id integer NOT NULL,
    user_id integer NOT NULL,
    content text NOT NULL,
    message_type character varying(50) DEFAULT 'text'::character varying,
    file_name character varying(255),
    quoted_message_id integer,
    quoted_message_content text,
    status character varying(20) DEFAULT 'normal'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    server_id integer
);


--
-- Name: TABLE file_assistant_messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.file_assistant_messages IS 'File Assistant Messages Table';


--
-- Name: COLUMN file_assistant_messages.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.user_id IS 'User ID';


--
-- Name: COLUMN file_assistant_messages.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.content IS 'Message content';


--
-- Name: COLUMN file_assistant_messages.message_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.message_type IS 'Message type: text, image, file, quoted';


--
-- Name: COLUMN file_assistant_messages.file_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.file_name IS 'File name (for file type)';


--
-- Name: COLUMN file_assistant_messages.quoted_message_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.quoted_message_id IS 'Quoted message ID';


--
-- Name: COLUMN file_assistant_messages.quoted_message_content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.quoted_message_content IS 'Quoted message content';


--
-- Name: COLUMN file_assistant_messages.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.status IS 'Message status: normal, recalled';


--
-- Name: COLUMN file_assistant_messages.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.file_assistant_messages.created_at IS 'Created at';


--
-- Name: file_assistant_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.file_assistant_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: file_assistant_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.file_assistant_messages_id_seq OWNED BY public.file_assistant_messages.id;


--
-- Name: group_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_members (
    id integer NOT NULL,
    group_id integer NOT NULL,
    user_id integer NOT NULL,
    nickname character varying(100),
    remark character varying(255),
    role character varying(20) DEFAULT 'member'::character varying,
    joined_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    is_muted boolean DEFAULT false,
    approval_status character varying(20) DEFAULT 'approved'::character varying,
    do_not_disturb boolean DEFAULT false,
    CONSTRAINT check_approval_status CHECK (((approval_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text])))
);


--
-- Name: COLUMN group_members.is_muted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_members.is_muted IS 'Whether the member is muted';


--
-- Name: COLUMN group_members.approval_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_members.approval_status IS 'Approval status: pending, approved, rejected';


--
-- Name: COLUMN group_members.do_not_disturb; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_members.do_not_disturb IS 'Do not disturb: true displays only a red dot, false displays unread message count';


--
-- Name: group_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_members_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_members_id_seq OWNED BY public.group_members.id;


--
-- Name: group_message_reads; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_message_reads (
    id integer NOT NULL,
    group_message_id integer NOT NULL,
    user_id integer NOT NULL,
    read_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: group_message_reads_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_message_reads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_message_reads_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_message_reads_id_seq OWNED BY public.group_message_reads.id;


--
-- Name: group_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.group_messages (
    id integer NOT NULL,
    group_id integer NOT NULL,
    sender_id integer,
    sender_name character varying(100) NOT NULL,
    content text NOT NULL,
    message_type character varying(50) DEFAULT 'text'::character varying,
    file_name character varying(255),
    quoted_message_id integer,
    quoted_message_content text,
    status character varying(20) DEFAULT 'normal'::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    sender_avatar text,
    mentioned_user_ids text,
    mentions text,
    deleted_by_users text DEFAULT ''::text,
    call_type character varying(20),
    channel_name character varying(255),
    sender_nickname character varying(100),
    sender_full_name character varying(100),
    server_id integer,
    voice_duration integer
);


--
-- Name: COLUMN group_messages.sender_avatar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.sender_avatar IS 'Sender avatar URL';


--
-- Name: COLUMN group_messages.mentioned_user_ids; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.mentioned_user_ids IS 'List of mentioned user IDs (comma-separated string)';


--
-- Name: COLUMN group_messages.mentions; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.mentions IS 'Mention text content (e.g., "@all" or "@username")';


--
-- Name: COLUMN group_messages.deleted_by_users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.deleted_by_users IS 'Comma-separated list of user IDs who have deleted this message';


--
-- Name: COLUMN group_messages.call_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.call_type IS 'Call type (voice/video), only used for call_initiated type messages';


--
-- Name: COLUMN group_messages.channel_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.channel_name IS 'Agora channel name, used to join group calls, only used for call_initiated type messages';


--
-- Name: COLUMN group_messages.sender_nickname; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.sender_nickname IS 'Sender group nickname (from group_members.nickname)';


--
-- Name: COLUMN group_messages.sender_full_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.sender_full_name IS 'Sender full name (from users.full_name)';


--
-- Name: COLUMN group_messages.voice_duration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.group_messages.voice_duration IS 'Voice message duration (seconds)';


--
-- Name: group_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.group_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: group_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.group_messages_id_seq OWNED BY public.group_messages.id;


--
-- Name: groups; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.groups (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    announcement text,
    avatar character varying(255),
    owner_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    deleted_at timestamp without time zone,
    all_muted boolean DEFAULT false NOT NULL,
    invite_confirmation boolean DEFAULT false,
    admin_only_edit_name boolean DEFAULT false NOT NULL,
    member_view_permission boolean DEFAULT true
);


--
-- Name: COLUMN groups.deleted_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.groups.deleted_at IS 'Soft delete timestamp (NULL means not deleted)';


--
-- Name: COLUMN groups.all_muted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.groups.all_muted IS 'Whether all members are muted';


--
-- Name: COLUMN groups.invite_confirmation; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.groups.invite_confirmation IS 'Enable group invite confirmation (member invitations require approval)';


--
-- Name: COLUMN groups.admin_only_edit_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.groups.admin_only_edit_name IS 'Whether only the group owner/admins can modify the group name';


--
-- Name: COLUMN groups.member_view_permission; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.groups.member_view_permission IS 'Member view permission: true = regular members can view other members'' information, false = only the owner and administrators can view member information.';


--
-- Name: groups_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.groups_id_seq OWNED BY public.groups.id;


--
-- Name: invite_code_usages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invite_code_usages (
    id integer NOT NULL,
    invite_code_id integer NOT NULL,
    user_id integer NOT NULL,
    used_at timestamp without time zone DEFAULT now()
);


--
-- Name: invite_code_usages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invite_code_usages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invite_code_usages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invite_code_usages_id_seq OWNED BY public.invite_code_usages.id;


--
-- Name: invite_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.invite_codes (
    id integer NOT NULL,
    code character varying(20) NOT NULL,
    status character varying(20) DEFAULT 'unused'::character varying,
    used_by_user_id integer,
    used_by_username character varying(100),
    used_by_fullname character varying(100),
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    used_at timestamp without time zone
);


--
-- Name: invite_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.invite_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: invite_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.invite_codes_id_seq OWNED BY public.invite_codes.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.messages (
    id integer NOT NULL,
    sender_id integer NOT NULL,
    receiver_id integer NOT NULL,
    content text NOT NULL,
    message_type character varying(50) DEFAULT 'text'::character varying,
    is_read boolean DEFAULT false,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    read_at timestamp without time zone,
    sender_name character varying(100),
    receiver_name character varying(100),
    file_name character varying(255) DEFAULT NULL::character varying,
    quoted_message_id integer,
    quoted_message_content text,
    status character varying(20) DEFAULT 'normal'::character varying,
    deleted_by_users text DEFAULT ''::text,
    sender_avatar text,
    receiver_avatar text,
    call_type character varying(20) DEFAULT NULL::character varying,
    server_id integer,
    voice_duration integer
);


--
-- Name: COLUMN messages.sender_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.sender_name IS 'Sender username';


--
-- Name: COLUMN messages.receiver_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.receiver_name IS 'Receiver username';


--
-- Name: COLUMN messages.file_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.file_name IS 'File name (for file type messages)';


--
-- Name: COLUMN messages.quoted_message_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.quoted_message_id IS 'Quoted message ID';


--
-- Name: COLUMN messages.quoted_message_content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.quoted_message_content IS 'Quoted message content (for display)';


--
-- Name: COLUMN messages.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.status IS 'Message status: normal, recalled';


--
-- Name: COLUMN messages.deleted_by_users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.deleted_by_users IS 'List of user IDs who deleted this message (comma-separated), e.g., 1,2,3';


--
-- Name: COLUMN messages.sender_avatar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.sender_avatar IS 'Sender avatar URL';


--
-- Name: COLUMN messages.receiver_avatar; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.receiver_avatar IS 'Receiver avatar URL';


--
-- Name: COLUMN messages.call_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.call_type IS 'Call type (voice/video), used only for call message types';


--
-- Name: COLUMN messages.voice_duration; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.messages.voice_duration IS 'Voice message duration (seconds)';


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.messages_id_seq
    AS integer
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
-- Name: private_message_synced; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.private_message_synced (
    id integer NOT NULL,
    message_id integer NOT NULL,
    user_id integer NOT NULL,
    synced_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: private_message_synced_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.private_message_synced_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: private_message_synced_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.private_message_synced_id_seq OWNED BY public.private_message_synced.id;


--
-- Name: scheduled_messages; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.scheduled_messages (
    id integer NOT NULL,
    sender_id integer NOT NULL,
    receiver_id integer NOT NULL,
    message_type character varying(20) DEFAULT 'private'::character varying NOT NULL,
    title character varying(100) NOT NULL,
    send_time character varying(5) NOT NULL,
    send_type character varying(20) DEFAULT 'once'::character varying NOT NULL,
    content text NOT NULL,
    status character varying(20) DEFAULT 'pending'::character varying NOT NULL,
    created_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    send_date character varying(10)
);


--
-- Name: TABLE scheduled_messages; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.scheduled_messages IS '定时消息表';


--
-- Name: COLUMN scheduled_messages.id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.id IS '主键ID';


--
-- Name: COLUMN scheduled_messages.sender_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.sender_id IS '发送人ID';


--
-- Name: COLUMN scheduled_messages.receiver_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.receiver_id IS '接收人ID（私聊为用户ID，群聊为群组ID）';


--
-- Name: COLUMN scheduled_messages.message_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.message_type IS '类型：private-私聊，group-群聊';


--
-- Name: COLUMN scheduled_messages.title; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.title IS '任务标题';


--
-- Name: COLUMN scheduled_messages.send_time; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.send_time IS '发送时间（HH:MM格式）';


--
-- Name: COLUMN scheduled_messages.send_type; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.send_type IS '发送类型：once-单次，daily-每日';


--
-- Name: COLUMN scheduled_messages.content; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.content IS '消息内容（最多1000字）';


--
-- Name: COLUMN scheduled_messages.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.status IS '任务状态：pending-待发送，sent-已发送，deleted-已删除';


--
-- Name: COLUMN scheduled_messages.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.created_at IS '创建时间';


--
-- Name: COLUMN scheduled_messages.updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.updated_at IS '更新时间';


--
-- Name: COLUMN scheduled_messages.send_date; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.scheduled_messages.send_date IS 'Send date (YYYY-MM-DD format, for once type only)';


--
-- Name: scheduled_messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.scheduled_messages_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: scheduled_messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.scheduled_messages_id_seq OWNED BY public.scheduled_messages.id;


--
-- Name: server_settings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.server_settings (
    id integer NOT NULL,
    key character varying(100) NOT NULL,
    value text NOT NULL,
    description character varying(255) DEFAULT ''::character varying,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: TABLE server_settings; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.server_settings IS 'Server Settings Table';


--
-- Name: server_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.server_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: server_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.server_settings_id_seq OWNED BY public.server_settings.id;


--
-- Name: user_relations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.user_relations (
    id integer NOT NULL,
    user_id integer NOT NULL,
    friend_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    approval_status character varying(20) DEFAULT 'approved'::character varying NOT NULL,
    is_blocked boolean DEFAULT false NOT NULL,
    is_deleted boolean DEFAULT false NOT NULL,
    blocked_by_user_id integer,
    deleted_by_user_id integer,
    CONSTRAINT check_approval_status CHECK (((approval_status)::text = ANY (ARRAY[('pending'::character varying)::text, ('approved'::character varying)::text, ('rejected'::character varying)::text])))
);


--
-- Name: TABLE user_relations; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.user_relations IS 'User Relations Table';


--
-- Name: COLUMN user_relations.user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.user_id IS 'User ID';


--
-- Name: COLUMN user_relations.friend_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.friend_id IS 'Friend user ID';


--
-- Name: COLUMN user_relations.created_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.created_at IS 'Created at';


--
-- Name: COLUMN user_relations.approval_status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.approval_status IS 'Approval status: pending, approved, rejected';


--
-- Name: COLUMN user_relations.is_blocked; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.is_blocked IS 'Whether the user is blocked; true means blocked';


--
-- Name: COLUMN user_relations.is_deleted; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.is_deleted IS 'Whether the relation is deleted (soft delete); true means deleted';


--
-- Name: COLUMN user_relations.blocked_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.blocked_by_user_id IS 'User ID who performed the block operation';


--
-- Name: COLUMN user_relations.deleted_by_user_id; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.user_relations.deleted_by_user_id IS 'User ID who performed the delete operation';


--
-- Name: user_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.user_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.user_relations_id_seq OWNED BY public.user_relations.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    password character varying(255) NOT NULL,
    phone character varying(20) DEFAULT NULL::character varying,
    email character varying(100) DEFAULT NULL::character varying,
    avatar character varying(255) DEFAULT ''::character varying,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    auth_code character varying(100) DEFAULT NULL::character varying,
    full_name character varying(100) DEFAULT NULL::character varying,
    gender character varying(10) DEFAULT NULL::character varying,
    work_signature character varying(500) DEFAULT NULL::character varying,
    status character varying(50) DEFAULT 'offline'::character varying,
    landline character varying(20) DEFAULT NULL::character varying,
    short_number character varying(10) DEFAULT NULL::character varying,
    department character varying(100) DEFAULT NULL::character varying,
    "position" character varying(100) DEFAULT NULL::character varying,
    region character varying(100) DEFAULT NULL::character varying,
    invite_code character varying(6) DEFAULT NULL::character varying,
    invited_by_code character varying(6) DEFAULT NULL::character varying,
    voip_token character varying(255),
    voip_token_updated_at timestamp without time zone,
    last_login_at timestamp without time zone,
    is_overseas smallint DEFAULT 1,
    active_token text,
    token_updated_at timestamp with time zone,
    CONSTRAINT check_gender CHECK (((gender)::text = ANY (ARRAY[(NULL::character varying)::text, ('male'::character varying)::text, ('female'::character varying)::text, ('other'::character varying)::text]))),
    CONSTRAINT check_status CHECK (((status)::text = ANY (ARRAY[('online'::character varying)::text, ('busy'::character varying)::text, ('away'::character varying)::text, ('offline'::character varying)::text])))
);


--
-- Name: TABLE users; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.users IS 'Users Table';


--
-- Name: COLUMN users.auth_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.auth_code IS 'Authorization code';


--
-- Name: COLUMN users.full_name; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.full_name IS 'Full name';


--
-- Name: COLUMN users.gender; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.gender IS 'Gender: male, female, other';


--
-- Name: COLUMN users.work_signature; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.work_signature IS 'Work signature';


--
-- Name: COLUMN users.status; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.status IS 'Status: online, busy, away, offline';


--
-- Name: COLUMN users.landline; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.landline IS 'Landline';


--
-- Name: COLUMN users.short_number; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.short_number IS 'Short number';


--
-- Name: COLUMN users.department; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.department IS 'Department';


--
-- Name: COLUMN users."position"; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users."position" IS 'Position';


--
-- Name: COLUMN users.region; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.region IS 'Region';


--
-- Name: COLUMN users.invite_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.invite_code IS 'User''s own invite code (6 characters, 0-9a-zA-Z)';


--
-- Name: COLUMN users.invited_by_code; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.invited_by_code IS 'Invite code used during registration';


--
-- Name: COLUMN users.voip_token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.voip_token IS 'iOS VoIP Push Token，用于后台来电推送';


--
-- Name: COLUMN users.voip_token_updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.voip_token_updated_at IS 'VoIP Token 最后更新时间';


--
-- Name: COLUMN users.last_login_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.last_login_at IS 'User last login timestamp';


--
-- Name: COLUMN users.is_overseas; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.is_overseas IS 'Whether overseas user: 0-domestic, 1-overseas, default 1';


--
-- Name: COLUMN users.active_token; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.active_token IS 'Current valid login token for single device login restriction';


--
-- Name: COLUMN users.token_updated_at; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON COLUMN public.users.token_updated_at IS 'Token update timestamp';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
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
-- Name: verification_codes; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.verification_codes (
    id integer NOT NULL,
    account character varying(100) NOT NULL,
    code character varying(10) NOT NULL,
    type character varying(20) NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT verification_codes_type_check CHECK (((type)::text = ANY (ARRAY[('login'::character varying)::text, ('register'::character varying)::text, ('reset'::character varying)::text])))
);


--
-- Name: TABLE verification_codes; Type: COMMENT; Schema: public; Owner: -
--

COMMENT ON TABLE public.verification_codes IS 'Verification Codes Table';


--
-- Name: verification_codes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.verification_codes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verification_codes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.verification_codes_id_seq OWNED BY public.verification_codes.id;


--
-- Name: app_versions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions ALTER COLUMN id SET DEFAULT nextval('public.app_versions_id_seq'::regclass);


--
-- Name: device_registrations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_registrations ALTER COLUMN id SET DEFAULT nextval('public.device_registrations_id_seq'::regclass);


--
-- Name: favorite_contacts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_contacts ALTER COLUMN id SET DEFAULT nextval('public.favorite_contacts_id_seq'::regclass);


--
-- Name: favorite_groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_groups ALTER COLUMN id SET DEFAULT nextval('public.favorite_groups_id_seq'::regclass);


--
-- Name: favorites id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites ALTER COLUMN id SET DEFAULT nextval('public.favorites_id_seq'::regclass);


--
-- Name: file_assistant_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_assistant_messages ALTER COLUMN id SET DEFAULT nextval('public.file_assistant_messages_id_seq'::regclass);


--
-- Name: group_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_members ALTER COLUMN id SET DEFAULT nextval('public.group_members_id_seq'::regclass);


--
-- Name: group_message_reads id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_message_reads ALTER COLUMN id SET DEFAULT nextval('public.group_message_reads_id_seq'::regclass);


--
-- Name: group_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages ALTER COLUMN id SET DEFAULT nextval('public.group_messages_id_seq'::regclass);


--
-- Name: groups id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups ALTER COLUMN id SET DEFAULT nextval('public.groups_id_seq'::regclass);


--
-- Name: invite_code_usages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_code_usages ALTER COLUMN id SET DEFAULT nextval('public.invite_code_usages_id_seq'::regclass);


--
-- Name: invite_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_codes ALTER COLUMN id SET DEFAULT nextval('public.invite_codes_id_seq'::regclass);


--
-- Name: messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages ALTER COLUMN id SET DEFAULT nextval('public.messages_id_seq'::regclass);


--
-- Name: private_message_synced id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_message_synced ALTER COLUMN id SET DEFAULT nextval('public.private_message_synced_id_seq'::regclass);


--
-- Name: scheduled_messages id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_messages ALTER COLUMN id SET DEFAULT nextval('public.scheduled_messages_id_seq'::regclass);


--
-- Name: server_settings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_settings ALTER COLUMN id SET DEFAULT nextval('public.server_settings_id_seq'::regclass);


--
-- Name: user_relations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_relations ALTER COLUMN id SET DEFAULT nextval('public.user_relations_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: verification_codes id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_codes ALTER COLUMN id SET DEFAULT nextval('public.verification_codes_id_seq'::regclass);


--
-- Data for Name: app_versions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.app_versions (id, version, platform, distribution_type, package_url, oss_object_key, release_notes, status, is_force_update, min_supported_version, file_size, file_hash, created_at, updated_at, published_at, created_by) FROM stdin;
2	1.0.23-1765520167	windows	url	https://xn--wxtp0q.vip/releases/windows/1.0.23-1765520167.zip		优化安装包下载和弹窗关闭问题	published	f		65322192	61a610e2b18bab7f5daddfdec0edb064	2025-12-10 23:59:46.57674+08	2025-12-14 16:38:42+08	2025-12-14 16:38:42+08	
4	1.0.23-1765520167	android	url	https://xn--wxtp0q.vip/releases/android/1.0.23-1765520167.apk		优化安装包下载和弹窗关闭问题	published	f		304619933	8ea6f67f23d4ebe7421a24d66d060165	2025-12-11 00:09:54.601814+08	2025-12-14 16:39:17+08	2025-12-14 16:39:17+08	
3	1.0.5+7	ios	url	https://testflight.apple.com/join/m6U2cVQe	\N	优化APP	published	f	\N	0	\N	2025-12-11 00:06:46.823815+08	2026-01-08 15:41:13+08	2026-01-08 15:41:13+08	
\.


--
-- Data for Name: device_registrations; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.device_registrations (id, uuid, request_ip, platform, system_info, installed_at, created_at, updated_at) FROM stdin;
1	65456255-5196-4d8a-96ee-0653cbf22b03	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 16:32:52.691175	2025-11-24 16:32:52.399671	2025-11-24 16:32:52.399671
2	73c978aa-91c1-4a78-a5b4-2f5fe96bdffb	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 16:59:42.547024	2025-11-24 16:59:42.160502	2025-11-24 16:59:42.160502
3	36f60dbf-5cb8-4f7a-811e-4df7a88fab98	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 17:03:19.046834	2025-11-24 17:03:18.664769	2025-11-24 17:03:18.664769
5	e1f51d0d-049b-4ac5-bb7e-d9b8fa6e597d	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 17:23:18.035138	2025-11-24 17:23:17.616277	2025-11-24 17:23:17.616277
6	6c330562-016b-4e2f-9ec8-4d37a07535a9	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 17:25:01.609749	2025-11-24 17:25:01.193762	2025-11-24 17:25:01.193762
7	08063d2e-5811-4d18-ad09-fe10d715cb6b	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:31:51.740815	2025-11-24 18:31:51.280192	2025-11-24 18:31:51.280192
8	e4b06750-ba49-41bc-b1cc-58a62a606aca	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:49:29.879892	2025-11-24 18:49:29.370826	2025-11-24 18:49:29.370826
9	3106432c-f53e-4404-9552-b5d8bba52c45	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:51:17.015426	2025-11-24 18:51:16.544603	2025-11-24 18:51:16.544603
10	56755645-eaf6-4c0f-9136-158f9cd83aa9	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:52:03.292145	2025-11-24 18:52:02.794389	2025-11-24 18:52:02.794389
11	82015ad5-9fb8-4903-8bc2-c37a96c3c31a	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:54:37.352337	2025-11-24 18:54:36.900083	2025-11-24 18:54:36.900083
12	fce81ded-188c-46ce-854e-6ebc582132ec	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 18:55:47.033147	2025-11-24 18:55:46.534483	2025-11-24 18:55:46.534483
13	ee37dbdd-c016-475f-9767-2a6aa09414ea	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 19:22:00.760805	2025-11-24 19:22:00.232015	2025-11-24 19:22:00.232015
14	e794de5d-438f-46e8-9aa8-06dcc3aacf75	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 19:36:29.31927	2025-11-24 19:36:28.853927	2025-11-24 19:36:28.853927
15	2389c0e7-eef1-4835-8ff3-b07fef2b424f	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 20:24:24.407072	2025-11-24 20:24:23.867995	2025-11-24 20:24:23.867995
16	e70cc0eb-5d3d-4b1e-8a4a-d36eaa377ff7	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:05:42.752888	2025-11-24 21:05:42.136421	2025-11-24 21:05:42.136421
17	87be40bb-b6b7-4316-902b-9d2bc986274a	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:09:35.86997	2025-11-24 21:09:35.240155	2025-11-24 21:09:35.240155
18	28b8a56e-4d1c-49e4-80ab-038c88e51465	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:25:37.164615	2025-11-24 21:25:37.906537	2025-11-24 21:25:37.906537
19	fade0452-0db9-4316-98ff-0c0c070fa0a7	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:43:45.453674	2025-11-24 21:43:44.941572	2025-11-24 21:43:44.941572
20	916c0ce5-3397-4266-bff2-401c3fc3935e	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:49:50.617456	2025-11-24 21:49:49.962452	2025-11-24 21:49:49.962452
21	4ef9553a-b4f0-4cce-9e40-88e74a087084	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 21:55:30.356098	2025-11-24 21:55:29.739815	2025-11-24 21:55:29.739815
22	809d2349-6474-4bc2-9bd5-a8f002d9a181	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 22:11:03.742009	2025-11-24 22:11:03.063577	2025-11-24 22:11:03.063577
23	584b8d8a-c699-459a-9ac1-efefd1394022	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 22:18:47.363102	2025-11-24 22:18:46.728666	2025-11-24 22:18:46.728666
24	b0b3eb0b-e7fa-49be-9296-dcc5e24de9a6	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 22:19:23.608649	2025-11-24 22:19:22.934494	2025-11-24 22:19:22.934494
25	c9445ad5-203c-4c46-b5c3-09cc919cec0c	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-24 22:34:33.1772	2025-11-24 22:34:32.479725	2025-11-24 22:34:32.479725
26	f27e50f7-83b8-483c-8ab1-b6c0b516cfd6	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 00:03:41.342239	2025-11-25 00:03:40.550861	2025-11-25 00:03:40.550861
27	d163df22-c6d1-400e-8143-462395277ed8	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 00:05:53.019333	2025-11-25 00:05:52.248281	2025-11-25 00:05:52.248281
28	22b596e4-b8c0-4957-bdbb-ce5f19178f67	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 00:16:17.107674	2025-11-25 00:16:16.353663	2025-11-25 00:16:16.353663
29	dff8391f-d956-43f3-999c-d7febcf0723e	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:18:10.978674	2025-11-25 08:18:11.49042	2025-11-25 08:18:11.49042
30	8d6a82ce-4f7b-47d6-aa16-41af524a9bcd	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:28:20.15522	2025-11-25 08:28:20.595404	2025-11-25 08:28:20.595404
31	48767bc9-275d-45c6-a9ad-c710b7a1ee63	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:34:24.036256	2025-11-25 08:34:24.494151	2025-11-25 08:34:24.494151
32	d5029c8f-892a-41e7-878a-ae03bffdd824	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:37:53.699159	2025-11-25 08:37:54.144359	2025-11-25 08:37:54.144359
33	cb15ceff-8484-4f69-b3db-3d4574d9d1ff	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:41:28.664037	2025-11-25 08:41:29.11547	2025-11-25 08:41:29.11547
34	7091dc72-2c27-4db4-88ad-88ad66bc84d2	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:47:21.316979	2025-11-25 08:47:23.160436	2025-11-25 08:47:23.160436
35	3eacb277-4129-4bf2-8767-9c2ca53afb9c	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:52:38.939582	2025-11-25 08:52:39.369406	2025-11-25 08:52:39.369406
36	c1135659-fcbc-414a-a2be-549c20ab7a58	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:56:09.652759	2025-11-25 08:56:10.085898	2025-11-25 08:56:10.085898
37	246ea2ea-bf1c-437e-abdc-e168e9569a13	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:56:25.013069	2025-11-25 08:56:25.450198	2025-11-25 08:56:25.450198
38	0558766f-0c26-4199-8282-b451ab49c91a	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 08:59:58.9532	2025-11-25 08:59:59.393356	2025-11-25 08:59:59.393356
39	d85b1192-9aa5-4a4c-9e8d-12839f376a02	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 09:02:09.025642	2025-11-25 09:02:09.455145	2025-11-25 09:02:09.455145
40	2f16f48b-bf89-4d63-8299-53d632537086	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 09:04:09.891849	2025-11-25 09:04:10.323325	2025-11-25 09:04:10.323325
41	bd33dc2f-a36a-4e25-b107-893dad65f2b8	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 09:10:04.785869	2025-11-25 09:10:05.23198	2025-11-25 09:10:05.23198
42	69586b51-c69e-4726-9256-6c5f7a33c8ab	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 09:14:08.319645	2025-11-25 09:14:08.730014	2025-11-25 09:14:08.730014
43	b56f40a7-e92e-4258-bbfd-3173222a9734	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 09:21:04.546752	2025-11-25 09:21:04.999374	2025-11-25 09:21:04.999374
44	762c6262-2e6c-41f2-bcad-9d0fd1fd992e	192.168.1.17	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "STF-AL10 9.0.1.179(C00E63R1P9)", "number_of_processors": 8}	2025-11-25 11:11:57.929186	2025-11-25 11:11:58.225914	2025-11-25 11:11:58.225914
45	fc544ae2-4b60-40a6-82d4-4ca1a84d1b29	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 11:19:30.049053	2025-11-25 11:19:29.020267	2025-11-25 11:19:29.020267
46	bd5019ba-a67c-4fbe-9537-c8d1174dce45	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 11:32:23.338895	2025-11-25 11:32:22.1247	2025-11-25 11:32:22.1247
47	33cc8ede-faf3-49d2-bd0f-aece1b7f18d9	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 11:35:58.716565	2025-11-25 11:35:58.376009	2025-11-25 11:35:58.376009
48	f2032178-76ce-47ff-a875-f9d3196c809c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 11:53:03.75144	2025-11-25 11:53:04.111254	2025-11-25 11:53:04.111254
49	915c5527-cbef-40e7-a768-f9597a1d5093	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 11:54:37.821247	2025-11-25 11:54:37.867014	2025-11-25 11:54:37.867014
50	25236a4f-8012-419c-a570-89c479291a84	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 12:04:01.442658	2025-11-25 12:04:01.469949	2025-11-25 12:04:01.469949
51	a15ba249-f8d0-4bf7-9f7b-5cc1b805fb72	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 12:07:09.202745	2025-11-25 12:07:09.265357	2025-11-25 12:07:09.265357
52	1d02925d-f835-4f45-af50-7c995b6ace83	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 12:22:04.767515	2025-11-25 12:22:04.998069	2025-11-25 12:22:04.998069
53	77f31dae-e86d-4400-8bc3-3039363d511b	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 12:24:40.700709	2025-11-25 12:24:40.759095	2025-11-25 12:24:40.759095
54	e0330999-3e46-429b-bfd1-f3a136bb8e0e	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 12:29:12.995706	2025-11-25 12:29:13.014599	2025-11-25 12:29:13.014599
55	a752c3d7-80de-41ef-8863-234c552babb9	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 13:22:20.501071	2025-11-25 13:22:20.726887	2025-11-25 13:22:20.726887
56	7e3842d6-82e5-4336-bd4d-b5772e576edd	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 13:32:35.966598	2025-11-25 13:32:35.919187	2025-11-25 13:32:35.919187
58	b9e9764b-17dc-45b8-8bfd-2437f2c831d7	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 13:38:48.268297	2025-11-25 13:38:48.266142	2025-11-25 13:38:48.266142
59	c1e3880e-f5e8-4acf-ae02-5bfd9279a757	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 13:40:52.462031	2025-11-25 13:40:52.745461	2025-11-25 13:40:52.745461
57	ff0894cf-9adb-44c9-8095-29aff7f3edac	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 13:36:17.950608	2025-11-25 13:36:17.928761	2025-11-25 13:36:17.928761
60	83c48b4b-ce17-42f4-b6d6-01af0d53c6fe	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:01:45.321208	2025-11-25 14:01:45.232188	2025-11-25 14:01:45.232188
61	9f53e28c-5ff7-4540-979b-730ff0932744	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:04:36.057292	2025-11-25 14:04:36.027166	2025-11-25 14:04:36.027166
62	079fbc65-27aa-4912-8768-d3c8b0b658dc	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:10:26.108408	2025-11-25 14:10:26.048856	2025-11-25 14:10:26.048856
63	9d9f1cac-cce2-4adf-9279-370ac4be4d50	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:21:34.473242	2025-11-25 14:21:34.393043	2025-11-25 14:21:34.393043
64	24a39f06-b0a5-4d1d-b040-2b560147d0fd	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:24:09.402386	2025-11-25 14:24:09.312326	2025-11-25 14:24:09.312326
65	026bc387-61dd-46b3-843d-785a0652f76f	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 14:27:10.979887	2025-11-25 14:27:10.889383	2025-11-25 14:27:10.889383
66	d8f2fadc-5277-4424-9328-c4f60e5f8bef	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 15:38:53.010322	2025-11-25 15:38:52.868778	2025-11-25 15:38:52.868778
67	c738543c-08ec-4f34-96e7-0d399ac467d7	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 15:49:14.387703	2025-11-25 15:49:14.386368	2025-11-25 15:49:14.386368
68	0ade46ac-26a3-48b1-8fa4-a0afc0949115	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 17:19:30.403515	2025-11-25 17:19:30.267807	2025-11-25 17:19:30.267807
69	d8785cd2-4a5c-44c2-bd04-df053cec856a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 17:43:38.497821	2025-11-25 17:43:38.219704	2025-11-25 17:43:38.219704
70	d52a6cfc-13ce-42ad-a6da-90ab5ceda3ea	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 17:53:00.457868	2025-11-25 17:53:00.19576	2025-11-25 17:53:00.19576
71	043c5242-06f3-49ca-bc85-3b6b3a13223a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 18:11:45.130728	2025-11-25 18:11:44.82889	2025-11-25 18:11:44.82889
72	5f91a934-60a7-4157-ac39-156fe3ff9e43	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 18:38:22.495311	2025-11-25 18:38:22.216062	2025-11-25 18:38:22.216062
73	806d8ba8-104a-46ce-a417-0a7aeb0719c4	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:41:06.463983	2025-11-25 19:41:06.063551	2025-11-25 19:41:06.063551
74	76fb355c-64d8-4daf-913a-7fdb0c87c70c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:42:38.706995	2025-11-25 19:42:38.306272	2025-11-25 19:42:38.306272
75	58f1e12d-4e2e-42be-bcb9-75117b170148	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:48:22.518389	2025-11-25 19:48:22.112773	2025-11-25 19:48:22.112773
76	4fefdba2-2bd0-4451-8f7c-4b5134c4144a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:48:28.33671	2025-11-25 19:48:27.933706	2025-11-25 19:48:27.933706
77	4c75e6df-3eb7-45b6-b186-119753374a30	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:54:09.96777	2025-11-25 19:54:09.554267	2025-11-25 19:54:09.554267
78	d8d4acb8-4f4a-4022-9f47-3d91e51bd6a5	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 19:56:03.081249	2025-11-25 19:56:02.85509	2025-11-25 19:56:02.85509
79	2620a77f-a102-446b-b988-5d83d4ab5108	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:04:24.236337	2025-11-25 20:04:23.814206	2025-11-25 20:04:23.814206
80	6a4a6019-a6f2-4c93-a2f2-086e8f59a298	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:04:38.377972	2025-11-25 20:04:37.976805	2025-11-25 20:04:37.976805
81	fcec6d95-1d38-4886-bd3d-18b14e5fc325	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:06:26.82803	2025-11-25 20:06:26.475581	2025-11-25 20:06:26.475581
82	3f4b7969-a306-4256-b5c9-1492dab57cd0	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:10:57.856977	2025-11-25 20:10:57.43292	2025-11-25 20:10:57.43292
83	734e9b02-12b4-4bcc-8493-90cb15f2d20a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:19:03.598085	2025-11-25 20:19:03.181447	2025-11-25 20:19:03.181447
84	a936ebac-6c57-41b4-b322-b59233603f9c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:22:57.277069	2025-11-25 20:22:56.838712	2025-11-25 20:22:56.838712
85	4221d994-5b44-4b43-9716-6cd6d626504a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:23:49.165553	2025-11-25 20:23:48.750801	2025-11-25 20:23:48.750801
86	0f0ba7fd-afba-4d2b-83e1-90c214ef7bc4	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:26:30.035708	2025-11-25 20:26:29.597847	2025-11-25 20:26:29.597847
87	6b92c8d7-a62a-4f55-94fb-9e25bb478a9d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:28:56.748026	2025-11-25 20:28:58.263482	2025-11-25 20:28:58.263482
88	77e42379-69f8-48a9-ab40-a9951317079e	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:30:32.065887	2025-11-25 20:30:31.62035	2025-11-25 20:30:31.62035
89	d6467e49-2a40-482c-9025-d891461096b6	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:36:40.713391	2025-11-25 20:36:40.276314	2025-11-25 20:36:40.276314
90	347ea98e-e287-4072-8193-893b563747ae	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:40:20.988008	2025-11-25 20:40:20.535356	2025-11-25 20:40:20.535356
91	2373eecb-2b13-4c23-893e-5dab32491d0c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:44:37.067307	2025-11-25 20:44:36.612692	2025-11-25 20:44:36.612692
92	eba49194-37ff-4779-9559-3d13370272bb	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 20:54:35.376118	2025-11-25 20:54:34.921801	2025-11-25 20:54:34.921801
93	ec655448-7286-4377-ab2a-16b3df0a0b68	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:23:21.979589	2025-11-25 21:23:21.508674	2025-11-25 21:23:21.508674
94	0c18308a-4149-4625-8927-1e515d6ce1fb	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:24:17.87072	2025-11-25 21:24:17.41687	2025-11-25 21:24:17.41687
95	612a609b-cd03-45ea-8c01-464a3458613a	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:39:20.61494	2025-11-25 21:39:20.117964	2025-11-25 21:39:20.117964
96	bb64819a-f399-4b0d-9404-684c3c34758c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:46:43.35785	2025-11-25 21:46:42.882371	2025-11-25 21:46:42.882371
97	5dea924b-7ccd-49a7-9fe2-220059144a06	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:52:35.185834	2025-11-25 21:52:34.691173	2025-11-25 21:52:34.691173
98	57724f32-1297-490b-a22d-66c2ab551f2c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 21:59:42.8241	2025-11-25 21:59:42.302139	2025-11-25 21:59:42.302139
99	49855997-3145-4ed1-8bd2-64eb54808e5e	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 22:33:34.191296	2025-11-25 22:33:33.639834	2025-11-25 22:33:33.639834
100	7858fe7a-7a4a-456a-af78-8e8a265fbd94	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 22:33:41.688928	2025-11-25 22:33:41.153782	2025-11-25 22:33:41.153782
101	59d7abd0-ef1e-4fb7-9ebd-30b6d0c4a2a6	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 22:55:15.255051	2025-11-25 22:55:14.679492	2025-11-25 22:55:14.679492
102	a9b6f598-995f-424b-a766-49c6d984b9ab	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 23:04:32.378093	2025-11-25 23:04:31.821277	2025-11-25 23:04:31.821277
103	30afb8de-4119-483f-8e0c-b41a06448a3d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 23:06:26.89113	2025-11-25 23:06:26.373377	2025-11-25 23:06:26.373377
104	2a574dcd-2cee-434f-9552-75e9f67570f8	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 23:09:29.015874	2025-11-25 23:09:28.432674	2025-11-25 23:09:28.432674
105	ab9a6512-fc0b-478e-a467-69d6c08c74b2	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-25 23:10:48.161651	2025-11-25 23:10:47.585239	2025-11-25 23:10:47.585239
106	7502e17e-2335-4e91-9ed3-43607a99c314	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:37:15.095649	2025-11-26 07:37:15.071057	2025-11-26 07:37:15.071057
107	bb912307-7a38-45cb-a3ef-307ea953e5de	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:45:30.948205	2025-11-26 07:45:30.868409	2025-11-26 07:45:30.868409
108	0c2c6024-f7dd-4d63-9722-0adc4f483956	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:49:32.876205	2025-11-26 07:49:32.774263	2025-11-26 07:49:32.774263
109	e6d54af7-b374-41fb-bf75-1250ad486277	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:54:29.392304	2025-11-26 07:54:29.319695	2025-11-26 07:54:29.319695
110	0d9a2290-0dbd-448d-b55e-cd7e170e3719	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:56:37.549591	2025-11-26 07:56:37.43188	2025-11-26 07:56:37.43188
111	04d14f0b-791d-431a-bab2-d98bbdb25d89	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 07:58:16.969043	2025-11-26 07:58:16.854123	2025-11-26 07:58:16.854123
112	8b5ef048-8c53-4137-aa25-c68f775a9583	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:01:11.370084	2025-11-26 08:01:11.269399	2025-11-26 08:01:11.269399
113	bd87d81c-9401-451d-a5f9-31dba29f4608	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:31:29.203971	2025-11-26 08:31:29.095157	2025-11-26 08:31:29.095157
114	87994e87-18f1-461f-8fbc-9ab5bd4c3356	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:33:37.747346	2025-11-26 08:33:37.598261	2025-11-26 08:33:37.598261
115	8ec2fec1-02b8-4ec4-a001-f165bf59e553	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:34:15.11509	2025-11-26 08:34:14.995446	2025-11-26 08:34:14.995446
116	41e6e1ff-74ea-4a0d-91c4-03e4aefc8d65	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:40:12.619438	2025-11-26 08:40:12.473357	2025-11-26 08:40:12.473357
117	1498650b-8481-4545-9ab8-e29f19caf08d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:42:10.637891	2025-11-26 08:42:10.49893	2025-11-26 08:42:10.49893
119	b6b65dda-cc2a-41d8-9b64-f49ef24f3514	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:12:54.934906	2025-11-26 09:12:54.964311	2025-11-26 09:12:54.964311
120	ce4bdcd8-b0c7-4cb5-8069-5f9c4d36f442	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:14:30.726773	2025-11-26 09:14:30.543446	2025-11-26 09:14:30.543446
121	3ad91b55-4ea3-42f6-83b2-7fd900083a03	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:49:58.228205	2025-11-26 09:49:58.005009	2025-11-26 09:49:58.005009
124	5d0337d2-c9be-44f0-9054-eb46071276d6	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:55:48.976975	2025-11-26 09:55:48.770567	2025-11-26 09:55:48.770567
128	bfc46bfb-d53a-44aa-9fce-bca85a32b6b3	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:18:00.006837	2025-11-26 10:17:59.796355	2025-11-26 10:17:59.796355
129	2ec7773a-f8cc-4412-80c1-6283c7a994c1	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:20:34.724345	2025-11-26 10:20:34.521563	2025-11-26 10:20:34.521563
118	d9ebd50e-481f-4847-87de-6d6b257f0ff5	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 08:54:32.776096	2025-11-26 08:54:32.615509	2025-11-26 08:54:32.615509
122	46c4bb01-6ec4-4b6c-86e5-85494bdb9b3b	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:50:26.779556	2025-11-26 09:50:26.5866	2025-11-26 09:50:26.5866
123	9a003691-8ccd-4cc8-9504-597c070cc2ee	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 09:55:17.907777	2025-11-26 09:55:17.663782	2025-11-26 09:55:17.663782
125	e5a4a66e-d30a-490c-9842-a5775cda5332	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:01:11.430038	2025-11-26 10:01:11.212401	2025-11-26 10:01:11.212401
126	475ef081-1093-44b0-9192-7aa49166ddb4	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:15:45.329098	2025-11-26 10:15:45.1006	2025-11-26 10:15:45.1006
127	ebe6e58f-bcd9-4437-b38b-284c0643be2c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:17:26.210485	2025-11-26 10:17:25.950785	2025-11-26 10:17:25.950785
130	89d836f4-1a44-48f9-a4f0-0309c84de9b3	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:39:07.373826	2025-11-26 10:39:07.111645	2025-11-26 10:39:07.111645
131	b4c47205-eca1-4667-9332-b24c30eead51	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:54:51.847937	2025-11-26 10:54:51.615992	2025-11-26 10:54:51.615992
132	6f3965bf-7844-47f9-b85a-8d635d63e292	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 10:57:04.154982	2025-11-26 10:57:03.877745	2025-11-26 10:57:03.877745
133	770fe5d6-4953-4c9e-8e78-9cbe4d575517	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:01:48.538703	2025-11-26 11:01:48.239702	2025-11-26 11:01:48.239702
134	f7987cb2-f029-4d93-857a-d5106560b4e4	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:04:42.226135	2025-11-26 11:04:41.930408	2025-11-26 11:04:41.930408
135	2e144eec-51f7-47f2-a4eb-cc2d7280ebac	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:10:43.694737	2025-11-26 11:10:43.396671	2025-11-26 11:10:43.396671
136	0f2a6a6f-f7c2-4fc0-ac67-b9b8c754999e	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:13:07.178014	2025-11-26 11:13:06.87064	2025-11-26 11:13:06.87064
137	bf44eb15-d488-4108-8aa4-70679926e786	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:30:12.627627	2025-11-26 11:30:12.318306	2025-11-26 11:30:12.318306
138	fcfc7d70-de95-4515-bb91-b70f4c2dc942	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:30:30.377454	2025-11-26 11:30:30.047432	2025-11-26 11:30:30.047432
139	db018109-e244-4220-b335-b47c494093ea	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:39:40.511148	2025-11-26 11:39:40.176858	2025-11-26 11:39:40.176858
140	1f8a331a-4b5f-4746-8ba1-0b6722f59b52	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:49:53.876705	2025-11-26 11:49:53.538408	2025-11-26 11:49:53.538408
141	f2b74f9a-5734-4899-81e5-a77021127e73	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 11:54:50.517873	2025-11-26 11:54:50.351237	2025-11-26 11:54:50.351237
142	00120942-70b2-4450-978d-d3caec3e0cbe	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 12:02:03.915081	2025-11-26 12:02:03.556492	2025-11-26 12:02:03.556492
143	244edff2-0ff8-48ca-bd50-8184fb9d3722	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 12:16:45.828892	2025-11-26 12:16:45.458784	2025-11-26 12:16:45.458784
144	a19d202f-3f72-4484-b663-71b26d1dc9bd	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 12:31:33.266459	2025-11-26 12:31:32.895131	2025-11-26 12:31:32.895131
145	502f31ab-ed28-4a6b-ae4c-fb1a51466f4d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 12:42:00.911159	2025-11-26 12:42:00.547747	2025-11-26 12:42:00.547747
146	e1ac652f-afcd-4fa8-8488-31616c96909f	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 12:57:36.187309	2025-11-26 12:57:35.805418	2025-11-26 12:57:35.805418
147	5eae4864-3a51-4fb7-8274-fc81d38e1b9c	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:01:28.766734	2025-11-26 13:01:28.386295	2025-11-26 13:01:28.386295
148	d46033cb-692d-4f74-86e2-c0c509cb88ad	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:06:41.047895	2025-11-26 13:06:40.655318	2025-11-26 13:06:40.655318
149	d427ec2c-7e50-4470-b0c1-dc10ddbe86a0	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:10:48.223229	2025-11-26 13:10:47.818751	2025-11-26 13:10:47.818751
150	bc1ba10e-c7a7-4f55-9953-dd9c95d623ad	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:23:21.671317	2025-11-26 13:23:21.259483	2025-11-26 13:23:21.259483
151	be54e5e4-cf36-49f4-8f83-017a38b52ba9	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:44:55.581652	2025-11-26 13:44:55.124417	2025-11-26 13:44:55.124417
152	062f4fc6-8e4b-4c9c-8785-384d30341478	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 13:55:21.543313	2025-11-26 13:55:21.081803	2025-11-26 13:55:21.081803
153	614919ad-e0ac-4975-a003-0a03e4383e60	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 14:29:57.498333	2025-11-26 14:29:57.095978	2025-11-26 14:29:57.095978
154	c9610919-0038-46e3-a3b7-56ae743e5269	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 14:33:39.345993	2025-11-26 14:33:38.845379	2025-11-26 14:33:38.845379
155	62008831-b970-4c31-80df-e56d40f3bd64	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 14:38:20.079653	2025-11-26 14:38:19.580705	2025-11-26 14:38:19.580705
156	bf85c053-a9d2-43b2-9493-129a7c2db1f1	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 14:41:57.690784	2025-11-26 14:41:57.194204	2025-11-26 14:41:57.194204
157	fb542994-3560-46d7-b5a5-935f529b9f7e	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 14:42:22.739886	2025-11-26 14:42:22.273116	2025-11-26 14:42:22.273116
158	7ef0891a-e29a-4a92-96fa-fcc1af688fc3	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:10:07.643534	2025-11-26 15:10:07.161133	2025-11-26 15:10:07.161133
159	8db261e8-d475-4fb5-9633-5f2e857e76f8	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:14:37.710162	2025-11-26 15:14:37.187638	2025-11-26 15:14:37.187638
160	8ddfc1dd-f96c-4491-8253-cbea813bd06d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:17:39.149445	2025-11-26 15:17:38.625383	2025-11-26 15:17:38.625383
161	e1f44f0a-fe45-4f38-9cf5-5d56185d0fc1	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:22:01.319742	2025-11-26 15:22:00.779837	2025-11-26 15:22:00.779837
162	f938feab-8153-4f2b-8056-f6b73a5401ec	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:30:10.054841	2025-11-26 15:30:09.580869	2025-11-26 15:30:09.580869
163	ed419092-4767-475e-b995-884b4c7c7be1	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:39:17.828027	2025-11-26 15:39:17.315721	2025-11-26 15:39:17.315721
164	063e6cfc-e056-4abc-b278-fcae6c8c1134	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:45:44.560126	2025-11-26 15:45:44.016702	2025-11-26 15:45:44.016702
165	a9845882-08fb-45b5-b0e9-314bfe7cdffa	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 15:55:39.41592	2025-11-26 15:55:38.876946	2025-11-26 15:55:38.876946
166	a323486d-23a4-4cf7-8325-ed0cacc9065d	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 16:04:21.208174	2025-11-26 16:04:20.691861	2025-11-26 16:04:20.691861
167	3b277725-e184-4ec9-8d99-51022d068e89	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 17:44:31.260372	2025-11-26 09:44:31.681346	2025-11-26 09:44:31.681346
168	a8d910b9-4a18-42ce-a112-75bf912c4142	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:04:54.719686	2025-11-26 10:04:55.155674	2025-11-26 10:04:55.155674
172	8c3c6ae8-4516-462c-a71d-64452f948762	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:45:15.340364	2025-11-26 10:45:15.408981	2025-11-26 10:45:15.408981
174	3f08acf2-8a8b-4d8e-a1b4-dfc43cdc3a95	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:14:45.325416	2025-11-26 14:14:46.630376	2025-11-26 14:14:46.630376
181	8cd0eee5-35d7-4afe-963f-9f820f4a990e	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:34:38.889912	2025-11-26 14:34:39.206919	2025-11-26 14:34:39.206919
182	a600d346-e82a-4ab0-a48a-f9bff1c58951	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 23:30:58.445694	2025-11-26 15:30:59.165878	2025-11-26 15:30:59.165878
188	a7bafa70-0f9d-478e-8e55-c7737657e61d	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 00:32:08.594983	2025-11-26 16:32:09.34863	2025-11-26 16:32:09.34863
190	c639b54f-02b7-4497-9b2f-3ef4ac6b7305	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 00:34:36.850377	2025-11-26 16:34:37.584934	2025-11-26 16:34:37.584934
169	7b002f20-6648-44b3-b7b9-bac82d48d207	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:11:11.244195	2025-11-26 10:11:11.673755	2025-11-26 10:11:11.673755
170	4b47f97d-a23d-4c01-b539-c087d1ba193b	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:34:22.125773	2025-11-26 10:34:22.124429	2025-11-26 10:34:22.124429
171	73c00ed7-0fff-4ca9-8df0-bb87c405f7aa	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:36:06.469848	2025-11-26 10:36:06.453216	2025-11-26 10:36:06.453216
173	15cdd093-f3eb-45ce-a981-1f99d76c3c66	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 18:46:49.626737	2025-11-26 10:46:49.619699	2025-11-26 10:46:49.619699
176	f27f30a3-bf15-4ed5-916f-e1b6625a52de	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:23:39.705628	2025-11-26 14:23:39.992418	2025-11-26 14:23:39.992418
178	0f2a1732-4a7e-4044-ba7b-950000bf3601	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:30:47.993899	2025-11-26 14:30:48.428994	2025-11-26 14:30:48.428994
179	fc6357af-35f6-494e-a92e-c61e7bb2a3ef	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:33:33.034856	2025-11-26 14:33:33.367185	2025-11-26 14:33:33.367185
180	af38047c-791b-4f9f-aaea-e4ae51c0e0bc	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-26 22:34:24.23376	2025-11-26 14:34:24.51355	2025-11-26 14:34:24.51355
183	acb3ccbf-ff7c-4ee8-a2ea-50d086af3d91	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 23:36:57.886108	2025-11-26 15:36:58.662291	2025-11-26 15:36:58.662291
184	8fde60c5-4fea-4b25-9ac9-42bd4625259e	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 23:46:31.455806	2025-11-26 15:46:32.154238	2025-11-26 15:46:32.154238
185	9c6d3e68-0243-4398-8895-0d7d52643e61	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-26 23:51:27.423598	2025-11-26 15:51:28.317616	2025-11-26 15:51:28.317616
186	4d04ba25-6549-4f5f-8d41-7977935e3043	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 00:13:11.98575	2025-11-26 16:13:12.688338	2025-11-26 16:13:12.688338
187	cd7a0bbb-117a-4b2c-a796-53c5dc3182e4	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 00:26:36.299425	2025-11-26 16:26:36.98912	2025-11-26 16:26:36.98912
189	24cb1926-a40c-4a13-abcd-9133499fbede	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 00:33:48.894818	2025-11-26 16:33:49.575266	2025-11-26 16:33:49.575266
191	ce5539c2-af05-426d-9dca-ea751b13c12c	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 01:35:44.530158	2025-11-26 17:35:44.833922	2025-11-26 17:35:44.833922
192	2e8f2c28-7712-40de-bf76-bbeebd342826	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 01:53:34.572644	2025-11-26 17:53:35.270329	2025-11-26 17:53:35.270329
193	2d8ed79f-ddc8-4680-a80e-043f38d2bcc7	223.77.17.251	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 02:51:37.293703	2025-11-26 18:51:37.245727	2025-11-26 18:51:37.245727
194	010bea85-2db6-432d-a07c-0ccc398fa8e5	39.144.110.130	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:17:41.227332	2025-11-26 19:17:41.908253	2025-11-26 19:17:41.908253
195	47d7d1a7-3d7a-4026-b696-0f005f64f4b4	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:38:05.790552	2025-11-26 19:38:06.422434	2025-11-26 19:38:06.422434
196	8c9c3847-4ac1-4fe6-8292-77fb565e82d9	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:38:10.023347	2025-11-26 19:38:10.648904	2025-11-26 19:38:10.648904
197	fbc197c3-a5eb-4814-bdaa-7083c08d0a48	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:40:33.859169	2025-11-26 19:40:34.487891	2025-11-26 19:40:34.487891
198	57d982a3-2288-4d6d-9830-05035a45ca7e	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:41:50.985011	2025-11-26 19:41:51.612486	2025-11-26 19:41:51.612486
199	8eda76f1-8438-401c-9fbd-b637448fcc02	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-11-27 03:45:11.114979	2025-11-26 19:45:11.733291	2025-11-26 19:45:11.733291
177	9e758d9b-dbef-4d55-a570-3412d854567c	112.38.98.182	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Pro\\" 10.0 (Build 22631)", "number_of_processors": 20}	2025-11-26 22:30:06.854483	2025-11-26 14:30:00.925065	2025-12-03 21:32:25.109366
200	6e1edffa-370e-406b-9eae-a72f9f0bbfcc	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-27 13:58:42.822706	2025-11-27 05:58:43.176598	2025-11-27 05:58:43.176598
201	cfef3c6a-c7f9-4cdf-8151-4218cfb68f39	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-27 13:59:22.508376	2025-11-27 05:59:22.860519	2025-11-27 05:59:22.860519
4	682fa00e-43d7-4218-b110-e17e7d84b5d3	117.154.120.81	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Pro\\" 10.0 (Build 19045)", "number_of_processors": 16}	2025-11-24 17:03:53.236877	2025-11-24 17:03:54.632007	2025-11-28 00:36:31.143976
175	29d8f84c-09a1-417b-a6f1-002b20b2ab03	103.241.103.162	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 26100)", "number_of_processors": 32}	2025-11-26 22:20:54.120838	2025-11-26 14:20:54.423493	2025-12-05 21:24:08.642224
202	087efefc-f167-4f8b-91ac-2cd710f486a0	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-27 13:59:31.440273	2025-11-27 05:59:31.894246	2025-11-27 05:59:31.894246
204	cdd114fb-25eb-4d7b-b1af-5f9cc3745194	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 14:24:19.356728	2025-11-27 06:24:20.216111	2025-11-27 06:24:20.216111
207	da3a6125-c093-4afb-b549-f27597c9db52	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 20:00:34.772118	2025-11-27 12:00:34.336616	2025-11-27 12:00:34.336616
203	a1237997-29b1-4506-bf89-d7e097ccfff3	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 14:14:44.07519	2025-11-27 06:14:43.899898	2025-11-27 06:14:43.899898
205	c4b46105-8061-4da5-b828-071307c8a8b7	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 14:58:47.715508	2025-11-27 06:58:47.291015	2025-11-27 06:58:47.291015
206	d03fba2a-482f-4fb0-88ae-23ffdd299f49	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 19:46:23.014859	2025-11-27 11:46:22.586722	2025-11-27 11:46:22.586722
208	e567f64e-f7fb-481a-952e-698a4c3efe62	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 21:07:09.273109	2025-11-27 13:07:09.239617	2025-11-27 13:07:09.239617
209	0c579094-6c31-48ff-92ca-da1535b60952	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 21:26:46.28413	2025-11-27 13:26:45.838829	2025-11-27 13:26:45.838829
210	8fe34b81-7cf1-45a1-9268-8c231e7fd2ff	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-27 22:24:05.035639	2025-11-27 14:24:04.603098	2025-11-27 14:24:04.603098
211	056c6300-53ea-4772-a18d-8efe1cc7978b	45.199.128.185	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-27 23:47:18.568788	2025-11-27 15:47:18.908292	2025-11-27 15:47:18.908292
212	ba09bea2-0756-4710-8e09-8fb6caca3657	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 00:52:46.380213	2025-11-27 16:52:46.710314	2025-11-27 16:52:46.710314
213	08587245-8456-404a-8fca-d1dda38fe181	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 00:55:25.994676	2025-11-27 16:55:26.399737	2025-11-27 16:55:26.399737
214	932ab653-4255-4f5f-a1d5-f2eb0cdf649b	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 00:56:55.095067	2025-11-27 16:56:55.489626	2025-11-27 16:56:55.489626
215	29c66954-8486-4d74-a5bd-27797bf8bee1	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 13:46:06.351002	2025-11-28 05:46:06.807639	2025-11-28 05:46:06.807639
216	29fe8cad-a02c-41c8-b66a-b348adcca48b	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 13:50:59.798485	2025-11-28 05:50:59.249081	2025-11-28 05:50:59.249081
217	9a00334e-6397-431f-b701-00c4175eee01	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 14:09:07.90417	2025-11-28 06:09:07.803309	2025-11-28 06:09:07.803309
218	c5cba707-54fb-4fd0-960f-6e12aa0a2e4f	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 14:38:47.197038	2025-11-28 06:38:47.041785	2025-11-28 06:38:47.041785
219	e2cb493f-2009-4e68-a1b1-77e27f2e33f8	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 14:40:43.149241	2025-11-28 06:40:43.023892	2025-11-28 06:40:43.023892
220	11b30515-93e4-4127-9156-eb8eddfaef5d	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 15:00:09.554078	2025-11-28 07:00:09.37547	2025-11-28 07:00:09.37547
221	8c46bf2c-e6e6-4778-8be0-3f7e20a9e744	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 15:02:23.038472	2025-11-28 07:02:22.860473	2025-11-28 07:02:22.860473
222	85fdfa17-3d8c-482c-a8df-20879853b4b2	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 15:08:02.193946	2025-11-28 07:08:02.045696	2025-11-28 07:08:02.045696
223	1974e6b0-b1d1-4d93-9230-9e381c4423a3	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 15:56:36.115882	2025-11-28 07:56:35.579204	2025-11-28 07:56:35.579204
224	82d9183a-9c86-4b98-94b6-277f742b6591	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 15:58:40.113023	2025-11-28 07:58:40.586031	2025-11-28 07:58:40.586031
225	d3272912-2b27-4b8f-944c-bec1b2aec649	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 15:59:02.568035	2025-11-28 07:59:03.009289	2025-11-28 07:59:03.009289
226	7d798b07-dbcc-489b-aa52-edb81e5ddc80	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 15:59:36.153986	2025-11-28 07:59:36.550005	2025-11-28 07:59:36.550005
227	99143ea8-f6b0-4dc4-97b3-1ac5f8a7db34	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 16:07:10.284911	2025-11-28 08:07:09.722247	2025-11-28 08:07:09.722247
228	ab39132a-67e8-40bb-808b-0ab0e5ced6fa	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 16:07:20.715291	2025-11-28 08:07:20.159407	2025-11-28 08:07:20.159407
229	8afe044d-d6fc-49bc-8b7c-6cf51ba8c5a0	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-28 18:59:37.313957	2025-11-28 10:59:37.328015	2025-11-28 10:59:37.328015
230	5f67f3fc-64f6-4b70-b476-84f6f884dd7a	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 21:57:07.333755	2025-11-28 13:57:07.742579	2025-11-28 13:57:07.742579
231	6ed3a670-7f00-44e3-a65e-bdfbda926a3b	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 21:58:03.428565	2025-11-28 13:58:03.859303	2025-11-28 13:58:03.859303
232	3193f298-5acb-4b5e-9620-756543eced22	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-28 21:59:55.313204	2025-11-28 13:59:55.714207	2025-11-28 13:59:55.714207
233	c40aafb7-cec2-4800-97fc-ff36c5cd320a	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-29 08:44:30.355283	2025-11-29 00:44:30.236394	2025-11-29 00:44:30.236394
234	037af4b6-6531-4082-84da-4f2872eeb6a8	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-29 11:15:47.673503	2025-11-29 03:15:47.790669	2025-11-29 03:15:47.790669
235	ca11699f-4d94-4410-af77-bbd9a678571b	125.80.220.55	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-11-29 11:50:08.753834	2025-11-29 03:50:08.853745	2025-11-29 03:50:08.853745
237	bf8bdc13-e488-4c23-9a32-4411b0e4b0f6	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-29 23:45:38.796673	2025-11-29 23:45:38.547176	2025-11-29 23:45:38.547176
249	4dfec9fc-6283-494b-b659-24e85234a8f6	219.142.153.115	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 26100)", "number_of_processors": 16}	2025-12-02 20:27:09.459991	2025-12-02 20:27:09.931516	2025-12-05 15:30:34.586683
238	5f897a33-cea6-4f92-9c8e-edc5c6032322	125.80.220.55	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-11-30 14:39:07.961096	2025-11-30 14:39:07.482885	2025-11-30 14:39:07.482885
239	012b0691-3616-4481-bf70-cbe61ba515e7	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-11-30 14:41:16.072498	2025-11-30 14:41:16.027472	2025-11-30 14:41:16.027472
240	6e4a877b-67ac-4766-b400-2283e5bf06ff	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-11-30 17:45:59.344832	2025-11-30 17:45:59.894548	2025-11-30 17:45:59.894548
241	edd124cf-439e-45dc-ab7f-8b1e08b0c236	113.248.107.238	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-01 10:23:24.945884	2025-12-01 10:23:24.14207	2025-12-01 10:23:24.14207
242	3efe4e9e-9e79-4f39-8005-d7c7c938ed2b	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-01 10:34:56.318774	2025-12-01 10:34:56.871234	2025-12-01 10:34:56.871234
243	21505c3e-1695-49dd-9259-968a13818ca1	113.248.107.238	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-01 10:52:17.990286	2025-12-01 10:52:18.229669	2025-12-01 10:52:18.229669
236	f25f8b56-b068-48e1-b34b-2189a6cca76b	125.80.215.120	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 26200)", "number_of_processors": 12}	2025-11-29 13:05:28.225376	2025-11-29 05:06:10.470761	2025-12-11 11:48:54.17449
244	4b7696e9-e827-4e86-b21d-c47ed991193d	183.227.175.28	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-01 22:18:22.778118	2025-12-01 22:18:21.804389	2025-12-01 22:18:21.804389
245	d0818abb-05ea-4562-8ad4-5fb75e7bb345	113.248.107.238	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-01 22:34:52.560553	2025-12-01 22:34:53.479902	2025-12-01 22:34:53.479902
246	0d8b75f1-9739-4f45-a638-4188ecae3c41	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-02 13:20:15.360247	2025-12-02 13:20:15.988097	2025-12-02 13:20:15.988097
247	1d8da976-c80c-49f9-ad0f-bf605e0c4cfa	183.227.245.229	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-02 20:26:40.576257	2025-12-02 20:26:39.21951	2025-12-02 20:26:39.21951
248	7f638861-3a78-4391-805f-9699d0b2a5b6	113.248.107.238	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-02 20:26:47.499517	2025-12-02 20:26:51.819194	2025-12-02 20:26:51.819194
250	69a0fcdb-9ff4-4e14-a0c3-f766452feb5d	113.248.107.238	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-02 20:50:32.41686	2025-12-02 20:50:37.168905	2025-12-02 20:50:37.168905
251	6eca18b6-f35f-463f-a94a-a289aab1729a	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-02 20:55:49.721421	2025-12-02 20:55:48.990594	2025-12-02 20:55:48.990594
252	114c85ae-dea7-4985-8bef-03aa6f8d4688	183.227.245.229	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-02 21:00:21.976544	2025-12-02 21:00:20.906784	2025-12-02 21:00:20.906784
253	79b0380a-ae45-4a6b-94ee-3c608556dba9	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-03 21:27:00.281327	2025-12-03 21:27:01.067504	2025-12-03 21:27:01.067504
254	d785ce88-2321-4251-bf5c-586594501f37	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-03 21:46:50.29011	2025-12-03 21:46:49.450289	2025-12-03 21:46:49.450289
255	436bd176-504a-4cf0-b8d1-e5e05337dcd3	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-04 00:34:44.54908	2025-12-04 00:34:45.326215	2025-12-04 00:34:45.326215
256	3f36e071-04d4-45bd-9df6-b490af88f87d	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "AP3A.240905.015.A2.F9460ZCS7EYI1", "number_of_processors": 8}	2025-12-04 00:46:14.853627	2025-12-04 00:46:14.953809	2025-12-04 00:46:14.953809
257	e85e5fbb-2cc9-4876-b2f8-adf27455cb57	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-04 14:58:58.634206	2025-12-04 14:58:59.448529	2025-12-04 14:58:59.448529
258	bdb455b4-0d1d-4d8b-a809-dccb91330674	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 11:39:50.952831	2025-12-05 11:39:51.857564	2025-12-05 11:39:51.857564
259	ef863540-229a-4c58-b800-340f8877f4b6	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 11:40:58.899843	2025-12-05 11:40:59.795442	2025-12-05 11:40:59.795442
260	c76aa53a-0e32-4255-b55b-83cb9005a867	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 11:41:36.39141	2025-12-05 11:41:37.279521	2025-12-05 11:41:37.279521
261	19865c07-2725-465a-8221-ac2806f8fa9a	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 11:42:56.051246	2025-12-05 11:42:56.966707	2025-12-05 11:42:56.966707
262	6fa791d5-27d2-4a4c-9279-3b99a5dfabc9	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-05 12:02:03.853225	2025-12-05 12:02:03.348174	2025-12-05 12:02:03.348174
263	81177425-8332-43fe-ba3a-d9d212bd25bb	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 12:10:29.513674	2025-12-05 12:10:30.408698	2025-12-05 12:10:30.408698
264	2ec1f5a0-e011-4972-8cc9-91d8e4de218e	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-05 12:12:20.396377	2025-12-05 12:12:19.883926	2025-12-05 12:12:19.883926
265	8744f8b2-c6da-40ec-8c66-50ab501e5ec8	113.250.144.118	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-05 15:31:46.706709	2025-12-05 15:31:54.055562	2025-12-05 15:31:54.055562
266	3d40ef93-6c53-444d-b343-cd5831b247e7	219.142.153.115	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-05 15:44:39.395094	2025-12-05 15:44:40.083452	2025-12-05 15:44:40.083452
267	035e2d1f-5cc4-486b-b3e9-34db4f284302	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 18:47:26.616353	2025-12-05 18:47:27.50854	2025-12-05 18:47:27.50854
268	7d54e003-43c7-4d77-9096-9e8a3229399b	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-05 20:16:56.74758	2025-12-05 20:16:56.194384	2025-12-05 20:16:56.194384
269	fe9a77a1-c987-4d1c-beb7-4aa6b2dac9c1	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-12-05 21:01:28.054628	2025-12-05 21:01:28.064548	2025-12-05 21:01:28.064548
270	a3f2cfc3-138d-40b2-8424-f04aef1ab896	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-05 21:15:31.385433	2025-12-05 21:15:32.285549	2025-12-05 21:15:32.285549
271	a6f64ac4-abd4-4e50-a47d-6df3b176bf30	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-06 00:57:16.606145	2025-12-06 00:57:15.99687	2025-12-06 00:57:15.99687
272	474c29a7-9e7a-4884-9141-46d3c1733dcc	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-06 01:12:41.44917	2025-12-06 01:12:40.832394	2025-12-06 01:12:40.832394
273	7e398df9-9c87-43b6-a792-e7f2bb52efd9	103.241.103.162	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "RedMagicOS11.0.13MR2", "number_of_processors": 8}	2025-12-06 09:16:50.510769	2025-12-06 09:16:51.401627	2025-12-06 09:16:51.401627
274	4e4bd0d5-9cb0-4940-9791-5a971b0c8f3a	129.224.202.243	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Enterprise\\" 10.0 (Build 19045)", "number_of_processors": 4}	2025-12-06 10:19:10.023759	2025-12-06 10:20:03.868737	2025-12-06 10:20:03.868737
275	e13c5c20-b994-4420-b892-0402616223d1	129.224.203.145	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 26100)", "number_of_processors": 16}	2025-12-06 10:21:07.28045	2025-12-06 10:21:08.788186	2025-12-06 10:21:08.788186
276	646b9941-ab81-4ddf-9dad-3261e242979b	129.224.202.101	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Pro\\" 10.0 (Build 26200)", "number_of_processors": 32}	2025-12-06 10:21:18.664582	2025-12-06 10:21:19.698564	2025-12-06 10:21:19.698564
277	635fe834-4247-4279-8826-206b09691d50	129.224.202.101	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Enterprise\\" 10.0 (Build 19045)", "number_of_processors": 4}	2025-12-06 10:22:12.501319	2025-12-06 10:22:14.843174	2025-12-06 10:22:14.843174
278	3f9cd572-93ac-4531-bdde-7803a113052e	129.224.203.208	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "TP1A.220624.014", "number_of_processors": 8}	2025-12-06 10:29:57.395718	2025-12-06 10:29:57.126703	2025-12-06 10:29:57.126703
279	0bca375f-4e8e-436d-a43f-8c26569cb07c	112.57.79.240	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R301P4)", "number_of_processors": 8}	2025-12-06 10:31:34.257051	2025-12-06 10:31:33.27719	2025-12-06 10:31:33.27719
280	ff2cc286-74c8-41a2-99cf-96952efea460	129.224.203.145	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "RMO-TN00 7.0.0.210(C01E189R6P6)", "number_of_processors": 8}	2025-12-06 10:34:02.3414	2025-12-06 10:34:02.31276	2025-12-06 10:34:02.31276
281	3c323cb0-4c79-453a-9589-6653ce40c642	129.224.203.208	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R104P1)", "number_of_processors": 8}	2025-12-06 10:41:52.027188	2025-12-06 10:41:51.701744	2025-12-06 10:41:51.701744
282	cf841592-3f4a-4421-a23a-ebfd27a9d6fb	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-12-06 14:53:11.213541	2025-12-06 14:53:11.342805	2025-12-06 14:53:11.342805
283	906e4c39-fda6-44d3-9b37-0cad8db1589a	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PD2055_A_9.10.3", "number_of_processors": 8}	2025-12-06 14:53:28.890262	2025-12-06 14:53:29.016087	2025-12-06 14:53:29.016087
284	43dedf82-2fc0-4594-9070-f26c724d7a33	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "AQ3A.240912.001", "number_of_processors": 8}	2025-12-06 15:06:30.352537	2025-12-06 15:06:30.503131	2025-12-06 15:06:30.503131
285	4496f934-e385-4206-91a7-c1742a0dbe10	112.38.98.182	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PD2055_A_9.10.3", "number_of_processors": 8}	2025-12-06 15:06:40.358335	2025-12-06 15:06:40.473648	2025-12-06 15:06:40.473648
286	8e621a97-9c70-4189-82be-a6ec623a6239	117.154.120.81	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-06 15:09:14.367866	2025-12-06 15:09:13.640602	2025-12-06 15:09:13.640602
287	f5e54147-385c-40d7-a234-4ab2a023517f	129.224.203.208	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R104P1)", "number_of_processors": 8}	2025-12-07 12:20:18.272542	2025-12-07 12:20:17.844784	2025-12-07 12:20:17.844784
288	ba0b671e-39e7-46b5-b700-fb802e8110a0	129.224.203.242	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "RMO-TN00 7.0.0.210(C01E189R6P6)", "number_of_processors": 8}	2025-12-07 12:57:53.95025	2025-12-07 12:57:53.865309	2025-12-07 12:57:53.865309
289	79c41975-0485-47d2-9a75-ed330fd250c8	129.224.203.208	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "TP1A.220624.014", "number_of_processors": 8}	2025-12-07 13:10:01.079191	2025-12-07 13:10:01.346179	2025-12-07 13:10:01.346179
290	85741e2c-d364-4448-81b6-383ffa54a2b7	129.224.202.78	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "RMO-TN00 7.0.0.210(C01E189R6P6)", "number_of_processors": 8}	2025-12-07 13:10:28.919	2025-12-07 13:10:28.973633	2025-12-07 13:10:28.973633
291	84a91b4f-f21f-493c-ab67-ae718094080b	112.57.79.240	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R301P4)", "number_of_processors": 8}	2025-12-07 13:12:08.893385	2025-12-07 13:12:08.804508	2025-12-07 13:12:08.804508
292	e1fc009a-413a-49a7-92fe-9068923502b2	125.80.215.120	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-11 11:46:52.677133	2025-12-11 11:46:52.896763	2025-12-11 11:46:52.896763
293	09c0ba0e-e228-4258-842d-20a7679944f5	125.80.215.120	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-11 12:08:43.70455	2025-12-11 12:08:43.791414	2025-12-11 12:08:43.791414
294	6f167592-8d69-423d-9b6b-b59e16e075a8	223.77.17.174	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-12 10:43:22.816708	2025-12-12 10:43:21.892563	2025-12-12 10:43:21.892563
295	7b2fc8fd-41f6-45ec-ac6d-efed1a492448	150.228.149.175	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R301P4)", "number_of_processors": 8}	2025-12-13 09:36:17.805847	2025-12-13 09:36:17.141219	2025-12-13 09:36:17.141219
296	fd5ad9d7-b4fb-4a51-99d7-1d68ea2554ba	150.228.148.20	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "BRC-AN00 9.0.0.200(C00E170R301P5)", "number_of_processors": 8}	2025-12-13 09:42:18.049372	2025-12-13 09:42:13.470747	2025-12-13 09:42:13.470747
297	82e3998d-0519-4f8c-b21c-fed0bd6b9623	129.224.203.248	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Enterprise\\" 10.0 (Build 19045)", "number_of_processors": 4}	2025-12-13 10:25:46.733223	2025-12-13 10:25:55.283275	2025-12-13 10:25:55.283275
298	d196c61e-33ab-4205-a365-d6b96b29cfe0	117.154.120.11	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Pro\\" 10.0 (Build 19045)", "number_of_processors": 16}	2025-12-13 19:56:37.758009	2025-12-13 19:56:39.337103	2025-12-13 19:56:39.337103
299	2c220ead-bfdc-45a1-b389-df1cccd63643	117.154.120.11	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-13 20:12:27.015188	2025-12-13 20:12:27.299993	2025-12-13 20:12:27.299993
300	801adfce-aea6-4e2e-b820-517cd83ab9e8	150.228.148.20	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "TP1A.220624.014", "number_of_processors": 8}	2025-12-14 10:03:22.324648	2025-12-14 10:03:21.967373	2025-12-14 10:03:21.967373
301	24ba8b73-861a-4b0c-b873-a36dd80c78ab	129.224.203.176	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "BRC-AN00 9.0.0.200(C00E170R301P5)", "number_of_processors": 8}	2025-12-14 10:05:54.084268	2025-12-14 10:05:50.560085	2025-12-14 10:05:50.560085
302	156077e7-81a9-41ac-8eb6-db20477e0aa8	112.19.198.177	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "BRC-AN00 9.0.0.188(SP3C00E163R104P5)", "number_of_processors": 8}	2025-12-14 10:18:01.626747	2025-12-14 10:18:02.278713	2025-12-14 10:18:02.278713
303	a818953b-6497-4d1d-9bf0-c1b182c9dc6b	150.228.149.175	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R301P4)", "number_of_processors": 8}	2025-12-14 10:24:28.029354	2025-12-14 10:24:27.13947	2025-12-14 10:24:27.13947
304	4db656b5-c94f-4bbe-bf62-0fe5697e7ccc	150.228.148.20	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "ALT-AN10 8.0.0.612(C00E601R104P1)", "number_of_processors": 8}	2025-12-14 10:29:51.076215	2025-12-14 10:29:44.754154	2025-12-14 10:29:44.754154
306	f0ad201c-4722-4fa4-96bf-6b534b31dff2	113.248.107.208	android	{"os": "android", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "PQ3B.190801.08071126 release-keys", "number_of_processors": 4}	2025-12-14 13:47:22.274865	2025-12-14 13:47:22.456116	2025-12-14 13:47:22.456116
307	69463f93-be79-4164-9322-712da794453c	113.248.107.208	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "HMA-AL00 10.1.0.163(C00E160R1P8)", "number_of_processors": 8}	2025-12-14 13:51:05.859332	2025-12-14 13:51:05.007999	2025-12-14 13:51:05.007999
305	f1f119ca-9e4b-4ac4-9325-4a99835e4469	113.248.107.208	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 26200)", "number_of_processors": 12}	2025-12-14 13:24:00.690217	2025-12-14 13:24:58.583422	2025-12-14 16:04:49.606422
308	e4615b8f-3d55-4f28-8b41-0d669a049e21	111.41.17.48	windows	{"os": "windows", "is_web": false, "locale": "zh_CN", "is_debug": false, "os_version": "\\"Windows 10 Home China\\" 10.0 (Build 19045)", "number_of_processors": 12}	2025-12-15 11:47:53.669603	2025-12-15 11:47:57.01135	2025-12-15 11:47:57.01135
309	59194441-ce0b-4e11-8729-940c06784c4f	117.154.120.11	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-16 11:17:29.5578	2025-12-16 11:17:29.234901	2025-12-16 11:17:29.234901
310	d2670d72-87ba-449f-ab11-d340abfa1d85	117.154.120.11	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": false, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2025-12-16 11:20:45.586586	2025-12-16 11:20:45.280477	2025-12-16 11:20:45.280477
311	514ad2d4-7fa9-4344-86d0-a7977f36f014	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-18 10:09:05.703718	2025-12-18 10:09:05.994695	2025-12-18 12:41:20.206487
312	53d87d66-ba39-4667-92fe-2ed954f0f8a2	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 09:39:07.07418	2025-12-19 09:39:07.445219	2025-12-19 09:39:07.445219
313	6146efe4-72f0-4147-98cc-f1cd4205955f	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 09:50:06.54965	2025-12-19 09:50:06.77318	2025-12-19 09:50:06.77318
314	c9fbc4a0-76fb-4974-89b8-cfa7c9a6a15f	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 10:09:27.518209	2025-12-19 10:09:27.738882	2025-12-19 10:09:27.738882
315	fd031741-084c-43e3-af49-ee48252a8af9	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 10:47:07.283369	2025-12-19 10:47:07.509861	2025-12-19 10:47:07.509861
316	5ab3656a-b98c-4fa1-a54a-ea9d900b13b4	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 14:38:14.867039	2025-12-19 14:38:15.101958	2025-12-19 14:38:15.101958
317	bb13be8a-4513-4b73-8eb7-38faddb9123f	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 20:49:36.913296	2025-12-19 20:49:37.245391	2025-12-19 20:49:37.245391
318	d6386335-ea70-44af-8d94-9d282692ee50	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-19 22:13:47.045697	2025-12-19 22:13:47.274573	2025-12-19 22:13:47.274573
319	ab584270-9d2a-4f28-ba47-13f354819dfb	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2025-12-29 20:40:16.404455	2025-12-29 20:40:16.633432	2025-12-29 20:40:16.633432
320	0101cd54-6f7c-49a5-9a3c-ff4fde1b15a6	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-01-09 12:08:02.907596	2026-01-09 12:08:03.1803	2026-01-09 12:08:03.1803
321	d6ec8aea-931a-47fa-a2d0-d1bc15b72bf6	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-01-09 12:46:42.724943	2026-01-09 12:46:42.957201	2026-01-09 12:46:42.957201
322	1e6b8f4e-6703-417e-a408-a74e11f5e9d6	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-01-09 16:34:54.174642	2026-01-09 08:34:54.47082	2026-01-09 08:34:54.47082
323	5b18a6b7-4bb9-4a82-8353-d0a914ffac06	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-01-09 17:05:00.089819	2026-01-09 17:05:00.318309	2026-01-09 17:05:00.318309
324	926d03cb-7eff-47a7-861b-20b85ecaec25	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-01-23 21:18:30.476602	2026-01-23 21:18:30.706661	2026-01-23 21:18:30.706661
325	cb4e28d3-ec41-4c6d-953e-2f6ac8081b75	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-02-27 21:11:21.573123	2026-02-27 13:11:21.819169	2026-02-27 13:11:21.819169
326	5f0bf85e-d7e2-474c-9d44-f0fd748e1e1d	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-02-28 13:15:40.602391	2026-02-28 05:15:40.849527	2026-02-28 05:15:40.849527
327	3a1d7489-d78e-4649-bb7a-75b95a8c6e78	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-03-01 13:46:01.220172	2026-03-01 13:46:01.475227	2026-03-01 13:46:01.475227
328	d2452de5-6a25-401a-95c5-bc1cee03f146	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-03-01 14:51:50.288494	2026-03-01 06:51:50.555741	2026-03-01 06:51:50.555741
329	1cd7eaf0-9018-4f40-829b-9b234c2966dc	192.168.1.20	ios	{"os": "ios", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "Version 18.4 (Build 22E238)", "number_of_processors": 16}	2026-03-01 14:52:34.535298	2026-03-01 06:52:34.791325	2026-03-01 06:52:34.791325
330	248c9c33-91d1-4aa0-a253-31590bb6517b	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2026-06-27 12:58:13.166138	2026-06-27 12:58:14.455114	2026-06-27 12:58:14.455114
331	bf8b4351-4518-4076-bd31-ee8426808b38	192.168.1.7	android	{"os": "android", "is_web": false, "locale": "zh_Hans_CN", "is_debug": true, "os_version": "GLK-AL00 3.0.0.168(C00E160R1P3)", "number_of_processors": 8}	2026-06-27 21:07:26.301333	2026-06-27 13:07:27.334597	2026-06-27 13:07:27.334597
\.


--
-- Data for Name: favorite_contacts; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorite_contacts (id, user_id, contact_id, created_at) FROM stdin;
\.


--
-- Data for Name: favorite_groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorite_groups (id, user_id, group_id, created_at) FROM stdin;
\.


--
-- Data for Name: favorites; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.favorites (id, user_id, message_id, content, message_type, file_name, sender_id, sender_name, created_at, server_id, sync_status) FROM stdin;
76	143	\N	11	text	\N	142	规范规定112	2025-12-11 11:59:15.787975	\N	synced
77	143	\N	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764556414_屏幕截图 2025-08-12 125412.png	image	\N	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	2025-12-11 11:59:30.941254	\N	synced
78	143	\N	67890	text	\N	144	cesfffff	2025-12-17 11:39:41.292715	\N	synced
79	143	3132	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765943581_image_0DD5F000-CAD9-4133-9914-CF8F5E8B9BAB_1765943582.png	image	\N	143	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	2025-12-17 11:53:12.185654	\N	synced
\.


--
-- Data for Name: file_assistant_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.file_assistant_messages (id, user_id, content, message_type, file_name, quoted_message_id, quoted_message_content, status, created_at, server_id) FROM stdin;
\.


--
-- Data for Name: group_members; Type: TABLE DATA; Schema: public; Owner: -
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
\.


--
-- Data for Name: group_message_reads; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_message_reads (id, group_message_id, user_id, read_at) FROM stdin;
2852	1603	102	2026-01-09 17:24:46.530878
2853	1604	102	2026-01-09 17:24:46.530878
2854	1610	102	2026-01-09 17:24:46.530878
2855	1611	102	2026-01-09 17:24:46.530878
2856	1616	102	2026-01-09 17:24:46.530878
2857	1618	102	2026-01-09 17:24:46.530878
2858	1606	103	2026-01-09 17:24:55.518845
2859	1608	103	2026-01-09 17:24:55.518845
2860	1613	103	2026-01-09 17:24:55.518845
2861	1615	103	2026-01-09 17:24:55.518845
2862	1620	103	2026-01-09 17:24:55.518845
2863	1622	103	2026-01-09 17:24:55.518845
2864	1624	103	2026-01-09 17:24:55.518845
2865	1626	103	2026-01-09 17:24:55.518845
2866	1628	103	2026-01-09 17:24:55.518845
2867	1630	102	2026-01-09 17:25:21.732346
2868	1635	102	2026-01-10 20:00:31.266482
2869	1637	102	2026-01-10 20:00:31.266482
2870	1629	103	2026-01-10 20:16:16.372748
2871	1631	103	2026-01-10 20:16:16.372748
2872	1632	103	2026-01-10 20:16:16.372748
2873	1633	103	2026-01-10 20:16:16.372748
2874	1634	103	2026-01-10 20:16:16.372748
2875	1636	103	2026-01-10 20:16:16.372748
2876	1638	103	2026-01-10 20:16:16.372748
2877	1639	103	2026-01-10 20:18:03.197166
2878	1640	102	2026-01-23 22:14:07.48439
2879	1641	103	2026-01-23 22:14:14.135135
2880	1532	102	2026-06-27 12:20:40.968384
2881	1533	102	2026-06-27 12:20:40.968384
2882	1539	102	2026-06-27 12:20:40.968384
2883	1541	102	2026-06-27 12:20:40.968384
2884	1543	102	2026-06-27 12:20:40.968384
2885	1545	102	2026-06-27 12:20:40.968384
2886	1503	102	2026-06-27 18:23:09.384041
2887	1504	102	2026-06-27 18:23:09.384041
2888	1505	102	2026-06-27 18:23:09.384041
2889	1506	102	2026-06-27 18:23:09.384041
2890	1507	102	2026-06-27 18:23:09.384041
2891	1642	106	2026-06-27 18:24:18.675359
2892	1643	106	2026-06-27 18:24:18.675359
2893	1644	106	2026-06-27 18:24:18.675359
2894	1645	106	2026-06-27 18:24:28.592849
2896	1647	106	2026-06-27 18:24:28.592849
2898	1649	102	2026-06-27 18:29:14.439925
2899	1650	106	2026-06-27 18:29:24.154578
2901	1652	106	2026-06-27 18:29:24.154578
2902	1653	106	2026-06-27 18:29:24.154578
2903	1654	102	2026-06-27 18:38:33.366419
2904	1655	106	2026-06-27 18:38:42.789283
2906	1657	106	2026-06-27 18:39:23.468064
2907	1592	102	2026-06-27 22:18:11.016269
2908	1593	102	2026-06-27 22:18:11.016269
2909	1594	102	2026-06-27 22:18:11.016269
2910	1573	102	2026-06-27 22:18:11.016269
2911	1574	102	2026-06-27 22:18:11.016269
2912	1575	102	2026-06-27 22:18:11.016269
2913	1576	102	2026-06-27 22:18:11.016269
2914	1577	102	2026-06-27 22:18:11.016269
2915	1578	102	2026-06-27 22:18:11.016269
2916	1579	102	2026-06-27 22:18:11.016269
2917	1580	102	2026-06-27 22:18:11.016269
2918	1581	102	2026-06-27 22:18:11.016269
2919	1582	102	2026-06-27 22:18:11.016269
2920	1583	102	2026-06-27 22:18:11.016269
2921	1584	102	2026-06-27 22:18:11.016269
2922	1585	102	2026-06-27 22:18:11.016269
2923	1586	102	2026-06-27 22:18:11.016269
2924	1587	102	2026-06-27 22:18:11.016269
2925	1588	102	2026-06-27 22:18:11.016269
2926	1589	102	2026-06-27 22:18:11.016269
2927	1590	102	2026-06-27 22:18:11.016269
2928	1591	102	2026-06-27 22:18:11.016269
2929	1595	102	2026-06-27 22:18:11.016269
2930	1596	102	2026-06-27 22:18:11.016269
2931	1597	102	2026-06-27 22:18:11.016269
2932	1598	102	2026-06-27 22:18:11.016269
2933	1599	102	2026-06-27 22:18:11.016269
2934	1600	102	2026-06-27 22:18:11.016269
2935	1601	102	2026-06-27 22:18:11.016269
2936	1602	102	2026-06-27 22:18:11.016269
\.


--
-- Data for Name: group_messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.group_messages (id, group_id, sender_id, sender_name, content, message_type, file_name, quoted_message_id, quoted_message_content, status, created_at, sender_avatar, mentioned_user_ids, mentions, deleted_by_users, call_type, channel_name, sender_nickname, sender_full_name, server_id, voice_duration) FROM stdin;
733	23	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-24 19:23:07.635651		\N	\N		\N	\N	\N	\N	\N	\N
734	23	102	测试01	111	text	\N	\N	\N	normal	2025-11-24 19:23:19.500715		\N	\N		\N	\N	\N	\N	\N	\N
735	23	102	测试01	222	text	\N	\N	\N	normal	2025-11-24 19:23:27.014424		\N	\N		\N	\N	\N	\N	\N	\N
736	23	103	测试2	333	text	\N	\N	\N	normal	2025-11-24 19:23:31.618152		\N	\N		\N	\N	\N	\N	\N	\N
737	23	103	测试2	444	text	\N	\N	\N	normal	2025-11-24 19:23:37.856743		\N	\N		\N	\N	\N	\N	\N	\N
738	23	103	测试2	555	text	\N	\N	\N	normal	2025-11-24 19:38:17.805563		\N	\N		\N	\N	\N	\N	\N	\N
739	23	103	测试2	666	text	\N	\N	\N	normal	2025-11-24 19:46:32.889884		\N	\N		\N	\N	\N	\N	\N	\N
740	23	102	测试01	3333	text	\N	\N	\N	normal	2025-11-24 19:48:32.560429		\N	\N		\N	\N	\N	\N	\N	\N
741	23	103	测试2	444	text	\N	\N	\N	normal	2025-11-24 20:40:25.299577		\N	\N		\N	\N	\N	\N	\N	\N
742	23	103	测试2	555	text	\N	\N	\N	normal	2025-11-24 20:57:29.713493		\N	\N		\N	\N	\N	\N	\N	\N
743	23	103	测试2	[emotion:1_Smile.png]	text	\N	\N	\N	normal	2025-11-24 20:59:29.390911		\N	\N		\N	\N	\N	\N	\N	\N
744	23	102	测试01	123456	text	\N	\N	\N	normal	2025-11-24 21:10:27.56401		\N	\N		\N	\N	\N	\N	\N	\N
745	23	103	测试2	55	text	\N	\N	\N	normal	2025-11-24 21:10:34.24543		\N	\N		\N	\N	\N	\N	\N	\N
746	23	102	测试01	111	text	\N	\N	\N	normal	2025-11-24 22:05:29.410129		\N	\N		\N	\N	\N	\N	\N	\N
747	24	112	测试21	群组已创建	system	\N	\N	\N	normal	2025-11-25 14:27:47.611305		\N	\N		\N	\N	\N	\N	\N	\N
748	24	112	测试21	222	text	\N	\N	\N	normal	2025-11-25 14:58:54.273276		\N	\N		\N	\N	\N	\N	\N	\N
749	24	112	测试21	333	text	\N	\N	\N	normal	2025-11-25 14:59:53.809909		\N	\N		\N	\N	\N	\N	\N	\N
750	24	102	测试01	3333	text	\N	\N	\N	normal	2025-11-25 15:12:22.138085		\N	\N		\N	\N	\N	\N	\N	\N
751	24	102	测试01	4444	text	\N	\N	\N	normal	2025-11-25 15:12:27.363005		\N	\N		\N	\N	\N	\N	\N	\N
752	24	112	测试21	555	text	\N	\N	\N	normal	2025-11-25 15:27:06.089523		\N	\N		\N	\N	\N	\N	\N	\N
753	25	107	测试06	群组已创建	system	\N	\N	\N	normal	2025-11-26 08:02:29.852289		\N	\N		\N	\N	\N	\N	\N	\N
754	25	107	测试06	111	text	\N	\N	\N	normal	2025-11-26 08:02:43.550818		\N	\N		\N	\N	\N	\N	\N	\N
755	25	107	测试06	222	text	\N	\N	\N	normal	2025-11-26 08:03:15.363561		\N	\N		\N	\N	\N	\N	\N	\N
756	25	107	测试06	333	text	\N	\N	\N	normal	2025-11-26 08:03:16.498114		\N	\N		\N	\N	\N	\N	\N	\N
757	25	107	测试06	444	text	\N	\N	\N	normal	2025-11-26 08:03:17.208616		\N	\N		\N	\N	\N	\N	\N	\N
758	25	107	测试06	555	text	\N	\N	\N	normal	2025-11-26 08:03:18.264466		\N	\N		\N	\N	\N	\N	\N	\N
759	25	107	测试06	666	text	\N	\N	\N	normal	2025-11-26 08:03:18.975135		\N	\N		\N	\N	\N	\N	\N	\N
760	25	107	测试06	777	text	\N	\N	\N	normal	2025-11-26 08:03:20.107302		\N	\N		\N	\N	\N	\N	\N	\N
761	25	107	测试06	888	text	\N	\N	\N	normal	2025-11-26 08:03:20.898584		\N	\N		\N	\N	\N	\N	\N	\N
762	25	107	测试06	999	text	\N	\N	\N	normal	2025-11-26 08:03:21.728416		\N	\N		\N	\N	\N	\N	\N	\N
763	25	107	测试06	000	text	\N	\N	\N	normal	2025-11-26 08:03:22.624321		\N	\N		\N	\N	\N	\N	\N	\N
764	25	107	测试06	111	text	\N	\N	\N	normal	2025-11-26 08:03:24.015655		\N	\N		\N	\N	\N	\N	\N	\N
765	25	107	测试06	222	text	\N	\N	\N	normal	2025-11-26 08:03:24.812569		\N	\N		\N	\N	\N	\N	\N	\N
766	25	107	测试06	333	text	\N	\N	\N	normal	2025-11-26 08:03:25.594716		\N	\N		\N	\N	\N	\N	\N	\N
767	25	107	测试06	444	text	\N	\N	\N	normal	2025-11-26 08:03:26.842507		\N	\N		\N	\N	\N	\N	\N	\N
768	25	107	测试06	555	text	\N	\N	\N	normal	2025-11-26 08:03:27.761114		\N	\N		\N	\N	\N	\N	\N	\N
769	25	107	测试06	666	text	\N	\N	\N	normal	2025-11-26 08:03:28.482357		\N	\N		\N	\N	\N	\N	\N	\N
770	26	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 11:03:31.409536		\N	\N		\N	\N	\N	\N	\N	\N
771	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 11:04:24.278418		\N	\N		\N	\N	\N	\N	\N	\N
772	26	113	测试22	22	text	\N	\N	\N	normal	2025-11-26 11:04:57.883292		\N	\N		\N	\N	\N	\N	\N	\N
773	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 11:34:41.051765		\N	\N		\N	\N	\N	\N	\N	\N
774	26	113	测试22	全体禁言已关闭	system	\N	\N	\N	normal	2025-11-26 11:35:31.790812		\N	\N		\N	\N	\N	\N	\N	\N
775	26	113	测试22	全体禁言已开启	system	\N	\N	\N	normal	2025-11-26 11:41:20.784102		\N	\N		\N	\N	\N	\N	\N	\N
776	26	113	测试22	全体禁言已关闭	system	\N	\N	\N	normal	2025-11-26 11:41:33.23408		\N	\N		\N	\N	\N	\N	\N	\N
777	26	113	测试22	33	text	\N	\N	\N	normal	2025-11-26 12:42:35.080768	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
778	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 12:42:36.744637	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
779	26	113	测试22	5	text	\N	\N	\N	normal	2025-11-26 12:43:46.486436	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
780	26	114	测试23	gfdd	text	\N	\N	\N	normal	2025-11-26 12:49:40.723715	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
781	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 13:08:25.827485	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
782	26	113	测试22	333	text	\N	\N	\N	normal	2025-11-26 13:11:22.597601	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
783	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 13:17:16.741276	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
784	26	113	测试22	55	text	\N	\N	\N	normal	2025-11-26 13:24:25.907743	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
785	26	113	测试22	66	text	\N	\N	\N	normal	2025-11-26 13:27:13.018659	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
786	26	114	测试23	888	text	\N	\N	\N	normal	2025-11-26 13:28:52.052571	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
787	26	113	测试22	999	text	\N	\N	\N	normal	2025-11-26 13:29:45.929195	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
788	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 13:45:25.1804	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
789	26	113	测试22	22	text	\N	\N	\N	normal	2025-11-26 13:45:36.784231	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
790	26	113	测试22	33	text	\N	\N	\N	normal	2025-11-26 13:45:40.528921	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
791	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 13:45:42.873167	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
792	26	113	测试22	55	text	\N	\N	\N	normal	2025-11-26 13:45:44.81739	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
793	26	113	测试22	66	text	\N	\N	\N	normal	2025-11-26 13:45:46.5844	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
794	26	113	测试22	77	text	\N	\N	\N	normal	2025-11-26 13:45:48.387732	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
795	26	113	测试22	88	text	\N	\N	\N	normal	2025-11-26 13:45:50.074842	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
796	26	113	测试22	99	text	\N	\N	\N	normal	2025-11-26 13:45:51.878091	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
797	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 13:45:53.514781	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
798	26	113	测试22	22	text	\N	\N	\N	normal	2025-11-26 13:45:55.406646	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
943	48	127	测试901	aaa	text	\N	\N	\N	normal	2025-12-02 20:57:30.914665		\N	\N		\N	\N	\N	\N	\N	\N
799	26	113	测试22	33	text	\N	\N	\N	normal	2025-11-26 13:45:56.950207	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
800	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 13:45:58.751613	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
801	26	113	测试22	55	text	\N	\N	\N	normal	2025-11-26 13:46:00.549709	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
802	26	113	测试22	66	text	\N	\N	\N	normal	2025-11-26 13:46:02.390738	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
803	26	113	测试22	77	text	\N	\N	\N	normal	2025-11-26 13:46:03.938289	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
804	26	113	测试22	88	text	\N	\N	\N	normal	2025-11-26 13:46:05.719986	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
805	26	113	测试22	99	text	\N	\N	\N	normal	2025-11-26 13:46:07.344627	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
806	26	113	测试22	00	text	\N	\N	\N	normal	2025-11-26 13:46:09.029697	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
807	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 13:46:10.526067	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
808	26	113	测试22	22	text	\N	\N	\N	normal	2025-11-26 13:46:13.678397	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
809	26	113	测试22	33	text	\N	\N	\N	normal	2025-11-26 13:46:15.039012	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
810	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 13:46:16.495445	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
811	26	113	测试22	55	text	\N	\N	\N	normal	2025-11-26 13:46:17.984549	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
812	26	113	测试22	66	text	\N	\N	\N	normal	2025-11-26 13:46:19.614847	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
813	26	113	测试22	77	text	\N	\N	\N	normal	2025-11-26 13:46:21.045952	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
814	26	113	测试22	88	text	\N	\N	\N	normal	2025-11-26 13:46:22.600989	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
815	26	113	测试22	99	text	\N	\N	\N	normal	2025-11-26 13:46:23.947025	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
816	26	114	测试23	00	text	\N	\N	\N	normal	2025-11-26 13:46:36.377028	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
817	26	114	测试23	11	text	\N	\N	\N	normal	2025-11-26 13:46:38.519683	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
818	26	114	测试23	22	text	\N	\N	\N	normal	2025-11-26 13:46:40.815048	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
819	26	114	测试23	33	text	\N	\N	\N	normal	2025-11-26 13:46:42.714386	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
820	26	114	测试23	44	text	\N	\N	\N	normal	2025-11-26 13:46:44.782637	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
821	26	114	测试23	55	text	\N	\N	\N	normal	2025-11-26 13:46:47.209412	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
822	26	114	测试23	66	text	\N	\N	\N	normal	2025-11-26 13:46:49.417748	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
823	26	114	测试23	77	text	\N	\N	\N	normal	2025-11-26 13:46:51.237514	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
824	26	114	测试23	88	text	\N	\N	\N	normal	2025-11-26 13:46:53.043184	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
825	26	114	测试23	99	text	\N	\N	\N	normal	2025-11-26 13:46:54.984957	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
826	26	114	测试23	00	text	\N	\N	\N	normal	2025-11-26 13:46:56.822441	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
827	26	114	测试23	11	text	\N	\N	\N	normal	2025-11-26 13:46:58.572483	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
828	26	114	测试23	22	text	\N	\N	\N	normal	2025-11-26 13:47:00.241181	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
829	26	114	测试23	44	text	\N	\N	\N	normal	2025-11-26 13:47:02.360447	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
830	26	114	测试23	55	text	\N	\N	\N	normal	2025-11-26 13:47:04.430001	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
831	26	114	测试23	66	text	\N	\N	\N	normal	2025-11-26 13:47:06.172422	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
832	26	114	测试23	77	text	\N	\N	\N	normal	2025-11-26 13:47:08.487261	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
833	26	114	测试23	77	text	\N	\N	\N	normal	2025-11-26 13:47:10.202599	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
834	26	114	测试23	88	text	\N	\N	\N	normal	2025-11-26 13:47:11.739179	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
835	26	114	测试23	88	text	\N	\N	\N	normal	2025-11-26 13:47:13.586649	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
836	26	114	测试23	88	text	\N	\N	\N	normal	2025-11-26 13:47:16.536907	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
837	26	113	测试22	aa	text	\N	\N	\N	normal	2025-11-26 14:18:59.384982	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
838	26	114	测试23	bbb	text	\N	\N	\N	normal	2025-11-26 14:19:05.433868	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
839	26	114	测试23	ddd	text	\N	\N	\N	normal	2025-11-26 14:19:07.179958	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
840	26	113	测试22	aa	text	\N	\N	\N	normal	2025-11-26 14:30:26.381301	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
841	26	113	测试22	bb	text	\N	\N	\N	normal	2025-11-26 14:30:27.745005	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
842	26	114	测试23	esd	text	\N	\N	\N	normal	2025-11-26 14:30:36.110574	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
843	26	114	测试23	bvc	text	\N	\N	\N	normal	2025-11-26 14:30:38.692654	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
844	26	113	测试22	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764139616_ic_launcher.png	image	\N	\N	\N	normal	2025-11-26 14:46:59.265643	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
845	26	113	测试22	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764139634_2637-161442811_tiny.mp4	video	\N	\N	\N	normal	2025-11-26 14:47:19.882021	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
846	26	113	测试22	11	text	\N	\N	\N	normal	2025-11-26 14:47:20.040599	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
847	26	114	测试23	222	text	\N	\N	\N	normal	2025-11-26 15:25:05.389823	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
848	26	113	测试22	33	text	\N	\N	\N	normal	2025-11-26 15:25:13.061205	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
849	26	113	测试22	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141920_ic_launcher.png	image	\N	\N	\N	normal	2025-11-26 15:25:22.777081	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
850	26	113	测试22	333	text	\N	\N	\N	normal	2025-11-26 15:51:03.93179	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
851	26	113	测试22	111	text	\N	\N	\N	normal	2025-11-26 16:07:51.536408	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
852	26	113	测试22	22	text	\N	\N	\N	normal	2025-11-26 16:07:58.636518	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
853	26	113	测试22	44	text	\N	\N	\N	normal	2025-11-26 16:08:09.152316	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
854	26	113	测试22	77	text	\N	\N	\N	normal	2025-11-26 16:08:11.39757	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
855	26	114	测试23	yff	text	\N	\N	\N	normal	2025-11-26 16:08:20.422945	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
856	26	114	测试23	hgc	text	\N	\N	\N	normal	2025-11-26 16:08:22.721963	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N		\N	\N	\N	\N	\N	\N
857	26	113	测试22	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764144515_ic_launcher.png	image	\N	\N	\N	normal	2025-11-26 16:08:37.967704	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
858	27	116	秋风1	群组已创建	system	\N	\N	\N	normal	2025-11-26 14:35:07.299943		\N	\N		\N	\N	\N	\N	\N	\N
859	27	118	有度	1	text	\N	\N	\N	normal	2025-11-26 14:38:15.67109		\N	\N		\N	\N	\N	\N	\N	\N
860	27	117	秋风2	1	text	\N	\N	\N	normal	2025-11-26 14:38:30.618102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N		\N	\N	\N	\N	\N	\N
861	27	117	秋风2	电脑端能显示	text	\N	\N	\N	normal	2025-11-26 14:38:35.132912	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N		\N	\N	\N	\N	\N	\N
862	27	116	秋风1	全体禁言已开启	system	\N	\N	\N	normal	2025-11-26 14:39:05.790278	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
863	27	116	秋风1	全体禁言已关闭	system	\N	\N	\N	normal	2025-11-26 14:39:17.661675	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
864	28	116	秋风1	群组已创建	system	\N	\N	\N	normal	2025-11-26 14:40:48.517465	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
865	29	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-26 15:45:50.365861	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
866	30	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 15:47:10.462635	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
867	31	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 15:55:05.697223	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
868	31	113	测试22	111	text	\N	\N	\N	normal	2025-11-26 15:55:29.940212	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
869	31	113	测试22	111	text	\N	\N	\N	normal	2025-11-26 15:55:32.46985	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
870	32	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 16:15:10.784788	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
871	33	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 16:16:54.942326	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
872	34	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 16:28:30.265867	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
873	35	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 16:29:29.988402	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
874	33	103	测试2	33	text	\N	\N	\N	normal	2025-11-26 16:33:19.105441	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
875	36	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 16:35:00.786218	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
876	37	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-26 17:37:26.923456	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
877	38	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-26 17:41:15.994203	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
878	39	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-26 17:42:01.615757	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
879	40	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-26 17:54:30.51187	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
880	41	103	测试2	群组已创建	system	\N	\N	\N	normal	2025-11-26 17:55:11.633165	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	\N	\N	\N
881	42	102	测试01	群组已创建	system	\N	\N	\N	normal	2025-11-26 18:53:50.904869		\N	\N		\N	\N	\N	\N	\N	\N
882	27	116	秋风1	1	text	\N	\N	\N	normal	2025-11-27 15:47:44.04395	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
883	43	116	秋风1	群组已创建	system	\N	\N	\N	normal	2025-11-27 16:53:21.98154	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
884	43	116	秋风1	1	text	\N	\N	\N	normal	2025-11-27 16:53:29.940969	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	\N	\N	\N
885	44	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-28 11:01:02.570963	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
886	44	113	测试22	111	text	\N	\N	\N	normal	2025-11-28 11:01:15.401841	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
887	44	113	测试22	222	text	\N	\N	\N	normal	2025-11-28 11:01:27.137113	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
888	44	113	测试22	33	text	\N	\N	\N	normal	2025-11-28 11:01:33.772669	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
889	45	113	测试22	群组已创建	system	\N	\N	\N	normal	2025-11-28 11:02:01.086443	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
890	45	113	测试22	111	text	\N	\N	\N	normal	2025-11-28 11:02:12.957837	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
891	45	113	测试22	222	text	\N	\N	\N	normal	2025-11-28 11:02:23.088271	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
892	45	113	测试22	111	text	\N	\N	\N	normal	2025-11-28 11:03:02.096574	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
893	44	113	测试22	7777	text	\N	\N	\N	normal	2025-11-28 11:08:34.05655	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N		\N	\N	\N	\N	\N	\N
894	46	143	aa123456	创建新群组"1"	system	\N	\N	\N	normal	2025-11-29 06:25:05.185245	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
895	46	143	aa123456	您已被邀请加入群组"1"	system	\N	\N	\N	normal	2025-11-29 06:25:05.187384	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
896	46	143	aa123456	1	text	\N	\N	\N	normal	2025-11-29 06:27:19.775849	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
897	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	烦烦烦	text	\N	\N	\N	normal	2025-11-29 06:27:32.956041	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
898	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	😇	text	\N	\N	\N	normal	2025-11-29 06:29:54.492432	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
899	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764397804_JPEG_20251129_143003_1049007828959111884.jpg	image	\N	\N	\N	normal	2025-11-29 06:30:05.438652	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
900	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方 发起了语音通话	call_initiated	\N	\N	\N	normal	2025-11-29 06:30:35.592768	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
901	46	143	aa123456	aa123456 发起了语音通话	call_initiated	\N	\N	\N	normal	2025-11-29 06:32:50.55231	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
902	46	143	aa123456	全体禁言已开启	system	\N	\N	\N	normal	2025-11-29 06:42:48.83141	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
903	46	143	aa123456	d	text	\N	\N	\N	normal	2025-11-29 06:42:55.291309	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
904	46	143	aa123456	全体禁言已关闭	system	\N	\N	\N	normal	2025-11-29 06:43:12.545696	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
905	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已开启	system	\N	\N	\N	normal	2025-11-29 06:45:40.642908	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
906	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已关闭	system	\N	\N	\N	normal	2025-11-29 06:50:15.037742	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
907	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-11-29 06:54:02.481873	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
908	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-11-29 07:12:11.963947	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
909	46	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	就是	text	\N	\N	\N	normal	2025-11-29 07:12:30.039367	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
910	47	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	创建新群组"测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2"	system	\N	\N	\N	normal	2025-11-30 15:27:59.076031	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
911	47	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	您已被邀请加入群组"测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2"	system	\N	\N	\N	normal	2025-11-30 15:27:59.078171	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
942	48	128	test902	您已被邀请加入群组"群组09901"	system	\N	\N	\N	normal	2025-12-02 20:57:21.971956	\N	\N	\N		\N	\N	\N	\N	\N	\N
912	47	142	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	大家好	text	\N	\N	\N	normal	2025-11-30 15:28:18.249133	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
913	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	在的	text	\N	\N	\N	normal	2025-11-30 15:28:25.879141	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
914	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	不知道	text	\N	\N	\N	normal	2025-11-30 15:29:46.497825	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
915	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	h	text	\N	\N	\N	normal	2025-11-30 15:43:51.798828	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
916	46	144	cesfffff	1	text	\N	\N	\N	normal	2025-11-30 15:50:55.040144		\N	\N		\N	\N	\N	\N	\N	\N
917	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	在的	text	\N	\N	\N	normal	2025-11-30 15:52:07.611045	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
918	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	再没	text	\N	\N	\N	normal	2025-12-01 10:40:09.236838	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
919	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-12-01 10:40:44.831621	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
920	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	2	text	\N	\N	\N	normal	2025-12-01 10:41:26.35391	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
921	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	3	text	\N	\N	\N	normal	2025-12-01 10:41:53.668455	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
922	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1	text	\N	\N	\N	normal	2025-12-01 10:52:45.259865	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
923	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1	text	\N	\N	\N	normal	2025-12-01 10:55:01.233326	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
924	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	2	text	\N	\N	\N	normal	2025-12-01 10:55:30.584623	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
925	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	6	text	\N	\N	\N	normal	2025-12-01 10:58:03.969897	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
926	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	3	text	\N	\N	\N	normal	2025-12-01 11:00:45.745809	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
927	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	6	text	\N	\N	\N	normal	2025-12-01 11:01:42.400563	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
928	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	您已被移除群组	system	\N	\N	\N	normal	2025-12-01 11:12:05.125838	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
929	46	144	cesfffff	1	text	\N	\N	\N	normal	2025-12-01 11:22:38.167957	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	\N	\N	\N
930	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	3	text	\N	\N	\N	normal	2025-12-01 22:21:10.283635	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
931	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	4	text	\N	\N	\N	normal	2025-12-01 22:21:23.761253	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
932	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-12-01 22:23:17.317368	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
933	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	4	text	\N	\N	\N	normal	2025-12-01 22:23:48.10232	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
934	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-12-01 22:23:51.277583	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
935	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	3	text	\N	\N	\N	normal	2025-12-01 22:23:56.437812	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
936	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1	text	\N	\N	\N	normal	2025-12-01 22:31:26.655249	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
937	47	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	您已被移除群组	system	\N	\N	\N	normal	2025-12-01 22:32:22.096161	\N	\N	\N		\N	\N	\N	\N	\N	\N
939	47	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	0	text	\N	\N	\N	normal	2025-12-01 22:35:26.41766	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
940	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	您已被移除群组	system	\N	\N	\N	normal	2025-12-02 20:29:53.199263	\N	\N	\N		\N	\N	\N	\N	\N	\N
941	48	128	test902	创建新群组"群组09901"	system	\N	\N	\N	normal	2025-12-02 20:57:21.969946	\N	\N	\N		\N	\N	\N	\N	\N	\N
944	48	128	测试902	bbb	text	\N	\N	\N	normal	2025-12-02 20:57:36.210966		\N	\N		\N	\N	\N	\N	\N	\N
1114	52	149	苏	通话时长 01:07	call_ended	\N	\N	\N	normal	2025-12-06 14:22:06.366994	\N	\N	\N		voice	group_call_147_1765002059	\N	\N	\N	\N
945	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764681527_JPEG_20251202_211848_523723774826566576.jpg	image	\N	\N	\N	normal	2025-12-02 21:26:52.117896	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
946	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已开启	system	\N	\N	\N	normal	2025-12-02 21:29:32.818965	\N	\N	\N		\N	\N	\N	\N	\N	\N
947	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-12-02 21:29:38.380572	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
949	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	通话时长 00:15	call_ended	\N	\N	\N	normal	2025-12-02 21:30:06.92985	\N	\N	\N		voice	group_call_143_1764682191	\N	\N	\N	\N
950	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	通话时长 00:23	call_ended	\N	\N	\N	normal	2025-12-02 21:30:14.741099	\N	\N	\N		voice	group_call_143_1764682191	\N	\N	\N	\N
951	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已关闭	system	\N	\N	\N	normal	2025-12-02 21:31:00.234899	\N	\N	\N		\N	\N	\N	\N	\N	\N
952	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	你已被1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的解除禁言	system	\N	\N	\N	normal	2025-12-02 21:31:13.494913	\N	\N	\N		\N	\N	\N	\N	\N	\N
953	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	99	text	\N	\N	\N	normal	2025-12-02 21:31:20.029558	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
954	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	你已被1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的禁言	system	\N	\N	\N	normal	2025-12-02 21:31:24.897844	\N	\N	\N		\N	\N	\N	\N	\N	\N
955	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	你已被1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的解除禁言	system	\N	\N	\N	normal	2025-12-02 21:31:33.015069	\N	\N	\N		\N	\N	\N	\N	\N	\N
956	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已开启	system	\N	\N	\N	normal	2025-12-02 21:31:35.241613	\N	\N	\N		\N	\N	\N	\N	\N	\N
957	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	全体禁言已关闭	system	\N	\N	\N	normal	2025-12-02 21:32:36.872535	\N	\N	\N		\N	\N	\N	\N	\N	\N
958	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	全体禁言已开启	system	\N	\N	\N	normal	2025-12-02 21:33:43.656282	\N	\N	\N		\N	\N	\N	\N	\N	\N
959	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	全体禁言已关闭	system	\N	\N	\N	normal	2025-12-02 21:37:32.506836	\N	\N	\N		\N	\N	\N	\N	\N	\N
960	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	66号	text	\N	\N	\N	normal	2025-12-02 21:38:17.718748	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	\N	\N	\N
961	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	1	text	\N	\N	\N	normal	2025-12-02 21:38:40.121022	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
962	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	22	text	\N	\N	\N	normal	2025-12-02 21:41:04.285276	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	\N	\N	\N	\N
964	46	142	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	通话时长 00:59	call_ended	\N	\N	\N	normal	2025-12-02 21:51:50.332658	\N	\N	\N		voice	group_call_143_1764683451	\N	\N	\N	\N
966	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	通话时长 00:12	call_ended_video	\N	\N	\N	normal	2025-12-02 21:53:15.618878	\N	\N	\N		video	group_call_143_1764683583	\N	\N	\N	\N
967	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳发起了视频通话	join_video_button	\N	\N	\N	normal	2025-12-02 21:53:47.898607	\N	\N	\N		video	group_call_143_1764683627	\N	\N	\N	\N
968	46	143	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	通话时长 00:40	call_ended_video	\N	\N	\N	normal	2025-12-02 21:54:28.475258	\N	\N	\N		video	group_call_143_1764683628	\N	\N	\N	\N
969	49	126	test900	创建新群组"90901"	system	\N	\N	\N	normal	2025-12-03 21:11:58.657345	\N	\N	\N		\N	\N	\N	\N	\N	\N
970	49	126	test900	您已被邀请加入群组"90901"	system	\N	\N	\N	normal	2025-12-03 21:11:58.659333	\N	\N	\N		\N	\N	\N	\N	\N	\N
971	49	127	测试901	11	text	\N	\N	\N	normal	2025-12-03 21:12:04.198711	\N	\N	\N		\N	\N	\N	测试901	\N	\N
972	49	126	123	22	text	\N	\N	\N	normal	2025-12-03 21:12:06.671502	\N	\N	\N		\N	\N	\N	123	\N	\N
974	49	127	测试901	通话时长 00:11	call_ended	\N	\N	\N	normal	2025-12-03 21:12:23.23028	\N	\N	\N		voice	group_call_126_1764767532	\N	\N	\N	\N
975	50	145	qiufeng11	创建新群组"测试群"	system	\N	\N	\N	normal	2025-12-04 01:06:55.947745	\N	\N	\N		\N	\N	\N	\N	\N	\N
976	50	145	qiufeng11	您已被邀请加入群组"测试群"	system	\N	\N	\N	normal	2025-12-04 01:06:55.949849	\N	\N	\N		\N	\N	\N	\N	\N	\N
977	50	145	秋风	你好	text	\N	\N	\N	normal	2025-12-04 01:07:02.742787	\N	\N	\N		\N	\N	\N	秋风	\N	\N
978	50	145	秋风	你好	text	\N	\N	\N	normal	2025-12-04 01:09:46.956909	\N	\N	\N		\N	\N	\N	秋风	\N	\N
979	50	145	秋风	你好	text	\N	\N	\N	normal	2025-12-04 01:09:55.652683	\N	\N	\N		\N	\N	\N	秋风	\N	\N
980	50	145	秋风	1	text	\N	\N	\N	normal	2025-12-04 01:09:58.115294	\N	\N	\N		\N	\N	\N	秋风	\N	\N
981	50	145	秋风	2	text	\N	\N	\N	normal	2025-12-04 01:09:59.17735	\N	\N	\N		\N	\N	\N	秋风	\N	\N
982	50	145	秋风	5	text	\N	\N	\N	normal	2025-12-04 01:10:00.698103	\N	\N	\N		\N	\N	\N	秋风	\N	\N
983	50	145	秋风	6	text	\N	\N	\N	normal	2025-12-04 01:10:01.797052	\N	\N	\N		\N	\N	\N	秋风	\N	\N
984	50	145	秋风	60	text	\N	\N	\N	normal	2025-12-04 01:10:03.082161	\N	\N	\N		\N	\N	\N	秋风	\N	\N
985	50	145	秋风	79	text	\N	\N	\N	normal	2025-12-04 01:10:04.905119	\N	\N	\N		\N	\N	\N	秋风	\N	\N
986	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:28:16.107864	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
990	50	116	秋风1	你好	text	\N	\N	\N	normal	2025-12-04 20:30:18.677547	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
991	50	141	秋风2	1	text	\N	\N	\N	normal	2025-12-04 20:30:25.465309	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
992	50	141	秋风2	2	text	\N	\N	\N	normal	2025-12-04 20:30:32.480938	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
993	50	141	秋风2	34	text	\N	\N	\N	normal	2025-12-04 20:30:34.145232	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
994	50	141	秋风2	1	text	\N	\N	\N	normal	2025-12-04 20:31:46.262951	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
995	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:31:51.755282	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
996	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:31:57.815103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
997	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:32:05.309634	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
998	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:32:08.475509	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
999	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:32:19.160016	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1000	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:32:23.050547	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1001	50	116	秋风1	2	text	\N	\N	\N	normal	2025-12-04 20:32:25.833314	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1002	50	116	秋风1	3	text	\N	\N	\N	normal	2025-12-04 20:32:27.336554	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1003	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:32:28.618677	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1004	50	116	秋风1	4	text	\N	\N	\N	normal	2025-12-04 20:32:32.441332	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1005	50	116	秋风1	5	text	\N	\N	\N	normal	2025-12-04 20:32:33.908289	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1006	50	116	秋风1	1	text	\N	\N	\N	normal	2025-12-04 20:33:25.231394	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1007	50	116	秋风1	2	text	\N	\N	\N	normal	2025-12-04 20:33:26.745593	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1008	50	116	秋风1	3	text	\N	\N	\N	normal	2025-12-04 20:33:27.685149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1009	50	116	秋风1	4	text	\N	\N	\N	normal	2025-12-04 20:33:28.956191	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1010	50	116	秋风1	5	text	\N	\N	\N	normal	2025-12-04 20:33:30.093827	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1011	50	116	秋风1	6	text	\N	\N	\N	normal	2025-12-04 20:33:30.965665	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1012	50	116	秋风1	7	text	\N	\N	\N	normal	2025-12-04 20:33:32.557338	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1013	50	116	秋风1	秋风1发起了视频通话	join_video_button	\N	\N	\N	normal	2025-12-04 20:34:19.954485	\N	\N	\N		video	group_call_116_1764851659	\N	\N	\N	\N
1014	50	141	秋风2	1	text	\N	\N	\N	normal	2025-12-04 20:38:27.188565	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
1015	46	142	规范规定112	11	text	\N	\N	\N	normal	2025-12-05 15:46:37.84228	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N		\N	\N	规范规定112	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N
1016	46	143	弄一下嘻嘻	好的	text	\N	\N	\N	normal	2025-12-05 15:46:49.728166	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N
1017	46	142	规范规定112	规范规定112发起了语音通话	join_voice_button	\N	\N	\N	normal	2025-12-05 15:50:34.823323	\N	\N	\N		voice	group_call_142_1764921034	\N	\N	\N	\N
1018	46	142	规范规定112	规范规定112发起了语音通话	join_voice_button	\N	\N	\N	normal	2025-12-05 15:55:45.721234	\N	\N	\N		voice	group_call_142_1764921345	\N	\N	\N	\N
1019	46	142	规范规定112	规范规定112发起了语音通话	join_voice_button	\N	\N	\N	normal	2025-12-05 15:56:07.154375	\N	\N	\N		voice	group_call_142_1764921367	\N	\N	\N	\N
1021	46	142	规范规定112	通话时长 00:42	call_ended	\N	\N	\N	normal	2025-12-05 15:57:54.868438	\N	\N	\N		voice	group_call_142_1764921432	\N	\N	\N	\N
1023	46	143	弄一下嘻嘻	通话时长 00:06	call_ended	\N	\N	\N	normal	2025-12-05 16:00:02.767339	\N	\N	\N		voice	group_call_143_1764921596	\N	\N	\N	\N
1025	46	143	弄一下嘻嘻	通话时长 00:15	call_ended	\N	\N	\N	normal	2025-12-05 16:12:43.118581	\N	\N	\N		voice	group_call_143_1764922348	\N	\N	\N	\N
1026	46	143	弄一下嘻嘻	弄一下嘻嘻发起了视频通话	join_video_button	\N	\N	\N	normal	2025-12-05 16:12:55.395792	\N	\N	\N		video	group_call_143_1764922375	\N	\N	\N	\N
1028	46	142	规范规定112	通话时长 00:27	call_ended	\N	\N	\N	normal	2025-12-05 16:14:29.556441	\N	\N	\N		voice	group_call_142_1764922442	\N	\N	\N	\N
1030	46	143	弄一下嘻嘻	通话时长 00:10	call_ended_video	\N	\N	\N	normal	2025-12-05 16:15:56.237284	\N	\N	\N		video	group_call_142_1764922546	\N	\N	\N	\N
1031	46	142	规范规定112	规范规定112发起了视频通话	join_video_button	\N	\N	\N	normal	2025-12-05 16:16:05.438767	\N	\N	\N		video	group_call_142_1764922565	\N	\N	\N	\N
1033	46	143	弄一下嘻嘻	通话时长 00:02	call_ended	\N	\N	\N	normal	2025-12-05 16:16:31.005954	\N	\N	\N		voice	group_call_142_1764922589	\N	\N	\N	\N
1034	50	116	秋风1	你好	text	\N	\N	\N	normal	2025-12-05 21:18:56.044102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N		\N	\N	\N	秋风1	\N	\N
1035	50	141	秋风2	你好	text	\N	\N	\N	normal	2025-12-06 09:19:39.970831	\N	\N	\N		\N	\N	\N	秋风2	\N	\N
1036	51	151	wxs6688	创建新群组"一战成名"	system	\N	\N	\N	normal	2025-12-06 11:01:34.743776	\N	\N	\N		\N	\N	\N	\N	\N	\N
1037	51	151	wxs6688	您已被邀请加入群组"一战成名"	system	\N	\N	\N	normal	2025-12-06 11:01:34.745765	\N	\N	\N		\N	\N	\N	\N	\N	\N
1038	51	151	wxs6688	您已被邀请加入群组"一战成名"	system	\N	\N	\N	normal	2025-12-06 11:01:34.747019	\N	\N	\N		\N	\N	\N	\N	\N	\N
1039	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 11:09:54.095109	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1040	51	148	阿迪	要你通过一下	text	\N	\N	\N	normal	2025-12-06 11:10:14.455684	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1043	51	148	阿迪	这个群名字和你的名字不一样	text	\N	\N	\N	normal	2025-12-06 11:11:20.953335	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1045	51	151	王总先生	全部发信息看下	text	\N	\N	\N	normal	2025-12-06 11:13:33.337673	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1046	51	151	王先生	全体禁言已开启	system	\N	\N	\N	normal	2025-12-06 11:14:31.373004	\N	\N	\N		\N	\N	\N	\N	\N	\N
1048	51	146	王志豪	1	text	\N	\N	\N	normal	2025-12-06 11:14:58.615463	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1049	51	151	王总先生	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764990944_JPEG_20251206_111543_286319152350785940.jpg	image	\N	\N	\N	normal	2025-12-06 11:15:45.002083	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1050	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764991090_JPEG_20251206_111810_6750271967361465066.jpg	image	\N	\N	\N	normal	2025-12-06 11:18:11.860146	\N	\N	\N		\N	\N	\N	大江	\N	\N
1058	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764991406_JPEG_20251206_112327_3347329956885238896.jpg	image	\N	\N	\N	normal	2025-12-06 11:23:28.003153	\N	\N	\N		\N	\N	\N	大江	\N	\N
1059	51	150	大江	引用消息还是看不到引用谁的	text	\N	\N	\N	normal	2025-12-06 11:23:46.406569	\N	\N	\N		\N	\N	\N	大江	\N	\N
1061	51	146	王志豪	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764991458_paste_1764991457167.png	image	\N	\N	\N	normal	2025-12-06 11:24:19.299545	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1063	51	150	大江	自己引用能看到，别人看不到	quoted	\N	1061	[图片]	normal	2025-12-06 11:25:15.313516	\N	\N	\N		\N	\N	\N	大江	\N	\N
1064	51	147	风生水起	进来了	text	\N	\N	\N	normal	2025-12-06 11:25:34.313823	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1066	51	149	苏	这个引用消息只有点头像才可以引用	text	\N	\N	\N	normal	2025-12-06 11:26:16.653833	\N	\N	\N		\N	\N	\N	苏	\N	\N
1067	51	149	苏	点信息引用不了	text	\N	\N	\N	normal	2025-12-06 11:26:23.226586	\N	\N	\N		\N	\N	\N	苏	\N	\N
1041	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 11:10:35.224723	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1042	51	148	阿迪	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764990668_paste_1764990666273.png	image	\N	\N	\N	normal	2025-12-06 11:11:09.021352	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1047	51	151	王先生	全体禁言已关闭	system	\N	\N	\N	normal	2025-12-06 11:14:53.831306	\N	\N	\N		\N	\N	\N	\N	\N	\N
1051	51	150	大江	哈喽	text	\N	\N	\N	normal	2025-12-06 11:18:29.30214	\N	\N	\N		\N	\N	\N	大江	\N	\N
1052	51	149	苏	哈喽	text	\N	\N	\N	normal	2025-12-06 11:18:47.21444	\N	\N	\N		\N	\N	\N	苏	\N	\N
1053	51	149	苏	我都没有通过好友，你怎么能给我发信息	text	\N	\N	\N	normal	2025-12-06 11:19:06.186089	\N	\N	\N		\N	\N	\N	苏	\N	\N
1054	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764991159_JPEG_20251206_111918_8335466360724866366.jpg	image	\N	\N	\N	normal	2025-12-06 11:19:21.204818	\N	\N	\N		\N	\N	\N	大江	\N	\N
1055	51	150	大江	这里群成员应该显示网名，不要显示ID	text	\N	\N	\N	normal	2025-12-06 11:19:44.715071	\N	\N	\N		\N	\N	\N	大江	\N	\N
1056	51	146	王志豪	发到群里去	text	\N	\N	\N	normal	2025-12-06 11:20:36.630735	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1057	51	146	王志豪	在看下能不能看到？	quoted	\N	1055	这里群成员应该显示网名，不要显示ID	normal	2025-12-06 11:21:23.967699	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1068	51	147	风生水起	你猜	quoted	\N	1066	这个引用消息只有点头像才可以引用	normal	2025-12-06 11:26:49.466627	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1069	51	147	风生水起	考虑下	quoted	\N	1067	点信息引用不了	normal	2025-12-06 11:27:00.533101	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1070	51	151	王总先生	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764991725_VID_20251206_112833_162.mp4	video	\N	\N	\N	normal	2025-12-06 11:28:46.969985	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1071	51	151	王总先生	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764991858_VID_20251206_113034_093.mp4	video	\N	\N	\N	normal	2025-12-06 11:30:59.989246	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1072	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764991871_JPEG_20251206_113111_8313587867143454363.jpg	image	\N	\N	\N	normal	2025-12-06 11:31:12.382832	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1073	51	149	苏	任务没有达标	text	\N	\N	\N	normal	2025-12-06 11:33:46.771974	\N	\N	\N		\N	\N	\N	苏	\N	\N
1074	51	148	阿迪	可以可以	quoted	\N	1071	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764991858_VID_20251206_113034_093.mp4	normal	2025-12-06 11:33:47.102887	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1075	51	148	阿迪	1	quoted	\N	1073	任务没有达标	normal	2025-12-06 11:34:11.553535	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1076	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764992059_VID_20251116_120424_679.mp4	video	\N	\N	\N	normal	2025-12-06 11:34:30.413071	\N	\N	\N		\N	\N	\N	苏	\N	\N
1077	51	150	大江	阿珂	text	\N	\N	\N	normal	2025-12-06 14:09:21.855031	\N	\N	\N		\N	\N	\N	大江	\N	\N
1078	51	147	风生水起	盖亚	text	\N	\N	\N	normal	2025-12-06 14:10:20.140151	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1079	52	149	sfq80810	创建新群组"😀"	system	\N	\N	\N	normal	2025-12-06 14:15:58.959259	\N	\N	\N		\N	\N	\N	\N	\N	\N
1080	52	149	sfq80810	您已被邀请加入群组"😀"	system	\N	\N	\N	normal	2025-12-06 14:15:58.96054	\N	\N	\N		\N	\N	\N	\N	\N	\N
1081	52	149	sfq80810	您已被邀请加入群组"😀"	system	\N	\N	\N	normal	2025-12-06 14:15:58.961582	\N	\N	\N		\N	\N	\N	\N	\N	\N
1082	52	150	大江	哈喽	text	\N	\N	\N	normal	2025-12-06 14:16:09.81835	\N	\N	\N		\N	\N	\N	大江	\N	\N
1083	52	149	苏	晚上安排	text	\N	\N	\N	normal	2025-12-06 14:16:11.88318	\N	\N	\N		\N	\N	\N	苏	\N	\N
1084	52	150	大江	晚上安排妹妹	text	\N	\N	\N	normal	2025-12-06 14:16:39.879392	\N	\N	\N		\N	\N	\N	大江	\N	\N
1085	52	147	风生水起	哪里来的妹妹	text	\N	\N	\N	normal	2025-12-06 14:16:47.777246	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1086	52	150	大江	不知道	text	\N	\N	\N	normal	2025-12-06 14:16:55.221893	\N	\N	\N		\N	\N	\N	大江	\N	\N
1087	52	150	大江	我想妹妹	text	\N	\N	\N	normal	2025-12-06 14:17:01.368987	\N	\N	\N		\N	\N	\N	大江	\N	\N
1088	52	150	大江	不想打飞机	text	\N	\N	\N	normal	2025-12-06 14:17:06.655977	\N	\N	\N		\N	\N	\N	大江	\N	\N
1089	52	147	风生水起	全体禁言已开启	system	\N	\N	\N	normal	2025-12-06 14:17:13.118425	\N	\N	\N		\N	\N	\N	\N	\N	\N
1090	52	147	风生水起	全体禁言已关闭	system	\N	\N	\N	normal	2025-12-06 14:17:23.349521	\N	\N	\N		\N	\N	\N	\N	\N	\N
1091	52	147	风生水起	哈喽	text	\N	\N	\N	normal	2025-12-06 14:17:57.10922	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1092	52	150	大江	1522	text	\N	\N	\N	normal	2025-12-06 14:18:20.604246	\N	\N	\N		\N	\N	\N	大江	\N	\N
1093	52	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:18:21.261997	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1094	52	147	风生水起	您已被移除群组	system	\N	\N	\N	normal	2025-12-06 14:18:24.79837	\N	\N	\N		\N	\N	\N	\N	\N	\N
1095	52	147	风生水起	打飞机	text	\N	\N	\N	normal	2025-12-06 14:18:45.864506	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1096	52	150	大江	夹生飞机	text	\N	\N	\N	normal	2025-12-06 14:18:57.445962	\N	\N	\N		\N	\N	\N	大江	\N	\N
1097	52	150	大江	难搞	text	\N	\N	\N	normal	2025-12-06 14:19:00.161979	\N	\N	\N		\N	\N	\N	大江	\N	\N
1098	52	149	苏	打飞机也像做饭一样，还有夹生的吗？	text	\N	\N	\N	normal	2025-12-06 14:19:10.247591	\N	\N	\N		\N	\N	\N	苏	\N	\N
1099	52	147	风生水起	难搞	text	\N	\N	\N	normal	2025-12-06 14:19:16.269544	\N	\N	\N		\N	\N	\N	风生水起	\N	\N
1100	52	149	苏	没熟透吗？那熟透的打飞机是什么样子的？	text	\N	\N	\N	normal	2025-12-06 14:19:18.832223	\N	\N	\N		\N	\N	\N	苏	\N	\N
1101	52	150	大江	你不懂了吧	text	\N	\N	\N	normal	2025-12-06 14:19:19.144736	\N	\N	\N		\N	\N	\N	大江	\N	\N
1103	52	150	大江	夹生飞机就是打不出来	text	\N	\N	\N	normal	2025-12-06 14:19:47.341211	\N	\N	\N		\N	\N	\N	大江	\N	\N
1104	52	150	大江	懂不懂	text	\N	\N	\N	normal	2025-12-06 14:19:49.064834	\N	\N	\N		\N	\N	\N	大江	\N	\N
1105	52	147	风生水起	您已被移除群组	system	\N	\N	\N	normal	2025-12-06 14:20:05.707074	\N	\N	\N		\N	\N	\N	\N	\N	\N
1107	52	149	苏	迪迪	text	\N	\N	\N	normal	2025-12-06 14:20:26.586995	\N	\N	\N		\N	\N	\N	苏	\N	\N
1108	52	150	大江	🍎	text	\N	\N	\N	normal	2025-12-06 14:20:29.026479	\N	\N	\N		\N	\N	\N	大江	\N	\N
1109	52	150	大江	⌚	text	\N	\N	\N	normal	2025-12-06 14:20:33.680231	\N	\N	\N		\N	\N	\N	大江	\N	\N
1110	52	150	大江	🕹	text	\N	\N	\N	normal	2025-12-06 14:20:45.709694	\N	\N	\N		\N	\N	\N	大江	\N	\N
1111	52	150	大江	缅甸🇲🇲	text	\N	\N	\N	normal	2025-12-06 14:20:50.591995	\N	\N	\N		\N	\N	\N	大江	\N	\N
1112	52	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765002051_JPEG_20251206_142054_8388966570381865649.jpg	image	\N	\N	\N	normal	2025-12-06 14:20:53.104584	\N	\N	\N		\N	\N	\N	苏	\N	\N
1115	52	147	风生水起	哈喽	text	\N	\N	\N	normal	2025-12-06 14:26:02.848909	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1116	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:34:44.510458	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1117	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:34:49.565343	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1118	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:35:09.914801	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1119	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:35:17.546693	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1120	51	149	苏	私聊时间就是对的	text	\N	\N	\N	normal	2025-12-06 14:35:19.208209	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1135	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:36:34.18377	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1121	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:35:20.909511	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1122	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:35:23.645884	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1123	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:35:27.303733	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1124	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:35:28.441093	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1125	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:35:30.201506	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1126	51	151	王总先生	好的	text	\N	\N	\N	normal	2025-12-06 14:35:31.823715	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1127	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:35:32.790933	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1128	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:35:34.318086	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1129	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:35:36.956879	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1130	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:35:39.11241	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1131	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:36:00.733473	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1132	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-06 14:36:15.038828	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1133	51	151	王总先生	3	text	\N	\N	\N	normal	2025-12-06 14:36:16.789129	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1134	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:36:18.378167	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1143	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:15.414259	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1144	51	151	王总先生	你们发1的时候能正常吗	text	\N	\N	\N	normal	2025-12-06 14:38:24.093419	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1145	51	149	苏	正常	text	\N	\N	\N	normal	2025-12-06 14:38:29.953937	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1146	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:38:30.223825	\N	\N	\N		\N	\N	\N	大江	\N	\N
1147	51	149	苏	我发1正常	text	\N	\N	\N	normal	2025-12-06 14:38:34.917813	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1148	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:35.95738	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1149	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:38:37.34628	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1150	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:37.553788	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1157	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:44.009183	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1158	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:38:45.769772	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1159	51	149	苏	2	text	\N	\N	\N	normal	2025-12-06 14:38:47.178055	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1160	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:38:48.058126	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1161	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:38:48.392255	\N	\N	\N		\N	\N	\N	大江	\N	\N
1162	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:49.330035	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1163	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:50.015683	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1164	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:38:50.563526	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1165	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:50.624584	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1166	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:51.20443	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1136	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:36:34.611553	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1137	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:36:35.327787	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1138	51	149	苏	😇	text	\N	\N	\N	normal	2025-12-06 14:36:41.297227	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1139	51	149	苏	🤣	text	\N	\N	\N	normal	2025-12-06 14:36:44.335014	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1140	51	149	苏	😆	text	\N	\N	\N	normal	2025-12-06 14:36:45.460505	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1141	51	149	苏	😀	text	\N	\N	\N	normal	2025-12-06 14:36:46.504166	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1142	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:37:45.586869	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1151	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:39.325742	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1152	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:40.111847	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1153	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:40.686427	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1154	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:41.7144	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1155	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:42.516793	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1156	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:42.863085	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1167	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:51.771518	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1168	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:38:52.288512	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1169	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:38:53.106263	\N	\N	\N		\N	\N	\N	大江	\N	\N
1170	51	150	大江	2	text	\N	\N	\N	normal	2025-12-06 14:38:55.46548	\N	\N	\N		\N	\N	\N	大江	\N	\N
1171	51	149	苏	不正常了	text	\N	\N	\N	normal	2025-12-06 14:38:55.932343	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1172	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:38:59.855407	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1173	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:39:04.75984	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1174	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:05.063453	\N	\N	\N		\N	\N	\N	大江	\N	\N
1175	51	150	大江	3	text	\N	\N	\N	normal	2025-12-06 14:39:08.102199	\N	\N	\N		\N	\N	\N	大江	\N	\N
1176	51	150	大江	4	text	\N	\N	\N	normal	2025-12-06 14:39:10.58843	\N	\N	\N		\N	\N	\N	大江	\N	\N
1177	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:39:12.216406	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1178	51	150	大江	5	text	\N	\N	\N	normal	2025-12-06 14:39:13.39822	\N	\N	\N		\N	\N	\N	大江	\N	\N
1179	51	149	苏	2	text	\N	\N	\N	normal	2025-12-06 14:39:13.913745	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1180	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:15.647197	\N	\N	\N		\N	\N	\N	大江	\N	\N
1181	51	149	苏	2	text	\N	\N	\N	normal	2025-12-06 14:39:16.19998	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1182	51	149	苏	3	text	\N	\N	\N	normal	2025-12-06 14:39:18.200269	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1183	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:18.594576	\N	\N	\N		\N	\N	\N	大江	\N	\N
1184	51	149	苏	3	text	\N	\N	\N	normal	2025-12-06 14:39:20.605993	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1185	51	150	大江	6	text	\N	\N	\N	normal	2025-12-06 14:39:21.661257	\N	\N	\N		\N	\N	\N	大江	\N	\N
1186	51	149	苏	4	text	\N	\N	\N	normal	2025-12-06 14:39:22.611597	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1187	51	150	大江	7	text	\N	\N	\N	normal	2025-12-06 14:39:24.797336	\N	\N	\N		\N	\N	\N	大江	\N	\N
1188	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:39:24.851995	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1189	51	149	苏	4	text	\N	\N	\N	normal	2025-12-06 14:39:25.233921	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1190	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:39:26.942002	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1191	51	150	大江	8	text	\N	\N	\N	normal	2025-12-06 14:39:27.826354	\N	\N	\N		\N	\N	\N	大江	\N	\N
1192	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:39:28.937583	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1193	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:39:29.03108	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1194	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:39:29.949383	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1195	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:39:30.900276	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1196	51	147	风生水起	4	text	\N	\N	\N	normal	2025-12-06 14:39:31.577402	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1197	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:39:31.857681	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1198	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:39:32.710363	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1199	51	147	风生水起	5	text	\N	\N	\N	normal	2025-12-06 14:39:32.958747	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1200	51	150	大江	9	text	\N	\N	\N	normal	2025-12-06 14:39:33.393003	\N	\N	\N		\N	\N	\N	大江	\N	\N
1201	51	147	风生水起	6	text	\N	\N	\N	normal	2025-12-06 14:39:35.067565	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1202	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:36.486759	\N	\N	\N		\N	\N	\N	大江	\N	\N
1203	51	147	风生水起	7	text	\N	\N	\N	normal	2025-12-06 14:39:36.489289	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1204	51	147	风生水起	8	text	\N	\N	\N	normal	2025-12-06 14:39:37.870737	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1205	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:39.440092	\N	\N	\N		\N	\N	\N	大江	\N	\N
1206	51	147	风生水起	9	text	\N	\N	\N	normal	2025-12-06 14:39:40.238352	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1207	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:39:42.357427	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1208	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:39:43.931775	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1209	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:39:45.646347	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1210	51	147	风生水起	4	text	\N	\N	\N	normal	2025-12-06 14:39:47.519972	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1211	51	147	风生水起	5	text	\N	\N	\N	normal	2025-12-06 14:39:49.485481	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1212	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:50.000316	\N	\N	\N		\N	\N	\N	大江	\N	\N
1213	51	147	风生水起	6	text	\N	\N	\N	normal	2025-12-06 14:39:51.459613	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1214	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:39:57.776496	\N	\N	\N		\N	\N	\N	大江	\N	\N
1215	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:40:31.586197	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1216	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:40:42.977887	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1217	51	149	苏	2	text	\N	\N	\N	normal	2025-12-06 14:40:45.769154	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1218	51	149	苏	5	text	\N	\N	\N	normal	2025-12-06 14:40:50.732148	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1219	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-06 14:40:50.910291	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1492	49	127	测试901	777	text	\N	\N	\N	normal	2025-12-18 17:26:12.487656	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1220	51	149	苏	5	text	\N	\N	\N	normal	2025-12-06 14:40:51.234107	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1221	51	149	苏	6	text	\N	\N	\N	normal	2025-12-06 14:40:53.521869	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1222	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-06 14:40:54.998146	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1223	51	149	苏	6	text	\N	\N	\N	normal	2025-12-06 14:40:55.667305	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1224	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-06 14:41:02.595572	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1225	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:41:06.786563	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1226	51	151	王总先生	3	text	\N	\N	\N	normal	2025-12-06 14:41:11.01438	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1232	51	151	王总先生	12	text	\N	\N	\N	normal	2025-12-06 14:41:34.509321	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1233	51	151	王总先生	13	text	\N	\N	\N	normal	2025-12-06 14:41:36.078597	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1234	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:41:37.144022	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1236	51	148	阿迪	12	text	\N	\N	\N	normal	2025-12-06 14:41:38.899423	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1237	51	151	王总先生	5	text	\N	\N	\N	normal	2025-12-06 14:41:39.91765	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1238	51	148	阿迪	11	text	\N	\N	\N	normal	2025-12-06 14:41:40.789827	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1239	51	151	王总先生	3	text	\N	\N	\N	normal	2025-12-06 14:41:41.25891	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1240	51	148	阿迪	15	text	\N	\N	\N	normal	2025-12-06 14:41:42.518199	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1241	51	151	王总先生	5	text	\N	\N	\N	normal	2025-12-06 14:41:43.714681	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1242	51	148	阿迪	138858	text	\N	\N	\N	normal	2025-12-06 14:41:45.143541	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1243	51	151	王总先生	5	text	\N	\N	\N	normal	2025-12-06 14:41:46.477314	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1246	51	151	王总先生	过来一起测	text	\N	\N	\N	normal	2025-12-06 14:42:22.318955	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1247	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:43:53.232403	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1248	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:44:29.122195	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1249	51	150	大江	具体	text	\N	\N	\N	normal	2025-12-06 14:44:29.467354	\N	\N	\N		\N	\N	\N	大江	\N	\N
1250	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:44:30.86606	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1251	51	150	大江	想我了	text	\N	\N	\N	normal	2025-12-06 14:44:31.876926	\N	\N	\N		\N	\N	\N	大江	\N	\N
1252	51	150	大江	哦哦哦	text	\N	\N	\N	normal	2025-12-06 14:44:34.115781	\N	\N	\N		\N	\N	\N	大江	\N	\N
1253	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:44:34.472624	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1254	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:45:27.346943	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1255	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:45:32.385809	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1256	51	149	苏	1	text	\N	\N	\N	normal	2025-12-06 14:45:43.679135	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1227	51	151	王总先生	你好	text	\N	\N	\N	normal	2025-12-06 14:41:17.470307	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1228	51	148	阿迪	你好	text	\N	\N	\N	normal	2025-12-06 14:41:23.562873	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1229	51	148	阿迪	你好	text	\N	\N	\N	normal	2025-12-06 14:41:24.873077	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1230	51	148	阿迪	你好	text	\N	\N	\N	normal	2025-12-06 14:41:28.21119	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1231	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:41:32.488648	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1235	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-06 14:41:37.405694	\N	\N	\N		\N	\N	王总先生	王先生	\N	\N
1244	51	148	阿迪	9	text	\N	\N	\N	normal	2025-12-06 14:41:49.131365	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1245	51	148	阿迪	0	text	\N	\N	\N	normal	2025-12-06 14:41:50.188706	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1257	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:46:17.199121	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1258	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:47:26.214425	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1259	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:47:28.220306	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1260	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-06 14:47:34.626102	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1261	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-06 14:47:55.975754	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1262	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-06 14:47:57.178638	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1263	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-06 14:47:59.277029	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1264	51	150	大江	1	text	\N	\N	\N	normal	2025-12-06 14:54:32.172909	\N	\N	\N		\N	\N	\N	大江	\N	\N
1265	51	146	王志豪	1	text	\N	\N	\N	normal	2025-12-06 15:11:39.041452	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1266	51	146	王志豪	2	text	\N	\N	\N	normal	2025-12-06 15:11:40.347649	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1267	51	146	王志豪	3	text	\N	\N	\N	normal	2025-12-06 15:11:41.707782	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1268	51	146	王志豪	564	text	\N	\N	\N	normal	2025-12-06 15:11:59.779382	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1269	51	146	王志豪	23232	text	\N	\N	\N	normal	2025-12-06 15:12:01.919334	\N	\N	\N		\N	\N	\N	王志豪	\N	\N
1270	53	118	youdu1	创建新群组"测试"	system	\N	\N	\N	normal	2025-12-06 15:13:55.374965	\N	\N	\N		\N	\N	\N	\N	\N	\N
1271	53	118	youdu1	您已被邀请加入群组"测试"	system	\N	\N	\N	normal	2025-12-06 15:13:55.376772	\N	\N	\N		\N	\N	\N	\N	\N	\N
1273	53	152	wxh	1	text	\N	\N	\N	normal	2025-12-06 15:14:38.612765	\N	\N	\N		\N	\N	\N	wxh	\N	\N
1274	53	118	有度	1	text	\N	\N	\N	normal	2025-12-06 15:14:43.322514	\N	\N	\N		\N	\N	\N	有度	\N	\N
1275	53	118	有度	2	quoted	\N	1273	1	normal	2025-12-06 15:14:55.946214	\N	\N	\N		\N	\N	\N	有度	\N	\N
1279	53	152	wxh	2	quoted	\N	1274	1	normal	2025-12-06 15:16:07.939333	\N	\N	\N		\N	\N	\N	wxh	\N	\N
1282	53	153	wxhh	111	text	\N	\N	\N	normal	2025-12-06 15:17:23.366639	\N	\N	\N		\N	\N	\N	wxhh	\N	\N
1283	54	153	wxh2	创建新群组"1"	system	\N	\N	\N	normal	2025-12-06 15:18:19.672722	\N	\N	\N		\N	\N	\N	\N	\N	\N
1284	54	153	wxh2	您已被邀请加入群组"1"	system	\N	\N	\N	normal	2025-12-06 15:18:19.674527	\N	\N	\N		\N	\N	\N	\N	\N	\N
1285	54	153	wxhh	111	text	\N	\N	\N	normal	2025-12-06 15:18:29.380727	\N	\N	\N		\N	\N	\N	wxhh	\N	\N
1286	54	152	wxh	我就直接耳机忘记	text	\N	\N	\N	normal	2025-12-06 15:18:32.860148	\N	\N	\N		\N	\N	\N	wxh	\N	\N
1287	54	153	wxhh	1	quoted	\N	1286	我就直接耳机忘记	normal	2025-12-06 15:18:43.746819	\N	\N	\N		\N	\N	\N	wxhh	\N	\N
1292	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:11:40.985703	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1293	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:11:55.360034	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1483	47	144	cesfffff	111	text	\N	\N	\N	normal	2025-12-18 12:11:13.23125	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1294	51	151	王总先生	你好	quoted	\N	1	1	normal	2025-12-07 13:12:35.387594	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1295	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:12:45.295971	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1296	51	150	大江	bxh	text	\N	\N	\N	normal	2025-12-07 13:12:48.76133	\N	\N	\N		\N	\N	\N	大江	\N	\N
1297	51	150	大江	一荣俱荣	text	\N	\N	\N	normal	2025-12-07 13:12:51.32301	\N	\N	\N		\N	\N	\N	大江	\N	\N
1298	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:12:54.034282	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1299	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-07 13:13:21.86712	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1300	51	150	大江	开玩笑	text	\N	\N	\N	normal	2025-12-07 13:13:26.929768	\N	\N	\N		\N	\N	\N	大江	\N	\N
1301	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-07 13:13:41.041071	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1302	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-07 13:13:43.901207	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1303	51	148	阿迪	开什么玩笑	text	\N	\N	\N	normal	2025-12-07 13:13:45.64093	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1304	51	150	大江	扣扣	quoted	\N	1298	1	normal	2025-12-07 13:13:50.116353	\N	\N	\N		\N	\N	\N	大江	\N	\N
1305	51	150	大江	1、引用发送失败问题修复；\n2、列表排序按最新信息来排序，群不要总是显示在最下面；\n3、发送数字不生效问题；\n4、语音时自己的头像换到上面去；\n5、群聊对方信息时间不对；\n6、图片保存不到相册;\n7、群组设置成员显示昵称不要显示ID；\n8、视频通话中的“点击小框”去掉。	text	\N	\N	\N	normal	2025-12-07 13:14:18.068239	\N	\N	\N		\N	\N	\N	大江	\N	\N
1306	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765084465_JPEG_20251207_131425_5146216890987420328.jpg	image	\N	\N	\N	normal	2025-12-07 13:14:26.267544	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1307	51	151	王总先生	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765084570_JPEG_20251207_131606_2757158699257108948.jpg	image	\N	\N	\N	normal	2025-12-07 13:16:11.47757	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1314	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:18:20.260223	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1308	51	148	阿迪	这个可以吧	quoted	\N	1307	[图片]	normal	2025-12-07 13:16:33.076008	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1317	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:02.408778	\N	\N	\N		\N	\N	\N	大江	\N	\N
1318	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:04.644126	\N	\N	\N		\N	\N	\N	大江	\N	\N
1319	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:20:10.248576	\N	\N	\N		\N	\N	\N	大江	\N	\N
1320	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:13.161831	\N	\N	\N		\N	\N	\N	大江	\N	\N
1321	51	150	大江	3	text	\N	\N	\N	normal	2025-12-07 13:20:20.419441	\N	\N	\N		\N	\N	\N	大江	\N	\N
1322	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:22.948124	\N	\N	\N		\N	\N	\N	大江	\N	\N
1323	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:33.283832	\N	\N	\N		\N	\N	\N	大江	\N	\N
1324	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:37.192152	\N	\N	\N		\N	\N	\N	大江	\N	\N
1325	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:20:42.269881	\N	\N	\N		\N	\N	\N	大江	\N	\N
1326	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:21:22.116279	\N	\N	\N		\N	\N	\N	大江	\N	\N
1327	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:21:26.954878	\N	\N	\N		\N	\N	\N	大江	\N	\N
1328	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:21:29.425964	\N	\N	\N		\N	\N	\N	大江	\N	\N
1329	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:21:35.118342	\N	\N	\N		\N	\N	\N	大江	\N	\N
1330	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:22:10.403563	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1331	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:22:15.159053	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1332	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:24:04.12024	\N	\N	\N		\N	\N	\N	大江	\N	\N
1333	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:24:16.892279	\N	\N	\N		\N	\N	\N	大江	\N	\N
1334	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:25:53.487793	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1335	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:25:57.684877	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1352	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:33:12.215726	\N	\N	\N		\N	\N	\N	大江	\N	\N
1353	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:33:14.226374	\N	\N	\N		\N	\N	\N	大江	\N	\N
1354	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:33:16.43235	\N	\N	\N		\N	\N	\N	大江	\N	\N
1355	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:33:18.381559	\N	\N	\N		\N	\N	\N	大江	\N	\N
1362	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/150/1765086068279954245_1764492028506.mp4	video	\N	\N	\N	normal	2025-12-07 13:43:42.784782	\N	\N	\N		\N	\N	\N	大江	\N	\N
1309	51	148	阿迪	对对对	quoted	\N	1305	1、引用发送失败问题修复；\n2、列表排序按最新信息来排序，群不要总是显示在最下面；\n3、发送数字不生效问题；\n4、语音时自己的头像换到上面去；\n5、群聊对方信息时间不对；\n6、图片保存不到相册;\n7、群组设置成员显示昵称不要显示ID；\n8、视频通话中的“点击小框”去掉。	normal	2025-12-07 13:17:05.657199	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1310	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:18:12.880124	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1311	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:18:15.547408	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1312	51	148	阿迪	2	text	\N	\N	\N	normal	2025-12-07 13:18:17.112502	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1313	51	148	阿迪	3	text	\N	\N	\N	normal	2025-12-07 13:18:19.018788	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1315	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:18:22.431471	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1316	51	148	阿迪	4	text	\N	\N	\N	normal	2025-12-07 13:18:27.471286	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1336	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:26:29.952065	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1337	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:26:32.765986	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1338	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-07 13:26:34.911749	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1339	51	151	王总先生	1	text	\N	\N	\N	normal	2025-12-07 13:26:37.104381	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1340	51	151	王总先生	2	text	\N	\N	\N	normal	2025-12-07 13:26:39.219972	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N		\N	\N	王总先生	王先生	\N	\N
1341	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-07 13:26:51.437823	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1342	51	148	阿迪	2	text	\N	\N	\N	normal	2025-12-07 13:26:55.715977	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1343	51	148	阿迪	3	text	\N	\N	\N	normal	2025-12-07 13:26:58.889348	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1344	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:27:48.587428	\N	\N	\N		\N	\N	\N	大江	\N	\N
1345	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:27:52.10623	\N	\N	\N		\N	\N	\N	大江	\N	\N
1346	51	150	大江	群里不行	text	\N	\N	\N	normal	2025-12-07 13:27:59.049101	\N	\N	\N		\N	\N	\N	大江	\N	\N
1347	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:28:04.536698	\N	\N	\N		\N	\N	\N	大江	\N	\N
1348	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:32:39.082007	\N	\N	\N		\N	\N	\N	大江	\N	\N
1349	51	150	大江	2	text	\N	\N	\N	normal	2025-12-07 13:32:41.509968	\N	\N	\N		\N	\N	\N	大江	\N	\N
1350	51	150	大江	3	text	\N	\N	\N	normal	2025-12-07 13:32:43.589466	\N	\N	\N		\N	\N	\N	大江	\N	\N
1351	51	150	大江	发数学出去延迟的很	text	\N	\N	\N	normal	2025-12-07 13:32:58.913403	\N	\N	\N		\N	\N	\N	大江	\N	\N
1356	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:39:57.457051	\N	\N	\N		\N	\N	\N	大江	\N	\N
1357	51	150	大江	1	text	\N	\N	\N	normal	2025-12-07 13:40:01.439654	\N	\N	\N		\N	\N	\N	大江	\N	\N
1358	51	150	大江	群里发数学不行	text	\N	\N	\N	normal	2025-12-07 13:40:08.309906	\N	\N	\N		\N	\N	\N	大江	\N	\N
1359	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765086028_JPEG_20251207_134028_2308281356293816901.jpg	image	\N	\N	\N	normal	2025-12-07 13:40:29.17838	\N	\N	\N		\N	\N	\N	大江	\N	\N
1360	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765086040_JPEG_20251207_134039_8404148591313946689.jpg	image	\N	\N	\N	normal	2025-12-07 13:40:42.713882	\N	\N	\N		\N	\N	\N	大江	\N	\N
1361	51	150	大江	保存图片试试	text	\N	\N	\N	normal	2025-12-07 13:40:50.943872	\N	\N	\N		\N	\N	\N	大江	\N	\N
1363	52	148	阿迪	这个好看	text	\N	\N	\N	normal	2025-12-14 10:06:12.345467	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1364	52	148	阿迪	打不打	text	\N	\N	\N	normal	2025-12-14 10:06:34.51794	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1365	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:06:48.935772	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1366	52	149	苏	打什么	text	\N	\N	\N	normal	2025-12-14 10:06:50.595483	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1367	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:06:52.188045	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1368	52	148	阿迪	不知道阿	text	\N	\N	\N	normal	2025-12-14 10:07:03.723825	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1369	52	148	阿迪	你说呢	text	\N	\N	\N	normal	2025-12-14 10:07:09.399414	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1370	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765678037_Screenshot_20251212_183259_com_ss_android_ugc_aweme_DetailActivity.jpg	image	\N	\N	\N	normal	2025-12-14 10:07:18.605436	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1371	51	148	阿迪	什么意思	text	\N	\N	\N	normal	2025-12-14 10:07:35.216763	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1372	51	149	苏	这是你的戒指吗	quoted	\N	139	1	normal	2025-12-14 10:07:43.951547	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1373	51	148	阿迪	你查一下	text	\N	\N	\N	normal	2025-12-14 10:08:00.750555	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1374	52	148	阿迪	？	text	\N	\N	\N	normal	2025-12-14 10:08:59.091293	\N	\N	\N		\N	\N	\N	阿迪	\N	\N
1375	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:12:53.717337	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1376	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:13:04.40563	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1377	51	149	苏	哈了他	text	\N	\N	\N	normal	2025-12-14 10:13:09.192449	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1378	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:13:21.17396	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1379	51	149	苏	时间对的	text	\N	\N	\N	normal	2025-12-14 10:13:24.932318	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1380	51	149	苏	1	text	\N	\N	\N	normal	2025-12-14 10:13:29.306706	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1381	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:13:32.968069	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1382	51	149	苏	1	text	\N	\N	\N	normal	2025-12-14 10:13:35.146491	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1383	51	149	苏	2	text	\N	\N	\N	normal	2025-12-14 10:13:38.014703	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1384	51	149	苏	3	text	\N	\N	\N	normal	2025-12-14 10:13:40.142798	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1385	51	149	苏	1	text	\N	\N	\N	normal	2025-12-14 10:13:41.863004	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1386	51	149	苏	2	text	\N	\N	\N	normal	2025-12-14 10:13:43.931057	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1387	51	149	苏	3	text	\N	\N	\N	normal	2025-12-14 10:13:46.267568	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1388	51	149	苏	数字还是会卡	text	\N	\N	\N	normal	2025-12-14 10:13:53.640661	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1389	51	149	苏	23	text	\N	\N	\N	normal	2025-12-14 10:14:06.146273	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1390	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-14 10:18:22.53337	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1391	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-14 10:18:24.185693	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1392	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/147/1765678719212735335_voice_1765678717335.m4a	voice	\N	\N	\N	normal	2025-12-14 10:18:40.658788	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1418	51	148	阿迪	1	text	\N	\N	\N	normal	2025-12-14 10:23:40.13906	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1424	51	155	阿宇	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679083_Screenshot_20251023_122832.jpg	image	\N	\N	\N	normal	2025-12-14 10:24:44.565224	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1393	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-14 10:19:23.898614	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1394	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-14 10:19:27.349672	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1395	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-14 10:19:29.701983	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1493	49	127	测试901	888	text	\N	\N	\N	normal	2025-12-18 17:26:15.182753	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1396	51	147	风生水起	4	text	\N	\N	\N	normal	2025-12-14 10:19:31.99601	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1397	51	147	风生水起	5	text	\N	\N	\N	normal	2025-12-14 10:19:33.477491	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1398	51	147	风生水起	6	text	\N	\N	\N	normal	2025-12-14 10:19:34.822002	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1399	51	147	风生水起	7	text	\N	\N	\N	normal	2025-12-14 10:19:36.053385	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1400	51	147	风生水起	8	text	\N	\N	\N	normal	2025-12-14 10:19:37.532553	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1401	51	147	风生水起	9	text	\N	\N	\N	normal	2025-12-14 10:19:38.811248	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1402	51	147	风生水起	这个有问题，为什么1和2不能发	text	\N	\N	\N	normal	2025-12-14 10:20:04.621276	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1403	51	147	风生水起	9	text	\N	\N	\N	normal	2025-12-14 10:20:14.794148	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1404	51	147	风生水起	重复的数字不能发	text	\N	\N	\N	normal	2025-12-14 10:20:24.876036	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1405	51	147	风生水起	发了显示不出来	text	\N	\N	\N	normal	2025-12-14 10:20:38.766255	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1406	51	147	风生水起	要退出重新来	text	\N	\N	\N	normal	2025-12-14 10:20:46.894804	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1407	51	147	风生水起	1	text	\N	\N	\N	normal	2025-12-14 10:21:15.302087	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1408	51	147	风生水起	2	text	\N	\N	\N	normal	2025-12-14 10:21:17.270609	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1409	51	147	风生水起	3	text	\N	\N	\N	normal	2025-12-14 10:21:18.550352	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1410	51	147	风生水起	4	text	\N	\N	\N	normal	2025-12-14 10:21:20.189921	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1411	51	147	风生水起	5	text	\N	\N	\N	normal	2025-12-14 10:21:21.550009	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1412	51	147	风生水起	6	text	\N	\N	\N	normal	2025-12-14 10:21:22.804125	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1413	51	147	风生水起	7	text	\N	\N	\N	normal	2025-12-14 10:21:24.183207	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1414	51	147	风生水起	8	text	\N	\N	\N	normal	2025-12-14 10:21:25.874213	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1415	51	147	风生水起	9	text	\N	\N	\N	normal	2025-12-14 10:21:27.197716	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1416	51	147	风生水起	0	text	\N	\N	\N	normal	2025-12-14 10:21:29.174479	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1417	51	155	阿迪	您已被添加到群组	system	\N	\N	\N	normal	2025-12-14 10:23:20.153792	\N	\N	\N		\N	\N	\N	\N	\N	\N
1419	51	155	阿宇	中午好	text	\N	\N	\N	normal	2025-12-14 10:23:52.262685	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1420	51	155	阿宇	1	text	\N	\N	\N	normal	2025-12-14 10:24:10.507125	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1421	51	155	阿宇	1	text	\N	\N	\N	normal	2025-12-14 10:24:15.186356	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1422	51	155	阿宇	2	text	\N	\N	\N	normal	2025-12-14 10:24:18.018475	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1423	51	155	阿宇	2	text	\N	\N	\N	normal	2025-12-14 10:24:20.91461	\N	\N	\N		\N	\N	\N	阿宇	\N	\N
1425	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1765679095_JPEG_20251206_141216_3661491002188513628.jpg	file	JPEG_20251206_141216_3661491002188513628.jpg	\N	\N	normal	2025-12-14 10:25:01.400619	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1426	51	150	大江	1	text	\N	\N	\N	normal	2025-12-14 10:25:10.103941	\N	\N	\N		\N	\N	\N	大江	\N	\N
1427	51	150	大江	1	text	\N	\N	\N	normal	2025-12-14 10:25:19.656919	\N	\N	\N		\N	\N	\N	大江	\N	\N
1428	51	150	大江	今了	text	\N	\N	\N	normal	2025-12-14 10:25:30.90267	\N	\N	\N		\N	\N	\N	大江	\N	\N
1429	51	150	大江	1	text	\N	\N	\N	normal	2025-12-14 10:25:33.425342	\N	\N	\N		\N	\N	\N	大江	\N	\N
1430	51	150	大江	1	text	\N	\N	\N	normal	2025-12-14 10:25:35.697644	\N	\N	\N		\N	\N	\N	大江	\N	\N
1431	51	150	大江	2	text	\N	\N	\N	normal	2025-12-14 10:25:37.426834	\N	\N	\N		\N	\N	\N	大江	\N	\N
1432	51	150	大江	3	text	\N	\N	\N	normal	2025-12-14 10:25:39.835908	\N	\N	\N		\N	\N	\N	大江	\N	\N
1433	51	150	大江	4	text	\N	\N	\N	normal	2025-12-14 10:25:41.848009	\N	\N	\N		\N	\N	\N	大江	\N	\N
1434	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1765679142_IMG_20251213_153834_720.jpg	file	IMG_20251213_153834_720.jpg	\N	\N	normal	2025-12-14 10:25:43.984877	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1435	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1765679153_JPEG_20251206_141216_3661491002188513628.jpg	file	JPEG_20251206_141216_3661491002188513628.jpg	\N	\N	normal	2025-12-14 10:25:55.263114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1436	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679265_Screenshot_20251211_092147_com_baidu_searchbox_LightSearchActivity.jpg	image	\N	\N	\N	normal	2025-12-14 10:27:46.217986	\N	\N	\N		\N	\N	\N	大江	\N	\N
1437	51	148	阿迪	我不吃	text	\N	\N	\N	normal	2025-12-14 10:27:56.109	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1438	51	150	大江	好吃	text	\N	\N	\N	normal	2025-12-14 10:28:10.8514	\N	\N	\N		\N	\N	\N	大江	\N	\N
1439	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679310_Screenshot_20251210_132403_com_jingdong_app_mall_ProductDetailActivity.jpg	image	\N	\N	\N	normal	2025-12-14 10:28:31.078533	\N	\N	\N		\N	\N	\N	大江	\N	\N
1440	51	150	大江	好看不	text	\N	\N	\N	normal	2025-12-14 10:28:42.405886	\N	\N	\N		\N	\N	\N	大江	\N	\N
1441	51	149	苏	买一件	text	\N	\N	\N	normal	2025-12-14 10:28:44.502443	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1494	49	127	测试901	好	text	\N	\N	\N	normal	2025-12-18 17:27:14.845952	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1442	51	149	苏	不好看	text	\N	\N	\N	normal	2025-12-14 10:28:49.80283	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1443	51	148	阿迪	你要送我吗？	text	\N	\N	\N	normal	2025-12-14 10:28:50.459913	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1444	51	150	大江	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679341_Image_1764404858777.jpg	image	\N	\N	\N	normal	2025-12-14 10:29:02.45714	\N	\N	\N		\N	\N	\N	大江	\N	\N
1445	51	150	大江	苏，这个是你女朋友	text	\N	\N	\N	normal	2025-12-14 10:29:10.626763	\N	\N	\N		\N	\N	\N	大江	\N	\N
1446	51	149	苏	晚上弄来	text	\N	\N	\N	normal	2025-12-14 10:29:19.284101	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1447	51	150	大江	你自己弄	text	\N	\N	\N	normal	2025-12-14 10:29:27.293479	\N	\N	\N		\N	\N	\N	大江	\N	\N
1448	51	150	大江	好的，晚上我们一起早点睡，梦里一起去逛商场	quoted	\N	1443	你要送我吗？	normal	2025-12-14 10:29:54.040439	\N	\N	\N		\N	\N	\N	大江	\N	\N
1449	51	150	大江	我给你买	text	\N	\N	\N	normal	2025-12-14 10:29:59.136354	\N	\N	\N		\N	\N	\N	大江	\N	\N
1451	51	147	风生水起	原来我没有在群里	text	\N	\N	\N	normal	2025-12-14 10:32:23.270602	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1450	51	149	苏	还要测试什么想想	text	\N	\N	\N	normal	2025-12-14 10:31:37.404215	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1452	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679787_1764170322838_edit_26831073563722.jpg	image	\N	\N	\N	normal	2025-12-14 10:36:29.60843	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1453	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/147/1765679796267618190_13fd626d4d805fb273de0b1018227381.mp4	video	\N	\N	\N	normal	2025-12-14 10:36:44.816454	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1454	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679815_JPEG_20251121_204108_4461358918224051702.jpg	image	\N	\N	\N	normal	2025-12-14 10:36:56.140757	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1455	51	147	风生水起	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765679847_BR10297-1_1.webp	image	\N	\N	\N	normal	2025-12-14 10:37:28.772108	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1456	51	148	阿迪	这个好看	text	\N	\N	\N	normal	2025-12-14 10:37:45.481207	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N		\N	\N	\N	阿迪	\N	\N
1457	51	149	苏	群主和管理员呢	text	\N	\N	\N	normal	2025-12-14 10:40:56.933805	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1458	51	149	苏	群主和管理员开个群语音试试	text	\N	\N	\N	normal	2025-12-14 10:41:09.091937	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1459	51	148	阿迪	阿迪发起了语音通话	join_voice_button	\N	\N	\N	normal	2025-12-14 10:41:42.893442	\N	\N	\N		voice	group_call_148_1765680102	\N	\N	\N	\N
1460	51	148	阿迪	阿迪发起了视频通话	join_video_button	\N	\N	\N	normal	2025-12-14 10:42:57.496678	\N	\N	\N		video	group_call_148_1765680177	\N	\N	\N	\N
1461	51	149	苏	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765680500_Screenshot_20251212_183310_com_ss_android_ugc_aweme_DetailActivity.jpg	image	\N	\N	\N	normal	2025-12-14 10:48:21.325282	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1462	51	149	苏	还有哪些地方需要测试	text	\N	\N	\N	normal	2025-12-14 10:49:35.531414	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1463	51	149	苏	大家提提意见啊	text	\N	\N	\N	normal	2025-12-14 10:49:43.008271	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1464	51	149	苏	我想不到了	text	\N	\N	\N	normal	2025-12-14 10:49:53.138039	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1465	51	147	风生水起	没有了，	text	\N	\N	\N	normal	2025-12-14 10:50:23.745303	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1466	51	149	苏	确定	text	\N	\N	\N	normal	2025-12-14 10:50:33.071535	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1467	51	149	苏	我的时间一会好一会差的	text	\N	\N	\N	normal	2025-12-14 10:50:40.359401	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N		\N	\N	\N	苏	\N	\N
1468	51	147	风生水起	你们用的这个东西是不是觉得有点卡顿，反应很慢	text	\N	\N	\N	normal	2025-12-14 10:50:45.436053	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1469	51	147	风生水起	用的一点也不流畅	text	\N	\N	\N	normal	2025-12-14 10:51:33.908592	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N		\N	\N	\N	风生水起	\N	\N
1470	49	127	测试901	333	text	\N	\N	\N	normal	2025-12-14 17:28:17.961809	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1471	49	127	测试901	44	text	\N	\N	\N	normal	2025-12-14 17:28:18.826043	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1472	49	126	123	555	text	\N	\N	\N	normal	2025-12-14 17:28:32.856422	\N	\N	\N		\N	\N	\N	123	\N	\N
1473	49	126	123	66	text	\N	\N	\N	normal	2025-12-14 17:28:35.015308	\N	\N	\N		\N	\N	\N	123	\N	\N
1474	49	127	测试901	qqqw	text	\N	\N	\N	normal	2025-12-14 18:42:43.086118	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1475	43	117	秋风2	你好	text	\N	\N	\N	normal	2025-12-15 21:27:13.258639	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N		\N	\N	\N	秋风2	\N	\N
1476	28	117	秋风2	你好	text	\N	\N	\N	normal	2025-12-15 21:27:16.877857	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N		\N	\N	\N	秋风2	\N	\N
1477	50	117	秋风2	你好	text	\N	\N	\N	normal	2025-12-15 21:27:20.680479	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N		\N	\N	\N	秋风2	\N	\N
1478	46	143	弄一下嘻嘻	44566	quoted	\N	33	就是	normal	2025-12-17 12:42:20.027265	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1479	46	143	弄一下嘻嘻	try	text	\N	\N	\N	normal	2025-12-18 09:59:41.849547	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1484	47	144	cesfffff	222	text	\N	\N	\N	normal	2025-12-18 12:11:35.02755	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1480	46	143	弄一下嘻嘻	hi	text	\N	\N	\N	normal	2025-12-18 09:59:43.872004	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1481	46	143	弄一下嘻嘻	iii	text	\N	\N	\N	normal	2025-12-18 09:59:45.834439	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1482	46	143	弄一下嘻嘻	4466	text	\N	\N	\N	normal	2025-12-18 10:17:23.316058	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	弄一下嘻嘻	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1485	47	144	cesfffff	333	text	\N	\N	\N	normal	2025-12-18 12:11:37.177812	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1486	47	143	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	44	text	\N	\N	\N	normal	2025-12-18 12:30:43.129313	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N		\N	\N	\N	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N
1487	47	144	cesfffff	55	text	\N	\N	\N	normal	2025-12-18 12:31:12.637252	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1488	47	144	cesfffff	66	text	\N	\N	\N	normal	2025-12-18 12:31:14.83024	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1489	47	144	cesfffff	555	text	\N	\N	\N	normal	2025-12-18 12:44:32.495162	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1490	47	144	cesfffff	66	text	\N	\N	\N	normal	2025-12-18 12:44:42.524961	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1491	47	144	cesfffff	77	text	\N	\N	\N	normal	2025-12-18 12:44:44.986705	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N		\N	\N	\N	cesfffff	\N	\N
1495	49	127	测试901	好	text	\N	\N	\N	normal	2025-12-18 17:27:17.081725	\N	\N	\N		\N	\N	\N	测试901	\N	\N
1496	48	127	aaaa	333	text	\N	\N	\N	normal	2025-12-18 17:29:03.497784	\N	\N	\N		\N	\N	aaaa	测试901	\N	\N
1497	48	127	aaaa	666	text	\N	\N	\N	normal	2025-12-18 17:29:05.148056	\N	\N	\N		\N	\N	aaaa	测试901	\N	\N
1498	23	102	测试01	888	text	\N	\N	\N	normal	2025-12-19 09:41:35.615836	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1499	55	102	test01	创建新群组"222"	system	\N	\N	\N	normal	2025-12-19 09:42:38.789903	\N	\N	\N		\N	\N	\N	\N	\N	\N
1500	55	102	test01	您已被邀请加入群组"222"	system	\N	\N	\N	normal	2025-12-19 09:42:38.790818	\N	\N	\N		\N	\N	\N	\N	\N	\N
1502	55	103	测试2	通话时长 00:21	call_ended	\N	\N	\N	normal	2025-12-19 09:43:29.527944	\N	\N	\N		voice	group_call_102_1766108588	\N	\N	\N	\N
1503	56	159	test25	创建新群组"0104"	system	\N	\N	\N	normal	2025-12-19 10:58:30.153368	\N	\N	\N		\N	\N	\N	\N	\N	\N
1504	56	159	test25	您已被邀请加入群组"0104"	system	\N	\N	\N	normal	2025-12-19 10:58:30.155027	\N	\N	\N		\N	\N	\N	\N	\N	\N
1505	56	159	test25	您已被邀请加入群组"0104"	system	\N	\N	\N	normal	2025-12-19 10:58:30.15612	\N	\N	\N		\N	\N	\N	\N	\N	\N
1506	56	159	ceshi25	11	text	\N	\N	\N	normal	2025-12-19 10:58:45.477414	\N	\N	\N		\N	\N	\N	ceshi25	\N	\N
1507	56	105	测试04	22	text	\N	\N	\N	normal	2025-12-19 10:58:54.523876	\N	\N	\N		\N	\N	\N	测试04	\N	\N
1508	57	108	test07	创建新群组"ceshi0407"	system	\N	\N	\N	normal	2025-12-19 13:15:24.74526	\N	\N	\N		\N	\N	\N	\N	\N	\N
1509	57	108	test07	您已被邀请加入群组"ceshi0407"	system	\N	\N	\N	normal	2025-12-19 13:15:24.748245	\N	\N	\N		\N	\N	\N	\N	\N	\N
1510	57	108	test07	您已被邀请加入群组"ceshi0407"	system	\N	\N	\N	normal	2025-12-19 13:15:24.749499	\N	\N	\N		\N	\N	\N	\N	\N	\N
1512	57	105	测试04	通话时长 00:40	call_ended_video	\N	\N	\N	normal	2025-12-19 05:16:31.920987	\N	\N	\N		video	group_call_108_1766121351	\N	\N	\N	\N
1513	58	108	test07	创建新群组"001"	system	\N	\N	\N	normal	2025-12-19 13:48:24.900607	\N	\N	\N		\N	\N	\N	\N	\N	\N
1514	58	108	test07	您已被邀请加入群组"001"	system	\N	\N	\N	normal	2025-12-19 13:48:24.902244	\N	\N	\N		\N	\N	\N	\N	\N	\N
1516	58	108	测试07	通话时长 00:12	call_ended	\N	\N	\N	normal	2025-12-19 05:49:06.595816	\N	\N	\N		voice	group_call_108_1766123334	\N	\N	\N	\N
1517	58	105	测试04	11	text	\N	\N	\N	normal	2025-12-19 14:16:01.004288	\N	\N	\N		\N	\N	\N	测试04	\N	\N
1518	58	108	测试07	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/108/1766125027982769000_voice_1766124967323.m4a	voice	\N	\N	\N	normal	2025-12-19 14:17:12.622679	\N	\N	\N		\N	\N	\N	测试07	\N	60
1519	58	105	测试04	222	text	\N	\N	\N	normal	2025-12-19 14:21:39.937852	\N	\N	\N		\N	\N	\N	测试04	\N	\N
1520	58	108	测试07	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/108/1766125379172012000_voice_1766125318826.m4a	voice	\N	\N	\N	normal	2025-12-19 14:23:05.615742	\N	\N	\N		\N	\N	\N	测试07	\N	60
1521	58	103	测试07	您已被添加到群组	system	\N	\N	\N	normal	2025-12-19 14:40:10.721215	\N	\N	\N		\N	\N	\N	\N	\N	\N
1522	58	108	测试07	123	text	\N	\N	\N	normal	2025-12-19 14:40:27.118032	\N	\N	\N		\N	\N	\N	测试07	\N	\N
1524	58	108	测试07	通话时长 00:43	call_ended	\N	\N	\N	normal	2025-12-19 06:41:31.401863	\N	\N	\N		voice	group_call_108_1766126448	\N	\N	\N	\N
1525	58	108	测试07	111	text	\N	\N	\N	normal	2025-12-19 14:49:29.631423	\N	\N	\N		\N	\N	\N	测试07	\N	\N
1527	58	105	测试04	通话时长 00:08	call_ended_video	\N	\N	\N	normal	2025-12-19 06:49:55.459745	\N	\N	\N		video	group_call_108_1766126987	\N	\N	\N	\N
1529	58	108	测试07	通话时长 03:51	call_ended	\N	\N	\N	normal	2025-12-19 06:53:52.922846	\N	\N	\N		voice	group_call_108_1766127001	\N	\N	\N	\N
1530	58	108	测试07	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1766127431_租房管理 3.pdf	file	租房管理 3.pdf	\N	\N	normal	2025-12-19 14:57:13.836165	\N	\N	\N		\N	\N	\N	测试07	\N	\N
1531	56	102	测试01	33	text	\N	\N	\N	normal	2025-12-19 19:29:56.76456	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1532	59	103	test02	创建新群组"0102"	system	\N	\N	\N	normal	2025-12-19 19:32:01.00251	\N	\N	\N		\N	\N	\N	\N	\N	\N
1533	59	103	test02	您已被邀请加入群组"0102"	system	\N	\N	\N	normal	2025-12-19 19:32:01.00402	\N	\N	\N		\N	\N	\N	\N	\N	\N
1535	59	102	测试01	通话时长 00:15	call_ended	\N	\N	\N	normal	2025-12-19 11:33:11.937627	\N	\N	\N		voice	group_call_103_1766143976	\N	\N	\N	\N
1536	59	102	测试01	111	text	\N	\N	\N	normal	2025-12-19 20:50:36.519621	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1537	59	102	测试01	22	text	\N	\N	\N	normal	2025-12-19 20:50:59.336694	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1538	59	102	测试01	333	text	\N	\N	\N	normal	2025-12-19 21:03:22.486805	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1539	59	103	测试2	444	text	\N	\N	\N	normal	2025-12-19 21:03:31.10305	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1540	59	102	测试01	555	text	\N	\N	\N	normal	2025-12-19 21:09:03.258408	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1541	59	103	测试2	666	text	\N	\N	\N	normal	2025-12-19 21:10:26.322769	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1542	59	102	测试01	777	text	\N	\N	\N	normal	2025-12-19 21:10:33.712874	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1543	59	103	测试2	888	text	\N	\N	\N	normal	2025-12-19 21:18:35.304493	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1544	59	102	测试01	9999	text	\N	\N	\N	normal	2025-12-19 21:18:39.293615	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1545	59	103	测试2	000	text	\N	\N	\N	normal	2025-12-19 13:35:11.923676	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1546	59	102	测试01	1111	text	\N	\N	\N	normal	2025-12-19 13:35:16.535487	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1547	60	102	test01	创建新群组"0108"	system	\N	\N	\N	normal	2025-12-19 14:22:01.773759	\N	\N	\N		\N	\N	\N	\N	\N	\N
1548	60	102	test01	您已被邀请加入群组"0108"	system	\N	\N	\N	normal	2025-12-19 14:22:01.775985	\N	\N	\N		\N	\N	\N	\N	\N	\N
1549	61	102	test01	创建新群组"Cheshire -0108"	system	\N	\N	\N	normal	2025-12-19 14:22:31.213169	\N	\N	\N		\N	\N	\N	\N	\N	\N
1550	61	102	test01	您已被邀请加入群组"Cheshire -0108"	system	\N	\N	\N	normal	2025-12-19 14:22:31.215001	\N	\N	\N		\N	\N	\N	\N	\N	\N
1551	61	102	测试01	111	text	\N	\N	\N	normal	2025-12-19 14:22:45.838116	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1552	61	109	测试08	222	text	\N	\N	\N	normal	2025-12-19 14:22:50.141507	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1553	61	109	测试08	33	text	\N	\N	\N	normal	2025-12-19 14:25:14.752405	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1554	61	109	测试08	44	text	\N	\N	\N	normal	2025-12-19 14:25:16.263357	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1555	61	109	测试08	55	text	\N	\N	\N	normal	2025-12-19 14:25:17.105526	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1556	61	109	测试08	66	text	\N	\N	\N	normal	2025-12-19 14:25:18.210215	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1557	61	109	测试08	77	text	\N	\N	\N	normal	2025-12-19 14:25:19.080888	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1561	62	102	test01	创建新群组"Cheshire-0108-01"	system	\N	\N	\N	normal	2025-12-19 14:39:54.192144	\N	\N	\N		\N	\N	\N	\N	\N	\N
1562	62	102	test01	您已被邀请加入群组"Cheshire-0108-01"	system	\N	\N	\N	normal	2025-12-19 14:39:54.193551	\N	\N	\N		\N	\N	\N	\N	\N	\N
1592	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155332_image_08E4FC5A-1632-455B-8878-3C34D774DEC3_1766155332.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:16.565612	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1593	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155330_image_07AAE015-E835-4699-952C-1F1844B9ACF1_1766155330.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:16.575755	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1594	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155328_image_D6933A04-77A5-49D5-B55C-91984FA5A7F0_1766155328.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:17.492211	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1558	61	109	测试08	88	text	\N	\N	\N	normal	2025-12-19 14:25:20.097408	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1559	61	109	测试08	99	text	\N	\N	\N	normal	2025-12-19 14:25:22.087621	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1560	61	109	测试08	00	text	\N	\N	\N	normal	2025-12-19 14:25:24.140971	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1563	62	102	测试01	1	text	\N	\N	\N	normal	2025-12-19 14:40:06.202262	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1564	62	102	测试01	2	text	\N	\N	\N	normal	2025-12-19 14:40:08.083475	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1565	62	102	测试01	3	text	\N	\N	\N	normal	2025-12-19 14:40:09.706522	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1566	62	102	测试01	4	text	\N	\N	\N	normal	2025-12-19 14:40:11.13982	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1567	62	102	测试01	5	text	\N	\N	\N	normal	2025-12-19 14:40:12.71769	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1568	62	102	测试01	6	text	\N	\N	\N	normal	2025-12-19 14:40:14.310899	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1569	62	102	测试01	7	text	\N	\N	\N	normal	2025-12-19 14:40:16.050312	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1570	62	102	测试01	8	text	\N	\N	\N	normal	2025-12-19 14:40:17.686533	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1571	62	102	测试01	9	text	\N	\N	\N	normal	2025-12-19 14:40:19.518466	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1572	62	102	测试01	0	text	\N	\N	\N	normal	2025-12-19 14:40:21.194041	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1573	62	109	测试08	1	text	\N	\N	\N	normal	2025-12-19 14:40:26.244147	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1574	62	109	测试08	2	text	\N	\N	\N	normal	2025-12-19 14:40:28.005899	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1575	62	109	测试08	3	text	\N	\N	\N	normal	2025-12-19 14:40:29.334336	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1576	62	109	测试08	4	text	\N	\N	\N	normal	2025-12-19 14:40:31.048863	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1577	62	109	测试08	5	text	\N	\N	\N	normal	2025-12-19 14:40:32.512749	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1578	62	109	测试08	6	text	\N	\N	\N	normal	2025-12-19 14:40:33.629845	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1579	62	109	测试08	7	text	\N	\N	\N	normal	2025-12-19 14:40:34.650639	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1580	62	109	测试08	8	text	\N	\N	\N	normal	2025-12-19 14:40:35.691028	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1581	62	109	测试08	9	text	\N	\N	\N	normal	2025-12-19 14:40:36.595061	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1582	62	109	测试08	0	text	\N	\N	\N	normal	2025-12-19 14:40:37.728526	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1583	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155306_image_6B6486E4-97FD-4047-A6EE-573BD28B8FAC_1766155306.jpeg	image	\N	\N	\N	normal	2025-12-19 14:41:49.880708	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1584	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155303_image_702AACA0-AF54-400F-9533-631C91FA2E2C_1766155302.jpeg	image	\N	\N	\N	normal	2025-12-19 14:41:50.753735	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1585	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155311_image_98F85128-BD93-404C-B74A-F3F0813B8233_1766155311.jpeg	image	\N	\N	\N	normal	2025-12-19 14:41:54.676576	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1586	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155309_image_9FD58BA8-21D5-4B84-92D3-B715F61E104D_1766155309.jpeg	image	\N	\N	\N	normal	2025-12-19 14:41:57.419635	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1587	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155313_image_2A1296BC-EC94-469F-A611-B44D8E29883E_1766155313.jpeg	image	\N	\N	\N	normal	2025-12-19 14:41:59.405125	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1588	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155323_image_2B0D7835-BCC6-46D9-A665-AE2C851BF283_1766155323.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:06.44402	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1589	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155325_image_C8A5B5D9-734B-43DB-8BE8-031635C0127B_1766155325.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:08.885157	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1590	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155320_image_D1C8724C-C905-4053-A68F-43F32DBAECA8_1766155320.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:09.884709	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1591	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155318_image_82918190-14F2-4F5F-9F63-D9E908000E67_1766155318.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:10.234306	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1595	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155316_image_8F2569B2-7905-4165-A692-8513751C2F97_1766155316.jpeg	image	\N	\N	\N	normal	2025-12-19 14:42:19.554559	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1596	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155672_image_61889C7C-A591-4CDE-B9D7-A9259C5584AE_1766155672.jpeg	image	\N	\N	\N	normal	2025-12-19 14:47:57.972089	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1597	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155676_image_B192F0F8-DC65-4B18-8799-97DED46AE21F_1766155675.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:00.840771	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1598	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155678_image_D80D53D4-31DB-4A4A-96CA-03C56CE2DE05_1766155678.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:03.301097	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1599	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155680_image_BEAE1A55-680D-41C1-A83D-F5ACBA2AB83D_1766155680.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:07.747639	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1600	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155685_image_8E7E0960-214E-4ED7-89C4-10F7BB6D2FE8_1766155685.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:12.612703	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1601	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155687_image_5E13DE6C-0761-4E91-B19A-E42CF47C610D_1766155687.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:15.796258	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1602	62	109	测试08	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766155683_image_0AF24636-67E4-4040-A9C4-DD3F9C110F8E_1766155683.jpeg	image	\N	\N	\N	normal	2025-12-19 14:48:20.083702	\N	\N	\N		\N	\N	\N	测试08	\N	\N
1603	63	103	test02	创建新群组"群组0102"	system	\N	\N	\N	normal	2025-12-22 04:56:17.082602	\N	\N	\N		\N	\N	\N	\N	\N	\N
1604	63	103	test02	您已被邀请加入群组"群组0102"	system	\N	\N	\N	normal	2025-12-22 04:56:17.086342	\N	\N	\N		\N	\N	\N	\N	\N	\N
1606	63	102	测试01	通话时长 00:09	call_ended	\N	\N	\N	normal	2025-12-22 04:56:46.584985	\N	\N	\N		voice	group_call_103_1766379397	\N	\N	\N	\N
1608	63	102	测试01	通话时长 00:05	call_ended	\N	\N	\N	normal	2025-12-22 04:57:19.158453	\N	\N	\N		voice	group_call_103_1766379434	\N	\N	\N	\N
1610	63	103	测试2	通话时长 00:05	call_ended	\N	\N	\N	normal	2025-12-22 05:07:35.354407	\N	\N	\N		voice	group_call_103_1766380050	\N	\N	\N	\N
1611	63	103	测试2	123	text	\N	\N	\N	normal	2025-12-22 05:11:48.876551	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1613	63	102	测试01	通话时长 00:44	call_ended	\N	\N	\N	normal	2025-12-22 05:12:37.792493	\N	\N	\N		voice	group_call_103_1766380313	\N	\N	\N	\N
1615	63	102	测试01	通话时长 00:08	call_ended	\N	\N	\N	normal	2025-12-22 05:13:00.728986	\N	\N	\N		voice	group_call_103_1766380372	\N	\N	\N	\N
1616	63	103	测试2	111	text	\N	\N	\N	normal	2025-12-22 05:22:33.900634	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1618	63	103	测试2	通话时长 00:21	call_ended	\N	\N	\N	normal	2025-12-22 05:22:59.198833	\N	\N	\N		voice	group_call_103_1766380958	\N	\N	\N	\N
1620	63	102	测试01	通话时长 00:13	call_ended	\N	\N	\N	normal	2025-12-22 05:23:17.258333	\N	\N	\N		voice	group_call_103_1766380984	\N	\N	\N	\N
1622	63	102	测试01	通话时长 00:13	call_ended	\N	\N	\N	normal	2025-12-22 05:37:30.579853	\N	\N	\N		voice	group_call_103_1766381837	\N	\N	\N	\N
1624	63	102	测试01	通话时长 00:11	call_ended	\N	\N	\N	normal	2025-12-22 05:37:55.837229	\N	\N	\N		voice	group_call_103_1766381864	\N	\N	\N	\N
1626	63	102	测试01	通话时长 00:26	call_ended	\N	\N	\N	normal	2025-12-22 05:39:14.221495	\N	\N	\N		voice	group_call_103_1766381928	\N	\N	\N	\N
1628	63	102	测试01	通话时长 00:28	call_ended	\N	\N	\N	normal	2025-12-22 05:48:06.929504	\N	\N	\N		voice	group_call_103_1766382458	\N	\N	\N	\N
1629	63	102	测试01	111	text	\N	\N	\N	normal	2026-01-09 09:25:00.233668	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1630	63	103	测试2	测试2发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-01-09 09:25:08.81934	\N	\N	\N		voice		\N	\N	\N	\N
1631	63	102	测试01	通话时长 00:24	call_ended	\N	\N	\N	normal	2026-01-09 09:25:35.715631	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1632	63	102	测试01	通话时长 00:24	call_ended	\N	\N	\N	normal	2026-01-09 09:25:35.745324	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1633	63	102	测试01	通话时长 00:24	call_ended	\N	\N	\N	normal	2026-01-09 09:25:35.756458	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1634	63	102	测试01	通话时长 00:24	call_ended	\N	\N	\N	normal	2026-01-09 09:25:35.762269	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1635	63	103	测试2	通话时长 00:25	call_ended	\N	\N	\N	normal	2026-01-09 09:25:36.172025	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1636	63	102	测试01	通话时长 00:24	call_ended	\N	\N	\N	normal	2026-01-09 09:25:36.223803	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1637	63	103	测试2	通话时长 00:25	call_ended	\N	\N	\N	normal	2026-01-09 09:25:37.718271	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1638	63	102	测试01	9999	text	\N	\N	\N	normal	2026-01-10 12:07:00.003458		\N	\N		\N	\N	\N	\N	\N	\N
1639	63	102	测试01	00000	text	\N	\N	\N	normal	2026-01-10 12:18:00.004946		\N	\N		\N	\N	\N	\N	\N	\N
1640	63	103	测试2	1111	text	\N	\N	\N	normal	2026-01-23 14:14:04.512003	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N		\N	\N	\N	测试2	\N	\N
1641	63	102	测试01	2222	text	\N	\N	\N	normal	2026-01-23 14:14:11.239412	\N	\N	\N		\N	\N	\N	测试01	\N	\N
1642	64	102	test01	创建新群组"test05 group"	system	\N	\N	\N	normal	2026-06-27 10:23:58.694158	\N	\N	\N		\N	\N	\N	\N	\N	\N
1643	64	102	test01	您已被邀请加入群组"test05 group"	system	\N	\N	\N	normal	2026-06-27 10:23:58.699454	\N	\N	\N		\N	\N	\N	\N	\N	\N
1644	64	102	测试01	123	text	\N	\N	\N	normal	2026-06-27 10:24:14.162135	\N	\N	\N		\N	\N	\N	测试01	1576	\N
1645	64	102	测试01	测试01发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-06-27 10:24:25.592047	\N	\N	\N		voice		\N	\N	\N	\N
1647	64	102	测试01	测试01发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-06-27 10:24:25.90226	\N	\N	\N		voice		\N	\N	\N	\N
1649	64	106	测试05	通话时长 00:05	call_ended	\N	\N	\N	normal	2026-06-27 10:24:40.531229	\N	\N	\N		voice	group_call_102_1782555865	\N	\N	\N	\N
1650	64	102	测试01	测试01发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-06-27 10:29:20.820083	\N	\N	\N		voice		\N	\N	\N	\N
1652	64	102	测试01	测试01发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-06-27 10:29:21.051852	\N	\N	\N		voice		\N	\N	\N	\N
1653	64	102	测试01	加入通话	join_voice_button	\N	\N	\N	normal	2026-06-27 10:29:21.057162	\N	\N	\N		voice	group_call_102_1782556161	\N	\N	\N	\N
1654	64	106	测试05	通话时长 00:05	call_ended	\N	\N	\N	normal	2026-06-27 10:29:33.662455	\N	\N	\N		voice	group_call_102_1782556160	\N	\N	\N	\N
1655	64	102	测试01	测试01发起了语音通话	group_call_initiated	\N	\N	\N	normal	2026-06-27 10:38:40.673804	\N	\N	\N		voice		\N	\N	\N	\N
1657	64	102	测试01	通话时长 00:16	call_ended	\N	\N	\N	normal	2026-06-27 10:39:02.225873	\N	\N	\N		voice	group_call_102_1782556720	\N	\N	\N	\N
\.


--
-- Data for Name: groups; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.groups (id, name, announcement, avatar, owner_id, created_at, updated_at, deleted_at, all_muted, invite_confirmation, admin_only_edit_name, member_view_permission) FROM stdin;
23	111	\N	\N	103	2025-11-24 19:23:07.556208	2025-11-24 19:23:07.556208	\N	f	f	f	t
24	群组01	\N	\N	112	2025-11-25 14:27:47.605044	2025-11-25 14:27:47.605044	\N	f	f	f	t
25	群测试02	\N	\N	107	2025-11-26 08:02:29.848503	2025-11-26 08:02:29.848503	\N	f	f	f	t
26	群组测试3	\N	\N	113	2025-11-26 11:03:31.404564	2025-11-26 12:43:40.793218	\N	f	f	f	t
27	测试群	\N	\N	116	2025-11-26 14:35:07.291999	2025-11-26 14:39:26.260618	\N	f	f	f	t
28	测试2	\N	\N	116	2025-11-26 14:40:48.509173	2025-11-26 14:40:48.509173	\N	f	f	f	t
29	测试群组05	\N	\N	103	2025-11-26 15:45:50.358678	2025-11-26 15:45:50.358678	\N	f	f	f	t
30	test_group_06	\N	\N	113	2025-11-26 15:47:10.45277	2025-11-26 15:47:10.45277	\N	f	f	f	t
31	群组07	\N	\N	113	2025-11-26 15:55:05.688749	2025-11-26 15:55:05.688749	\N	f	f	f	t
32	群组9	\N	\N	113	2025-11-26 16:15:10.775466	2025-11-26 16:15:10.775466	\N	f	f	f	t
33	test_group_10	\N	\N	113	2025-11-26 16:16:54.934576	2025-11-26 16:16:54.934576	\N	f	f	f	t
34	群组11	\N	\N	113	2025-11-26 16:28:30.259332	2025-11-26 16:28:30.259332	\N	f	f	f	t
35	群组12	\N	\N	113	2025-11-26 16:29:29.981185	2025-11-26 16:29:29.981185	\N	f	f	f	t
36	群组13	\N	\N	113	2025-11-26 16:35:00.779698	2025-11-26 16:35:00.779698	\N	f	f	f	t
37	qunz	\N	\N	103	2025-11-26 17:37:26.914977	2025-11-26 17:37:26.914977	\N	f	f	f	t
38	群组测试333	\N	\N	103	2025-11-26 17:41:15.986786	2025-11-26 17:41:15.986786	\N	f	f	f	t
39	qunzu222	\N	\N	113	2025-11-26 17:42:01.608414	2025-11-26 17:42:01.608414	\N	f	f	f	t
40	qunzu123	\N	\N	103	2025-11-26 17:54:30.504349	2025-11-26 17:54:30.504349	\N	f	f	f	t
41	qqqq	\N	\N	103	2025-11-26 17:55:11.626231	2025-11-26 17:55:11.626231	\N	f	f	f	t
42	opopop	\N	\N	102	2025-11-26 18:53:50.895114	2025-11-26 18:53:50.895114	\N	f	f	f	t
43	测试1	\N	\N	116	2025-11-27 16:53:21.974939	2025-11-27 16:53:21.974939	\N	f	f	f	t
44	群组789	\N	\N	113	2025-11-28 11:01:02.564663	2025-11-28 11:01:02.564663	\N	f	f	f	t
45	群组999	\N	\N	113	2025-11-28 11:02:01.077957	2025-11-28 11:02:01.077957	\N	f	f	f	t
49	90901	\N	\N	126	2025-12-03 21:11:58.649087	2025-12-03 21:11:58.649087	\N	f	f	f	t
47	测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2	测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2测试群组2	\N	142	2025-11-30 15:27:59.067778	2025-12-01 22:35:20.951778	\N	f	f	f	t
48	群组09901	\N	\N	128	2025-12-02 20:57:21.962926	2025-12-02 20:58:06.429503	\N	f	f	f	t
50	测试群	\N	\N	145	2025-12-04 01:06:55.940785	2025-12-04 01:06:55.940785	\N	f	f	f	t
51	一战成名	大家好，本人王志豪12345678998745632112365478998745632112334566789965441336995578635489669974599852542899647862216624896258632489328872985665897239847625845684499	\N	151	2025-12-06 11:01:34.735536	2025-12-06 11:21:02.033479	\N	f	t	f	f
46	1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方	11大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方1大撒旦飞洒士大夫萨芬收到萨芬撒地方撒旦飞洒地方士大夫撒地方撒地方撒地方	\N	142	2025-11-29 06:25:05.177094	2025-12-05 16:13:53.630449	\N	f	t	f	t
52	😀	\N	\N	149	2025-12-06 14:15:58.951302	2025-12-06 14:17:23.34506	\N	f	t	f	t
53	测试	\N	\N	118	2025-12-06 15:13:55.367239	2025-12-06 15:13:55.367239	\N	f	f	f	t
54	1	\N	\N	153	2025-12-06 15:18:19.664738	2025-12-06 15:18:19.664738	\N	f	f	f	t
55	222	\N	\N	102	2025-12-19 09:42:38.780626	2025-12-19 09:42:38.780626	\N	f	f	f	t
56	0104	\N	\N	159	2025-12-19 10:58:30.14733	2025-12-19 10:58:30.14733	\N	f	f	f	t
57	ceshi0407	\N	\N	108	2025-12-19 13:15:24.737863	2025-12-19 13:15:24.737863	\N	f	f	f	t
58	001	\N	\N	108	2025-12-19 13:48:24.89378	2025-12-19 13:48:24.89378	\N	f	f	f	t
59	0102	\N	\N	103	2025-12-19 19:32:00.993461	2025-12-19 19:32:00.993461	\N	f	f	f	t
60	0108	\N	\N	102	2025-12-19 22:22:01.769773	2025-12-19 22:22:01.769773	\N	f	f	f	t
61	Cheshire -0108	\N	\N	102	2025-12-19 22:22:31.208619	2025-12-19 22:22:31.208619	\N	f	f	f	t
62	Cheshire-0108-01	\N	\N	102	2025-12-19 22:39:54.188224	2025-12-19 22:39:54.188224	\N	f	f	f	t
63	群组0102	\N	\N	103	2025-12-22 12:56:17.073109	2025-12-22 12:56:17.073109	\N	f	f	f	t
64	test05 group	\N	\N	102	2026-06-27 18:23:58.682844	2026-06-27 18:23:58.682844	\N	f	f	f	t
\.


--
-- Data for Name: invite_code_usages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invite_code_usages (id, invite_code_id, user_id, used_at) FROM stdin;
\.


--
-- Data for Name: invite_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.invite_codes (id, code, status, used_by_user_id, used_by_username, used_by_fullname, created_at, used_at) FROM stdin;
\.


--
-- Data for Name: messages; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.messages (id, sender_id, receiver_id, content, message_type, is_read, created_at, read_at, sender_name, receiver_name, file_name, quoted_message_id, quoted_message_content, status, deleted_by_users, sender_avatar, receiver_avatar, call_type, server_id, voice_duration) FROM stdin;
3511	102	103	55	text	t	2026-03-01 03:30:06.534156	2026-03-01 11:30:06.577721	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	275	\N
3513	102	103	66	text	t	2026-03-01 03:30:18.717233	2026-03-01 11:30:18.745981	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	276	\N
1760	102	103	333	text	t	2025-11-24 15:29:27.390818	2025-11-24 15:29:27.473912	test01	test02	\N	\N	\N	normal				\N	\N	\N
1761	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763969375_ic_launcher.png	image	t	2025-11-24 15:29:38.791805	2025-11-24 15:29:38.887998	test01	test02	\N	\N	\N	normal				\N	\N	\N
1762	102	103	44	text	t	2025-11-24 15:29:38.796791	2025-11-24 15:29:39.118573	test01	test02	\N	\N	\N	normal				\N	\N	\N
1763	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763969392_2637-161442811_tiny.mp4	video	t	2025-11-24 15:29:57.206475	2025-11-24 15:29:57.373893	test01	test02	\N	\N	\N	normal				\N	\N	\N
1764	102	103	555	text	t	2025-11-24 15:29:57.212034	2025-11-24 15:29:57.646549	test01	test02	\N	\N	\N	normal				\N	\N	\N
1765	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1763969411_test_voice_py	file	t	2025-11-24 15:30:13.207027	2025-11-24 15:30:13.38206	test01	test02	test_voice_py	\N	\N	normal				\N	\N	\N
1766	102	103	666	text	t	2025-11-24 15:30:13.259686	2025-11-24 15:30:13.555659	test01	test02	\N	\N	\N	normal				\N	\N	\N
1767	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763969424_paste_1763969422960.png	image	t	2025-11-24 15:30:30.591005	2025-11-24 15:30:30.756506	test01	test02	\N	\N	\N	normal				\N	\N	\N
1768	102	103	888	text	t	2025-11-24 15:30:30.653791	2025-11-24 15:30:31.013935	test01	test02	\N	\N	\N	normal				\N	\N	\N
1769	102	103	[emotion:1_Smile.png]	text	t	2025-11-24 15:30:58.213642	2025-11-24 15:30:58.412877	test01	test02	\N	\N	\N	normal				\N	\N	\N
3571	102	103	f	text	t	2026-03-01 05:50:14.165644	2026-03-01 13:50:14.197338	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	183	\N
3575	102	103	d	text	t	2026-03-01 05:51:16.720135	2026-03-01 13:51:16.785896	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
1774	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763969611_2637-161442811_tiny.mp4	video	t	2025-11-24 15:33:37.693563	2025-11-24 15:33:37.8626	test01	test02	\N	\N	\N	normal				\N	\N	\N
1776	102	103	55	text	t	2025-11-24 15:40:08.475646	2025-11-24 15:40:08.631529	test01	test02	\N	\N	\N	normal				\N	\N	\N
1777	102	103	[emotion:42_NosePick.png]	text	t	2025-11-24 15:40:14.382122	2025-11-24 15:40:14.504165	test01	test02	\N	\N	\N	normal				\N	\N	\N
1778	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763970022_ic_launcher.png	image	t	2025-11-24 15:40:25.174766	2025-11-24 15:40:25.307806	test01	test02	\N	\N	\N	normal				\N	\N	\N
1779	102	103	66	text	t	2025-11-24 15:40:25.179948	2025-11-24 15:40:25.638117	test01	test02	\N	\N	\N	normal				\N	\N	\N
1780	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763970035_2637-161442811_tiny.mp4	video	t	2025-11-24 15:40:44.189585	2025-11-24 15:40:44.403454	test01	test02	\N	\N	\N	normal				\N	\N	\N
1781	102	103	777	text	t	2025-11-24 15:40:44.195303	2025-11-24 15:40:44.548593	test01	test02	\N	\N	\N	normal				\N	\N	\N
1782	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1763970055_test_voice_py	file	t	2025-11-24 15:40:57.322876	2025-11-24 15:40:57.454947	test01	test02	test_voice_py	\N	\N	normal				\N	\N	\N
1783	102	103	888	text	t	2025-11-24 15:40:57.361159	2025-11-24 15:40:57.67877	test01	test02	\N	\N	\N	normal				\N	\N	\N
3588	102	103	6	text	t	2026-03-01 06:00:26.77004	2026-03-01 14:00:26.823447	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	190	\N
1785	102	103	000	text	t	2025-11-24 16:01:26.578354	2025-11-24 16:01:26.761454	test01	test02	\N	\N	\N	normal				\N	\N	\N
1786	102	103	[emotion:29_Laugh.png]	text	t	2025-11-24 16:01:31.83709	2025-11-24 16:01:32.040728	test01	test02	\N	\N	\N	normal				\N	\N	\N
1787	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763971305_ic_launcher.png	image	t	2025-11-24 16:01:47.414273	2025-11-24 16:01:47.519639	test01	test02	\N	\N	\N	normal				\N	\N	\N
1788	102	103	11	text	t	2025-11-24 16:01:47.600457	2025-11-24 16:01:47.817559	test01	test02	\N	\N	\N	normal				\N	\N	\N
1789	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763971315_2637-161442811_tiny.mp4	video	t	2025-11-24 16:02:01.417178	2025-11-24 16:02:01.572053	test01	test02	\N	\N	\N	normal				\N	\N	\N
1790	102	103	222	text	t	2025-11-24 16:02:01.443995	2025-11-24 16:02:01.763547	test01	test02	\N	\N	\N	normal				\N	\N	\N
1791	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1763971333_test_voice_py	file	t	2025-11-24 16:02:15.001842	2025-11-24 16:02:15.149483	test01	test02	test_voice_py	\N	\N	normal				\N	\N	\N
1792	102	103	555	text	t	2025-11-24 16:02:15.186573	2025-11-24 16:02:15.337331	test01	test02	\N	\N	\N	normal				\N	\N	\N
1793	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763971344_paste_1763971342584.png	image	t	2025-11-24 16:02:47.366026	2025-11-24 16:02:47.48701	test01	test02	\N	\N	\N	normal				\N	\N	\N
1794	102	103	66	text	t	2025-11-24 16:02:47.412741	2025-11-24 16:02:47.667039	test01	test02	\N	\N	\N	normal				\N	\N	\N
3623	102	103	66	text	t	2026-03-01 07:01:40.187749	2026-03-01 15:01:40.221648	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	190	\N
1801	102	103	1111	text	t	2025-11-24 16:58:11.996506	2025-11-24 16:58:12.183152	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
1804	103	102	444	text	t	2025-11-24 17:05:30.661474	2025-11-24 17:05:30.83429	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1807	103	102	77	text	t	2025-11-24 17:28:39.819639	2025-11-24 17:28:40.002785	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1808	104	103	请求添加好友【已驳回】	text	f	2025-11-24 18:57:10.684222	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1809	104	103	请求添加好友【已驳回】	text	f	2025-11-24 18:59:28.17374	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1810	103	104	111	text	f	2025-11-24 18:59:36.93846	\N	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
1811	104	103	请求添加好友【已通过】	text	f	2025-11-24 19:04:05.945853	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1812	103	104	请求添加好友【已通过】	text	f	2025-11-24 19:04:05.947369	\N	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
1813	104	103	1111	text	f	2025-11-24 19:05:35.976882	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1814	104	103	222	text	f	2025-11-24 19:05:45.27096	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1815	103	104	333	text	f	2025-11-24 19:05:50.258905	\N	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
1816	103	104	444	text	t	2025-11-24 19:10:02.371765	2025-11-24 19:10:02.475652	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
1817	104	103	555	text	f	2025-11-24 19:10:09.659479	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1818	104	103	666	text	f	2025-11-24 19:10:16.842969	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1756	103	102	请求添加好友【已通过】	text	t	2025-11-24 15:20:56.009906	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1759	103	102	2222	text	t	2025-11-24 15:29:23.97706	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1770	103	102	😀	text	t	2025-11-24 15:31:07.18073	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1771	103	102	999	text	t	2025-11-24 15:31:15.432144	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1772	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763969502_scaled_f590be0a-e5ce-41c8-af14-2ae1310c4c887932569343199737445.jpg	image	t	2025-11-24 15:31:47.50087	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1775	103	102	334	text	t	2025-11-24 15:39:51.525375	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1819	104	103	666	text	f	2025-11-24 19:10:17.399841	\N	测试03	测试2	\N	\N	\N	normal				\N	\N	\N
1820	103	104	777	text	f	2025-11-24 19:10:32.986448	\N	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
1821	103	104	88	text	t	2025-11-24 19:10:41.703854	2025-11-24 19:10:41.842633	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
3512	102	103	66	text	t	2026-03-01 03:30:08.303304	2026-03-01 11:30:08.331531	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	276	\N
3577	102	103	g	text	t	2026-03-01 05:51:16.720505	2026-03-01 13:51:16.785896	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	184	\N
1826	103	104	555	text	f	2025-11-24 19:32:49.189666	\N	测试2	测试03	\N	\N	\N	normal				\N	\N	\N
3578	102	103	1	text	t	2026-03-01 05:59:17.525046	2026-03-01 13:59:17.590605	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	185	\N
3581	102	103	4	text	t	2026-03-01 05:59:19.900957	2026-03-01 13:59:19.958959	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	188	\N
3585	102	103	8	text	t	2026-03-01 05:59:22.821423	2026-03-01 13:59:22.876424	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	192	\N
1833	103	102	666	text	t	2025-11-24 20:26:43.706494	2025-11-24 20:26:43.823071	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1845	103	102	00:16	call_ended	t	2025-11-24 21:33:25.776685	2025-11-24 21:33:25.95598	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1846	103	102	00:05	call_ended	t	2025-11-24 21:33:45.656376	2025-11-24 21:33:45.99822	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1848	103	102	00:05	call_ended	t	2025-11-24 21:34:06.606783	2025-11-24 21:34:06.697272	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1850	104	102	测试03 请求添加您为好友	system	f	2025-11-24 21:56:27.589274	\N	测试03	测试01	\N	\N	\N	normal				\N	\N	\N
1851	102	104	请求添加好友【已驳回】	text	f	2025-11-24 21:57:21.204635	\N	测试01	测试03	\N	\N	\N	normal				\N	\N	\N
1852	104	102	测试03 请求添加您为好友	system	f	2025-11-24 22:02:27.636549	\N	测试03	测试01	\N	\N	\N	normal				\N	\N	\N
1853	104	102	00:09	call_ended	t	2025-11-24 22:02:49.207834	2025-11-24 22:02:49.394183	测试03	测试01	\N	\N	\N	normal				voice	\N	\N
1854	102	104	请求添加好友【已通过】	text	f	2025-11-24 22:06:11.085767	\N	测试01	测试03	\N	\N	\N	normal				\N	\N	\N
1855	104	102	请求添加好友【已通过】	text	f	2025-11-24 22:06:11.087895	\N	测试03	测试01	\N	\N	\N	normal				\N	\N	\N
1856	103	102	00:51	call_ended	t	2025-11-24 22:12:24.751771	2025-11-24 22:12:24.925238	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1857	103	102	00:11	call_ended	t	2025-11-24 22:20:52.45966	2025-11-24 22:20:52.603004	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1858	103	102	00:03	call_ended	t	2025-11-24 22:21:24.475064	2025-11-24 22:21:24.538795	测试2	测试01	\N	\N	\N	normal				voice	\N	\N
1859	105	102	测试04 请求添加您为好友	system	f	2025-11-24 22:22:26.117356	\N	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1860	102	105	请求添加好友【已通过】	text	f	2025-11-24 22:22:46.499346	\N	测试01	测试04	\N	\N	\N	normal				\N	\N	\N
1861	105	102	请求添加好友【已通过】	text	f	2025-11-24 22:22:46.502484	\N	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1862	105	102	00:02	call_ended	t	2025-11-24 22:23:56.084594	2025-11-24 22:23:56.23454	测试04	测试01	\N	\N	\N	normal				voice	\N	\N
1863	105	102	00:02	call_ended	t	2025-11-24 22:31:38.478474	2025-11-24 22:31:38.654021	测试04	测试01	\N	\N	\N	normal				voice	\N	\N
1864	105	102	111	text	f	2025-11-25 08:19:19.882386	\N	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1865	105	102	111	text	f	2025-11-25 08:34:47.738113	\N	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1866	102	105	2222	text	f	2025-11-25 08:56:47.429347	\N	测试01	测试04	\N	\N	\N	normal				\N	\N	\N
1867	102	105	111	text	f	2025-11-25 09:10:52.189658	\N	测试01	测试04	\N	\N	\N	normal				\N	\N	\N
1868	105	102	对方已拒绝	call_rejected	f	2025-11-25 09:15:13.567219	\N	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1869	105	102	11	text	t	2025-11-25 11:13:56.966287	2025-11-25 11:13:57.169017	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1870	102	105	22	text	f	2025-11-25 11:14:16.085094	\N	测试01	测试04	\N	\N	\N	normal				\N	\N	\N
1871	102	105	22	text	f	2025-11-25 11:14:16.707171	\N	测试01	测试04	\N	\N	\N	normal				\N	\N	\N
1872	105	102	33	text	t	2025-11-25 11:14:19.856665	2025-11-25 11:14:19.995614	测试04	测试01	\N	\N	\N	normal				\N	\N	\N
1822	103	102	11	text	t	2025-11-24 19:22:35.410806	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1824	103	102	333	text	t	2025-11-24 19:29:12.359392	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1827	103	102	5555	text	t	2025-11-24 19:38:35.808875	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1828	103	102	666	text	t	2025-11-24 19:38:56.030638	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1829	103	102	777	text	t	2025-11-24 19:46:22.87716	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1834	103	102	777	text	t	2025-11-24 21:28:08.442312	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1835	103	102	[emotion:29_Laugh.png]	text	t	2025-11-24 21:28:15.452982	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1836	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763990903_ic_launcher.png	image	t	2025-11-24 21:28:25.919173	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1837	103	102	88	text	t	2025-11-24 21:28:26.158038	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1838	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763990915_2637-161442811_tiny.mp4	video	t	2025-11-24 21:28:54.011069	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1849	103	102	111	text	t	2025-11-24 21:56:07.501601	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1881	107	102	测试06 请求添加您为好友,待审核	system	t	2025-11-25 12:11:19.086946	2025-12-19 21:37:08.325901	测试06	测试01	\N	\N	\N	normal				\N	\N	\N
1880	107	102	请求添加好友【已拒绝】	text	t	2025-11-25 12:07:46.73071	2025-12-19 21:37:08.325901	测试06	测试01	\N	\N	\N	normal				\N	\N	\N
1879	107	102	测试06 请求添加您为好友,待审核	system	t	2025-11-25 12:07:32.284718	2025-12-19 21:37:08.325901	测试06	测试01	\N	\N	\N	normal				\N	\N	\N
1878	107	102	测试06 请求添加您为好友,待审核	system	t	2025-11-25 12:00:14.384184	2025-12-19 21:37:08.325901	测试06	测试01	\N	\N	\N	normal				\N	\N	\N
1884	102	107	请求添加好友【已驳回】	text	t	2025-11-25 12:25:22.495078	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
1883	102	107	请求添加好友【已驳回】	text	t	2025-11-25 12:23:04.632949	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
1882	102	107	请求添加好友【已驳回】	text	t	2025-11-25 12:11:27.28312	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
1877	106	102	111	text	t	2025-11-25 11:29:29.046026	2026-01-11 17:31:26.108638	测试05	测试01	\N	\N	\N	normal				\N	\N	\N
1876	106	102	测试05 请求添加您为好友	system	t	2025-11-25 11:27:53.805621	2026-01-11 17:31:26.108638	测试05	测试01	\N	\N	\N	normal				\N	\N	\N
1875	106	102	111	text	t	2025-11-25 11:20:12.154115	2026-01-11 17:31:26.108638	测试05	测试01	\N	\N	\N	normal				\N	\N	\N
1873	106	102	测试05 请求添加您为好友	system	t	2025-11-25 11:14:41.565684	2026-01-11 17:31:26.108638	测试05	测试01	\N	\N	\N	normal				\N	\N	\N
1874	102	106	请求添加好友【已驳回】	text	t	2025-11-25 11:15:04.796636	2026-01-11 17:33:37.288435	测试01	测试05	\N	\N	\N	normal				\N	\N	\N
1887	102	108	请求添加好友【已驳回】	text	f	2025-11-25 12:33:46.119294	\N	测试01	测试07	\N	\N	\N	normal				\N	\N	\N
1888	102	108	请求添加好友【已驳回】	text	f	2025-11-25 12:36:49.452974	\N	测试01	测试07	\N	\N	\N	normal				\N	\N	\N
1889	102	108	请求添加好友【已驳回】	text	f	2025-11-25 12:44:12.958758	\N	测试01	测试07	\N	\N	\N	normal				\N	\N	\N
1890	102	110	请求添加好友【已驳回】	text	f	2025-11-25 13:03:25.347484	\N	测试01	测试09	\N	\N	\N	normal				\N	\N	\N
1891	110	102	111	text	f	2025-11-25 13:03:32.838038	\N	测试09	测试01	\N	\N	\N	normal				\N	\N	\N
1892	110	102	222	text	f	2025-11-25 13:12:20.139711	\N	测试09	测试01	\N	\N	\N	normal				\N	\N	\N
1893	102	110	请求添加好友【已驳回】	text	f	2025-11-25 13:17:04.482964	\N	测试01	测试09	\N	\N	\N	normal				\N	\N	\N
1894	102	110	请求添加好友【已通过】	text	f	2025-11-25 13:17:49.376504	\N	测试01	测试09	\N	\N	\N	normal				\N	\N	\N
1895	110	102	请求添加好友【已通过】	text	f	2025-11-25 13:17:49.378057	\N	测试09	测试01	\N	\N	\N	normal				\N	\N	\N
1896	110	102	777	text	f	2025-11-25 13:17:57.716987	\N	测试09	测试01	\N	\N	\N	normal				\N	\N	\N
1897	111	112	请求添加好友【已驳回】	text	f	2025-11-25 13:23:06.719324	\N	测试20	测试21	\N	\N	\N	normal				\N	\N	\N
1898	111	112	请求添加好友【已通过】	text	f	2025-11-25 13:24:13.848335	\N	测试20	测试21	\N	\N	\N	normal				\N	\N	\N
1899	112	111	请求添加好友【已通过】	text	f	2025-11-25 13:24:13.850079	\N	测试21	测试20	\N	\N	\N	normal				\N	\N	\N
1900	112	111	111	text	f	2025-11-25 13:24:21.74996	\N	测试21	测试20	\N	\N	\N	normal				\N	\N	\N
1902	112	102	请求添加好友【已通过】	text	f	2025-11-25 13:39:44.062264	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1903	112	102	11	text	f	2025-11-25 14:14:30.505131	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1904	112	102	333	text	f	2025-11-25 15:00:19.1173	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1905	112	102	444	text	f	2025-11-25 15:00:31.04974	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1906	112	102	666	text	f	2025-11-25 15:26:41.417799	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1907	112	102	777	text	f	2025-11-25 15:26:47.980479	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1908	112	102	88	text	f	2025-11-25 15:27:21.068688	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
1910	113	113	请求添加好友【已驳回】	text	f	2025-11-25 18:07:00.77581	\N	测试22	测试22	\N	\N	\N	normal				\N	\N	\N
1911	113	113	请求添加好友【已驳回】	text	f	2025-11-25 18:15:58.027404	\N	测试22	测试22	\N	\N	\N	normal				\N	\N	\N
1912	114	113	请求添加好友【已驳回】	text	f	2025-11-25 18:24:47.215059	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1913	114	113	请求添加好友【已通过】	text	f	2025-11-25 18:25:23.627795	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1914	113	114	请求添加好友【已通过】	text	f	2025-11-25 18:25:23.62983	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1915	114	113	1	text	f	2025-11-25 18:25:45.67401	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1916	114	113	2	text	f	2025-11-25 18:25:55.152569	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1917	114	113	3	text	f	2025-11-25 18:28:55.079605	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1918	114	113	4	text	f	2025-11-25 18:29:02.072258	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1919	113	114	5	text	t	2025-11-25 18:29:12.566669	2025-11-25 18:29:13.754836	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1920	113	114	6	text	t	2025-11-25 18:29:18.281247	2025-11-25 18:29:19.494776	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1921	113	114	[emotion:1_Smile.png]	text	t	2025-11-25 18:29:24.966488	2025-11-25 18:29:26.120461	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1922	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764066577_ic_launcher.png	image	t	2025-11-25 18:29:39.895337	2025-11-25 18:29:41.018436	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1923	113	114	77	text	t	2025-11-25 18:29:40.030547	2025-11-25 18:29:42.13867	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1924	114	113	😃	text	f	2025-11-25 18:29:59.260148	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1925	114	113	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764066622_scaled_5c9373f9-b2a9-4e67-b46e-d7923c55a4703584403794167940725.jpg	image	f	2025-11-25 18:30:27.794427	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1926	114	113	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764066655_JPEG_20251125_183056_8109158235297963793.jpg	image	f	2025-11-25 18:30:58.088917	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1927	113	114	00:02	call_ended	t	2025-11-25 18:31:20.243111	2025-11-25 18:31:21.610223	测试22	测试23	\N	\N	\N	normal				voice	\N	\N
1928	113	114	00:01	call_ended_video	t	2025-11-25 18:31:33.652046	2025-11-25 18:31:35.049789	测试22	测试23	\N	\N	\N	normal				video	\N	\N
1930	114	113	00:02	call_ended	f	2025-11-25 18:31:50.737302	\N	测试23	测试22	\N	\N	\N	normal				voice	\N	\N
1931	114	113	00:02	call_ended	f	2025-11-25 18:31:50.972617	\N	测试23	测试22	\N	\N	\N	normal				voice	\N	\N
1929	113	114	00:02	call_ended	t	2025-11-25 18:31:50.726785	2025-11-25 18:31:52.163477	测试22	测试23	\N	\N	\N	normal				voice	\N	\N
1932	114	113	00:05	call_ended_video	f	2025-11-25 18:32:07.740449	\N	测试23	测试22	\N	\N	\N	normal				video	\N	\N
1934	114	113	00:05	call_ended_video	f	2025-11-25 18:32:08.045294	\N	测试23	测试22	\N	\N	\N	normal				video	\N	\N
1933	113	114	00:05	call_ended_video	t	2025-11-25 18:32:07.74098	2025-11-25 18:32:09.15375	测试22	测试23	\N	\N	\N	normal				video	\N	\N
1935	114	113	请求添加好友【已通过】	text	f	2025-11-25 20:30:58.230263	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1936	113	114	请求添加好友【已通过】	text	f	2025-11-25 20:30:58.239622	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1937	113	114	111	text	f	2025-11-25 20:31:04.195182	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1938	113	114	22	text	f	2025-11-25 20:31:11.838359	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1939	113	114	999	text	f	2025-11-25 20:36:55.163121	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1940	113	114	000	text	f	2025-11-25 20:37:10.688469	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1941	113	114	999	text	t	2025-11-25 20:37:36.860868	2025-11-25 20:37:38.508453	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1942	113	114	111	text	f	2025-11-25 20:40:38.814614	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1943	113	114	222	text	f	2025-11-25 20:44:24.81414	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1944	113	114	33	text	f	2025-11-25 20:44:52.658456	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1945	113	114	444	text	t	2025-11-25 20:45:06.030933	2025-11-25 20:45:06.122649	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1946	113	114	555	text	t	2025-11-25 20:45:14.593804	2025-11-25 20:45:14.73758	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1947	113	114	666	text	f	2025-11-25 20:48:38.570261	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1948	113	114	888	text	f	2025-11-25 20:48:49.079406	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1949	113	114	999	text	f	2025-11-25 20:48:58.314793	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1950	113	114	000	text	f	2025-11-25 20:55:11.542241	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1951	113	114	111	text	f	2025-11-25 20:55:16.572383	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1952	113	114	222	text	f	2025-11-25 20:55:22.039835	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1886	102	107	请求添加好友【已驳回】	text	t	2025-11-25 12:30:31.013846	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
1885	102	107	请求添加好友【已驳回】	text	t	2025-11-25 12:29:40.196891	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
1953	113	114	333	text	t	2025-11-25 20:56:30.069188	2025-11-25 20:56:30.199542	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1954	113	114	44	text	t	2025-11-25 20:59:30.390662	2025-11-25 20:59:30.698297	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1955	113	114	55	text	t	2025-11-25 21:05:10.714131	2025-11-25 21:05:11.100257	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1956	113	114	66	text	t	2025-11-25 21:05:14.934423	2025-11-25 21:05:15.335034	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1957	113	114	777	text	t	2025-11-25 21:12:42.840403	2025-11-25 21:12:42.973506	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1958	114	113	请求添加好友【已通过】	text	f	2025-11-25 22:34:30.28956	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1959	113	114	请求添加好友【已通过】	text	f	2025-11-25 22:34:30.294191	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1960	114	113	请求添加好友【已通过】	text	f	2025-11-25 22:55:50.082671	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1961	113	114	请求添加好友【已通过】	text	f	2025-11-25 22:55:50.085073	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1962	114	113	请求添加好友【已驳回】	text	f	2025-11-25 22:56:41.468425	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1963	114	113	请求添加好友【已驳回】	text	f	2025-11-25 22:57:34.9493	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1964	114	113	请求添加好友【已通过】	text	f	2025-11-25 22:59:48.978688	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1965	113	114	请求添加好友【已通过】	text	f	2025-11-25 22:59:48.980343	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1966	113	114	111	text	f	2025-11-25 22:59:58.260783	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1967	113	114	222	text	f	2025-11-25 23:00:29.521927	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1968	113	114	333	text	f	2025-11-25 23:00:53.868439	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1969	113	114	444	text	f	2025-11-25 23:02:14.220962	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1970	113	114	555	text	f	2025-11-25 23:03:43.272079	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1971	113	114	66	text	f	2025-11-25 23:05:00.798408	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1972	113	114	77	text	f	2025-11-25 23:05:09.578034	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1973	113	114	88	text	f	2025-11-25 23:07:02.074112	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1974	113	114	00	text	f	2025-11-25 23:11:22.713101	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1975	113	114	111	text	f	2025-11-25 23:11:32.75305	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1976	113	114	22	text	t	2025-11-25 23:12:04.194139	2025-11-25 23:12:04.303297	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1977	113	114	33	text	t	2025-11-25 23:15:03.269903	2025-11-25 23:15:03.62112	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1978	113	114	44	text	f	2025-11-25 23:15:35.835828	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1979	113	114	55	text	f	2025-11-25 23:15:42.834547	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1980	113	114	22	text	f	2025-11-26 07:38:22.966654	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1981	114	107	请求添加好友【已通过】	text	f	2025-11-26 08:01:46.582499	\N	测试23	测试06	\N	\N	\N	normal				\N	\N	\N
1982	107	114	请求添加好友【已通过】	text	f	2025-11-26 08:01:46.586933	\N	测试06	测试23	\N	\N	\N	normal				\N	\N	\N
1983	114	107	111	text	f	2025-11-26 08:02:07.381862	\N	测试23	测试06	\N	\N	\N	normal				\N	\N	\N
1984	114	106	请求添加好友【已通过】	text	f	2025-11-26 08:05:12.511448	\N	测试23	测试05	\N	\N	\N	normal				\N	\N	\N
1985	106	114	请求添加好友【已通过】	text	f	2025-11-26 08:05:12.514915	\N	测试05	测试23	\N	\N	\N	normal				\N	\N	\N
1986	114	105	请求添加好友【已通过】	text	f	2025-11-26 08:05:14.452565	\N	测试23	测试04	\N	\N	\N	normal				\N	\N	\N
1987	105	114	请求添加好友【已通过】	text	f	2025-11-26 08:05:14.454765	\N	测试04	测试23	\N	\N	\N	normal				\N	\N	\N
1988	114	104	请求添加好友【已通过】	text	f	2025-11-26 08:05:16.169219	\N	测试23	测试03	\N	\N	\N	normal				\N	\N	\N
1989	104	114	请求添加好友【已通过】	text	f	2025-11-26 08:05:16.17211	\N	测试03	测试23	\N	\N	\N	normal				\N	\N	\N
1990	114	103	请求添加好友【已通过】	text	f	2025-11-26 08:05:17.69953	\N	测试23	测试2	\N	\N	\N	normal				\N	\N	\N
1991	103	114	请求添加好友【已通过】	text	f	2025-11-26 08:05:17.700701	\N	测试2	测试23	\N	\N	\N	normal				\N	\N	\N
1992	109	114	请求添加好友【已驳回】	text	f	2025-11-26 08:17:56.284543	\N	测试08	测试23	\N	\N	\N	normal				\N	\N	\N
1993	109	114	请求添加好友【已通过】	text	f	2025-11-26 08:18:47.101008	\N	测试08	测试23	\N	\N	\N	normal				\N	\N	\N
1994	114	109	请求添加好友【已通过】	text	f	2025-11-26 08:18:47.103144	\N	测试23	测试08	\N	\N	\N	normal				\N	\N	\N
1995	113	114	22	text	f	2025-11-26 10:19:07.773563	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1996	113	114	44	text	f	2025-11-26 10:19:19.71841	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1997	113	114	555	text	f	2025-11-26 10:21:01.306717	\N	测试22	测试23	\N	\N	\N	normal				\N	\N	\N
1998	114	113	6666	text	f	2025-11-26 10:21:23.919344	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
1999	114	113	7777	text	f	2025-11-26 10:32:44.468963	\N	测试23	测试22	\N	\N	\N	normal				\N	\N	\N
2000	113	103	请求添加好友【已通过】	text	f	2025-11-26 10:37:08.008365	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2001	103	113	请求添加好友【已通过】	text	f	2025-11-26 10:37:08.010234	\N	测试2	测试22	\N	\N	\N	normal				\N	\N	\N
2002	113	103	11	text	f	2025-11-26 10:37:28.837142	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2003	104	113	请求添加好友【已通过】	text	f	2025-11-26 10:52:25.568023	\N	测试03	测试22	\N	\N	\N	normal				\N	\N	\N
2004	113	104	请求添加好友【已通过】	text	f	2025-11-26 10:52:25.570089	\N	测试22	测试03	\N	\N	\N	normal				\N	\N	\N
2005	113	104	111	text	f	2025-11-26 10:52:42.725239	\N	测试22	测试03	\N	\N	\N	normal				\N	\N	\N
2006	103	113	444	text	f	2025-11-26 10:59:24.549707	\N	测试2	测试22	\N	\N	\N	normal				\N	\N	\N
2007	103	113	5555	text	f	2025-11-26 11:00:33.272851	\N	测试2	测试22	\N	\N	\N	normal				\N	\N	\N
2008	103	113	www	text	f	2025-11-26 11:02:28.895357	\N	测试2	测试22	\N	\N	\N	normal				\N	\N	\N
2009	103	113	aaaa	text	f	2025-11-26 11:02:37.720391	\N	测试2	测试22	\N	\N	\N	normal				\N	\N	\N
2010	113	103	11	text	f	2025-11-26 11:03:42.224729	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2011	113	103	22	text	f	2025-11-26 11:03:51.40169	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2012	113	103	33	text	f	2025-11-26 11:05:01.870463	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2013	113	103	444	text	f	2025-11-26 11:05:24.33803	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2014	113	103	22	text	f	2025-11-26 11:10:58.008582	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2015	113	103	333	text	f	2025-11-26 11:11:03.554296	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2016	113	103	444	text	f	2025-11-26 11:11:04.946804	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2017	113	103	55	text	f	2025-11-26 11:11:05.86365	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2018	113	103	666	text	f	2025-11-26 11:11:26.055705	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2019	113	103	77	text	f	2025-11-26 11:13:38.098835	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2020	113	103	88	text	t	2025-11-26 11:13:49.536993	2025-11-26 11:13:49.648458	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2022	113	103	00	text	f	2025-11-26 11:14:00.713159	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2021	113	103	99	text	t	2025-11-26 11:13:50.596686	2025-11-26 11:13:50.761916	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2023	113	103	11	text	f	2025-11-26 11:14:33.472011	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2024	113	103	222	text	f	2025-11-26 11:14:49.42206	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2026	113	103	444	text	f	2025-11-26 11:20:01.903223	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2025	113	103	333	text	f	2025-11-26 11:15:08.610481	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2027	113	103	555	text	f	2025-11-26 11:31:11.090144	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2028	113	103	666	text	f	2025-11-26 11:31:19.479582	\N	测试22	测试2	\N	\N	\N	normal				\N	\N	\N
2029	113	114	11	text	f	2025-11-26 11:57:33.582197	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129384_JPEG_20251126_115624_1671823011779936550.jpg		\N	\N	\N
2030	113	114	123	text	f	2025-11-26 12:02:29.405953	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2031	113	114	34346	text	f	2025-11-26 12:02:31.35331	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2032	114	113	tygg	text	f	2025-11-26 12:02:38.645398	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2033	114	113	festival	text	f	2025-11-26 12:02:40.985446	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2034	114	113	sad	text	f	2025-11-26 12:08:51.230361	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2035	114	113	sad	text	f	2025-11-26 12:08:51.671237	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2036	114	113	dd	text	f	2025-11-26 12:08:52.655296	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2037	114	113	ssddddffddeed	text	f	2025-11-26 12:09:19.932927	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2038	113	114	333	text	t	2025-11-26 12:11:09.047954	2025-11-26 12:11:09.17067	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2039	114	113	tgdd	text	f	2025-11-26 12:11:25.500475	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2040	114	113	shhd	text	f	2025-11-26 12:11:37.368328	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2041	114	113	shhdddd	text	f	2025-11-26 12:11:38.296014	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2042	114	113	sd	text	f	2025-11-26 12:11:39.433408	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2043	114	113	sdsdd	text	f	2025-11-26 12:11:40.280287	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2044	113	114	1112	text	f	2025-11-26 12:17:05.8188	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2045	113	114	333	text	f	2025-11-26 12:17:13.974809	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2046	114	113	dude	text	f	2025-11-26 12:17:31.997895	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2047	114	113	sss	text	f	2025-11-26 12:17:34.650743	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2048	114	113	ddxx	text	f	2025-11-26 12:17:36.585184	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2049	114	113	ddfc	text	f	2025-11-26 12:17:38.729108	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2050	113	114	123	text	t	2025-11-26 12:17:54.949594	2025-11-26 12:17:55.006089	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2051	113	114	123	text	t	2025-11-26 12:17:56.072729	2025-11-26 12:17:56.243414	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2052	113	114	312	text	t	2025-11-26 12:17:57.444656	2025-11-26 12:17:57.674886	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2053	113	114	123	text	t	2025-11-26 12:17:58.761001	2025-11-26 12:17:59.029411	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2219	116	117	请求添加好友【已通过】	text	t	2025-11-26 22:23:22.115869	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal				\N	\N	\N
1830	102	103	111	text	t	2025-11-24 20:26:12.091085	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2055	113	114	2222	text	f	2025-11-26 12:32:39.963274	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2054	113	114	asd	text	t	2025-11-26 12:18:33.948495	2025-11-26 12:18:33.99656	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2056	113	114	333	text	f	2025-11-26 12:32:41.675497	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2057	113	114	44	text	f	2025-11-26 12:33:35.695892	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2058	113	114	5	text	f	2025-11-26 12:37:35.438006	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2059	113	114	55	text	f	2025-11-26 12:37:37.634144	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2060	113	114	77	text	f	2025-11-26 12:42:18.766272	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2061	113	114	88	text	f	2025-11-26 12:42:22.016746	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2062	113	103	77	text	f	2025-11-26 12:42:25.245639	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2063	113	103	88	text	f	2025-11-26 12:42:27.080559	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2064	113	104	11	text	f	2025-11-26 12:42:29.613855	\N	测试22	测试03	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2065	113	104	22	text	f	2025-11-26 12:42:31.791924	\N	测试22	测试03	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2066	113	114	[emotion:1_Smile.png]	text	f	2025-11-26 12:43:06.073171	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2067	113	114	55	text	f	2025-11-26 12:43:57.599686	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2068	113	114	66	text	f	2025-11-26 12:44:20.58074	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2069	114	113	ffdd	text	f	2025-11-26 12:49:22.234261	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2070	114	113	hgff	text	f	2025-11-26 12:49:31.634436	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2071	113	114	11	text	f	2025-11-26 13:08:17.745956	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2072	113	114	33	text	f	2025-11-26 13:11:32.492014	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2073	113	114	333	text	f	2025-11-26 13:17:13.662404	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2074	113	114	钱钱钱	text	f	2025-11-26 13:23:55.474149	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2075	113	114	1	text	f	2025-11-26 13:23:57.667056	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2076	113	114	2222	text	f	2025-11-26 13:24:00.067869	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2077	113	114	333	text	f	2025-11-26 13:24:01.057895	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2078	114	113	444	text	f	2025-11-26 13:24:13.362623	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2079	114	113	555	text	f	2025-11-26 13:24:16.282265	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2080	113	114	666	text	f	2025-11-26 13:28:31.043972	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2220	116	117	你好	text	t	2025-11-26 22:23:29.75484	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal				\N	\N	\N
1831	102	103	333	text	t	2025-11-24 20:26:23.884625	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2081	113	114	777	text	f	2025-11-26 13:28:36.135703	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2082	113	114	88	text	f	2025-11-26 13:29:50.325813	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2083	113	114	999	text	f	2025-11-26 13:31:40.203752	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2084	113	114	00	text	f	2025-11-26 13:32:11.921133	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2085	113	114	111	text	f	2025-11-26 13:32:50.243124	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2086	113	114	222	text	f	2025-11-26 13:32:56.957358	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2087	113	114	33	text	f	2025-11-26 13:33:04.379139	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2090	114	113	666	text	f	2025-11-26 13:33:45.795866	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2092	114	113	hhgg	text	f	2025-11-26 13:42:44.177772	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2093	114	113	6767)	text	f	2025-11-26 13:42:54.344521	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2094	114	113	566	text	f	2025-11-26 13:42:58.0289	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2095	114	113	7766	text	f	2025-11-26 13:43:01.112829	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2088	113	114	44	text	f	2025-11-26 13:33:27.066923	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2089	114	113	5555	text	f	2025-11-26 13:33:40.561138	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2091	114	113	hhgg	text	f	2025-11-26 13:42:43.056196	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2096	113	114	00	text	f	2025-11-26 13:48:35.630699	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2097	113	114	11	text	t	2025-11-26 13:48:42.211779	2025-11-26 13:48:42.269561	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2098	113	114	22	text	t	2025-11-26 13:48:43.565998	2025-11-26 13:48:43.721742	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2099	113	114	33	text	t	2025-11-26 13:48:45.066302	2025-11-26 13:48:45.158014	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2100	113	114	44	text	t	2025-11-26 13:48:46.491504	2025-11-26 13:48:46.576137	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2101	113	114	55	text	t	2025-11-26 13:48:47.725571	2025-11-26 13:48:47.81653	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2102	113	114	66	text	t	2025-11-26 13:48:49.326687	2025-11-26 13:48:49.457572	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2103	113	114	77	text	t	2025-11-26 13:48:50.701975	2025-11-26 13:48:50.786104	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2104	113	114	88	text	t	2025-11-26 13:48:52.06733	2025-11-26 13:48:52.221898	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2105	113	114	99	text	t	2025-11-26 13:48:53.466157	2025-11-26 13:48:53.514493	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2106	113	114	00	text	t	2025-11-26 13:48:54.911368	2025-11-26 13:48:54.978488	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
1832	102	103	555	text	t	2025-11-24 20:26:35.453862	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
1840	102	103	111	text	t	2025-11-24 21:29:39.224277	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2107	113	114	11	text	t	2025-11-26 13:48:56.394392	2025-11-26 13:48:56.523224	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2108	113	114	22	text	t	2025-11-26 13:48:57.783716	2025-11-26 13:48:57.846414	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2109	113	114	33	text	t	2025-11-26 13:48:59.205524	2025-11-26 13:48:59.282603	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2110	113	114	44	text	t	2025-11-26 13:49:00.563982	2025-11-26 13:49:00.722997	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2111	113	114	55	text	t	2025-11-26 13:49:02.100919	2025-11-26 13:49:02.259779	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2112	113	114	66	text	t	2025-11-26 13:49:03.48287	2025-11-26 13:49:03.590811	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2113	113	114	77	text	t	2025-11-26 13:49:04.770714	2025-11-26 13:49:04.918977	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2114	113	114	88	text	t	2025-11-26 13:49:06.05123	2025-11-26 13:49:06.150949	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2115	113	114	99	text	t	2025-11-26 13:49:07.43417	2025-11-26 13:49:07.586438	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2116	113	114	00	text	t	2025-11-26 13:49:08.822913	2025-11-26 13:49:08.908534	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2117	113	114	11	text	t	2025-11-26 13:49:10.150306	2025-11-26 13:49:10.244224	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2118	113	114	22	text	t	2025-11-26 13:49:11.439107	2025-11-26 13:49:11.57056	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2119	113	114	33	text	t	2025-11-26 13:49:12.694618	2025-11-26 13:49:12.795306	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2120	113	114	44	text	t	2025-11-26 13:49:14.02286	2025-11-26 13:49:14.143384	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2121	113	114	55	text	t	2025-11-26 13:49:15.405753	2025-11-26 13:49:15.560621	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2122	113	114	66	text	t	2025-11-26 13:49:16.744301	2025-11-26 13:49:16.89366	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2123	113	114	77	text	t	2025-11-26 13:49:18.103732	2025-11-26 13:49:18.237082	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2124	113	114	88	text	t	2025-11-26 13:49:19.567801	2025-11-26 13:49:19.664636	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2125	113	114	99	text	t	2025-11-26 13:49:20.882722	2025-11-26 13:49:20.993921	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2126	113	114	00	text	t	2025-11-26 13:49:22.210617	2025-11-26 13:49:22.325941	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2127	114	113	11	text	f	2025-11-26 13:49:31.027987	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2128	114	113	22	text	f	2025-11-26 13:49:32.583428	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2129	114	113	33	text	f	2025-11-26 13:49:34.037897	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2130	114	113	44	text	f	2025-11-26 13:49:35.368024	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2131	114	113	55	text	f	2025-11-26 13:49:36.686834	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2132	114	113	66	text	f	2025-11-26 13:49:38.504308	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
1841	102	103	😁	text	t	2025-11-24 21:30:33.951968	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2133	114	113	77	text	f	2025-11-26 13:49:40.613466	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2134	114	113	88	text	f	2025-11-26 13:49:42.015401	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2135	114	113	99	text	f	2025-11-26 13:49:43.419393	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2136	114	113	00	text	f	2025-11-26 13:49:45.048781	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2137	114	113	11	text	f	2025-11-26 13:49:46.982381	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2138	114	113	22	text	f	2025-11-26 13:49:48.413129	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2139	114	113	33	text	f	2025-11-26 13:49:50.378631	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2140	114	113	44	text	f	2025-11-26 13:49:51.776059	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2141	114	113	55	text	f	2025-11-26 13:49:53.21882	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2142	114	113	66	text	f	2025-11-26 13:49:57.426747	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2143	114	113	77	text	f	2025-11-26 13:50:00.597366	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2144	114	113	88	text	f	2025-11-26 13:50:02.114093	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2145	114	113	99	text	f	2025-11-26 13:50:04.184238	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2146	114	113	00	text	f	2025-11-26 13:50:06.187312	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2147	114	113	11	text	f	2025-11-26 13:50:07.594532	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2148	114	113	22	text	f	2025-11-26 13:50:09.440824	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2149	114	113	33	text	f	2025-11-26 13:50:10.93258	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2150	114	113	44	text	f	2025-11-26 13:50:12.576008	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2151	114	113	55	text	f	2025-11-26 13:50:13.988357	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2152	114	113	66	text	f	2025-11-26 13:50:15.321763	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2153	114	113	77	text	f	2025-11-26 13:50:16.50511	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2154	114	113	88	text	f	2025-11-26 13:50:17.822916	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2155	114	113	99	text	f	2025-11-26 13:50:19.07915	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2156	114	113	00	text	f	2025-11-26 13:50:20.229835	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2157	114	113	11	text	f	2025-11-26 13:50:21.544745	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2158	114	113	22	text	f	2025-11-26 13:50:22.473258	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2159	114	113	22	text	f	2025-11-26 13:50:22.666793	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2160	114	113	44	text	f	2025-11-26 13:50:24.324923	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2161	114	113	55	text	f	2025-11-26 13:50:25.493088	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2162	114	113	66	text	f	2025-11-26 13:50:26.557144	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2163	114	113	7788	text	f	2025-11-26 13:50:30.185479	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2164	114	113	99	text	f	2025-11-26 13:50:33.317841	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2165	114	113	00	text	f	2025-11-26 13:50:34.744745	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2166	114	113	11	text	f	2025-11-26 13:50:35.921087	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2167	114	113	22	text	f	2025-11-26 13:50:37.03959	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2168	114	113	aa	text	f	2025-11-26 13:55:49.02796	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2169	114	113	qq	text	f	2025-11-26 13:55:52.49383	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2170	114	113	ww	text	f	2025-11-26 13:56:13.039468	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2171	113	114	111	text	f	2025-11-26 14:18:31.605209	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2172	113	114	22	text	f	2025-11-26 14:18:33.697774	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2173	113	114	33	text	f	2025-11-26 14:18:34.952541	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2174	114	113	444	text	f	2025-11-26 14:18:41.854331	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2175	114	113	555	text	f	2025-11-26 14:18:44.293792	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2176	114	113	666	text	f	2025-11-26 14:18:47.092192	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2177	114	113	777	text	f	2025-11-26 14:18:49.605545	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2178	113	114	11	text	f	2025-11-26 14:19:14.568415	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2179	114	113	😃	text	f	2025-11-26 14:19:35.384441	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2180	114	113	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764137985_JPEG_20251126_141946_7857814876190130443.jpg	image	f	2025-11-26 14:19:48.41228	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2181	113	114	[emotion:42_NosePick.png]	text	t	2025-11-26 14:20:21.80073	2025-11-26 14:20:21.944664	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2182	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764138031_ic_launcher.png	image	t	2025-11-26 14:20:33.825406	2025-11-26 14:20:33.886823	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2183	113	114	322	text	t	2025-11-26 14:20:33.973379	2025-11-26 14:20:34.205845	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2184	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764138046_2637-161442811_tiny.mp4	video	t	2025-11-26 14:20:52.710133	2025-11-26 14:20:52.836029	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2185	113	114	444	text	t	2025-11-26 14:20:52.874186	2025-11-26 14:20:53.113163	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2186	113	114	55	text	f	2025-11-26 14:30:22.069686	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2187	113	114	66	text	f	2025-11-26 14:30:23.426573	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2188	114	113	11	text	f	2025-11-26 14:30:51.059213	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2189	114	113	33	text	f	2025-11-26 14:30:54.200699	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2190	113	114	00:12	call_ended_video	t	2025-11-26 14:32:29.968865	2025-11-26 14:32:30.110749	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	video	\N	\N
2191	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764140667_JPEG_20251126_150428_1878458380162378301.jpg	image	f	2025-11-26 15:04:30.360006	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2192	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764140691_scaled_4704a5e0-6434-4e7b-af3c-c0ea29afff4d5426499907645439188.jpg	image	f	2025-11-26 15:04:55.661859	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2193	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764140981_JPEG_20251126_150941_8789028214721261209.jpg	image	f	2025-11-26 15:09:44.106995	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2194	114	114	44333	text	f	2025-11-26 15:10:54.353877	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2195	114	114	zxff	text	f	2025-11-26 15:14:22.031984	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2196	114	114	zxff	text	f	2025-11-26 15:14:22.697154	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2197	114	114	hgxf	text	f	2025-11-26 15:14:26.578792	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2198	114	114	5555	text	f	2025-11-26 15:15:00.256163	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2199	114	114	666	text	f	2025-11-26 15:15:17.270003	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2200	114	114	7777	text	f	2025-11-26 15:17:54.204155	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2201	114	114	hhg	text	f	2025-11-26 15:18:05.238051	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2202	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141493_JPEG_20251126_151813_4656255887350295458.jpg	image	f	2025-11-26 15:18:15.796709	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2203	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141610_ic_launcher.png	image	f	2025-11-26 15:20:12.413807	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2204	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764141620_2637-161442811_tiny.mp4	video	f	2025-11-26 15:20:27.200615	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2205	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1764141639_test_voice_py	file	f	2025-11-26 15:20:41.473234	\N	测试22	测试23	test_voice_py	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2206	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141705_JPEG_20251126_152145_3615330885970552040.jpg	image	f	2025-11-26 15:21:47.333719	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2207	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141765_JPEG_20251126_152245_8946593931332298050.jpg	image	f	2025-11-26 15:22:47.279398	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2225	116	117	在干嘛	text	t	2025-11-26 22:31:23.52003	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal				\N	\N	\N
1909	102	112	999	text	t	2025-11-25 15:32:25.553126	2025-12-19 10:04:38.716468	测试01	测试21	\N	\N	\N	normal				\N	\N	\N
2208	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764141780_1764141620_2637-161442811_tiny.mp4	video	f	2025-11-26 15:23:05.872133	\N	测试23	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2209	114	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1764141793_1764141639_test_voice_py	file	f	2025-11-26 15:23:15.601086	\N	测试23	测试23	1764141639_test_voice_py	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2210	114	113	111	text	f	2025-11-26 15:24:04.4462	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2211	113	114	22	text	t	2025-11-26 15:24:33.883983	2025-11-26 15:24:33.984988	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2212	114	113	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764141891_JPEG_20251126_152451_3707027135882267997.jpg	image	f	2025-11-26 15:24:54.006747	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2213	113	114	123	text	f	2025-11-26 15:50:57.649146	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2214	113	114	111	text	f	2025-11-26 16:07:26.591638	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2215	113	114	22	text	f	2025-11-26 16:07:28.755541	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2216	114	113	yytf	text	f	2025-11-26 16:07:39.196197	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2217	114	113	rcc	text	f	2025-11-26 16:07:42.19285	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2768	141	116	好的	text	t	2025-12-06 01:19:46.015883	2025-12-06 09:19:50.127315	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2769	116	141	你好	text	t	2025-12-06 01:19:54.542746	2025-12-06 09:19:54.618806	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
3017	148	150	？	text	t	2025-12-14 02:06:25.863993	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2770	116	141	1	text	t	2025-12-06 01:19:56.690499	2025-12-06 09:19:57.158261	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2771	116	141	1	text	t	2025-12-06 01:19:57.913531	2025-12-06 09:19:57.979414	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2772	116	141	1	text	t	2025-12-06 01:19:59.580526	2025-12-06 09:19:59.642621	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2773	116	141	1	text	t	2025-12-06 01:20:00.970351	2025-12-06 09:20:01.04249	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2777	148	149	请求添加好友【已驳回】	text	t	2025-12-06 10:27:52.719104	2025-12-06 10:27:54.013575	阿迪	苏	\N	\N	\N	normal				\N	\N	\N
2786	148	150	111	text	t	2025-12-06 02:34:39.298784	2025-12-06 10:34:39.549098	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2787	150	148	哈喽	text	t	2025-12-06 02:34:42.505647	2025-12-06 10:34:42.593618	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2788	150	148	美女你好	text	t	2025-12-06 02:34:50.751023	2025-12-06 10:34:50.83497	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2789	148	150	你给我发一个视频看一下	text	t	2025-12-06 02:34:50.95571	2025-12-06 10:34:51.222882	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2790	148	150	00:36	call_ended_video	t	2025-12-06 02:35:35.779753	2025-12-06 10:35:36.232695	阿迪	大江	\N	\N	\N	normal				video	\N	\N
2791	150	148	是不是听不见声音，	text	t	2025-12-06 02:35:44.076079	2025-12-06 10:35:44.174676	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2792	148	150	可以听见	text	t	2025-12-06 02:36:00.250539	2025-12-06 10:36:00.576069	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2793	148	150	00:27	call_ended	t	2025-12-06 02:36:35.318616	2025-12-06 10:36:35.543138	阿迪	大江	\N	\N	\N	normal				voice	\N	\N
2795	150	148	找不到发音条的了，	text	t	2025-12-06 02:37:11.685228	2025-12-06 10:37:39.148694	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2796	150	148	这个软件是不是发不了语音条	text	t	2025-12-06 02:37:22.349042	2025-12-06 10:37:39.148694	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2797	148	150	好像是	text	t	2025-12-06 02:37:46.572823	2025-12-06 10:37:46.865291	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2816	149	150	不准	text	t	2025-12-06 02:40:52.504995	2025-12-06 10:40:52.747004	苏	大江	\N	\N	\N	normal				\N	\N	\N
2817	150	149	买肉肠来烤，	text	t	2025-12-06 02:40:55.087652	2025-12-06 10:40:55.180752	大江	苏	\N	\N	\N	normal				\N	\N	\N
2818	150	149	那你不要参加哦，	text	t	2025-12-06 02:41:01.518514	2025-12-06 10:41:01.618092	大江	苏	\N	\N	\N	normal				\N	\N	\N
2819	150	149	不要，我把火起来了，你又开始屁颠屁颠跑过来蹭了，	text	t	2025-12-06 02:41:09.828402	2025-12-06 10:41:09.917977	大江	苏	\N	\N	\N	normal				\N	\N	\N
2820	149	150	我天天洗澡身上一点也不痒	text	t	2025-12-06 02:41:13.283924	2025-12-06 10:41:13.495789	苏	大江	\N	\N	\N	normal				\N	\N	\N
2821	149	150	你是皮痒了	text	t	2025-12-06 02:41:33.196028	2025-12-06 10:41:33.399429	苏	大江	\N	\N	\N	normal				\N	\N	\N
2822	150	149	不在一个频道，	text	t	2025-12-06 02:41:34.649462	2025-12-06 10:41:34.74851	大江	苏	\N	\N	\N	normal				\N	\N	\N
2824	149	150	我晚上还是喝点茶，赏赏月吧	text	t	2025-12-06 02:42:24.79313	2025-12-06 10:42:25.273017	苏	大江	\N	\N	\N	normal				\N	\N	\N
2825	149	150	我买了月饼	text	t	2025-12-06 02:42:28.973887	2025-12-06 10:42:29.18249	苏	大江	\N	\N	\N	normal				\N	\N	\N
2826	150	149	那你一定不要来参加，等一下别把我害了，	text	t	2025-12-06 02:42:42.052208	2025-12-06 10:42:42.183079	大江	苏	\N	\N	\N	normal				\N	\N	\N
2823	149	148	阿迪，阿迪，收到请回答	text	t	2025-12-06 02:42:06.56438	2025-12-06 10:44:38.937826	苏	阿迪	\N	\N	\N	normal				\N	\N	\N
2227	116	118	请求添加好友【已通过】	text	f	2025-11-26 22:31:50.40564	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2228	116	118	1	text	f	2025-11-26 22:31:54.818395	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2229	118	116	1	text	t	2025-11-26 22:31:57.10893	2025-11-26 22:31:57.304042	有度	秋风1	\N	\N	\N	normal				\N	\N	\N
2230	116	118	有问题	text	f	2025-11-26 22:32:02.04648	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2281	120	118	00:20	call_ended	t	2025-11-27 03:43:17.564898	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				voice	\N	\N
2231	118	116	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764167529_paste_1764167532282.png	image	t	2025-11-26 22:32:10.425275	2025-11-26 22:32:10.67542	有度	秋风1	\N	\N	\N	normal				\N	\N	\N
2232	116	118	自己发的信息关闭聊天框以后就看不到了	text	f	2025-11-26 22:32:32.991023	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2233	116	118	你好	text	f	2025-11-26 22:32:46.689003	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2234	116	118	111	text	f	2025-11-26 22:32:50.214866	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2278	120	118	1	text	t	2025-11-27 03:42:26.847144	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2235	118	116	123	text	t	2025-11-26 22:32:52.132195	2025-11-26 22:32:52.35246	有度	秋风1	\N	\N	\N	normal				\N	\N	\N
2236	116	118	111111	text	f	2025-11-26 22:32:54.612238	\N	秋风1	有度	\N	\N	\N	normal				\N	\N	\N
2336	117	116	nihao	text	t	2025-11-28 13:45:41.980925	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2237	118	116	33	text	t	2025-11-26 22:32:54.950054	2025-11-26 22:32:55.224288	有度	秋风1	\N	\N	\N	normal				\N	\N	\N
3016	148	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765677950_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	image	t	2025-12-14 02:05:52.041371	2025-12-14 10:06:22.147447	阿迪	苏	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N	\N
2262	102	119	请求添加好友【已通过】	text	f	2025-11-27 02:52:28.477091	\N	测试01	侧式0	\N	\N	\N	normal				\N	\N	\N
2263	119	102	请求添加好友【已通过】	text	f	2025-11-27 02:52:28.479264	\N	侧式0	测试01	\N	\N	\N	normal				\N	\N	\N
2270	118	120	1	text	f	2025-11-27 03:36:38.959142	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2271	120	121	请求添加好友【已通过】	text	f	2025-11-27 03:40:05.498437	\N	有度2	有度3	\N	\N	\N	normal				\N	\N	\N
2272	121	120	请求添加好友【已通过】	text	f	2025-11-27 03:40:05.499881	\N	有度3	有度2	\N	\N	\N	normal				\N	\N	\N
2343	127	126	1111	text	t	2025-11-28 13:55:56.252624	2025-12-14 17:25:42.800197	222	123	\N	\N	\N	normal				\N	\N	\N
2274	118	120	1	text	f	2025-11-27 03:42:14.735696	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2238	118	116	这个是什么意思	quoted	t	2025-11-26 22:33:45.465867	2025-12-07 13:02:56.849698	有度	秋风1	\N	6	自己发的信息关闭聊天框以后就看不到了	normal				\N	\N	\N
2275	120	118	1111	text	t	2025-11-27 03:42:19.301431	2025-11-27 03:42:19.69685	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2342	127	126	请求添加好友【已通过】	text	t	2025-11-28 13:55:45.46758	2025-12-14 17:25:42.800197	222	123	\N	\N	\N	normal				\N	\N	\N
2276	120	118	1	text	t	2025-11-27 03:42:20.218177	2025-11-27 03:42:20.643358	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2774	116	141	1	text	t	2025-12-06 01:20:06.618717	2025-12-15 23:45:11.793518	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2277	120	118	1	text	t	2025-11-27 03:42:21.003588	2025-11-27 03:42:21.40959	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2279	118	120	对方已拒绝	call_rejected	f	2025-11-27 03:42:46.37631	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2280	118	120	00:20	call_ended	f	2025-11-27 03:43:17.551432	\N	有度	有度2	\N	\N	\N	normal				voice	\N	\N
2282	118	120	00:20	call_ended	f	2025-11-27 03:43:17.753125	\N	有度	有度2	\N	\N	\N	normal				voice	\N	\N
2288	118	120	111	text	f	2025-11-27 03:44:13.090049	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2289	118	120	222	text	f	2025-11-27 03:44:21.007465	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2290	118	120	111	text	f	2025-11-27 03:44:41.308997	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2291	118	120	网	text	f	2025-11-27 03:44:50.12173	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2302	116	118	1111	text	f	2025-11-27 14:59:20.513568	\N	秋风1	有度	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2304	103	125	请求添加好友【已驳回】	text	f	2025-11-27 19:47:51.099314	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2305	125	103	请求添加好友【已驳回】	text	f	2025-11-27 19:48:32.529908	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3514	102	103	77	text	t	2026-03-01 04:29:01.216727	2026-03-01 12:29:01.274163	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	277	\N
3582	102	103	5	text	t	2026-03-01 05:59:20.698057	2026-03-01 13:59:20.730224	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	189	\N
2678	128	127	22	text	t	2025-12-05 04:07:16.313226	2025-12-06 01:15:16.572537	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
2344	128	127	请求添加好友【已通过】	text	t	2025-11-28 14:11:40.52006	2025-12-06 01:15:16.572537	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
3015	148	151	你好你好	text	t	2025-12-14 02:05:28.270997	2025-12-14 10:06:36.132512	阿迪	王先生	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2244	113	103	111	text	f	2025-11-26 23:57:39.51476	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2250	103	113	222	text	f	2025-11-27 00:33:11.50663	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2253	113	109	请求添加好友【已通过】	text	f	2025-11-27 00:41:09.822114	\N	测试22	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2254	109	113	请求添加好友【已通过】	text	f	2025-11-27 00:41:09.823399	\N	测试08	测试22	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2266	104	102	请求添加好友【已通过】	text	f	2025-11-27 02:53:25.390382	\N	测试03	测试01	\N	\N	\N	normal				\N	\N	\N
2267	102	104	请求添加好友【已通过】	text	f	2025-11-27 02:53:25.39175	\N	测试01	测试03	\N	\N	\N	normal				\N	\N	\N
2268	118	120	请求添加好友【已通过】	text	f	2025-11-27 03:36:30.56529	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2348	128	130	请求添加好友【已通过】	text	f	2025-11-28 14:23:55.158391	\N	测试902	测试905	\N	\N	\N	normal				\N	\N	\N
2339	103	102	请求添加好友【已通过】	text	t	2025-11-28 13:51:24.260587	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2265	103	102	请求添加好友【已通过】	text	t	2025-11-27 02:52:40.573613	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2269	120	118	请求添加好友【已通过】	text	t	2025-11-27 03:36:30.566905	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2354	131	132	请求添加好友【已通过】	text	f	2025-11-28 14:27:22.486155	\N	测试906	测试907	\N	\N	\N	normal				\N	\N	\N
2355	132	131	请求添加好友【已通过】	text	f	2025-11-28 14:27:22.487334	\N	测试907	测试906	\N	\N	\N	normal				\N	\N	\N
2382	117	109	请求添加好友【已通过】	text	f	2025-11-28 16:03:36.441356	\N	秋风2	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png		\N	\N	\N
2239	118	116	[emotion:1_Smile.png]	text	t	2025-11-26 22:38:27.795631	2025-12-07 13:02:56.849698	有度	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2443	143	144	请求添加好友【已通过】	text	t	2025-11-30 15:59:43.341472	2025-12-11 12:09:13.223696	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
2431	114	113	请求添加好友【已通过】	text	f	2025-11-29 23:46:12.714759	\N	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2432	113	114	请求添加好友【已通过】	text	f	2025-11-29 23:46:12.717065	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
3018	148	149	00:11	call_ended	t	2025-12-14 02:19:34.418615	2025-12-14 10:19:34.571671	阿迪	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	voice	\N	\N
2444	116	117	你好	text	t	2025-11-30 17:46:17.989653	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2384	109	117	22	text	t	2025-11-28 16:03:55.630634	2025-12-15 21:18:14.095932	测试08	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2383	109	117	111	text	t	2025-11-28 16:03:49.95894	2025-12-15 21:18:14.095932	测试08	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2438	143	144	请求添加好友【已通过】	text	t	2025-11-30 15:58:21.06677	2025-12-11 12:09:13.223696	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
2385	141	116	请求添加好友【已通过】	text	t	2025-11-28 16:04:39.572922	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2386	116	141	请求添加好友【已通过】	text	t	2025-11-28 16:04:39.574341	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2381	109	117	请求添加好友【已通过】	text	t	2025-11-28 16:03:36.439576	2025-12-15 21:18:14.095932	测试08	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2775	116	141	1	text	t	2025-12-06 01:20:09.29441	2025-12-15 23:45:11.793518	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2240	103	113	111	text	f	2025-11-26 23:40:24.835934	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2241	103	113	222	text	f	2025-11-26 23:41:05.98128	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2242	103	113	1111	text	f	2025-11-26 23:53:54.823235	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2243	103	113	22	text	f	2025-11-26 23:53:59.123794	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2245	103	113	000	text	f	2025-11-27 00:13:56.575067	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2246	103	113	111	text	f	2025-11-27 00:13:59.644883	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2247	103	113	22	text	f	2025-11-27 00:27:27.990623	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2248	103	113	33	text	f	2025-11-27 00:27:54.195668	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2249	103	113	44	text	f	2025-11-27 00:27:57.105889	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2251	108	113	请求添加好友【已通过】	text	f	2025-11-27 00:38:25.801844	\N	测试07	测试22	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2252	113	108	请求添加好友【已通过】	text	f	2025-11-27 00:38:25.803327	\N	测试22	测试07	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2306	103	125	请求添加好友【已驳回】	text	f	2025-11-27 20:32:16.682203	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2307	125	103	请求添加好友【已驳回】	text	f	2025-11-27 20:32:55.79576	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2776	116	145	你好	text	f	2025-12-06 01:20:38.916051	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2357	127	131	请求添加好友【已通过】	text	f	2025-11-28 14:41:32.034004	\N	测试901	测试906	\N	\N	\N	normal				\N	\N	\N
2359	131	133	请求添加好友【已通过】	text	f	2025-11-28 14:42:52.393341	\N	测试906	测试908	\N	\N	\N	normal				\N	\N	\N
2360	133	131	请求添加好友【已通过】	text	f	2025-11-28 14:42:52.394854	\N	测试908	测试906	\N	\N	\N	normal				\N	\N	\N
2364	130	133	111	text	t	2025-11-28 15:04:18.606619	2025-11-28 15:04:18.807138	测试905	测试908	\N	\N	\N	normal				\N	\N	\N
2367	130	136	请求添加好友【已通过】	text	f	2025-11-28 15:09:19.13972	\N	测试905	测试911	\N	\N	\N	normal				\N	\N	\N
2368	136	130	请求添加好友【已通过】	text	f	2025-11-28 15:09:19.141355	\N	测试911	测试905	\N	\N	\N	normal				\N	\N	\N
3019	148	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/148/1765678899365465020_Screenrecorder-2025-12-14-10-11-51-44.mp4	video	t	2025-12-14 02:22:01.786584	2025-12-14 10:22:01.953782	阿迪	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N	\N
2779	148	149	请求添加好友【已通过】	text	t	2025-12-06 10:28:13.451361	2025-12-06 10:28:13.550062	阿迪	苏	\N	\N	\N	normal				\N	\N	\N
2778	149	148	请求添加好友【已通过】	text	t	2025-12-06 10:28:13.449914	2025-12-06 10:28:25.511322	苏	阿迪	\N	\N	\N	normal				\N	\N	\N
2780	149	148	[emotion:12_Angry.png]	text	t	2025-12-06 02:28:28.827492	2025-12-06 10:28:28.91149	苏	阿迪	\N	\N	\N	normal				\N	\N	\N
2410	143	142	请求添加好友【已驳回】	text	f	2025-11-29 13:16:12.834428	\N	aa123456	ces001	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2412	143	142	请求添加好友【已驳回】	text	f	2025-11-29 13:24:55.661017	\N	aa123456	ces001	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2427	144	143	1	text	t	2025-11-29 15:08:36.430235	2025-11-29 15:08:36.509743	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2433	113	114	111	text	f	2025-11-29 23:46:22.820791	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2392	127	113	请求添加好友【已通过】	text	t	2025-11-28 19:00:18.689837	2025-12-06 01:13:47.83042	测试901	测试22	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2356	131	127	请求添加好友【已通过】	text	t	2025-11-28 14:41:32.031389	2025-12-06 01:18:15.485651	测试906	测试901	\N	\N	\N	normal				\N	\N	\N
2781	148	149	1	text	t	2025-12-06 02:28:28.953267	2025-12-06 10:28:29.046692	阿迪	苏	\N	\N	\N	normal				\N	\N	\N
2411	142	143	请求添加好友【已驳回】	text	t	2025-11-29 13:23:30.572536	2025-12-11 11:52:13.048042	ces001	aa123456	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg		\N	\N	\N
2428	143	144	请求添加好友【已通过】	text	t	2025-11-29 15:10:39.115556	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		\N	\N	\N
2255	113	103	请求添加好友【已通过】	text	f	2025-11-27 01:36:21.206125	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2256	103	113	请求添加好友【已通过】	text	f	2025-11-27 01:36:21.208368	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2308	125	103	请求添加好友【已驳回】	text	f	2025-11-27 20:34:33.508224	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3020	149	147	00:21	call_ended	t	2025-12-14 02:22:12.81249	2025-12-14 10:22:12.899738	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	voice	\N	\N
2358	131	127	123	text	t	2025-11-28 14:41:47.085328	2025-11-28 14:41:47.313104	测试906	测试901	\N	\N	\N	normal				\N	\N	\N
2782	148	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764988118_paste_1764988116458.png	image	t	2025-12-06 02:28:38.531488	2025-12-06 10:28:38.630543	阿迪	苏	\N	\N	\N	normal				\N	\N	\N
2783	148	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764988133_2021_05_04_20_02_02042BF6-F241-4F0D-B5A8-240381CFC0E0.JPG	image	t	2025-12-06 02:28:54.03177	2025-12-06 10:28:54.117595	阿迪	苏	\N	\N	\N	normal				\N	\N	\N
3021	148	149	00:21	call_ended_video	t	2025-12-14 02:22:13.167784	2025-12-14 10:22:13.26389	阿迪	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	video	\N	\N
2401	116	117	你好	text	t	2025-11-28 21:58:41.917924	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2420	144	143	00:02	call_ended	t	2025-11-29 15:03:33.728357	2025-11-29 15:03:33.875046	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
2785	150	148	请求添加好友【已通过】	text	t	2025-12-06 10:34:28.960004	2025-12-06 10:34:33.122911	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2422	144	143	00:03	call_ended_video	t	2025-11-29 15:03:42.231293	2025-11-29 15:03:42.796265	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
2434	113	114	222	text	f	2025-11-29 23:46:26.711939	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2784	148	150	请求添加好友【已通过】	text	t	2025-12-06 10:34:28.958589	2025-12-06 10:34:33.297747	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2435	114	113	33	text	t	2025-11-29 23:46:34.339585	2025-11-29 23:46:34.537611	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2436	114	113	444	text	t	2025-11-29 23:46:36.202669	2025-11-29 23:46:36.60534	测试23	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2340	102	103	11	text	t	2025-11-28 13:51:37.430744	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2437	113	114	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764431215_JPEG_20251129_234654_7966508428404550118.jpg	image	f	2025-11-29 23:46:56.848127	\N	测试22	测试23	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
2794	150	148	怎么找不到语音条了，	text	t	2025-12-06 02:36:56.007315	2025-12-06 10:36:56.097464	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2798	149	150	请求添加好友【已通过】	text	t	2025-12-06 10:39:03.866669	2025-12-06 10:39:15.102445	苏	大江	\N	\N	\N	normal				\N	\N	\N
2418	144	143	11	text	t	2025-11-29 15:03:02.823989	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2441	143	144	你好呀	text	t	2025-11-30 15:58:51.254044	2025-12-11 12:09:13.223696	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
2423	143	144	00:03	call_ended_video	t	2025-11-29 15:03:42.280849	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		video	\N	\N
2447	141	116	你好	text	t	2025-11-30 17:47:54.105181	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2449	141	116	1	text	t	2025-11-30 17:48:58.773562	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2448	116	141	111	text	t	2025-11-30 17:48:05.491456	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2446	116	141	你好	text	t	2025-11-30 17:47:35.001882	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2402	116	141	你好	text	t	2025-11-28 21:58:49.154793	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2421	143	144	00:02	call_ended	t	2025-11-29 15:03:33.755865	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		voice	\N	\N
2419	143	144	21323243	text	t	2025-11-29 15:03:23.576197	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		\N	\N	\N
2257	103	113	444	text	f	2025-11-27 01:36:34.455617	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2799	150	149	请求添加好友【已通过】	text	t	2025-12-06 10:39:03.86782	2025-12-06 10:39:07.725127	大江	苏	\N	\N	\N	normal				\N	\N	\N
2258	113	103	555	text	t	2025-11-27 01:36:40.890635	2025-11-27 01:36:41.01556	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2259	103	113	666	text	f	2025-11-27 01:36:50.918862	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2309	103	125	请求添加好友【已驳回】	text	f	2025-11-27 20:47:52.324744	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2310	103	125	请求添加好友【已驳回】	text	f	2025-11-27 20:54:47.572529	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2311	103	125	请求添加好友【已驳回】	text	f	2025-11-27 20:57:00.259775	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2312	103	125	请求添加好友【已驳回】	text	f	2025-11-27 20:57:23.454132	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2313	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:01:25.914943	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2314	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:10:41.823829	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2315	125	103	请求添加好友【已驳回】	text	f	2025-11-27 21:11:11.442215	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2316	125	103	请求添加好友【已驳回】	text	f	2025-11-27 21:11:27.736176	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2317	125	103	请求添加好友【已通过】	text	f	2025-11-27 21:11:42.422378	\N	测试35	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2318	103	125	请求添加好友【已通过】	text	f	2025-11-27 21:11:42.423509	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2320	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:29:50.467522	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2323	103	112	请求添加好友【已驳回】	text	f	2025-11-27 21:32:10.199707	\N	测试2	测试21	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2324	103	112	请求添加好友【已驳回】	text	f	2025-11-27 21:32:24.412397	\N	测试2	测试21	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2325	103	112	请求添加好友【已驳回】	text	f	2025-11-27 21:33:17.744752	\N	测试2	测试21	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2399	116	117	你好	text	t	2025-11-28 21:57:45.428102	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2334	117	116	111	text	t	2025-11-28 00:56:20.006955	2025-11-28 00:56:20.18974	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2361	130	133	请求添加好友【已驳回】	text	f	2025-11-28 15:03:41.467949	\N	测试905	测试908	\N	\N	\N	normal				\N	\N	\N
2362	130	133	请求添加好友【已通过】	text	f	2025-11-28 15:04:08.887908	\N	测试905	测试908	\N	\N	\N	normal				\N	\N	\N
2363	133	130	请求添加好友【已通过】	text	f	2025-11-28 15:04:08.889213	\N	测试908	测试905	\N	\N	\N	normal				\N	\N	\N
2365	130	135	请求添加好友【已通过】	text	f	2025-11-28 15:05:24.645735	\N	测试905	昵称910	\N	\N	\N	normal				\N	\N	\N
2366	135	130	请求添加好友【已通过】	text	f	2025-11-28 15:05:24.647061	\N	昵称910	测试905	\N	\N	\N	normal				\N	\N	\N
2369	130	137	请求添加好友【已通过】	text	f	2025-11-28 15:10:29.339537	\N	测试905	测试912	\N	\N	\N	normal				\N	\N	\N
2370	137	130	请求添加好友【已通过】	text	f	2025-11-28 15:10:29.340931	\N	测试912	测试905	\N	\N	\N	normal				\N	\N	\N
2371	130	138	请求添加好友【已通过】	text	f	2025-11-28 15:13:47.032277	\N	测试905	测试913	\N	\N	\N	normal				\N	\N	\N
2372	138	130	请求添加好友【已通过】	text	f	2025-11-28 15:13:47.033806	\N	测试913	测试905	\N	\N	\N	normal				\N	\N	\N
2373	130	139	请求添加好友【已通过】	text	f	2025-11-28 15:16:30.888245	\N	测试905	测试914	\N	\N	\N	normal				\N	\N	\N
2374	139	130	请求添加好友【已通过】	text	f	2025-11-28 15:16:30.889719	\N	测试914	测试905	\N	\N	\N	normal				\N	\N	\N
2353	131	128	123	text	t	2025-11-28 14:25:44.806445	2025-12-06 01:16:11.95457	测试906	测试902	\N	\N	\N	normal				\N	\N	\N
2260	113	103	111	text	f	2025-11-27 01:53:59.390082	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2261	103	113	222	text	f	2025-11-27 01:54:07.238288	\N	测试2	测试22	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2405	116	117	1	text	t	2025-11-28 22:03:02.378118	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2285	118	120	1	text	f	2025-11-27 03:43:46.194736	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2286	118	120	11	text	f	2025-11-27 03:43:52.103616	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2287	118	120	😀	text	f	2025-11-27 03:44:01.59409	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2294	116	118	你好	text	f	2025-11-27 14:00:39.010788	\N	秋风1	有度	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2295	113	103	11	text	f	2025-11-27 14:15:22.793	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2296	113	109	111	text	f	2025-11-27 14:15:55.535909	\N	测试22	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2297	113	108	112344	text	f	2025-11-27 14:17:32.647958	\N	测试22	测试07	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2298	113	103	123	text	f	2025-11-27 14:24:53.776565	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2299	113	109	333	text	f	2025-11-27 14:25:10.128791	\N	测试22	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2300	113	103	456	text	f	2025-11-27 14:29:41.809463	\N	测试22	测试2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
2301	113	109	6778	text	f	2025-11-27 14:29:57.896236	\N	测试22	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2319	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:27:56.887974	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2321	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:30:31.622226	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2322	103	125	请求添加好友【已驳回】	text	f	2025-11-27 21:30:56.898708	\N	测试2	测试35	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2326	103	112	请求添加好友【已驳回】	text	f	2025-11-27 21:33:30.073932	\N	测试2	测试21	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
2351	128	131	请求添加好友【已通过】	text	f	2025-11-28 14:25:10.975042	\N	测试902	测试906	\N	\N	\N	normal				\N	\N	\N
2375	109	113	请求添加好友【已通过】	text	f	2025-11-28 15:58:06.851978	\N	测试08	测试22	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
2376	113	109	请求添加好友【已通过】	text	f	2025-11-28 15:58:06.854074	\N	测试22	测试08	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2379	109	140	请求添加好友【已通过】	text	f	2025-11-28 15:59:32.171562	\N	测试08	测试831	\N	\N	\N	normal				\N	\N	\N
2380	140	109	请求添加好友【已通过】	text	f	2025-11-28 15:59:32.172828	\N	测试831	测试08	\N	\N	\N	normal				\N	\N	\N
2800	149	150	阿江，阿江，收到请回答	text	t	2025-12-06 02:39:18.153557	2025-12-06 10:39:18.385344	苏	大江	\N	\N	\N	normal				\N	\N	\N
2801	150	149	屌毛，屌毛，	text	t	2025-12-06 02:39:19.680527	2025-12-06 10:39:19.768011	大江	苏	\N	\N	\N	normal				\N	\N	\N
2389	141	116	nihao	text	t	2025-11-28 16:05:22.647467	2025-11-28 16:05:22.866342	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2352	131	128	请求添加好友【已通过】	text	t	2025-11-28 14:25:10.976512	2025-12-06 01:16:11.95457	测试906	测试902	\N	\N	\N	normal				\N	\N	\N
2388	141	116	nihao	text	t	2025-11-28 16:05:02.096771	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2390	116	141	你好	text	t	2025-11-28 16:05:30.42513	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2284	120	118	[emotion:1_Smile.png]	text	t	2025-11-27 03:43:33.742928	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2802	150	149	叫屌毛，呼叫屌毛，	text	t	2025-12-06 02:39:23.420194	2025-12-06 10:39:23.517506	大江	苏	\N	\N	\N	normal				\N	\N	\N
3022	149	147	对方已拒绝	call_rejected	t	2025-12-14 02:22:22.454926	2025-12-14 10:22:22.564256	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2803	150	149	收到收到，	text	t	2025-12-06 02:39:28.455548	2025-12-06 10:39:28.567137	大江	苏	\N	\N	\N	normal				\N	\N	\N
2804	150	149	叼毛，你收到没有	text	t	2025-12-06 02:39:33.970351	2025-12-06 10:39:34.063428	大江	苏	\N	\N	\N	normal				\N	\N	\N
2472	141	116	00:08	call_ended	t	2025-11-30 17:51:06.696352	2025-11-30 17:51:06.777786	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2453	141	116	1	text	t	2025-11-30 17:49:00.457083	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2454	141	116	1	text	t	2025-11-30 17:49:00.854792	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2455	141	116	1	text	t	2025-11-30 17:49:01.088082	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2471	141	116	1231321	text	t	2025-11-30 17:49:41.477065	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2805	149	150	收到，收到	text	t	2025-12-06 02:39:39.699769	2025-12-06 10:39:39.900225	苏	大江	\N	\N	\N	normal				\N	\N	\N
3023	148	155	请求添加好友【已通过】	text	t	2025-12-14 10:22:40.191011	2025-12-14 10:22:44.286563	阿迪	阿宇	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg		\N	\N	\N
2806	150	149	你昨天为什么在群里面骂我们	text	t	2025-12-06 02:39:42.487271	2025-12-06 10:39:42.576796	大江	苏	\N	\N	\N	normal				\N	\N	\N
3024	155	148	请求添加好友【已通过】	text	t	2025-12-14 10:22:40.192361	2025-12-14 10:23:25.415262	阿宇	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
2807	149	150	怎么发不了语音条？	text	t	2025-12-06 02:39:43.932242	2025-12-06 10:39:44.213484	苏	大江	\N	\N	\N	normal				\N	\N	\N
2808	149	150	你没看见那是奶牛吗？	text	t	2025-12-06 02:39:50.505897	2025-12-06 10:39:50.770694	苏	大江	\N	\N	\N	normal				\N	\N	\N
2809	150	149	你是不是不想团结了	text	t	2025-12-06 02:39:53.227589	2025-12-06 10:39:53.350502	大江	苏	\N	\N	\N	normal				\N	\N	\N
2810	149	150	我知道大家都想喝奶了	text	t	2025-12-06 02:39:55.877633	2025-12-06 10:39:56.339801	苏	大江	\N	\N	\N	normal				\N	\N	\N
2811	150	149	我看不懂，	text	t	2025-12-06 02:40:04.905477	2025-12-06 10:40:05.026403	大江	苏	\N	\N	\N	normal				\N	\N	\N
2812	150	149	阿迪说你在骂我们，	text	t	2025-12-06 02:40:08.855569	2025-12-06 10:40:08.954893	大江	苏	\N	\N	\N	normal				\N	\N	\N
2813	149	150	上面那个奶最大推荐一下	text	t	2025-12-06 02:40:23.71371	2025-12-06 10:40:23.920385	苏	大江	\N	\N	\N	normal				\N	\N	\N
2814	150	149	这个软件他妈的问题真多，	text	t	2025-12-06 02:40:23.832627	2025-12-06 10:40:23.941695	大江	苏	\N	\N	\N	normal				\N	\N	\N
2815	150	149	晚上整烧烤准不准	text	t	2025-12-06 02:40:43.521348	2025-12-06 10:40:45.88834	大江	苏	\N	\N	\N	normal				\N	\N	\N
2832	149	150	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764989010_JPEG_20251206_104334_3764134870554169361.jpg	image	t	2025-12-06 02:43:31.189765	2025-12-06 10:43:31.39569	苏	大江	\N	\N	\N	normal				\N	\N	\N
2973	147	151	3	text	t	2025-12-07 12:23:04.510986	2025-12-07 12:47:34.41864	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2972	147	151	2	text	t	2025-12-07 12:23:03.646677	2025-12-07 12:47:34.41864	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2971	147	151	1	text	t	2025-12-07 12:23:03.083323	2025-12-07 12:47:34.41864	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2970	147	151	💞	text	t	2025-12-07 12:22:58.640506	2025-12-07 12:47:34.41864	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2982	151	147	00:14	call_ended_video	t	2025-12-07 13:17:46.349655	2025-12-07 13:17:51.468448	王先生	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	video	\N	\N
2981	148	150	1	text	t	2025-12-07 13:17:35.811557	2025-12-07 13:24:22.904146	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2980	148	150	1	text	t	2025-12-07 13:17:33.847244	2025-12-07 13:24:22.904146	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2979	148	150	1	text	t	2025-12-07 13:17:32.855375	2025-12-07 13:24:22.904146	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2989	150	148	3	text	t	2025-12-07 13:24:45.382929	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2988	150	148	1	text	t	2025-12-07 13:24:43.211658	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2987	150	148	1	text	t	2025-12-07 13:24:40.781185	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2986	150	148	1	text	t	2025-12-07 13:24:38.192963	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
3007	143	144	😀	text	t	2025-12-11 04:09:52.587925	2025-12-11 12:09:52.666752	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3008	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765426201422679420_voice_1765426198616.m4a	voice	t	2025-12-11 04:10:03.892733	2025-12-11 12:10:03.978575	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	2
3014	148	150	3	text	t	2025-12-14 02:05:20.657548	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2827	149	150	鲜橙多 3箱\n绿茶 3箱\n百事可乐 3箱\n泡面 3箱\n零食 500元\n月饼 1000元\n牛肉自嗨锅 2箱\n火腿肠 1箱\n茶油豆干 1箱\n原味牛肉干 20包\n花生酱 一小件\n纸碗 1箱\n衣柜 1个\n洗衣服的飘香粉 15包\n洗衣液 1箱\n内裤 2盒3XL\n棉睡衣  2套3XL	text	t	2025-12-06 02:42:44.677422	2025-12-06 10:42:44.945457	苏	大江	\N	\N	\N	normal				\N	\N	\N
3013	148	150	3	text	t	2025-12-14 02:05:19.593862	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2828	149	150	有没有你喜欢的	text	t	2025-12-06 02:42:49.713269	2025-12-06 10:42:50.037696	苏	大江	\N	\N	\N	normal				\N	\N	\N
3012	148	150	2	text	t	2025-12-14 02:05:17.749691	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2829	150	149	又还没有买东西，	text	t	2025-12-06 02:43:04.982965	2025-12-06 10:43:05.082383	大江	苏	\N	\N	\N	normal				\N	\N	\N
3011	148	150	2	text	t	2025-12-14 02:05:16.6024	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2830	150	149	发了没买有什么卵用	text	t	2025-12-06 02:43:14.845828	2025-12-06 10:43:14.938521	大江	苏	\N	\N	\N	normal				\N	\N	\N
3010	148	150	1	text	t	2025-12-14 02:05:14.766289	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2831	149	150	58让我发的	text	t	2025-12-06 02:43:16.127823	2025-12-06 10:43:16.487483	苏	大江	\N	\N	\N	normal				\N	\N	\N
3009	148	150	1	text	t	2025-12-14 02:05:12.198354	2025-12-14 10:19:55.646955	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2974	151	147	群呢	text	t	2025-12-07 12:59:56.00822	2025-12-07 13:01:23.673129	王先生	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2975	151	147	00:05	call_ended	t	2025-12-07 13:01:39.184145	2025-12-07 13:01:39.345684	王先生	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	voice	\N	\N
2332	117	116	你好	text	t	2025-11-28 00:56:00.58923	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2329	117	116	1	text	t	2025-11-28 00:54:06.242868	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2474	142	144	请求添加好友【已驳回】	text	f	2025-12-01 10:21:56.856202	\N	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
2476	143	142	00:05	call_ended	f	2025-12-01 10:25:12.18626	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	voice	\N	\N
3026	155	148	中午好	text	t	2025-12-14 02:22:59.140445	2025-12-14 10:23:25.415262	阿宇	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
2478	143	142	00:05	call_ended	f	2025-12-01 10:25:12.403991	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	voice	\N	\N
3025	147	149	1	text	t	2025-12-14 02:22:45.277201	2025-12-14 10:25:06.866726	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N	\N
2480	143	142	请求添加好友【已通过】	text	f	2025-12-01 10:25:59.693601	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2481	143	142	1	text	f	2025-12-01 10:26:09.823307	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2483	143	142	2	text	f	2025-12-01 10:34:17.873278	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2328	117	116	请求添加好友【已通过】	text	t	2025-11-28 00:52:53.03405	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2223	117	116	1	text	t	2025-11-26 22:31:03.416559	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal				\N	\N	\N
2222	117	116	你好	text	t	2025-11-26 22:23:56.20528	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal				\N	\N	\N
2221	117	116	nihao	text	t	2025-11-26 22:23:51.531477	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal				\N	\N	\N
2218	117	116	请求添加好友【已通过】	text	t	2025-11-26 22:23:22.113741	2025-12-07 13:01:58.369072	秋风2	秋风1	\N	\N	\N	normal				\N	\N	\N
3028	150	148	？	text	f	2025-12-14 02:30:44.740673	\N	大江	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
3029	150	148	？	text	f	2025-12-14 02:30:45.876994	\N	大江	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
3030	150	148	1	text	f	2025-12-14 02:30:48.736707	\N	大江	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
3027	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1765679118_JPEG_20251206_141216_3661491002188513628.jpg	file	t	2025-12-14 02:25:23.845489	2025-12-14 10:27:28.030881	苏	风生水起	JPEG_20251206_141216_3661491002188513628.jpg	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2488	141	116	你好	text	t	2025-12-01 10:36:47.044461	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2834	150	149	他妈的，我箱子里面天天丢东西，	text	t	2025-12-06 02:43:51.683365	2025-12-06 10:44:15.991445	大江	苏	\N	\N	\N	normal				\N	\N	\N
2833	150	149	你是打算开超市啊	text	t	2025-12-06 02:43:46.283505	2025-12-06 10:44:15.991445	大江	苏	\N	\N	\N	normal				\N	\N	\N
2842	151	148	请求添加好友【已通过】	text	t	2025-12-06 10:44:24.528257	2025-12-06 10:44:30.23473	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2840	151	148	请求添加好友【已通过】	text	t	2025-12-06 10:44:22.763703	2025-12-06 10:44:30.23473	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2839	148	151	请求添加好友【已通过】	text	t	2025-12-06 10:44:22.76253	2025-12-06 10:44:31.724711	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2841	148	151	请求添加好友【已通过】	text	t	2025-12-06 10:44:24.526861	2025-12-06 10:44:31.724711	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2836	149	148	呼叫呼叫阿迪	text	t	2025-12-06 02:43:59.368368	2025-12-06 10:44:38.937826	苏	阿迪	\N	\N	\N	normal				\N	\N	\N
2835	149	148	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764989033_JPEG_20251206_104356_7757906741550035753.jpg	image	t	2025-12-06 02:43:53.899503	2025-12-06 10:44:38.937826	苏	阿迪	\N	\N	\N	normal				\N	\N	\N
2865	149	150	我就被拿过两包天叶	text	t	2025-12-06 02:47:37.392115	2025-12-06 10:47:37.757747	苏	大江	\N	\N	\N	normal				\N	\N	\N
2863	146	151	请求添加好友【已通过】	text	t	2025-12-06 10:47:33.66484	2025-12-06 10:47:50.589227	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2866	149	150	其他没有	text	t	2025-12-06 02:47:51.899022	2025-12-06 10:47:52.153808	苏	大江	\N	\N	\N	normal				\N	\N	\N
2864	151	146	请求添加好友【已通过】	text	t	2025-12-06 10:47:33.665969	2025-12-06 10:48:17.793164	王先生	王志豪	\N	\N	\N	normal				\N	\N	\N
2871	146	151	123	text	t	2025-12-06 02:49:46.916346	2025-12-06 10:49:47.123799	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2872	146	151	124	text	t	2025-12-06 02:49:53.628072	2025-12-06 10:49:55.816395	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2881	147	150	请求添加好友【已通过】	text	t	2025-12-06 10:53:02.664933	2025-12-06 10:53:07.319761	风生水起	大江	\N	\N	\N	normal				\N	\N	\N
2882	148	151	好的	text	t	2025-12-06 02:53:06.265579	2025-12-06 10:58:40.399429	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2883	148	151	这是什么原因	text	t	2025-12-06 02:53:14.220098	2025-12-06 10:58:40.399429	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2880	150	147	请求添加好友【已通过】	text	t	2025-12-06 10:53:02.663805	2025-12-06 11:04:46.872533	大江	风生水起	\N	\N	\N	normal				\N	\N	\N
2902	151	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764992042_VID_20251206_112833_162.mp4	video	t	2025-12-06 03:34:03.714115	2025-12-06 11:34:18.521263	王先生	风生水起	\N	\N	\N	normal				\N	\N	\N
2903	147	151	手机可以	text	t	2025-12-06 03:34:26.31	2025-12-06 11:34:26.527719	风生水起	王先生	\N	\N	\N	normal				\N	\N	\N
2904	151	147	你们试一下发点黄片看看	text	t	2025-12-06 03:34:57.228509	2025-12-06 11:34:57.503314	王先生	风生水起	\N	\N	\N	normal				\N	\N	\N
2905	151	147	我发了一个动画片不行	text	t	2025-12-06 03:35:06.059899	2025-12-06 11:35:06.202059	王先生	风生水起	\N	\N	\N	normal				\N	\N	\N
2906	147	151	没有啊😂😂😂😂😂	text	t	2025-12-06 03:35:12.37609	2025-12-06 11:35:12.601648	风生水起	王先生	\N	\N	\N	normal				\N	\N	\N
2908	147	149	00:23	call_ended	t	2025-12-06 06:06:33.256309	2025-12-06 14:06:33.379117	风生水起	苏	\N	\N	\N	normal				voice	\N	\N
2909	149	147	00:04	call_ended_video	t	2025-12-06 06:07:55.807416	2025-12-06 14:07:55.955232	苏	风生水起	\N	\N	\N	normal				video	\N	\N
2910	149	147	00:27	call_ended_video	t	2025-12-06 06:08:33.85672	2025-12-06 14:08:34.310831	苏	风生水起	\N	\N	\N	normal				video	\N	\N
2911	147	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765001323_JPEG_20251206_140842_7818344077636922676.jpg	image	t	2025-12-06 06:08:49.387363	2025-12-06 14:11:08.196402	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
2226	118	116	请求添加好友【已通过】	text	t	2025-11-26 22:31:50.404417	2025-12-07 13:02:56.849698	有度	秋风1	\N	\N	\N	normal				\N	\N	\N
2493	142	143	66	text	t	2025-12-01 11:02:30.120448	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2482	142	143	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764556414_屏幕截图 2025-08-12 125412.png	image	t	2025-12-01 10:33:34.295216	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3031	150	148	2	text	f	2025-12-14 02:30:52.63263	\N	大江	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	\N	\N	\N
2484	142	143	3	text	t	2025-12-01 10:34:24.878413	2025-12-01 10:34:24.962862	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2485	143	142	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764556491_JPEG_20251201_103451_926420810373122998.jpg	image	f	2025-12-01 10:34:51.39106	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2499	116	117	1	text	t	2025-12-02 05:21:46.136533	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2486	142	143	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764556503_屏幕截图 2025-04-02 105025.png	image	t	2025-12-01 10:35:03.875564	2025-12-01 10:35:04.002365	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2838	150	149	听说你们组的小龙会偷东西，你多留意一下，逮到了就打死，	text	t	2025-12-06 02:44:14.134306	2025-12-06 10:44:15.991445	大江	苏	\N	\N	\N	normal				\N	\N	\N
2837	150	149	不知道哪个狗天天偷我东西，昨天又丢了一包烟，两瓶东鹏，	text	t	2025-12-06 02:44:03.312243	2025-12-06 10:44:15.991445	大江	苏	\N	\N	\N	normal				\N	\N	\N
2490	142	143	00:07	call_ended_video	t	2025-12-01 10:53:47.804501	2025-12-01 10:53:47.971981	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
2491	142	143	00:07	call_ended_video	t	2025-12-01 10:53:48.082135	2025-12-01 10:53:48.168941	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
2843	149	150	谁看见的啊	text	t	2025-12-06 02:44:43.010561	2025-12-06 10:44:43.441964	苏	大江	\N	\N	\N	normal				\N	\N	\N
2492	143	142	00:03	call_ended	t	2025-12-01 10:54:07.049292	2025-12-01 10:54:07.131828	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	voice	\N	\N
2495	143	142	2	text	f	2025-12-01 14:20:18.684254	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2496	143	142	1	text	f	2025-12-01 14:31:03.633672	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2489	141	116	1	text	t	2025-12-01 10:36:57.175478	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2498	116	141	你好	text	t	2025-12-02 05:21:38.667608	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2497	116	141	年	text	t	2025-12-02 05:21:33.366848	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2846	150	149	只是听说，没有看见，	text	t	2025-12-06 02:44:58.612799	2025-12-06 10:44:58.719758	大江	苏	\N	\N	\N	normal				\N	\N	\N
2844	148	151	你好	text	t	2025-12-06 02:44:47.770447	2025-12-06 10:45:09.472259	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2845	148	151	你好	text	t	2025-12-06 02:44:52.280395	2025-12-06 10:45:09.472259	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2847	149	150	那不行，不信谣不传谣	text	t	2025-12-06 02:45:12.855994	2025-12-06 10:45:13.139671	苏	大江	\N	\N	\N	normal				\N	\N	\N
2848	150	149	你要看见他和东鹏了就告诉我，	text	t	2025-12-06 02:45:16.719093	2025-12-06 10:45:17.152783	大江	苏	\N	\N	\N	normal				\N	\N	\N
2849	150	149	我知道	text	t	2025-12-06 02:45:21.289004	2025-12-06 10:45:21.39409	大江	苏	\N	\N	\N	normal				\N	\N	\N
2850	149	150	嗯	text	t	2025-12-06 02:45:24.369465	2025-12-06 10:45:24.646767	苏	大江	\N	\N	\N	normal				\N	\N	\N
2851	148	151	你是谁	text	t	2025-12-06 02:45:24.848708	2025-12-06 10:45:26.773645	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2852	150	149	就是留意一下	text	t	2025-12-06 02:45:27.737375	2025-12-06 10:45:27.842255	大江	苏	\N	\N	\N	normal				\N	\N	\N
2853	149	150	👌	text	t	2025-12-06 02:45:34.193599	2025-12-06 10:45:34.478814	苏	大江	\N	\N	\N	normal				\N	\N	\N
2854	150	149	没有让你搞他	text	t	2025-12-06 02:45:34.941757	2025-12-06 10:45:35.054304	大江	苏	\N	\N	\N	normal				\N	\N	\N
2500	128	127	11	text	t	2025-12-02 12:56:58.70507	2025-12-02 20:56:58.838374	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
2855	150	149	看看能不能抓到证据	text	t	2025-12-06 02:45:45.664142	2025-12-06 10:45:45.767507	大江	苏	\N	\N	\N	normal				\N	\N	\N
2502	143	142	1	text	f	2025-12-02 13:00:42.578032	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
3032	147	148	01:12	call_ended_video	f	2025-12-14 02:43:04.531631	\N	风生水起	阿迪	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	video	\N	\N
2503	142	143	2	text	t	2025-12-02 13:01:02.974755	2025-12-02 21:01:03.059135	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2504	143	142	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764680497_JPEG_20251202_210138_5039756183896605044.jpg	image	f	2025-12-02 13:01:38.338702	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2856	149	150	好的好的	text	t	2025-12-06 02:45:51.657602	2025-12-06 10:45:51.861099	苏	大江	\N	\N	\N	normal				\N	\N	\N
2505	142	143	对方已取消	call_cancelled	t	2025-12-02 13:04:43.56482	2025-12-02 21:04:43.654764	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2506	143	142	00:32	call_ended	f	2025-12-02 13:05:24.361149	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	voice	\N	\N
3033	149	148	00:43	call_ended_video	f	2025-12-14 02:43:45.855034	\N	苏	阿迪	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	video	\N	\N
2507	142	143	00:32	call_ended	t	2025-12-02 13:05:24.435436	2025-12-02 21:05:24.528192	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
1842	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763991055_scaled_236d8877-6d39-436d-8918-8006426e82027980875032891819964.jpg	image	t	2025-11-24 21:31:00.049862	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2508	143	142	00:32	call_ended	f	2025-12-02 13:05:24.58936	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	voice	\N	\N
2857	150	149	聪明的小偷呀，好烟不敢拿，就拿灰狼	text	t	2025-12-06 02:46:17.865107	2025-12-06 10:46:24.885563	大江	苏	\N	\N	\N	normal				\N	\N	\N
2509	142	143	00:20	call_ended	t	2025-12-02 13:06:06.042377	2025-12-02 21:06:06.141579	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
2510	142	143	对方已取消	call_cancelled	t	2025-12-02 13:06:48.519695	2025-12-02 21:06:48.596202	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2858	149	150	没有不敢拿的	text	t	2025-12-06 02:46:33.670007	2025-12-06 10:46:33.909268	苏	大江	\N	\N	\N	normal				\N	\N	\N
2533	141	116	1	text	t	2025-12-03 07:08:28.804036	2025-12-03 15:08:29.008423	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2860	149	150	我的天叶就被偷了2包	text	t	2025-12-06 02:46:44.252344	2025-12-06 10:46:44.56912	苏	大江	\N	\N	\N	normal				\N	\N	\N
2861	150	149	几颗槟榔也拿了，把袋子放箱子里	text	t	2025-12-06 02:46:52.77365	2025-12-06 10:46:52.867878	大江	苏	\N	\N	\N	normal				\N	\N	\N
2862	150	149	我没有天叶	text	t	2025-12-06 02:47:03.524747	2025-12-06 10:47:03.626408	大江	苏	\N	\N	\N	normal				\N	\N	\N
2541	141	116	00:17	call_ended_video	t	2025-12-03 07:10:11.361145	2025-12-03 15:10:11.466983	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	video	\N	\N
2859	151	148	你在发几条信息	text	t	2025-12-06 02:46:40.267779	2025-12-06 10:53:00.922222	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2886	146	151	[emotion:1_Smile.png]	text	t	2025-12-06 02:56:35.21634	2025-12-06 10:58:47.939154	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2885	149	147	当然是悄悄的	text	t	2025-12-06 02:54:53.436467	2025-12-06 11:00:43.229864	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
2895	148	151	要你通过	text	t	2025-12-06 03:09:40.807815	2025-12-06 11:11:01.82096	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2893	148	151	1	text	t	2025-12-06 03:05:43.148587	2025-12-06 11:11:01.82096	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2899	147	151	请求添加好友【已通过】	text	t	2025-12-06 11:31:05.732919	2025-12-06 11:31:11.575846	风生水起	王先生	\N	\N	\N	normal				\N	\N	\N
2898	151	147	请求添加好友【已通过】	text	t	2025-12-06 11:31:05.731503	2025-12-06 11:31:35.723731	王先生	风生水起	\N	\N	\N	normal				\N	\N	\N
2900	151	147	你不是进群了吗？	text	t	2025-12-06 03:31:21.673757	2025-12-06 11:31:35.723731	王先生	风生水起	\N	\N	\N	normal				\N	\N	\N
2512	143	142	00:46	call_ended_video	f	2025-12-02 13:07:52.408813	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	video	\N	\N
2511	142	143	00:46	call_ended_video	t	2025-12-02 13:07:52.341506	2025-12-02 21:07:52.423494	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
3034	149	147	00:46	call_ended	t	2025-12-14 02:49:10.223643	2025-12-14 10:49:10.676441	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	voice	\N	\N
2513	142	143	00:22	call_ended_video	t	2025-12-02 13:08:29.276249	2025-12-02 21:08:29.351118	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
3037	150	148	00:35	call_ended_video	f	2025-12-14 02:57:43.494508	\N	大江	阿迪	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	video	\N	\N
2514	142	143	[emotion:1_Smile.png]	text	t	2025-12-02 13:08:36.115681	2025-12-02 21:08:36.268813	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2515	143	142	对方已拒绝	call_rejected_video	f	2025-12-02 13:09:04.094507	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2516	142	143	对方已拒绝	call_rejected_video	t	2025-12-02 13:09:53.644177	2025-12-02 21:09:53.993158	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2517	143	142	对方已拒绝	call_rejected_video	f	2025-12-02 13:09:59.880801	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2518	142	143	对方已拒绝	call_rejected	t	2025-12-02 13:10:29.895444	2025-12-02 21:10:29.966319	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2519	143	142	对方已拒绝	call_rejected	f	2025-12-02 13:10:40.925935	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2522	143	142	请求添加好友【已通过】	text	f	2025-12-02 21:19:54.50052	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2523	143	142	这是什么	quoted	f	2025-12-02 13:24:55.22897	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	2514	[图片]	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2524	143	142	没	text	f	2025-12-02 13:25:11.12263	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2525	143	142	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764681527_JPEG_20251202_211848_523723774826566576.jpg	image	f	2025-12-02 13:27:07.225957	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
3036	147	149	请求添加好友【已通过】	text	f	2025-12-14 10:57:23.854956	\N	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N	\N
3035	149	147	请求添加好友【已通过】	text	t	2025-12-14 10:57:23.852968	2025-12-14 10:57:23.960915	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2978	116	126	你好	text	t	2025-12-07 13:08:53.416356	2025-12-14 17:25:41.080699	秋风1	123	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2867	146	151	1	text	t	2025-12-06 02:48:33.51709	2025-12-06 10:48:52.453498	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2868	146	151	2	text	t	2025-12-06 02:48:47.867478	2025-12-06 10:48:52.453498	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2869	146	151	3	text	t	2025-12-06 02:48:50.139387	2025-12-06 10:48:52.453498	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2540	141	116	00:04	call_ended	t	2025-12-03 07:09:41.111839	2025-12-03 15:09:41.218513	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2529	141	116	1	text	t	2025-12-03 07:08:08.464411	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2530	141	116	1	text	t	2025-12-03 07:08:11.218964	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2531	141	116	1	text	t	2025-12-03 07:08:17.716439	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2532	141	116	2	text	t	2025-12-03 07:08:19.508388	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2528	116	141	你好	text	t	2025-12-03 07:08:04.412275	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2870	146	151	1	text	t	2025-12-06 02:49:11.132978	2025-12-06 10:49:13.533755	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
3039	126	127	22	text	t	2025-12-14 09:25:48.981968	2025-12-14 17:25:50.05802	123	测试901	\N	\N	\N	normal				\N	\N	\N
2874	147	149	请求添加好友【已通过】	text	t	2025-12-06 10:52:07.184534	2025-12-06 10:52:11.866493	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
2873	149	147	请求添加好友【已通过】	text	t	2025-12-06 10:52:07.183128	2025-12-06 10:52:12.60515	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
3038	126	127	11	text	t	2025-12-14 09:25:45.250463	2025-12-14 17:25:50.05802	123	测试901	\N	\N	\N	normal				\N	\N	\N
2875	149	147	今晚去嫖娼	text	t	2025-12-06 02:52:22.186299	2025-12-06 10:52:22.316307	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
2876	149	147	去不去	text	t	2025-12-06 02:52:24.44856	2025-12-06 10:52:24.57954	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
3040	127	126	33	text	t	2025-12-14 09:25:53.693914	2025-12-14 17:25:53.918968	测试901	123	\N	\N	\N	normal				\N	\N	\N
2877	147	149	走，悄悄地去还是大家一起去	text	t	2025-12-06 02:52:41.215552	2025-12-06 10:52:41.322699	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
3041	127	126	44	text	t	2025-12-14 09:25:55.17508	2025-12-14 17:25:55.465998	测试901	123	\N	\N	\N	normal				\N	\N	\N
2879	147	150	请求添加好友【已通过】	text	t	2025-12-06 10:53:00.366729	2025-12-06 10:53:07.319761	风生水起	大江	\N	\N	\N	normal				\N	\N	\N
3042	127	126	1	text	t	2025-12-14 09:34:12.831976	2025-12-14 17:34:13.019147	测试901	123	\N	\N	\N	normal				\N	\N	\N
2884	148	151	法规	text	t	2025-12-06 02:53:18.588331	2025-12-06 10:58:40.399429	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2887	146	151	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764989807_示例图片_03.jpg	image	t	2025-12-06 02:56:48.308102	2025-12-06 10:58:47.939154	王志豪	王先生	\N	\N	\N	normal				\N	\N	\N
2888	147	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764990053_346f5ae3d5d0c59d6c65fd4954155625.mp4	video	t	2025-12-06 03:01:20.203325	2025-12-06 11:01:31.789235	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
3043	127	126	2	text	t	2025-12-14 09:34:13.811787	2025-12-14 17:34:14.076653	测试901	123	\N	\N	\N	normal				\N	\N	\N
2889	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1764990156_VID_20251116_120424_679.mp4	video	t	2025-12-06 03:02:39.568075	2025-12-06 11:02:39.686792	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
3044	127	126	3	text	t	2025-12-14 09:34:14.898172	2025-12-14 17:34:15.081708	测试901	123	\N	\N	\N	normal				\N	\N	\N
2890	148	147	请求添加好友【已通过】	text	t	2025-12-06 11:03:13.327563	2025-12-06 11:04:45.349658	阿迪	风生水起	\N	\N	\N	normal				\N	\N	\N
2878	150	147	请求添加好友【已通过】	text	t	2025-12-06 10:53:00.365593	2025-12-06 11:04:46.872533	大江	风生水起	\N	\N	\N	normal				\N	\N	\N
2892	151	148	一战成名群拉一下人看看	text	t	2025-12-06 03:04:02.468015	2025-12-06 11:05:36.158304	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
3045	127	126	4	text	t	2025-12-14 09:34:16.296244	2025-12-14 17:34:16.481185	测试901	123	\N	\N	\N	normal				\N	\N	\N
2894	148	151	我都没有这个群	text	t	2025-12-06 03:09:01.474843	2025-12-06 11:11:01.82096	阿迪	王先生	\N	\N	\N	normal				\N	\N	\N
2891	147	148	请求添加好友【已通过】	text	t	2025-12-06 11:03:13.32872	2025-12-06 14:30:17.753134	风生水起	阿迪	\N	\N	\N	normal				\N	\N	\N
2976	147	151	00:07	call_ended	t	2025-12-07 13:02:03.128604	2025-12-07 13:11:18.762556	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	voice	\N	\N
3046	127	126	5	text	t	2025-12-14 09:34:17.321276	2025-12-14 17:34:17.523414	测试901	123	\N	\N	\N	normal				\N	\N	\N
2985	150	148	2	text	t	2025-12-07 13:24:36.76494	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2984	150	148	1	text	t	2025-12-07 13:24:34.631783	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2527	142	143	00:20	call_ended	t	2025-12-02 13:51:50.583134	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
3047	127	126	1	text	t	2025-12-14 09:35:38.665739	2025-12-14 17:35:38.851915	测试901	123	\N	\N	\N	normal				\N	\N	\N
3048	127	126	2	text	t	2025-12-14 09:35:39.735743	2025-12-14 17:35:39.92424	测试901	123	\N	\N	\N	normal				\N	\N	\N
3049	127	126	3	text	t	2025-12-14 09:35:40.869657	2025-12-14 17:35:41.068905	测试901	123	\N	\N	\N	normal				\N	\N	\N
3050	127	126	1	text	t	2025-12-14 09:35:41.994735	2025-12-14 17:35:42.423013	测试901	123	\N	\N	\N	normal				\N	\N	\N
3051	127	126	2	text	t	2025-12-14 09:35:43.560534	2025-12-14 17:35:43.750447	测试901	123	\N	\N	\N	normal				\N	\N	\N
3052	127	126	3	text	t	2025-12-14 09:35:45.156808	2025-12-14 17:35:45.350449	测试901	123	\N	\N	\N	normal				\N	\N	\N
3053	127	126	1	text	t	2025-12-14 09:35:47.034473	2025-12-14 17:35:47.273426	测试901	123	\N	\N	\N	normal				\N	\N	\N
2572	116	126	请求添加好友【已通过】	text	t	2025-12-03 21:53:15.028604	2025-12-14 17:25:41.080699	秋风1	123	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2575	116	126	222	text	t	2025-12-03 13:53:36.074853	2025-12-14 17:25:41.080699	秋风1	123	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2896	151	149	请求添加好友【已通过】	text	t	2025-12-06 11:27:25.354042	2025-12-06 11:27:29.315852	王先生	苏	\N	\N	\N	normal				\N	\N	\N
2897	149	151	请求添加好友【已通过】	text	t	2025-12-06 11:27:25.356337	2025-12-06 11:27:30.516838	苏	王先生	\N	\N	\N	normal				\N	\N	\N
2549	141	116	1	text	t	2025-12-03 13:28:17.621039	2025-12-03 21:28:17.724819	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2912	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765001442_JPEG_20251206_141045_6332622315717846503.jpg	image	t	2025-12-06 06:10:42.828052	2025-12-06 14:10:43.088891	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
3054	127	126	2	text	t	2025-12-14 09:35:48.673283	2025-12-14 17:35:49.040456	测试901	123	\N	\N	\N	normal				\N	\N	\N
3055	127	126	3	text	t	2025-12-14 09:35:49.899722	2025-12-14 17:35:50.391795	测试901	123	\N	\N	\N	normal				\N	\N	\N
2571	116	117	1111	text	t	2025-12-03 13:48:02.787759	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2564	145	141	请求添加好友【已通过】	text	t	2025-12-03 21:36:53.719095	2025-12-15 23:45:09.167362	秋风	秋风2	\N	\N	\N	normal				\N	\N	\N
2562	145	141	请求添加好友【已通过】	text	t	2025-12-03 21:36:52.292056	2025-12-15 23:45:09.167362	秋风	秋风2	\N	\N	\N	normal				\N	\N	\N
2560	145	141	请求添加好友【已通过】	text	t	2025-12-03 21:36:00.985972	2025-12-15 23:45:09.167362	秋风	秋风	\N	\N	\N	normal				\N	\N	\N
2561	141	145	请求添加好友【已通过】	text	f	2025-12-03 21:36:00.987559	\N	秋风	秋风	\N	\N	\N	normal				\N	\N	\N
2563	141	145	请求添加好友【已通过】	text	f	2025-12-03 21:36:52.293783	\N	秋风2	秋风	\N	\N	\N	normal				\N	\N	\N
2565	141	145	请求添加好友【已通过】	text	f	2025-12-03 21:36:53.72035	\N	秋风2	秋风	\N	\N	\N	normal				\N	\N	\N
2585	145	141	你好	text	t	2025-12-03 16:35:02.578253	2025-12-15 23:45:09.167362	秋风	秋风2	\N	\N	\N	normal				\N	\N	\N
2567	141	145	00:04	call_ended	t	2025-12-03 13:39:40.090663	2025-12-03 21:39:40.234454	秋风2	秋风	\N	\N	\N	normal				voice	\N	\N
2566	145	141	1	text	t	2025-12-03 13:37:26.238643	2025-12-15 23:45:09.167362	秋风	秋风2	\N	\N	\N	normal				\N	\N	\N
2568	141	145	00:04	call_ended_video	t	2025-12-03 13:39:56.836575	2025-12-03 21:39:57.348501	秋风2	秋风	\N	\N	\N	normal				video	\N	\N
2983	116	141	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1765084665_VID_20251207_131722_232.mp4	video	t	2025-12-07 13:18:06.686174	2025-12-15 23:45:11.793518	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2569	141	145	对方已拒绝	call_rejected	t	2025-12-03 13:41:13.1156	2025-12-03 21:41:13.214393	秋风2	秋风	\N	\N	\N	normal				\N	\N	\N
2586	116	145	请求添加好友【已通过】	text	f	2025-12-04 00:35:54.17326	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2587	145	116	请求添加好友【已通过】	text	t	2025-12-04 00:35:54.174606	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2573	126	116	请求添加好友【已通过】	text	t	2025-12-03 21:53:15.030318	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2584	126	116	111	text	t	2025-12-03 13:54:33.55816	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2583	126	116	00	text	t	2025-12-03 13:54:32.269793	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2582	126	116	99	text	t	2025-12-03 13:54:31.337746	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2581	126	116	88	text	t	2025-12-03 13:54:30.768693	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2580	126	116	77	text	t	2025-12-03 13:54:29.937609	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2579	126	116	66	text	t	2025-12-03 13:54:03.391428	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2578	126	116	55	text	t	2025-12-03 13:54:02.775101	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2577	126	116	44	text	t	2025-12-03 13:54:02.04809	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2576	126	116	33	text	t	2025-12-03 13:54:01.29608	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2574	126	116	111	text	t	2025-12-03 13:53:25.19799	2025-12-06 09:18:13.507101	123	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2570	116	141	111	text	t	2025-12-03 13:47:56.278141	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2588	116	145	你好	text	f	2025-12-03 16:36:04.659299	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2977	116	117	你好	text	t	2025-12-07 13:08:45.633925	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2901	147	151	阿迪拉进去的	text	t	2025-12-06 03:31:42.943181	2025-12-06 11:31:43.234884	风生水起	王先生	\N	\N	\N	normal				\N	\N	\N
2487	116	117	1111	text	t	2025-12-01 10:35:26.987242	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2591	145	116	00:01	call_ended	t	2025-12-03 16:47:01.494973	2025-12-04 00:47:01.586229	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2907	147	148	1	text	t	2025-12-06 06:05:50.644916	2025-12-06 14:30:17.753134	风生水起	阿迪	\N	\N	\N	normal				\N	\N	\N
2592	145	116	对方已拒绝	call_rejected	t	2025-12-03 16:47:17.605707	2025-12-04 00:47:17.752261	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2409	116	117	999	text	t	2025-11-28 22:03:14.447986	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2593	145	116	1	text	t	2025-12-03 16:47:23.23747	2025-12-04 00:47:23.367889	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2408	116	117	66666	text	t	2025-11-28 22:03:11.990745	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2594	145	116	你好	text	t	2025-12-03 16:47:33.018281	2025-12-04 00:47:33.233116	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2407	116	117	555	text	t	2025-11-28 22:03:08.860713	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2992	150	148	那应该是我的网络问题	text	t	2025-12-07 13:25:00.972331	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2596	116	145	你好	text	t	2025-12-03 16:47:44.647163	2025-12-04 00:47:44.718486	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2991	150	148	又可以了	text	t	2025-12-07 13:24:53.097414	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2598	116	145	你好	text	f	2025-12-03 16:48:52.461398	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2990	150	148	4	text	t	2025-12-07 13:24:47.092529	2025-12-07 13:25:24.631552	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2599	116	145	1	text	t	2025-12-03 16:49:09.273517	2025-12-04 00:49:09.415164	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2600	116	145	11111	text	f	2025-12-03 16:49:19.777516	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2601	116	145	2222	text	f	2025-12-03 16:49:21.300286	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2602	116	145	33333	text	f	2025-12-03 16:49:22.462116	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2603	116	145	4444	text	f	2025-12-03 16:49:23.692759	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2406	116	117	1	text	t	2025-11-28 22:03:05.433918	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2604	116	145	111	text	t	2025-12-03 16:49:29.323149	2025-12-04 00:49:29.475665	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2993	148	150	1	text	t	2025-12-07 13:25:30.134614	2025-12-07 13:25:30.40871	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2605	145	116	111	text	t	2025-12-03 16:49:41.098694	2025-12-04 00:49:41.226951	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2404	116	117	1	text	t	2025-11-28 22:03:01.061866	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2606	145	116	222	text	t	2025-12-03 16:49:42.277354	2025-12-04 00:49:42.442877	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2994	148	150	1	text	t	2025-12-07 13:25:34.509497	2025-12-07 13:25:35.071324	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2607	145	116	333	text	t	2025-12-03 16:49:43.371867	2025-12-04 00:49:43.575465	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2995	148	150	群里面好像不可以	text	t	2025-12-07 13:25:43.29686	2025-12-07 13:25:43.871753	阿迪	大江	\N	\N	\N	normal				\N	\N	\N
2609	145	116	你好	text	t	2025-12-03 16:50:01.478149	2025-12-04 00:50:01.694101	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2608	145	116	444	text	t	2025-12-03 16:49:44.336962	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2597	145	116	你好	text	t	2025-12-03 16:48:00.669522	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2595	145	116	你好	text	t	2025-12-03 16:47:36.647625	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2590	145	116	1	text	t	2025-12-03 16:46:32.401763	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2589	145	116	你好	text	t	2025-12-03 16:38:29.630629	2025-12-06 09:18:02.581155	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2403	116	117	1	text	t	2025-11-28 22:02:59.799973	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2913	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765001459_JPEG_20251206_141103_4313043186139451807.jpg	image	t	2025-12-06 06:11:01.612968	2025-12-06 14:11:01.888348	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
2400	116	117	你好	text	t	2025-11-28 21:57:51.665359	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2914	147	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765001467_JPEG_20251206_141107_5343174259172886986.jpg	image	t	2025-12-06 06:11:08.065427	2025-12-06 14:11:08.196402	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
2378	116	117	你好	text	t	2025-11-28 15:59:30.385902	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2916	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1765001557_VID_20251116_120424_679.mp4	video	t	2025-12-06 06:12:44.159242	2025-12-06 14:12:44.272005	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
2377	116	117	你好	text	t	2025-11-28 15:58:56.230905	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2917	147	149	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1765001555_26ec1bea1cbbb350564e60f0cc08ce47.mp4	video	t	2025-12-06 06:12:56.718435	2025-12-06 14:12:56.838989	风生水起	苏	\N	\N	\N	normal				\N	\N	\N
2337	116	117	你好	text	t	2025-11-28 13:47:24.302251	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2335	116	117	你好	text	t	2025-11-28 00:57:07.870637	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2333	116	117	在干什么	text	t	2025-11-28 00:56:07.620069	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2331	116	117	你好	text	t	2025-11-28 00:55:49.842044	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2330	116	117	你好	text	t	2025-11-28 00:54:21.648855	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2327	116	117	请求添加好友【已通过】	text	t	2025-11-28 00:52:53.032035	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2928	151	150	8	text	t	2025-12-06 06:40:08.60547	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2927	151	150	5	text	t	2025-12-06 06:40:07.059359	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2926	151	150	6	text	t	2025-12-06 06:40:06.184086	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2925	151	150	3	text	t	2025-12-06 06:40:04.991751	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2924	151	150	2	text	t	2025-12-06 06:40:03.801608	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2923	151	150	1	text	t	2025-12-06 06:40:01.848003	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2303	116	117	22222	text	t	2025-11-27 14:59:32.376949	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2293	116	117	你好	text	t	2025-11-27 14:00:14.722392	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2951	150	147	给你	text	t	2025-12-06 06:56:14.517234	2025-12-06 14:56:15.535494	大江	风生水起	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2292	116	117	哈楼	text	t	2025-11-27 13:59:19.292812	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2952	150	147	女子	text	t	2025-12-06 06:56:18.874138	2025-12-06 14:56:19.028328	大江	风生水起	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2224	116	117	你好	text	t	2025-11-26 22:31:10.738202	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal				\N	\N	\N
2953	150	147	妹妹	text	t	2025-12-06 06:56:20.898473	2025-12-06 14:56:28.128344	大江	风生水起	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2950	149	147	就看见了	text	t	2025-12-06 06:56:11.313948	2025-12-06 14:56:34.18499	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2959	153	152	请求添加好友【已通过】	text	t	2025-12-06 14:56:45.729416	2025-12-06 14:56:50.054574	wxhh	wxh	\N	\N	\N	normal				\N	\N	\N
2958	152	153	请求添加好友【已通过】	text	t	2025-12-06 14:56:45.728137	2025-12-06 15:07:56.01883	wxh	wxhh	\N	\N	\N	normal				\N	\N	\N
2656	116	141	1	text	t	2025-12-04 12:26:54.467367	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
3002	150	148	2	text	t	2025-12-07 13:39:45.929955	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
3001	150	148	1	text	t	2025-12-07 13:39:43.218891	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
3000	150	148	1	text	t	2025-12-07 13:39:40.056811	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2999	150	148	1	text	t	2025-12-07 13:39:35.7733	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2998	150	148	1	text	t	2025-12-07 13:39:33.395035	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2997	150	148	数字	text	t	2025-12-07 13:39:30.73263	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
2996	150	148	延迟很厉害，有时候能发出去有时候发不出去	text	t	2025-12-07 13:39:26.804349	2025-12-14 10:05:02.662588	大江	阿迪	\N	\N	\N	normal				\N	\N	\N
3056	117	116	在做什么	text	f	2025-12-15 21:18:05.752342	\N	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2915	149	147	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765001532_JPEG_20251206_141216_3661491002188513628.jpg	image	t	2025-12-06 06:12:13.883616	2025-12-06 14:12:14.153944	苏	风生水起	\N	\N	\N	normal				\N	\N	\N
2918	150	147	00:10	call_ended	t	2025-12-06 06:21:48.653031	2025-12-06 14:22:10.168257	大江	风生水起	\N	\N	\N	normal				voice	\N	\N
2955	147	150	妹妹	text	t	2025-12-06 06:56:31.847304	2025-12-06 14:56:35.156302	风生水起	大江	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2957	147	149	看到啥	text	t	2025-12-06 06:56:39.136413	2025-12-06 14:56:58.439327	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	\N	\N	\N
2956	149	151	看咯	text	t	2025-12-06 06:56:34.04076	2025-12-06 15:06:14.608993	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2954	149	151	考虑考虑	text	t	2025-12-06 06:56:24.838468	2025-12-06 15:06:14.608993	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2442	144	143	请求添加好友【已通过】	text	t	2025-11-30 15:59:43.340165	2025-12-11 11:50:54.0699	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2663	141	116	1	text	t	2025-12-05 02:28:38.616849	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2664	141	116	3	text	t	2025-12-05 02:28:40.50348	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2666	141	116	66	text	t	2025-12-05 02:28:48.096874	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2667	141	116	44	text	t	2025-12-05 02:28:51.118796	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2676	141	116	00:06	call_ended	t	2025-12-05 02:32:22.713684	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2674	116	141	一估计会	text	t	2025-12-05 02:29:48.221858	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2673	116	141	8	text	t	2025-12-05 02:29:45.550897	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2672	116	141	6	text	t	2025-12-05 02:29:41.680983	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2671	116	141	3	text	t	2025-12-05 02:29:40.670173	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2670	116	141	2	text	t	2025-12-05 02:29:39.70092	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2669	116	141	1	text	t	2025-12-05 02:29:38.231263	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2668	116	141	1	text	t	2025-12-05 02:29:02.773474	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2665	116	141	你好	text	t	2025-12-05 02:28:45.44619	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2440	144	143	你好	text	t	2025-11-30 15:58:40.344638	2025-12-11 11:50:54.0699	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2439	144	143	请求添加好友【已通过】	text	t	2025-11-30 15:58:21.068831	2025-12-11 11:50:54.0699	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2429	144	143	请求添加好友【已通过】	text	t	2025-11-29 15:10:39.11697	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2426	144	143	11	text	t	2025-11-29 15:08:30.836504	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2425	144	143	111	text	t	2025-11-29 15:08:23.524827	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2424	144	143	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764399910_屏幕截图 2025-08-12 125412.png	image	t	2025-11-29 15:05:10.595995	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3057	117	116	你好	text	f	2025-12-15 21:27:06.653309	\N	秋风2	秋风1	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2675	116	141	1111	text	t	2025-12-05 02:31:04.471591	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
3061	141	117	请求添加好友【已通过】	text	t	2025-12-15 23:47:59.258896	2025-12-15 23:48:07.951897	秋风2	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2919	151	150	请求添加好友【已通过】	text	t	2025-12-06 14:23:18.08041	2025-12-06 14:23:30.018108	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2920	150	151	请求添加好友【已通过】	text	t	2025-12-06 14:23:18.081383	2025-12-06 14:23:46.132896	大江	王先生	\N	\N	\N	normal				\N	\N	\N
2922	147	149	00:22	call_ended	t	2025-12-06 06:32:59.617229	2025-12-06 14:32:59.768992	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	voice	\N	\N
3062	117	141	111	text	t	2025-12-15 23:48:19.915538	2025-12-15 23:48:30.49653	秋风2	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png		\N	\N	\N
3063	141	117	在吗	text	f	2025-12-15 23:48:54.853914	\N	秋风2	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
3064	141	117	在吗	text	f	2025-12-15 23:49:06.277728	\N	秋风2	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
3065	141	117	在吗	text	f	2025-12-15 23:49:10.277809	\N	秋风2	秋风2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2933	149	148	晚上好	text	t	2025-12-06 06:47:11.917728	2025-12-06 14:47:52.581794	苏	阿迪	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg		\N	\N	\N
2935	151	148	1	text	t	2025-12-06 06:47:15.515715	2025-12-06 14:47:53.175441	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2934	151	148	1	text	t	2025-12-06 06:47:12.758202	2025-12-06 14:47:53.175441	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2932	151	148	1	text	t	2025-12-06 06:47:11.324372	2025-12-06 14:47:53.175441	王先生	阿迪	\N	\N	\N	normal				\N	\N	\N
2939	149	151	哈哈哈	text	t	2025-12-06 06:52:29.662617	2025-12-06 14:52:39.099729	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg		\N	\N	\N
2944	147	151	7	text	t	2025-12-06 06:52:38.321376	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2943	147	151	4	text	t	2025-12-06 06:52:34.96005	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2942	147	151	6	text	t	2025-12-06 06:52:33.621829	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2941	147	151	5	text	t	2025-12-06 06:52:32.40065	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2940	147	151	3	text	t	2025-12-06 06:52:29.822087	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2938	147	151	2	text	t	2025-12-06 06:52:28.901947	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2937	147	151	1	text	t	2025-12-06 06:52:27.897438	2025-12-06 14:52:43.531657	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2936	149	147	啥	text	t	2025-12-06 06:52:13.621856	2025-12-06 14:52:52.126443	苏	风生水起	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2948	149	151	咯咯咯	text	t	2025-12-06 06:53:17.27303	2025-12-06 14:54:06.952312	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg		\N	\N	\N
2947	149	151	太可怜了咯	text	t	2025-12-06 06:53:07.404588	2025-12-06 14:54:06.952312	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg		\N	\N	\N
2945	149	151	吉林	text	t	2025-12-06 06:52:55.672116	2025-12-06 14:54:06.952312	苏	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg		\N	\N	\N
2949	150	151	1	text	t	2025-12-06 06:54:22.79226	2025-12-06 14:56:17.108439	大江	王先生	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	\N	\N	\N
2946	147	151	1	text	t	2025-12-06 06:53:06.271153	2025-12-06 14:56:18.812077	风生水起	王先生	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2961	150	147	你说	text	t	2025-12-06 06:56:56.153389	2025-12-06 14:57:03.236767	大江	风生水起	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2960	150	147	跟明哥说安排搞妹妹	text	t	2025-12-06 06:56:51.630501	2025-12-06 14:57:03.236767	大江	风生水起	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	\N	\N	\N
2417	144	143	请求添加好友【已通过】	text	t	2025-11-29 15:02:52.652648	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2415	144	143	请求添加好友【已驳回】	text	t	2025-11-29 15:00:28.813351	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2413	144	143	请求添加好友【已驳回】	text	t	2025-11-29 14:57:49.091772	2025-12-11 11:50:54.0699	cesfffff	aa123456	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3003	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765425115124308302_voice_1765425081012.m4a	voice	t	2025-12-11 03:51:58.68717	2025-12-11 12:09:13.223696	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	33
2921	147	149	哈喽	text	t	2025-12-06 06:25:45.752672	2025-12-06 14:26:01.838694	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg		\N	\N	\N
2694	120	118	请求添加好友【已通过】	text	t	2025-12-05 21:11:15.951006	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2692	120	118	请求添加好友【已通过】	text	t	2025-12-05 21:11:15.880883	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
3059	127	126	22	text	t	2025-12-15 23:32:11.268277	2025-12-15 23:32:35.975117	测试901	123	\N	\N	\N	normal				\N	\N	\N
3058	127	126	11	text	t	2025-12-15 23:32:09.86411	2025-12-15 23:32:35.975117	测试901	123	\N	\N	\N	normal				\N	\N	\N
2688	143	142	对方已拒绝	call_rejected_video	f	2025-12-05 08:03:41.153614	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2690	143	142	对方已拒绝	call_rejected_video	f	2025-12-05 08:08:43.069719	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2693	118	120	请求添加好友【已通过】	text	f	2025-12-05 21:11:15.882452	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2695	118	120	请求添加好友【已通过】	text	f	2025-12-05 21:11:15.95226	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2696	118	120	1	text	f	2025-12-05 13:11:19.14034	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2697	118	120	1	text	f	2025-12-05 13:11:24.310522	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2698	118	120	2	text	f	2025-12-05 13:11:28.636843	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2704	118	120	00:03	call_ended_video	f	2025-12-05 13:12:06.041126	\N	有度	有度2	\N	\N	\N	normal				video	\N	\N
2703	120	118	已拒绝	call_rejected	t	2025-12-05 13:11:58.38207	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				voice	\N	\N
2706	116	145	1	text	f	2025-12-05 13:20:08.003782	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2702	120	118	1	text	t	2025-12-05 13:11:43.326784	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2691	142	143	对方已取消	call_cancelled_video	t	2025-12-05 08:09:09.2549	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2710	127	132	请求添加好友【已通过】	text	f	2025-12-05 21:24:40.699994	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2682	127	128	55	text	t	2025-12-05 04:14:04.029516	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2681	127	128	44	text	t	2025-12-05 04:14:02.935573	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2679	128	127	33	text	t	2025-12-05 04:07:17.899237	2025-12-06 01:15:16.572537	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
2707	141	116	1	text	t	2025-12-05 13:24:19.842624	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2705	116	141	1	text	t	2025-12-05 13:18:14.392545	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2713	127	132	222	text	f	2025-12-05 13:25:02.555183	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2747	116	126	111	text	t	2025-12-05 13:52:36.603399	2025-12-14 17:25:41.080699	秋风1	123	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2741	116	126	你好	text	t	2025-12-05 13:43:33.533776	2025-12-14 17:25:41.080699	秋风1	123	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2717	116	117	你好	text	t	2025-12-05 13:25:47.739483	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2931	151	150	1	text	t	2025-12-06 06:40:14.119376	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2930	151	150	4	text	t	2025-12-06 06:40:12.87999	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2929	151	150	9	text	t	2025-12-06 06:40:11.402378	2025-12-06 14:48:03.267359	王先生	大江	\N	\N	\N	normal				\N	\N	\N
2735	127	132	555	text	f	2025-12-05 13:30:41.317668	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2736	127	132	555	text	f	2025-12-05 13:30:51.555971	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2737	127	132	666	text	f	2025-12-05 13:31:36.612617	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2740	127	132	777	text	f	2025-12-05 13:33:27.203991	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2689	142	143	对方已取消	call_cancelled	t	2025-12-05 08:08:29.020364	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2687	142	143	00:07	call_ended_video	t	2025-12-05 08:03:32.847882	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
2686	142	143	00:29	call_ended_video	t	2025-12-05 08:02:27.371522	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	video	\N	\N
2685	142	143	对方已拒绝	call_rejected	t	2025-12-05 08:01:08.42048	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2750	118	120	00:07	call_ended	f	2025-12-05 14:00:01.540118	\N	有度	有度2	\N	\N	\N	normal				voice	\N	\N
2733	132	127	55	text	t	2025-12-05 13:30:24.154147	2025-12-06 00:54:04.438363	测试907	测试901	\N	\N	\N	normal				\N	\N	\N
2720	141	116	2	text	t	2025-12-05 13:26:53.016273	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2721	141	116	3	text	t	2025-12-05 13:26:54.359086	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2722	141	116	4	text	t	2025-12-05 13:26:55.446397	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2723	141	116	5	text	t	2025-12-05 13:26:56.51553	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2734	141	116	00:32	call_ended_video	t	2025-12-05 13:30:25.795236	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	video	\N	\N
2746	116	141	1	text	t	2025-12-05 13:52:30.113495	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2745	116	141	已拒绝	call_rejected	t	2025-12-05 13:47:57.456983	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		voice	\N	\N
2744	116	141	已拒绝	call_rejected	t	2025-12-05 13:47:42.10585	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		voice	\N	\N
2743	116	141	已拒绝	call_rejected	t	2025-12-05 13:47:30.358841	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		voice	\N	\N
2684	142	143	对方已拒绝	call_rejected	t	2025-12-05 08:00:47.165465	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2683	142	143	00:04	call_ended	t	2025-12-05 08:00:40.214313	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
2521	142	143	请求添加好友【已通过】	text	t	2025-12-02 21:19:54.499211	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3060	117	141	请求添加好友【已通过】	text	t	2025-12-15 23:47:59.257239	2025-12-15 23:48:30.49653	秋风2	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png		\N	\N	\N
2714	116	117	你好	text	t	2025-12-05 13:25:19.067382	2025-12-15 21:17:53.562515	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	\N	\N	\N
2962	147	149	00:29	call_ended_video	t	2025-12-06 07:04:26.632324	2025-12-06 15:04:26.779001	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	video	\N	\N
2719	118	120	1	text	f	2025-12-05 13:26:21.834709	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2724	118	120	1+	text	f	2025-12-05 13:27:16.041899	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2725	118	120	1	text	f	2025-12-05 13:27:16.234099	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2726	118	120	1	text	f	2025-12-05 13:27:16.617369	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2964	153	152	1	text	t	2025-12-06 07:07:59.094134	2025-12-06 15:08:00.900015	wxhh	wxh	\N	\N	\N	normal				\N	\N	\N
2730	118	120	1	text	f	2025-12-05 13:29:38.07505	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2731	118	120	1	text	f	2025-12-05 13:29:38.929204	\N	有度	有度2	\N	\N	\N	normal				\N	\N	\N
2965	153	152	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/153/1765004941408731562_Video_1765004132524.mp4	video	t	2025-12-06 07:09:13.461058	2025-12-06 15:09:13.59191	wxhh	wxh	\N	\N	\N	normal				\N	\N	\N
2738	127	132	ytt	text	f	2025-12-05 13:32:19.617915	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2739	127	132	777	text	f	2025-12-05 13:33:10.810473	\N	测试901	测试907	\N	\N	\N	normal				\N	\N	\N
2727	120	118	1	text	t	2025-12-05 13:28:05.602095	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2752	118	120	00:04	call_ended_video	f	2025-12-05 14:00:14.533801	\N	有度	有度2	\N	\N	\N	normal				video	\N	\N
2729	132	127	444	text	t	2025-12-05 13:29:30.209997	2025-12-06 00:54:04.438363	测试907	测试901	\N	\N	\N	normal				\N	\N	\N
2715	132	127	33	text	t	2025-12-05 13:25:36.57444	2025-12-06 00:54:04.438363	测试907	测试901	\N	\N	\N	normal				\N	\N	\N
2718	141	116	11	text	t	2025-12-05 13:26:20.47254	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2728	141	116	222	text	t	2025-12-05 13:28:58.297978	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2732	141	116	00:03	call_ended	t	2025-12-05 13:29:40.47997	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2748	116	141	1	text	t	2025-12-05 13:55:39.646541	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2742	116	141	已拒绝	call_rejected	t	2025-12-05 13:47:19.602772	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		voice	\N	\N
2716	116	141	你好	text	t	2025-12-05 13:25:37.581443	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2968	152	118	请求添加好友【已通过】	text	t	2025-12-06 15:13:13.023021	2025-12-06 15:13:15.99318	wxh	有度	\N	\N	\N	normal				\N	\N	\N
2969	118	152	请求添加好友【已通过】	text	t	2025-12-06 15:13:13.024531	2025-12-06 15:13:16.155426	有度	wxh	\N	\N	\N	normal				\N	\N	\N
2520	142	143	1	text	t	2025-12-02 13:19:13.490051	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
1843	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/1763991139_1763990915_2637-161442811_tiny.mp4	video	t	2025-11-24 21:32:39.870368	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
2494	142	143	1	text	t	2025-12-01 14:19:52.295542	2025-12-11 11:52:13.048042	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2479	142	143	请求添加好友【已通过】	text	t	2025-12-01 10:25:59.692299	2025-12-11 11:52:13.048042	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
2477	142	143	00:04	call_ended	t	2025-12-01 10:25:12.215593	2025-12-11 11:52:13.048042	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
2475	142	143	1	text	t	2025-12-01 10:24:50.61312	2025-12-11 11:52:13.048042	ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3004	143	142	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765425198523768370_voice_1765425137703.m4a	voice	f	2025-12-11 03:53:23.011469	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	60
2963	147	149	00:04	call_ended	t	2025-12-06 07:04:39.418721	2025-12-06 15:04:39.84557	风生水起	苏	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	voice	\N	\N
2711	132	127	请求添加好友【已通过】	text	t	2025-12-05 21:24:40.7012	2025-12-06 00:54:04.438363	测试907	测试901	\N	\N	\N	normal				\N	\N	\N
2712	132	127	111	text	t	2025-12-05 13:24:45.883854	2025-12-06 00:54:04.438363	测试907	测试901	\N	\N	\N	normal				\N	\N	\N
2398	113	127	333	text	t	2025-11-28 19:08:47.913177	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2397	113	127	222	text	t	2025-11-28 19:05:21.456898	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2396	113	127	111	text	t	2025-11-28 19:05:03.086915	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2395	113	127	999	text	t	2025-11-28 19:01:40.354526	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2394	113	127	222	text	t	2025-11-28 19:00:40.505481	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2393	113	127	111	text	t	2025-11-28 19:00:34.346398	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2391	113	127	请求添加好友【已通过】	text	t	2025-11-28 19:00:18.687923	2025-12-06 00:58:01.397449	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2680	127	128	00:01	call_ended	t	2025-12-05 04:12:47.668991	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				voice	\N	\N
2677	127	128	11	text	t	2025-12-05 04:07:10.376229	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2501	127	128	22	text	t	2025-12-02 12:57:03.482546	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2347	127	128	444344	text	t	2025-11-28 14:11:57.864149	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2346	127	128	123123	text	t	2025-11-28 14:11:45.630847	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2345	127	128	请求添加好友【已通过】	text	t	2025-11-28 14:11:40.521889	2025-12-06 00:58:19.120366	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2756	113	127	333	text	t	2025-12-05 17:14:44.084215	2025-12-06 01:15:08.506596	测试22	测试901	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
2755	128	127	11	text	t	2025-12-05 16:58:21.945939	2025-12-06 01:15:16.572537	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
2759	128	127	11	text	t	2025-12-05 17:16:39.711667	2025-12-06 01:16:39.821927	测试902	测试901	\N	\N	\N	normal				\N	\N	\N
2350	130	128	123123	text	t	2025-11-28 14:24:22.573251	2025-12-06 01:16:48.370732	测试905	测试902	\N	\N	\N	normal				\N	\N	\N
2349	130	128	请求添加好友【已通过】	text	t	2025-11-28 14:23:55.159976	2025-12-06 01:16:48.370732	测试905	测试902	\N	\N	\N	normal				\N	\N	\N
2760	127	128	666	text	t	2025-12-05 17:16:52.323622	2025-12-06 01:16:54.373121	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2758	127	128	33	text	t	2025-12-05 17:15:21.775662	2025-12-06 01:16:54.373121	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2757	127	128	22	text	t	2025-12-05 17:15:20.580599	2025-12-06 01:16:54.373121	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2761	127	128	io	text	f	2025-12-05 17:17:09.826158	\N	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2762	127	128	hhg	text	f	2025-12-05 17:17:11.725693	\N	测试901	测试902	\N	\N	\N	normal				\N	\N	\N
2445	141	116	你好	text	t	2025-11-30 17:47:29.378728	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2450	141	116	1	text	t	2025-11-30 17:48:59.241268	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2451	141	116	1	text	t	2025-11-30 17:48:59.644476	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2452	141	116	1	text	t	2025-11-30 17:49:00.06504	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2456	141	116	1	text	t	2025-11-30 17:49:12.926309	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2457	141	116	1	text	t	2025-11-30 17:49:15.248482	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
3167	102	112	请求添加好友【已通过】	text	t	2025-12-19 10:04:34.851728	2025-12-19 10:04:38.716468	测试01	测试21	\N	\N	\N	normal				\N	\N	\N
2458	141	116	1	text	t	2025-11-30 17:49:15.495304	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2459	141	116	1	text	t	2025-11-30 17:49:15.944649	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2460	141	116	1	text	t	2025-11-30 17:49:16.395731	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2461	141	116	1	text	t	2025-11-30 17:49:16.795566	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2462	141	116	111	text	t	2025-11-30 17:49:17.988424	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2463	141	116	1	text	t	2025-11-30 17:49:18.241933	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2464	141	116	1	text	t	2025-11-30 17:49:18.677685	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2753	141	116	对方已取消	call_cancelled	t	2025-12-05 14:32:19.904295	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2754	116	141	对方已拒绝	call_rejected	t	2025-12-05 14:32:26.157176	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2751	116	141	1111	text	t	2025-12-05 14:00:11.434979	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2749	116	141	1	text	t	2025-12-05 13:59:45.865955	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2465	141	116	1	text	t	2025-11-30 17:49:19.137527	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2466	141	116	1123	text	t	2025-11-30 17:49:28.853372	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2467	141	116	136	text	t	2025-11-30 17:49:30.410271	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2468	141	116	255415	text	t	2025-11-30 17:49:31.935996	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2469	141	116	123	text	t	2025-11-30 17:49:33.161874	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2470	141	116	1	text	t	2025-11-30 17:49:33.466467	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2473	141	116	00:09	call_ended_video	t	2025-11-30 17:52:10.660153	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	video	\N	\N
2534	141	116	1	text	t	2025-12-03 07:08:37.790095	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2535	141	116	2	text	t	2025-12-03 07:08:39.402247	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2536	141	116	3	text	t	2025-12-03 07:08:40.889934	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2537	141	116	4	text	t	2025-12-03 07:08:42.459603	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2538	141	116	5	text	t	2025-12-03 07:08:44.106013	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2539	141	116	6	text	t	2025-12-03 07:08:45.923676	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2542	141	116	1	text	t	2025-12-03 07:10:46.300504	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2543	141	116	2	text	t	2025-12-03 07:10:47.847017	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2544	141	116	3	text	t	2025-12-03 07:10:48.802288	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2545	141	116	5	text	t	2025-12-03 07:11:03.372256	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2546	141	116	6	text	t	2025-12-03 07:11:04.643834	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2547	141	116	7	text	t	2025-12-03 07:11:05.467502	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2548	141	116	8	text	t	2025-12-03 07:11:06.440491	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2550	141	116	1	text	t	2025-12-03 13:28:21.835856	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2551	141	116	2	text	t	2025-12-03 13:28:24.091755	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2552	141	116	3	text	t	2025-12-03 13:28:25.682827	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2553	141	116	4	text	t	2025-12-03 13:28:27.265114	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2554	141	116	9	text	t	2025-12-03 13:28:29.461917	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2555	141	116	9	text	t	2025-12-03 13:28:31.619442	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2556	141	116	6	text	t	2025-12-03 13:28:33.157313	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2557	141	116	6	text	t	2025-12-03 13:28:34.633637	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2558	141	116	1	text	t	2025-12-03 13:28:58.242625	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2559	141	116	对方已取消	call_cancelled	t	2025-12-03 13:29:56.125677	2025-12-06 09:17:43.057365	秋风	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2610	141	116	1	text	t	2025-12-04 12:21:17.787182	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2611	141	116	1	text	t	2025-12-04 12:21:21.447184	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2612	141	116	1	text	t	2025-12-04 12:21:36.13658	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2613	141	116	3	text	t	2025-12-04 12:21:37.720924	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2614	141	116	5	text	t	2025-12-04 12:21:39.287843	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2615	141	116	4	text	t	2025-12-04 12:21:40.420276	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2341	126	127	请求添加好友【已通过】	text	t	2025-11-28 13:55:45.46637	2025-12-06 15:09:43.284139	123	222	\N	\N	\N	normal				\N	\N	\N
2616	141	116	65	text	t	2025-12-04 12:21:41.644251	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2617	141	116	96	text	t	2025-12-04 12:21:42.993275	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2618	141	116	1	text	t	2025-12-04 12:21:59.670967	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2619	141	116	12	text	t	2025-12-04 12:22:01.969315	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2620	141	116	32	text	t	2025-12-04 12:22:03.821612	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2621	141	116	4	text	t	2025-12-04 12:22:04.75764	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2622	141	116	5	text	t	2025-12-04 12:22:05.569686	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2623	141	116	6	text	t	2025-12-04 12:22:06.283611	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2624	141	116	9	text	t	2025-12-04 12:22:07.134511	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2625	141	116	5	text	t	2025-12-04 12:22:07.952825	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2626	141	116	87	text	t	2025-12-04 12:22:08.963439	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2627	141	116	4	text	t	2025-12-04 12:22:09.917	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2628	141	116	5	text	t	2025-12-04 12:22:10.61714	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2629	141	116	62	text	t	2025-12-04 12:22:11.599884	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2630	141	116	12	text	t	2025-12-04 12:22:12.490276	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2631	141	116	63	text	t	2025-12-04 12:22:13.247664	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2632	141	116	54	text	t	2025-12-04 12:22:14.231673	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2633	141	116	654	text	t	2025-12-04 12:22:15.241023	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2634	141	116	95	text	t	2025-12-04 12:22:16.130673	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2635	141	116	641	text	t	2025-12-04 12:22:17.671416	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2636	141	116	12	text	t	2025-12-04 12:22:18.54548	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2637	141	116	12	text	t	2025-12-04 12:22:19.344133	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2638	141	116	1	text	t	2025-12-04 12:22:31.859419	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2639	141	116	2	text	t	2025-12-04 12:22:32.354278	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2640	141	116	21	text	t	2025-12-04 12:22:33.073371	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2641	141	116	3	text	t	2025-12-04 12:22:33.930368	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2642	141	116	25	text	t	2025-12-04 12:22:34.668971	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2643	141	116	21	text	t	2025-12-04 12:22:35.398343	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2644	141	116	56	text	t	2025-12-04 12:22:36.309434	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2645	141	116	1	text	t	2025-12-04 12:22:37.413969	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2646	141	116	231	text	t	2025-12-04 12:22:38.513298	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2647	141	116	12	text	t	2025-12-04 12:22:46.555423	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2648	141	116	3652323	text	t	2025-12-04 12:22:48.467423	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2649	141	116	32132123	text	t	2025-12-04 12:22:49.432141	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2650	141	116	121454	text	t	2025-12-04 12:22:50.769212	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2651	141	116	66	text	t	2025-12-04 12:22:51.724659	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2652	141	116	31	text	t	2025-12-04 12:24:31.970488	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2653	141	116	1	text	t	2025-12-04 12:25:11.188667	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2654	141	116	00:06	call_ended	t	2025-12-04 12:25:47.326776	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2655	141	116	00:05	call_ended	t	2025-12-04 12:26:15.249522	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	voice	\N	\N
2657	141	116	1	text	t	2025-12-04 12:34:41.070035	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2658	141	116	00:15	call_ended_video	t	2025-12-04 12:35:03.247318	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	video	\N	\N
2659	141	116	1	text	t	2025-12-04 12:37:13.052724	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2660	141	116	2	text	t	2025-12-04 12:37:17.818461	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2661	141	116	1	text	t	2025-12-05 02:28:16.795402	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2662	141	116	22	text	t	2025-12-05 02:28:36.450832	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2708	141	116	1111	text	t	2025-12-05 13:24:36.589952	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2709	141	116	22	text	t	2025-12-05 13:24:39.795414	2025-12-06 09:17:43.057365	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2766	141	116	在干什么	text	t	2025-12-06 01:19:29.275003	2025-12-06 09:19:50.127315	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2764	116	145	你好	text	f	2025-12-06 01:18:05.992916	\N	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2763	116	141	你好	text	t	2025-12-06 01:17:54.629552	2025-12-06 09:19:18.749314	秋风1	秋风2	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2387	116	141	你好	text	t	2025-11-28 16:04:55.407774	2025-12-06 09:19:18.749314	秋风1	秋风	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg		\N	\N	\N
2767	141	116	测试	text	t	2025-12-06 01:19:30.985423	2025-12-06 09:19:50.127315	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2765	141	116	你好	text	t	2025-12-06 01:19:21.518464	2025-12-06 09:19:24.822774	秋风2	秋风1	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	\N	\N	\N
2967	127	126	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/127/1765004996778677374_1765004013204959700_mmexport1765003993959.mp4	video	t	2025-12-06 07:10:13.355043	2025-12-14 17:25:42.800197	测试901	123	\N	\N	\N	normal				\N	\N	\N
2966	153	152	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/153/1765005003122615099_Video_1764662544659.mp4	video	t	2025-12-06 07:10:13.266064	2025-12-06 15:10:13.361886	wxhh	wxh	\N	\N	\N	normal				\N	\N	\N
2701	120	118	1	text	t	2025-12-05 13:11:42.515091	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2700	120	118	1111	text	t	2025-12-05 13:11:41.656498	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2699	120	118	11	text	t	2025-12-05 13:11:38.681993	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2283	120	118	[emotion:1_Smile.png]	text	t	2025-11-27 03:43:26.241426	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
2273	120	118	1	text	t	2025-11-27 03:42:09.322143	2025-12-06 15:12:58.372029	有度2	有度	\N	\N	\N	normal				\N	\N	\N
3005	143	142	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765425644517859691_voice_1765425642566.m4a	voice	f	2025-12-11 04:00:47.74307	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	1
3006	143	142	1	text	f	2025-12-11 04:00:51.77077	\N	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	\N	\N	\N
2526	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1764681527_JPEG_20251202_211848_523723774826566576.jpg	image	t	2025-12-02 13:27:07.320896	2025-12-11 12:09:13.223696	可可粉咳咳咳咳咳咳咳咳姐咳咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
2416	143	144	请求添加好友【已通过】	text	t	2025-11-29 15:02:52.65098	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		\N	\N	\N
2414	143	144	请求添加好友【已驳回】	text	t	2025-11-29 14:59:51.697325	2025-12-11 12:09:13.223696	aa123456	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png		\N	\N	\N
3066	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765865861191040000_voice_1765865858237.m4a	voice	t	2025-12-16 14:17:43.526518	2025-12-16 14:17:47.564758	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	2
3067	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765869333508717000_voice_1765869328801.m4a	voice	t	2025-12-16 15:15:35.876432	2025-12-16 15:15:35.901768	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	4
3068	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765870584496090000_voice_1765870581492.m4a	voice	t	2025-12-16 15:36:26.72293	2025-12-16 15:36:26.750162	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	2
3069	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765875738821556000_voice_1765875730910.m4a	voice	t	2025-12-16 17:02:22.763442	2025-12-16 17:02:22.798524	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	6
3070	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765876444398252000_voice_1765876434841.m4a	voice	t	2025-12-16 17:14:08.857481	2025-12-16 17:14:08.877577	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	8
3071	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765876494093704000_voice_1765876490956.m4a	voice	t	2025-12-16 17:14:56.880792	2025-12-16 17:14:56.897364	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	3
3072	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765876931664317000_voice_1765876924139.m4a	voice	t	2025-12-16 17:22:15.805792	2025-12-16 17:22:15.834229	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	5
3073	144	143	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/144/1765876955542485000_voice_1765876951138.m4a	voice	t	2025-12-16 17:22:40.742631	2025-12-16 17:22:40.827397	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	3
3074	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765877414028277000_voice_1765877409831.m4a	voice	t	2025-12-16 17:30:18.260799	2025-12-16 17:30:18.288844	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	4
3075	143	144	1111	text	t	2025-12-16 17:37:53.84895	2025-12-16 17:37:53.863396	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3076	143	144	2222	text	t	2025-12-16 17:38:26.794146	2025-12-16 17:38:26.806848	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3077	143	144	111	text	t	2025-12-16 17:48:48.889214	2025-12-16 17:48:48.91604	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3078	143	144	222	text	t	2025-12-16 17:49:20.381655	2025-12-16 17:49:20.395821	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3079	143	144	3333	text	t	2025-12-16 17:49:44.701124	2025-12-16 17:49:44.714967	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
1844	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1763991169_1763990946_test_voice_py	file	t	2025-11-24 21:32:53.406274	2025-12-19 09:39:41.518879	测试01	测试2	1763990946_test_voice_py	\N	\N	normal				\N	\N	\N
1847	102	103	00:05	call_ended	t	2025-11-24 21:33:45.80217	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				voice	\N	\N
2338	102	103	请求添加好友【已通过】	text	t	2025-11-28 13:51:24.258974	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3080	143	144	4444	text	t	2025-12-16 18:04:45.275075	2025-12-16 18:37:33.451539	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3081	143	144	5655	text	t	2025-12-16 18:39:37.997518	2025-12-16 18:39:38.018694	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3082	143	144	666	text	t	2025-12-16 18:39:54.534195	2025-12-16 18:39:54.545987	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3115	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765938605076398000_voice_1765938599112.m4a	voice	t	2025-12-17 10:30:08.034211	2025-12-17 10:30:08.070135	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	3
3116	143	144	7777	text	t	2025-12-17 10:57:15.096877	2025-12-17 10:57:15.112129	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3117	144	143	8888	text	t	2025-12-17 10:57:44.116241	2025-12-17 10:57:44.229492	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3118	143	144	8888	text	t	2025-12-17 10:58:22.117845	2025-12-17 10:58:22.131475	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3119	144	143	0000	text	t	2025-12-17 10:59:00.18886	2025-12-17 10:59:00.215208	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3120	143	144	1111	text	t	2025-12-17 11:02:18.707875	2025-12-17 11:02:18.719866	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3121	143	144	22222	text	t	2025-12-17 11:08:22.163381	2025-12-17 11:08:22.1861	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	recalled		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3122	143	144	00:02	call_ended	t	2025-12-17 11:10:15.249444	2025-12-17 11:10:15.268656	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	voice	\N	\N
3123	143	144	00:09	call_ended	t	2025-12-17 11:10:16.831322	2025-12-17 11:10:16.845323	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	voice	\N	\N
3124	144	143	222	text	t	2025-12-17 11:19:04.64591	2025-12-17 11:19:54.391356	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3125	143	144	333	text	t	2025-12-17 11:20:04.819333	2025-12-17 11:20:04.842163	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3126	144	143	00:11	call_ended	t	2025-12-17 11:20:23.647938	2025-12-17 11:20:23.689857	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	voice	\N	\N
3127	143	144	333	text	t	2025-12-17 11:20:33.120464	2025-12-17 11:20:33.131917	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3128	144	143	对方已拒绝	call_rejected	t	2025-12-17 11:30:02.233031	2025-12-17 11:30:03.866962	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3129	143	144	对方已取消	call_cancelled	t	2025-12-17 11:30:20.089262	2025-12-17 11:30:20.110728	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3130	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/voice/user/143/1765942689256259000_voice_1765942683899.m4a	voice	t	2025-12-17 11:38:11.868494	2025-12-17 11:38:11.976085	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	3
3131	144	143	67890	text	t	2025-12-17 11:39:37.823396	2025-12-17 11:39:37.856969	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
1757	102	103	请求添加好友【已通过】	text	t	2025-11-24 15:20:56.016732	2025-12-19 09:39:41.518879	test01	test02	\N	\N	\N	normal				\N	\N	\N
1758	102	103	111	text	t	2025-11-24 15:21:01.800378	2025-12-19 09:39:41.518879	test01	test02	\N	\N	\N	normal				\N	\N	\N
1798	102	103	111	text	t	2025-11-24 16:33:30.673746	2025-12-19 09:39:41.518879	test01	test02	\N	\N	\N	normal				\N	\N	\N
1799	102	103	[emotion:28_Sweat.png]	text	t	2025-11-24 16:33:39.922692	2025-12-19 09:39:41.518879	test01	test02	\N	\N	\N	normal				\N	\N	\N
3168	112	102	请求添加好友【已通过】	text	f	2025-12-19 10:04:34.855129	\N	测试21	测试01	\N	\N	\N	normal				\N	\N	\N
3132	143	144	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1765943581_image_0DD5F000-CAD9-4133-9914-CF8F5E8B9BAB_1765943582.png	image	t	2025-12-17 11:53:05.238627	2025-12-17 11:53:05.251929	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3515	102	103	88	text	t	2026-03-01 04:29:03.520274	2026-03-01 12:29:03.553788	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	278	\N
3516	102	103	99	text	t	2026-03-01 04:29:06.666622	2026-03-01 12:29:06.699558	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	279	\N
3583	102	103	6	text	t	2026-03-01 05:59:21.419044	2026-03-01 13:59:21.451022	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	190	\N
3624	103	102	777	text	t	2026-03-01 07:05:14.012818	2026-03-01 15:06:53.790996	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	160	\N
3625	103	102	888	text	t	2026-03-01 07:05:16.588323	2026-03-01 15:06:53.790996	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	161	\N
3626	103	102	999	text	t	2026-03-01 07:05:19.266647	2026-03-01 15:06:53.790996	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	162	\N
3137	143	144	888	text	t	2025-12-18 09:59:31.091417	2025-12-18 10:16:19.130806	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3136	143	144	333	text	t	2025-12-18 09:59:28.639562	2025-12-18 10:16:19.130806	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3135	143	144	6666	quoted	t	2025-12-17 12:41:47.163255	2025-12-18 10:16:19.130806	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	81	请求添加好友【已通过】	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3134	143	144	123	quoted	t	2025-12-17 12:41:10.534364	2025-12-18 10:16:19.130806	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	79	你好	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3133	143	144	123	quoted	t	2025-12-17 12:35:29.34129	2025-12-18 10:16:19.130806	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	79	你好	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3138	143	144	678	text	t	2025-12-18 10:17:39.710903	2025-12-18 10:17:41.841051	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3139	143	144	对方已拒绝	call_rejected	t	2025-12-18 10:18:14.97356	2025-12-18 10:18:14.986361	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3140	144	143	111	text	t	2025-12-18 10:33:25.317462	2025-12-18 10:33:25.354488	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3141	143	144	对方已取消	call_cancelled	t	2025-12-18 10:33:44.322406	2025-12-18 10:33:44.343926	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3146	143	144	对方已取消	call_cancelled	t	2025-12-18 11:58:37.902359	2025-12-18 12:00:26.442932	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3145	143	144	2233	text	t	2025-12-18 11:58:16.922432	2025-12-18 12:00:26.442932	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3144	143	144	对方已取消	call_cancelled	t	2025-12-18 10:39:16.818944	2025-12-18 12:00:26.442932	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3143	143	144	566	text	t	2025-12-18 10:39:05.540713	2025-12-18 12:00:26.442932	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3142	143	144	344	text	t	2025-12-18 10:38:59.099819	2025-12-18 12:00:26.442932	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3147	144	143	5555	text	t	2025-12-18 12:00:38.0151	2025-12-18 12:00:38.053884	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3148	144	143	对方已拒绝	call_rejected	t	2025-12-18 12:00:45.138531	2025-12-18 12:00:46.111505	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3149	143	144	对方已取消	call_cancelled	t	2025-12-18 12:01:01.620753	2025-12-18 12:01:01.668005	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3150	143	144	222	text	t	2025-12-18 12:01:09.489053	2025-12-18 12:01:09.500909	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3151	143	144	对方已取消	call_cancelled_video	t	2025-12-18 12:01:15.735252	2025-12-18 12:01:15.750809	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	cesfffff	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	\N	\N	\N
3152	144	143	对方已拒绝	call_rejected_video	t	2025-12-18 12:01:24.386934	2025-12-18 12:01:24.408189	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
1800	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763973233_ic_launcher.png	image	t	2025-11-24 16:33:55.828472	2025-12-19 09:39:41.518879	test01	test02	\N	\N	\N	normal				\N	\N	\N
1803	102	103	333	text	t	2025-11-24 17:05:25.770608	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
1806	102	103	666	text	t	2025-11-24 17:25:54.060367	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
1823	102	103	22	text	t	2025-11-24 19:22:44.434077	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
1825	102	103	😀	text	t	2025-11-24 19:31:27.227196	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal				\N	\N	\N
3154	144	143	444	text	t	2025-12-18 12:09:02.699176	2025-12-18 12:10:49.678742	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3153	144	143	333	text	t	2025-12-18 12:08:59.29593	2025-12-18 12:10:49.678742	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3517	102	103	99	text	t	2026-03-01 04:30:10.027576	2026-03-01 12:30:10.074162	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	279	\N
3155	144	143	55	text	t	2025-12-18 12:27:36.332583	2025-12-18 12:27:45.598528	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3590	102	103	a	text	t	2026-03-01 06:36:15.449726	2026-03-01 14:36:15.4826	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	194	\N
3157	144	143	777	text	t	2025-12-18 12:28:08.747214	2025-12-18 12:30:00.358212	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3156	144	143	666	text	t	2025-12-18 12:28:05.820727	2025-12-18 12:30:00.358212	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3158	144	143	88	text	t	2025-12-18 12:42:09.739769	2025-12-18 12:42:11.55581	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3592	102	103	c	text	t	2026-03-01 06:36:17.584446	2026-03-01 14:36:17.614582	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	196	\N
3160	144	143	00	text	t	2025-12-18 12:42:26.322155	2025-12-18 12:44:07.796584	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3159	144	143	99	text	t	2025-12-18 12:42:23.899459	2025-12-18 12:44:07.796584	cesfffff	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	\N	\N	\N
3627	103	102	11	text	t	2026-03-16 15:48:55.125223	2026-03-16 23:48:57.083965	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	163	\N
3630	102	103	https://youdu.co/images/1773678344_image_E65FE968-C315-4508-A71F-0E7B3BAFF7B1_1773678345.jpeg	image	t	2026-03-16 16:25:47.213039	2026-03-17 00:25:47.23925	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
3635	102	106	11111	text	t	2026-06-27 04:59:59.586796	2026-06-27 12:59:59.753379	测试01	测试05	\N	\N	\N	normal				\N	3255	\N
3636	106	102	2222	text	t	2026-06-27 05:00:06.240266	2026-06-27 13:00:06.315497	测试05	测试01	\N	\N	\N	normal				\N	17	\N
3637	106	102	https://youdu.co/voice/user/106/1782536424837729000_voice_1782536419840.m4a	voice	t	2026-06-27 05:00:27.884949	2026-06-27 13:00:27.901278	测试05	测试01	\N	\N	\N	normal				\N	18	3
3639	102	106	00:05	call_ended	t	2026-06-27 05:04:42.222879	2026-06-27 14:54:10.785493	测试01	测试05	\N	\N	\N	normal				voice	3259	\N
2264	102	103	请求添加好友【已通过】	text	t	2025-11-27 02:52:40.571801	2025-12-19 09:39:41.518879	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
1773	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763969526_JPEG_20251124_153207_1249816683658267111.jpg	image	t	2025-11-24 15:32:08.953384	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1784	103	102	999	text	t	2025-11-24 16:01:21.033761	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1795	103	102	77	text	t	2025-11-24 16:03:04.011098	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1796	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763971398_scaled_1ea9e636-8711-4828-adee-5d39962f47655191813218996667729.jpg	image	t	2025-11-24 16:03:23.117268	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1797	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1763971422_JPEG_20251124_160342_8938100472596704238.jpg	image	t	2025-11-24 16:03:46.167514	2025-12-19 09:40:00.623253	test02	test01	\N	\N	\N	normal				\N	\N	\N
1802	103	102	111	text	t	2025-11-24 17:05:15.81902	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1805	103	102	555	text	t	2025-11-24 17:25:43.786074	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal				\N	\N	\N
1839	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1763990946_test_voice_py	file	t	2025-11-24 21:29:09.606788	2025-12-19 09:40:00.623253	测试2	测试01	test_voice_py	\N	\N	normal				\N	\N	\N
2430	103	102	00	text	t	2025-11-29 17:50:45.773719	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3161	103	102	22	text	t	2025-12-19 09:39:58.674911	2025-12-19 09:40:00.623253	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3518	102	103	88	text	t	2026-03-01 04:30:10.028271	2026-03-01 12:30:10.074162	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	278	\N
3162	102	103	00:04	call_ended	t	2025-12-19 09:40:14.13004	2025-12-19 09:40:14.233246	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3163	102	103	00:03	call_ended_video	t	2025-12-19 09:40:38.298984	2025-12-19 09:40:38.313624	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	video	\N	\N
3164	102	158	请求添加好友【已通过】	text	t	2025-12-19 09:55:13.968786	2025-12-19 09:55:27.890394	测试01	ceshi922	\N	\N	\N	normal				\N	\N	\N
3591	102	103	b	text	t	2026-03-01 06:36:16.450211	2026-03-01 14:36:16.488847	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	195	\N
3166	158	102	111	text	t	2025-12-19 09:55:38.753552	2025-12-19 09:55:42.219262	ceshi922	测试01	\N	\N	\N	normal				\N	\N	\N
3165	158	102	请求添加好友【已通过】	text	t	2025-12-19 09:55:13.970702	2025-12-19 09:55:42.219262	ceshi922	测试01	\N	\N	\N	normal				\N	\N	\N
3594	102	103	e	text	t	2026-03-01 06:36:19.54171	2026-03-01 14:36:19.574697	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	198	\N
3597	102	103	d	text	t	2026-03-01 06:36:50.587385	2026-03-01 14:36:50.628842	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	197	\N
3628	102	103	https://youdu.co/images/1773676150_image_92068606-A909-4727-9A36-76DBF5445463_1773676151.jpeg	image	t	2026-03-16 15:49:13.838189	2026-03-16 23:49:13.87056	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3629	102	103	22	text	t	2026-03-16 16:25:39.890081	2026-03-17 00:25:39.918013	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	180	\N
3638	102	106	00:05	call_ended	t	2026-06-27 05:03:01.897428	2026-06-27 13:04:36.762525	测试01	测试05	\N	\N	\N	normal				voice	3258	\N
1901	102	112	请求添加好友【已通过】	text	t	2025-11-25 13:39:44.05865	2025-12-19 10:04:38.716468	测试01	测试21	\N	\N	\N	normal				\N	\N	\N
3519	102	103	aaa	text	t	2026-03-01 04:35:57.720565	2026-03-01 12:35:57.75734	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	280	\N
3169	102	113	请求添加好友【已通过】	text	t	2025-12-19 10:08:19.685952	2025-12-19 10:08:24.26367	测试01	测试22	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	\N	\N	\N
3534	102	103	did	text	t	2026-03-01 04:51:00.567882	2026-03-01 12:51:00.607401	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	289	\N
3171	102	114	请求添加好友【已通过】	text	t	2025-12-19 10:10:42.321219	2025-12-19 10:10:44.440924	测试01	测试23	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	\N	\N	\N
3174	159	102	请求添加好友【已通过】	text	f	2025-12-19 10:50:42.050647	\N	ceshi25	测试01	\N	\N	\N	normal				\N	\N	\N
3173	102	159	请求添加好友【已通过】	text	t	2025-12-19 10:50:42.049043	2025-12-19 10:50:45.315912	测试01	ceshi25	\N	\N	\N	normal				\N	\N	\N
3593	102	103	d	text	t	2026-03-01 06:36:18.637538	2026-03-01 14:36:18.668681	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	197	\N
3175	159	105	请求添加好友【已通过】	text	t	2025-12-19 10:51:26.52852	2025-12-19 10:51:29.858335	ceshi25	测试04	\N	\N	\N	normal				\N	\N	\N
3176	105	159	请求添加好友【已通过】	text	t	2025-12-19 10:51:26.529996	2025-12-19 10:51:38.754596	测试04	ceshi25	\N	\N	\N	normal				\N	\N	\N
3596	102	103	c	text	t	2026-03-01 06:36:50.58739	2026-03-01 14:36:50.628842	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	196	\N
3179	159	105	333	text	t	2025-12-19 10:57:34.528425	2025-12-19 10:57:37.398437	ceshi25	测试04	\N	\N	\N	normal				\N	\N	\N
3180	105	159	444	text	t	2025-12-19 10:57:44.47716	2025-12-19 10:57:44.503683	测试04	ceshi25	\N	\N	\N	normal				\N	\N	\N
3631	102	103	https://youdu.co/images/1773678393_image_F6C0617D-8871-4118-844A-43956D5317BC_1773678394.jpeg	image	t	2026-03-16 16:26:39.191808	2026-03-17 00:26:39.218362	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	182	\N
3181	159	105	555	text	t	2025-12-19 10:57:48.96541	2025-12-19 10:57:48.995776	ceshi25	测试04	\N	\N	\N	normal				\N	\N	\N
3183	106	105	请求添加好友【已通过】	text	t	2025-12-19 10:59:41.987442	2025-12-19 10:59:47.313002	测试05	测试04	\N	\N	\N	normal				\N	\N	\N
3182	105	106	请求添加好友【已通过】	text	t	2025-12-19 10:59:41.986412	2025-12-19 11:00:05.773462	测试04	测试05	\N	\N	\N	normal				\N	\N	\N
3172	114	102	请求添加好友【已通过】	text	t	2025-12-19 10:10:42.322978	2025-12-22 13:58:25.992714	测试23	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg		\N	\N	\N
3170	113	102	请求添加好友【已通过】	text	t	2025-12-19 10:08:19.687229	2025-12-22 13:58:29.455796	测试22	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png		\N	\N	\N
3641	106	102	00:13	call_ended	t	2026-06-27 10:22:18.441331	2026-06-27 18:22:47.980335	测试05	测试01	\N	\N	\N	normal				voice	24	\N
3640	106	102	00:18	call_ended	t	2026-06-27 10:20:54.30551	2026-06-27 18:22:47.980335	测试05	测试01	\N	\N	\N	normal				voice	23	\N
3177	105	159	111	text	t	2025-12-19 10:51:34.55426	2025-12-19 10:51:38.754596	测试04	ceshi25	\N	\N	\N	normal				\N	\N	\N
3178	159	105	222	text	t	2025-12-19 10:51:50.348737	2025-12-19 10:51:50.376196	ceshi25	测试04	\N	\N	\N	normal				\N	\N	\N
3520	102	103	bbb	text	t	2026-03-01 04:35:59.915353	2026-03-01 12:35:59.96612	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	281	\N
3522	102	103	aaa	text	t	2026-03-01 04:37:05.573343	2026-03-01 12:37:05.62068	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	280	\N
3525	102	103	eee	text	t	2026-03-01 04:45:53.587908	2026-03-01 12:45:53.61893	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	284	\N
3528	102	103	bbb	text	t	2026-03-01 04:47:13.844018	2026-03-01 12:47:13.875612	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	287	\N
3529	102	103	ccc	text	t	2026-03-01 04:47:15.144884	2026-03-01 12:47:15.177533	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	288	\N
3530	102	103	ccc	text	t	2026-03-01 04:48:15.57121	2026-03-01 12:48:15.60195	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	288	\N
3532	102	103	we	text	t	2026-03-01 04:49:57.133361	2026-03-01 12:49:57.167897	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	290	\N
3535	102	103	tttt	text	t	2026-03-01 05:04:14.828096	2026-03-01 13:04:14.863986	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	291	\N
3538	102	103	hi	text	t	2026-03-01 05:05:47.959036	2026-03-01 13:05:48.004115	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	293	\N
3541	102	103	cc	text	t	2026-03-01 05:08:08.219957	2026-03-01 13:08:08.251515	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	296	\N
3595	102	103	f	text	t	2026-03-01 06:36:20.306068	2026-03-01 14:36:20.356803	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	199	\N
3633	102	103	https://youdu.co/voice/user/102/1773678439999719000_voice_1773678437848.m4a	voice	t	2026-03-16 16:27:22.692833	2026-03-17 00:27:22.711783	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	185	2
3632	103	102	00:06	call_ended	t	2026-03-16 16:27:10.40338	2026-03-17 00:27:38.528675	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	168	\N
3642	106	102	00:10	call_ended_video	t	2026-06-27 10:22:43.606244	2026-06-27 18:22:47.980335	测试05	测试01	\N	\N	\N	normal				video	25	\N
3184	106	105	1	text	t	2025-12-19 11:06:57.198176	2025-12-19 11:07:00.135043	测试05	测试04	\N	\N	\N	normal				\N	\N	\N
3185	106	105	22	text	t	2025-12-19 11:07:04.586159	2025-12-19 11:07:04.616196	测试05	测试04	\N	\N	\N	normal				\N	\N	\N
3521	102	103	ccc	text	t	2026-03-01 04:36:01.803746	2026-03-01 12:36:01.84059	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	282	\N
3186	105	106	4455	text	t	2025-12-19 11:07:15.906212	2025-12-19 11:07:15.930506	测试04	测试05	\N	\N	\N	normal				\N	\N	\N
3524	102	103	we	text	t	2026-03-01 04:44:21.56333	2026-03-01 12:44:21.599244	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	283	\N
3187	105	107	请求添加好友【已通过】	text	t	2025-12-19 03:08:00.115304	2025-12-19 11:08:10.446679	测试04	测试06	\N	\N	\N	normal				\N	\N	\N
3188	107	105	请求添加好友【已通过】	text	t	2025-12-19 03:08:00.116641	2025-12-19 11:14:20.983477	测试06	测试04	\N	\N	\N	normal				\N	\N	\N
3527	102	103	aaa	text	t	2026-03-01 04:47:12.311726	2026-03-01 12:47:12.346	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	286	\N
3533	102	103	we	text	t	2026-03-01 04:51:00.567451	2026-03-01 12:51:00.607401	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	290	\N
3536	102	103	tttt	text	t	2026-03-01 05:05:15.551744	2026-03-01 13:05:15.588447	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	291	\N
3542	102	103	cc	text	t	2026-03-01 05:09:10.549676	2026-03-01 13:09:10.583324	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	296	\N
3598	102	103	1	text	t	2026-03-01 06:42:19.284234	2026-03-01 14:42:19.346089	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	200	\N
3604	102	103	7	text	t	2026-03-01 06:42:23.969431	2026-03-01 14:42:24.007143	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	206	\N
3608	102	103	2	text	t	2026-03-01 06:42:58.392105	2026-03-01 14:42:58.436905	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	201	\N
3634	102	103	00:06	call_ended	f	2026-03-16 16:27:23.406765	\N	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	183	\N
3643	106	102	对方正在通话中	call_busy	t	2026-06-27 10:24:26.999224	2026-06-27 18:39:20.536732	测试05	测试01	\N	\N	\N	normal				\N	26	\N
3189	105	107	111	text	t	2025-12-19 03:14:24.491106	2025-12-19 11:14:24.564173	测试04	测试06	\N	\N	\N	normal				\N	\N	\N
3190	107	105	222	text	t	2025-12-19 03:14:35.899001	2025-12-19 11:14:35.932076	测试06	测试04	\N	\N	\N	normal				\N	\N	\N
3191	107	108	请求添加好友【已通过】	text	f	2025-12-19 03:15:28.813564	\N	测试06	测试07	\N	\N	\N	normal				\N	\N	\N
3523	102	103	bbb	text	t	2026-03-01 04:37:05.574899	2026-03-01 12:37:05.62068	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	281	\N
3192	108	107	请求添加好友【已通过】	text	t	2025-12-19 03:15:28.815059	2025-12-19 11:15:32.291711	测试07	测试06	\N	\N	\N	normal				\N	\N	\N
3526	102	103	fff	text	t	2026-03-01 04:45:55.239858	2026-03-01 12:45:55.270471	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	285	\N
3193	108	105	请求添加好友【已通过】	text	t	2025-12-19 03:16:05.75497	2025-12-19 11:16:15.398275	测试07	测试04	\N	\N	\N	normal				\N	\N	\N
3196	105	108	22	text	t	2025-12-19 03:16:34.574803	2025-12-19 11:16:35.843732	测试04	测试07	\N	\N	\N	normal				\N	\N	\N
3195	105	108	11	text	t	2025-12-19 03:16:27.317649	2025-12-19 11:16:35.843732	测试04	测试07	\N	\N	\N	normal				\N	\N	\N
3194	105	108	请求添加好友【已通过】	text	t	2025-12-19 03:16:05.756027	2025-12-19 11:16:35.843732	测试04	测试07	\N	\N	\N	normal				\N	\N	\N
3531	102	103	did	text	t	2026-03-01 04:49:55.821375	2026-03-01 12:49:55.867795	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	289	\N
3197	108	105	33	text	t	2025-12-19 03:16:40.222798	2025-12-19 11:16:40.236673	测试07	测试04	\N	\N	\N	normal				\N	\N	\N
3198	108	105	44	text	t	2025-12-19 03:16:41.518545	2025-12-19 11:16:41.534121	测试07	测试04	\N	\N	\N	normal				\N	\N	\N
3599	102	103	2	text	t	2026-03-01 06:42:20.083239	2026-03-01 14:42:20.124244	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	201	\N
3603	102	103	6	text	t	2026-03-01 06:42:23.190074	2026-03-01 14:42:23.222475	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	205	\N
3610	102	103	8	text	t	2026-03-01 06:42:58.392766	2026-03-01 14:42:58.436905	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	207	\N
3644	106	102	对方正在通话中	call_busy	t	2026-06-27 10:29:23.428436	2026-06-27 18:39:20.536732	测试05	测试01	\N	\N	\N	normal				\N	27	\N
3199	108	105	65	text	t	2025-12-19 05:03:47.993737	2025-12-19 13:03:48.017635	测试07	测试04	\N	\N	\N	normal				\N	\N	\N
3200	105	108	00:25	call_ended_video	t	2025-12-19 05:04:21.253677	2025-12-19 13:04:21.301279	测试04	测试07	\N	\N	\N	normal				video	\N	\N
3201	105	108	00:07	call_ended_video	t	2025-12-19 05:05:48.305014	2025-12-19 13:05:48.32672	测试04	测试07	\N	\N	\N	normal				video	\N	\N
3202	105	108	00:40	call_ended_video	t	2025-12-19 05:12:56.957693	2025-12-19 13:12:57.065332	测试04	测试07	\N	\N	\N	normal				video	\N	\N
3203	108	105	123	text	t	2025-12-19 05:16:45.544811	2025-12-19 13:16:45.607539	测试07	测试04	\N	\N	\N	normal				\N	\N	\N
3204	105	108	00:02	call_ended_video	t	2025-12-19 05:17:09.672964	2025-12-19 13:17:09.690792	测试04	测试07	\N	\N	\N	normal				video	\N	\N
3205	105	108	00:05	call_ended_video	t	2025-12-19 05:20:21.015439	2025-12-19 13:20:21.036146	测试04	测试07	\N	\N	\N	normal				video	\N	\N
3206	105	108	11	text	t	2025-12-19 05:23:38.682302	2025-12-19 13:23:38.70759	测试04	测试07	\N	\N	\N	normal				\N	\N	\N
3207	108	105	00:01	call_ended_video	t	2025-12-19 05:23:47.359785	2025-12-19 13:23:47.378605	测试07	测试04	\N	\N	\N	normal				video	\N	\N
3211	102	108	请求添加好友【已通过】	text	f	2025-12-19 06:48:58.207152	\N	测试01	测试07	\N	\N	\N	normal				\N	\N	\N
3212	108	102	请求添加好友【已通过】	text	f	2025-12-19 06:48:58.209049	\N	测试07	测试01	\N	\N	\N	normal				\N	\N	\N
3210	103	108	00:09	call_ended	t	2025-12-19 06:41:26.740974	2025-12-19 14:58:51.601646	测试2	测试07	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3208	103	108	请求添加好友【已通过】	text	t	2025-12-19 06:39:35.323083	2025-12-19 14:58:51.601646	测试2	测试07	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3213	108	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/files/1766127544_设备费-5499.00元-海尔（杭州）电子商务有限公司-2025.05.14-发票.pdf	file	t	2025-12-19 06:59:08.217682	2025-12-19 14:59:30.141685	测试07	测试2	设备费-5499.00元-海尔（杭州）电子商务有限公司-2025.05.14-发票.pdf	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3209	108	103	请求添加好友【已通过】	text	t	2025-12-19 06:39:35.326853	2025-12-19 14:59:30.141685	测试07	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3214	103	102	对方已取消	call_cancelled	t	2025-12-19 09:37:03.793528	2025-12-19 19:18:20.42699	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3215	103	102	对方已取消	call_cancelled	t	2025-12-19 09:37:45.600549	2025-12-19 19:18:20.42699	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3216	102	103	1	text	t	2025-12-19 11:18:26.067721	2025-12-19 19:18:26.091169	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3217	102	103	2	text	t	2025-12-19 11:18:27.300075	2025-12-19 19:18:27.310019	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3218	102	103	3	text	t	2025-12-19 11:18:28.329058	2025-12-19 19:18:28.340359	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3219	102	103	4	text	t	2025-12-19 11:18:29.247449	2025-12-19 19:18:29.258377	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3220	102	103	5	text	t	2025-12-19 11:18:30.089062	2025-12-19 19:18:30.099468	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3221	102	103	6	text	t	2025-12-19 11:18:30.877512	2025-12-19 19:18:30.888431	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3222	102	103	7	text	t	2025-12-19 11:18:31.702618	2025-12-19 19:18:31.714181	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3223	102	103	8	text	t	2025-12-19 11:18:32.522086	2025-12-19 19:18:32.532731	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3224	102	103	9	text	t	2025-12-19 11:18:33.36017	2025-12-19 19:18:33.371922	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3225	102	103	a	text	t	2025-12-19 11:18:35.392617	2025-12-19 19:18:35.403815	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3226	102	103	b	text	t	2025-12-19 11:18:36.923924	2025-12-19 19:18:36.93489	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3227	102	103	c	text	t	2025-12-19 11:18:37.736173	2025-12-19 19:18:37.747818	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3228	102	103	d	text	t	2025-12-19 11:18:38.570629	2025-12-19 19:18:38.580964	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3229	102	103	e	text	t	2025-12-19 11:18:39.530617	2025-12-19 19:18:39.541601	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3230	102	103	f	text	t	2025-12-19 11:18:40.231612	2025-12-19 19:18:40.241473	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3231	102	103	g	text	t	2025-12-19 11:18:41.021091	2025-12-19 19:18:41.032716	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3232	103	102	111111111	quoted	t	2025-12-19 11:18:57.422213	2025-12-19 19:18:57.529534	测试2	测试01	\N	87	11	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3233	102	103	222222	quoted	t	2025-12-19 11:19:41.336062	2025-12-19 19:19:41.348992	测试01	测试2	\N	93	22	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3234	102	103	6666666	quoted	t	2025-12-19 11:20:38.064949	2025-12-19 19:20:38.076774	测试01	测试2	\N	67	666	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3235	103	102	777	text	t	2025-12-19 11:31:01.843761	2025-12-19 19:31:03.899608	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3237	106	102	请求添加好友【已通过】	text	t	2025-12-19 12:08:58.294439	2026-01-11 17:31:26.108638	测试05	测试01	\N	\N	\N	normal				\N	\N	\N
3236	102	106	请求添加好友【已通过】	text	t	2025-12-19 12:08:58.288903	2026-01-11 17:33:37.288435	测试01	测试05	\N	\N	\N	normal				\N	\N	\N
3537	102	103	yyy	text	t	2026-03-01 05:05:39.198635	2026-03-01 13:05:39.236466	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	292	\N
3240	107	102	请求添加好友【已通过】	text	t	2025-12-19 13:37:03.920447	2025-12-19 21:37:08.325901	测试06	测试01	\N	\N	\N	normal				\N	\N	\N
3239	102	107	请求添加好友【已通过】	text	t	2025-12-19 13:37:03.917427	2025-12-19 21:37:21.495672	测试01	测试06	\N	\N	\N	normal				\N	\N	\N
3539	102	103	as	text	t	2026-03-01 05:08:04.377422	2026-03-01 13:08:04.429109	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	294	\N
3242	109	102	请求添加好友【已通过】	text	t	2025-12-19 13:46:21.11196	2025-12-19 21:46:24.600875	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3241	102	109	请求添加好友【已通过】	text	t	2025-12-19 13:46:21.109762	2025-12-19 21:48:32.805004	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3540	102	103	bb	text	t	2026-03-01 05:08:06.652631	2026-03-01 13:08:06.686427	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	295	\N
3244	109	102	请求添加好友【已通过】	text	t	2025-12-19 13:49:57.198033	2025-12-19 21:50:02.255858	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3600	102	103	3	text	t	2026-03-01 06:42:20.828342	2026-03-01 14:42:20.882904	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	202	\N
3246	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:07:02.288919	2025-12-19 22:07:09.308072	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3245	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:07:02.287225	2025-12-19 22:07:48.072169	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3243	102	109	请求添加好友【已通过】	text	t	2025-12-19 13:49:57.19621	2025-12-19 22:07:48.072169	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3605	102	103	8	text	t	2026-03-01 06:42:25.674135	2026-03-01 14:42:25.711177	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	207	\N
3248	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:09:03.912462	2025-12-19 22:09:07.659699	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3247	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:09:03.9113	2025-12-19 22:14:33.258162	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3609	102	103	9	text	t	2026-03-01 06:42:58.392791	2026-03-01 14:42:58.436905	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	208	\N
3250	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:14:53.436664	2025-12-19 22:14:57.129905	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3645	106	102	00:15	call_ended	t	2026-06-27 10:39:48.989757	2026-06-27 18:49:08.060564	测试05	测试01	\N	\N	\N	normal				voice	28	\N
3251	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:15:41.173668	2025-12-19 22:15:44.610725	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3249	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:14:53.435294	2025-12-19 22:15:44.610725	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3252	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:15:41.176694	2025-12-19 22:15:49.013991	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3254	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:16:41.071641	2025-12-19 22:16:44.200449	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3256	109	102	请求添加好友【已通过】	text	t	2025-12-19 14:21:08.367649	2025-12-19 22:21:11.89804	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3255	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:21:08.366264	2025-12-19 22:21:15.037068	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3253	102	109	请求添加好友【已通过】	text	t	2025-12-19 14:16:41.070236	2025-12-19 22:21:15.037068	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3257	102	109	111	text	t	2025-12-19 14:21:28.142608	2025-12-19 22:21:28.170144	测试01	测试08	\N	\N	\N	normal				\N	\N	\N
3258	109	102	222	text	t	2025-12-19 14:21:33.725089	2025-12-19 22:21:33.767213	测试08	测试01	\N	\N	\N	normal				\N	\N	\N
3238	102	103	888	text	t	2025-12-19 12:50:20.83097	2025-12-22 12:00:24.948598	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3259	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766376032_image_B45928A2-C457-4B35-ACEE-3646A44A6F25_1766376034.jpeg	image	t	2025-12-22 04:00:35.213511	2025-12-22 12:00:37.18232	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3260	102	103	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/1766376229_image_6756A811-C3AA-4F6E-9592-2D63D5F85CBF_1766376229.jpeg	image	t	2025-12-22 04:03:53.069868	2025-12-22 12:03:53.195786	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3261	102	103	对方已拒绝	call_rejected_video	t	2025-12-22 05:56:41.669105	2025-12-22 13:56:41.747023	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3262	103	102	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/videos/user/103/1766383017674447000_image_961A286B-41DC-469C-AA49-08B928AA64FA_1766383017.mp4	video	t	2025-12-22 05:57:20.816563	2025-12-22 13:58:16.837215	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3263	103	102	111	text	t	2025-12-29 12:41:11.198409	2025-12-29 20:42:42.374743	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3264	103	102	222	text	t	2025-12-29 12:41:15.802896	2025-12-29 20:42:42.374743	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3265	103	102	333	text	t	2025-12-29 12:41:22.164545	2025-12-29 20:42:42.374743	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3266	103	102	444	text	t	2025-12-29 12:41:41.565842	2025-12-29 20:42:42.374743	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3267	103	102	555	text	t	2025-12-29 12:42:35.524526	2025-12-29 20:42:42.374743	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3543	102	103	ddd	text	t	2026-03-01 05:21:25.481269	2026-03-01 13:21:25.543875	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	297	\N
3549	102	103	hhh	text	t	2026-03-01 05:22:35.857208	2026-03-01 13:22:35.894028	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	301	\N
3554	102	103	1	text	t	2026-03-01 05:27:22.83507	2026-03-01 13:27:22.872754	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	305	\N
3284	102	103	00:03	call_ended	t	2025-12-29 14:20:14.272972	2025-12-29 22:20:14.317018	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3558	102	103	5	text	t	2026-03-01 05:27:27.754177	2026-03-01 13:27:27.783177	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	309	\N
3559	102	103	6	text	t	2026-03-01 05:27:29.061297	2026-03-01 13:27:29.10532	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	310	\N
3564	102	103	7	text	t	2026-03-01 05:28:35.856093	2026-03-01 13:28:35.90069	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	311	\N
3290	102	103	00:03	call_ended	t	2025-12-29 14:51:45.023847	2025-12-29 22:51:45.039968	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3291	102	103	对方已拒绝	call_rejected	t	2025-12-29 14:52:09.149332	2025-12-29 22:52:09.165597	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3601	102	103	4	text	t	2026-03-01 06:42:21.644236	2026-03-01 14:42:21.678986	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	203	\N
3292	102	103	00:05	call_ended	t	2025-12-29 15:04:04.961767	2025-12-29 23:04:04.997123	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3602	102	103	5	text	t	2026-03-01 06:42:22.49929	2026-03-01 14:42:22.536233	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	204	\N
3294	102	103	00:32	call_ended	t	2025-12-29 15:07:38.593309	2025-12-29 23:07:38.609035	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3295	102	103	00:08	call_ended	t	2025-12-29 15:17:21.940501	2025-12-29 23:17:21.95904	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3607	102	103	3	text	t	2026-03-01 06:42:58.391364	2026-03-01 14:42:58.436905	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	202	\N
3296	102	103	00:06	call_ended	t	2025-12-29 15:32:05.168637	2025-12-29 23:32:05.208885	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3301	102	103	00:07	call_ended	t	2025-12-29 15:36:58.680234	2025-12-29 23:36:58.696052	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3302	102	103	00:04	call_ended	t	2025-12-29 15:51:39.628051	2025-12-29 23:51:39.646157	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3303	102	103	00:04	call_ended	t	2025-12-29 15:58:36.024857	2025-12-29 23:58:36.045885	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3309	102	103	00:18	call_ended	t	2025-12-30 02:15:38.961113	2025-12-30 10:15:39.00046	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3310	102	103	00:01	call_ended	t	2025-12-30 02:16:13.892107	2025-12-30 10:16:13.910349	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3312	102	103	00:08	call_ended	t	2025-12-30 02:21:01.249066	2025-12-30 10:21:01.26329	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3313	102	103	00:04	call_ended	t	2025-12-30 02:21:13.514312	2025-12-30 10:21:13.530087	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3314	102	103	00:06	call_ended	t	2025-12-30 02:22:04.571451	2025-12-30 10:22:04.588968	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3544	102	103	eee	text	t	2026-03-01 05:21:27.018121	2026-03-01 13:21:27.048466	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	298	\N
3315	102	103	00:02	call_ended	t	2025-12-30 02:22:25.837879	2025-12-30 10:22:25.907592	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3545	102	103	fff	text	t	2026-03-01 05:21:28.474173	2026-03-01 13:21:28.504846	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	299	\N
3550	102	103	I	text	t	2026-03-01 05:25:07.176144	2026-03-01 13:25:07.225115	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	302	\N
3553	102	103	j	text	t	2026-03-01 05:26:10.853601	2026-03-01 13:26:10.885129	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	303	\N
3555	102	103	2	text	t	2026-03-01 05:27:23.976303	2026-03-01 13:27:24.012107	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	306	\N
3561	102	103	8	text	t	2026-03-01 05:27:31.241454	2026-03-01 13:27:31.270854	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	312	\N
3606	102	103	9	text	t	2026-03-01 06:42:26.919057	2026-03-01 14:42:26.953847	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	208	\N
3360	102	103	00:09	call_ended	t	2026-01-09 04:48:05.130884	2026-01-09 12:48:05.361705	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3364	102	103	01:40	call_ended	t	2026-01-09 05:18:38.606045	2026-01-09 13:18:38.933787	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3368	102	103	00:05	call_ended	t	2026-01-09 06:01:28.186095	2026-01-09 14:01:28.282637	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3268	103	102	对方已取消	call_cancelled	t	2025-12-29 12:44:40.754148	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3269	103	102	111	text	t	2025-12-29 12:45:01.532015	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3270	103	102	222	text	t	2025-12-29 12:48:04.206957	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3349	103	102	00:05	call_ended	t	2026-01-09 04:10:04.615182	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3350	103	102	00:09	call_ended	t	2026-01-09 04:19:01.698415	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3351	103	102	22	text	t	2026-01-09 04:23:41.282536	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3352	103	102	00:07	call_ended	t	2026-01-09 04:23:56.619568	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3353	103	102	00:06	call_ended	t	2026-01-09 04:24:14.514722	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3271	103	102	333	text	t	2025-12-29 13:20:49.36179	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3272	103	102	对方已取消	call_cancelled	t	2025-12-29 13:21:38.74526	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3273	103	102	对方已取消	call_cancelled	t	2025-12-29 13:31:05.815007	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3274	103	102	对方已取消	call_cancelled	t	2025-12-29 13:31:28.024936	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3275	103	102	对方已取消	call_cancelled	t	2025-12-29 13:38:57.871984	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3276	103	102	对方已取消	call_cancelled	t	2025-12-29 13:52:19.013198	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3277	103	102	对方已取消	call_cancelled	t	2025-12-29 13:52:42.236549	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3278	103	102	对方已取消	call_cancelled	t	2025-12-29 13:55:56.313578	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3279	103	102	对方已取消	call_cancelled	t	2025-12-29 13:59:21.398154	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3280	103	102	111	text	t	2025-12-29 14:15:24.685705	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3281	103	102	对方已取消	call_cancelled	t	2025-12-29 14:15:31.255114	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3282	103	102	22	text	t	2025-12-29 14:17:26.271597	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3283	103	102	对方已取消	call_cancelled	t	2025-12-29 14:17:32.659852	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3285	103	102	111	text	t	2025-12-29 14:20:35.456127	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3286	103	102	对方已取消	call_cancelled	t	2025-12-29 14:27:08.597851	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3287	103	102	22	text	t	2025-12-29 14:27:36.623115	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3288	103	102	对方已取消	call_cancelled	t	2025-12-29 14:27:46.259074	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3289	103	102	111	text	t	2025-12-29 14:51:32.323443	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3293	103	102	对方已取消	call_cancelled	t	2025-12-29 15:05:14.555216	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3297	103	102	对方已取消	call_cancelled	t	2025-12-29 15:34:22.823673	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3298	103	102	00:04	call_ended	t	2025-12-29 15:34:42.037817	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3299	103	102	00:08	call_ended	t	2025-12-29 15:35:06.03151	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3300	103	102	00:03	call_ended	t	2025-12-29 15:35:21.615502	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3304	103	102	111	text	t	2025-12-29 15:58:45.910601	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3305	103	102	00:08	call_ended	t	2025-12-29 15:59:10.757286	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3306	103	102	00:12	call_ended_video	t	2025-12-30 02:04:07.774377	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		video	\N	\N
3307	103	102	00:04	call_ended	t	2025-12-30 02:05:54.358612	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3308	103	102	00:24	call_ended	t	2025-12-30 02:15:07.119555	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3311	103	102	00:05	call_ended	t	2025-12-30 02:16:27.110689	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3316	103	102	11	text	t	2025-12-30 02:26:18.052977	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3354	103	102	00:07	call_ended	t	2026-01-09 04:24:39.720564	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3355	103	102	00:03	call_ended	t	2026-01-09 04:34:12.636727	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3356	103	102	已取消	call_cancelled	t	2026-01-09 04:34:38.110051	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3357	103	102	00:05	call_ended	t	2026-01-09 04:34:54.45155	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3358	103	102	00:06	call_ended	t	2026-01-09 04:40:40.739026	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3359	103	102	333	text	t	2026-01-09 04:47:30.633557	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3361	103	102	00:09	call_ended	t	2026-01-09 04:52:30.285095	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3362	103	102	已取消	call_cancelled	t	2026-01-09 05:04:06.099564	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3363	103	102	00:06	call_ended	t	2026-01-09 05:04:30.043046	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3365	103	102	00:04	call_ended	t	2026-01-09 05:47:00.727064	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3366	103	102	已取消	call_cancelled	t	2026-01-09 06:01:14.437887	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3367	103	102	00:04	call_ended	t	2026-01-09 06:01:28.109373	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3369	103	102	00:03	call_ended	t	2026-01-09 06:11:36.591659	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3370	103	102	00:03	call_ended	t	2026-01-09 06:12:41.968919	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3371	103	102	00:05	call_ended	t	2026-01-09 06:22:50.072641	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3372	103	102	00:03	call_ended	t	2026-01-09 06:36:44.787363	2026-01-09 17:20:53.283919	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		voice	\N	\N
3373	102	103	00:07	call_ended	t	2026-01-09 09:21:29.344276	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3374	102	103	111	text	t	2026-01-09 09:23:48.672598	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3375	102	103	已取消	call_cancelled	t	2026-01-09 09:23:52.932199	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3376	102	103	222	text	t	2026-01-09 09:23:59.340503	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3377	102	103	00:03	call_ended	t	2026-01-09 09:24:13.605868	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3378	102	103	333	text	t	2026-01-09 09:24:19.107747	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3379	102	103	111111122222	text	t	2026-01-10 11:07:00.004966	2026-01-10 19:07:32.870234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3380	102	103	444	text	t	2026-01-10 11:25:34.699974	2026-01-10 19:27:18.823814	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3381	102	103	111	text	t	2026-01-10 11:30:00.003996	2026-01-10 19:37:25.652715	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3382	102	103	22222	text	t	2026-01-10 11:40:00.003351	2026-01-10 19:56:49.133163	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3383	102	103	7777	text	t	2026-01-10 11:58:00.003193	2026-01-10 19:58:10.822093	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3387	102	106	111	text	t	2026-01-11 09:31:29.141874	2026-01-11 17:33:37.288435	测试01	测试05	\N	\N	\N	normal				\N	\N	\N
3384	102	103	123123	text	t	2026-01-10 12:16:00.005288	2026-01-11 17:33:42.029424	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3385	102	103	555	text	t	2026-01-10 12:33:43.303916	2026-01-11 17:33:42.029424	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3386	102	103	00:03	call_ended	t	2026-01-10 12:33:55.708568	2026-01-11 17:33:42.029424	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	voice	\N	\N
3388	102	103	343434	text	t	2026-01-11 09:35:00.007648	2026-01-11 17:35:00.039853	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3389	102	106	(6789644	text	t	2026-01-11 09:35:00.014303	2026-01-11 17:35:00.147314	测试01	测试05	\N	\N	\N	normal				\N	\N	\N
3390	103	102	1111	text	t	2026-01-23 14:07:29.732221	2026-01-23 22:07:34.743669	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3391	102	103	222	text	t	2026-01-23 14:07:40.804467	2026-01-23 22:07:40.832587	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3392	103	102	333	text	t	2026-01-23 14:12:29.094325	2026-01-23 22:12:29.126305	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3393	102	103	444	text	t	2026-01-23 14:12:41.736749	2026-01-23 22:12:41.750832	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3394	103	102	55	text	t	2026-01-23 14:13:03.149659	2026-01-23 22:13:03.175602	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	\N	\N
3395	102	103	66	text	t	2026-01-23 14:13:21.836978	2026-01-23 22:13:23.392496	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3396	102	103	777	text	t	2026-01-23 14:13:31.284489	2026-01-23 22:13:31.297697	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	\N	\N
3546	102	103	ggg	text	t	2026-03-01 05:21:30.042501	2026-03-01 13:21:30.071484	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	300	\N
3397	102	103	111	text	t	2026-02-27 10:47:39.486825	2026-02-27 18:47:42.188424	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	178	\N
3398	102	103	222	text	t	2026-02-27 10:48:40.781169	2026-02-27 18:57:16.822824	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3399	103	102	4444	text	t	2026-02-27 11:40:59.883048	2026-02-27 19:40:59.916505	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	2375	\N
3400	103	102	5555	text	t	2026-02-27 11:42:44.884517	2026-02-27 19:42:44.968937	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	2376	\N
3401	103	102	666	text	t	2026-02-28 01:47:41.189618	2026-02-28 09:47:41.227781	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	147	\N
3402	103	102	777	text	t	2026-03-01 02:04:51.531416	2026-03-01 10:04:53.391621	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	147	\N
3403	102	103	888	text	t	2026-03-01 02:04:56.900281	2026-03-01 10:04:56.959208	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3404	102	103	888	text	t	2026-03-01 02:05:36.141406	2026-03-01 10:05:36.171962	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3405	102	103	999	text	t	2026-03-01 02:05:56.794001	2026-03-01 10:05:56.826367	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	180	\N
3406	102	103	21	text	t	2026-03-01 02:06:14.915888	2026-03-01 10:06:14.945583	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
3407	102	103	2233	text	t	2026-03-01 02:06:18.587335	2026-03-01 10:06:18.620784	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	182	\N
3408	102	103	2233	text	t	2026-03-01 02:06:51.139414	2026-03-01 10:06:51.17538	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	182	\N
3409	102	103	21	text	t	2026-03-01 02:06:51.139408	2026-03-01 10:06:51.17538	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
3410	102	103	77	text	t	2026-03-01 02:08:34.268701	2026-03-01 10:08:34.295407	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	183	\N
3411	103	102	888	text	t	2026-03-01 02:08:37.879086	2026-03-01 10:08:38.160191	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	156	\N
3412	102	103	333	text	t	2026-03-01 02:24:03.531111	2026-03-01 10:24:03.604626	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	185	\N
3413	102	103	44	text	t	2026-03-01 02:24:08.397165	2026-03-01 10:24:08.435367	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	186	\N
3414	102	103	55	text	t	2026-03-01 02:24:14.393029	2026-03-01 10:24:14.422505	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	187	\N
3415	102	103	333	text	t	2026-03-01 02:24:54.185756	2026-03-01 10:24:54.216939	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	185	\N
3416	102	103	66	text	t	2026-03-01 02:30:24.29011	2026-03-01 10:30:24.315362	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	188	\N
3417	102	103	77	text	t	2026-03-01 02:30:30.129638	2026-03-01 10:30:30.15537	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	189	\N
3418	102	103	88	text	t	2026-03-01 02:30:34.834163	2026-03-01 10:30:34.858697	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	190	\N
3419	102	103	77	text	t	2026-03-01 02:31:09.180161	2026-03-01 10:31:09.218036	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	189	\N
3420	102	103	88	text	t	2026-03-01 02:31:09.180224	2026-03-01 10:31:09.218036	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	190	\N
3421	103	102	999	text	t	2026-03-01 02:35:05.867657	2026-03-01 10:35:05.894537	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3422	103	102	999	text	t	2026-03-01 02:35:39.181187	2026-03-01 10:35:39.218805	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3423	103	102	999	text	t	2026-03-01 02:35:54.179495	2026-03-01 10:35:54.243688	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3424	103	102	999	text	t	2026-03-01 02:36:09.177653	2026-03-01 10:36:09.250733	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3425	103	102	999	text	t	2026-03-01 02:36:24.178176	2026-03-01 10:36:24.207858	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3426	103	102	999	text	t	2026-03-01 02:36:39.178487	2026-03-01 10:36:39.257237	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3427	103	102	999	text	t	2026-03-01 02:36:54.177407	2026-03-01 10:36:54.307508	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3428	103	102	999	text	t	2026-03-01 02:37:09.177364	2026-03-01 10:37:09.255608	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3429	103	102	999	text	t	2026-03-01 02:37:24.18107	2026-03-01 10:37:24.268349	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3430	103	102	999	text	t	2026-03-01 02:37:39.178874	2026-03-01 10:37:39.258625	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3431	103	102	999	text	t	2026-03-01 02:37:54.167289	2026-03-01 10:37:54.303153	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3437	103	102	999	text	t	2026-03-01 02:39:24.161034	2026-03-01 10:39:24.185064	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3547	102	103	hhh	text	t	2026-03-01 05:21:31.240474	2026-03-01 13:21:31.271073	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	301	\N
3445	103	102	999	text	t	2026-03-01 02:41:24.157692	2026-03-01 10:41:24.211456	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3451	103	102	000	text	t	2026-03-01 02:42:43.864603	2026-03-01 10:42:43.890429	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3548	102	103	eee	text	t	2026-03-01 05:22:35.857157	2026-03-01 13:22:35.894028	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	298	\N
3453	103	102	222	text	t	2026-03-01 02:42:50.718475	2026-03-01 10:42:50.839659	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3457	103	102	111	text	t	2026-03-01 02:43:24.156778	2026-03-01 10:43:24.225441	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3552	102	103	k	text	t	2026-03-01 05:25:10.652994	2026-03-01 13:25:10.684943	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	304	\N
3556	102	103	3	text	t	2026-03-01 05:27:25.315614	2026-03-01 13:27:25.357561	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	307	\N
3557	102	103	4	text	t	2026-03-01 05:27:26.533816	2026-03-01 13:27:26.562144	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	308	\N
3560	102	103	7	text	t	2026-03-01 05:27:30.114748	2026-03-01 13:27:30.146993	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	311	\N
3562	102	103	9	text	t	2026-03-01 05:27:32.387102	2026-03-01 13:27:32.421627	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	313	\N
3563	102	103	10	text	t	2026-03-01 05:27:33.669932	2026-03-01 13:27:33.697983	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	314	\N
3611	102	103	a	text	t	2026-03-01 06:55:05.973478	2026-03-01 14:55:06.027986	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	178	\N
3613	102	103	c	text	t	2026-03-01 06:55:08.316714	2026-03-01 14:55:08.368984	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	180	\N
3614	102	103	d	text	t	2026-03-01 06:55:09.320203	2026-03-01 14:55:09.366138	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
3617	102	103	g	text	t	2026-03-01 06:55:13.525118	2026-03-01 14:55:13.577405	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	184	\N
3432	103	102	999	text	t	2026-03-01 02:38:09.164779	2026-03-01 10:38:09.397893	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3435	103	102	999	text	t	2026-03-01 02:38:54.161039	2026-03-01 10:38:54.194732	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3551	102	103	j	text	t	2026-03-01 05:25:09.424361	2026-03-01 13:25:09.457619	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	303	\N
3436	103	102	999	text	t	2026-03-01 02:39:09.160416	2026-03-01 10:39:09.250161	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3441	103	102	999	text	t	2026-03-01 02:40:24.15824	2026-03-01 10:40:24.209155	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3612	102	103	b	text	t	2026-03-01 06:55:07.180939	2026-03-01 14:55:07.229947	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3448	103	102	999	text	t	2026-03-01 02:42:09.156485	2026-03-01 10:42:09.195002	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3452	103	102	111	text	t	2026-03-01 02:42:47.31108	2026-03-01 10:42:47.336412	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3615	102	103	e	text	t	2026-03-01 06:55:11.621429	2026-03-01 14:55:11.67519	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	182	\N
3455	103	102	222	text	t	2026-03-01 02:43:24.156793	2026-03-01 10:43:24.225441	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3458	103	102	222	text	t	2026-03-01 02:43:39.155119	2026-03-01 10:43:39.180578	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3433	103	102	999	text	t	2026-03-01 02:38:24.16184	2026-03-01 10:38:24.300479	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3438	103	102	999	text	t	2026-03-01 02:39:39.159563	2026-03-01 10:39:39.255473	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3565	102	103	2	text	t	2026-03-01 05:28:35.858169	2026-03-01 13:28:35.90069	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	306	\N
3442	103	102	999	text	t	2026-03-01 02:40:39.157834	2026-03-01 10:40:39.189991	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3443	103	102	999	text	t	2026-03-01 02:40:54.159083	2026-03-01 10:40:54.212185	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3616	102	103	f	text	t	2026-03-01 06:55:12.583179	2026-03-01 14:55:12.665857	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	183	\N
3444	103	102	999	text	t	2026-03-01 02:41:09.157806	2026-03-01 10:41:09.183997	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3449	103	102	999	text	t	2026-03-01 02:42:24.157205	2026-03-01 10:42:24.210307	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3450	103	102	999	text	t	2026-03-01 02:42:39.156788	2026-03-01 10:42:39.268787	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3434	103	102	999	text	t	2026-03-01 02:38:39.161729	2026-03-01 10:38:39.186778	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3439	103	102	999	text	t	2026-03-01 02:39:54.159772	2026-03-01 10:39:54.204186	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3566	102	103	a	text	t	2026-03-01 05:50:06.913636	2026-03-01 13:50:06.979391	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	178	\N
3568	102	103	c	text	t	2026-03-01 05:50:10.136285	2026-03-01 13:50:10.189696	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	180	\N
3576	102	103	f	text	t	2026-03-01 05:51:16.720423	2026-03-01 13:51:16.785896	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	183	\N
3580	102	103	3	text	t	2026-03-01 05:59:19.134342	2026-03-01 13:59:19.163234	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	187	\N
3587	102	103	7	text	t	2026-03-01 06:00:26.769947	2026-03-01 14:00:26.823447	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	191	\N
3589	102	103	1	text	t	2026-03-01 06:00:26.770382	2026-03-01 14:00:26.823447	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	185	\N
3618	103	102	111	text	t	2026-03-01 07:01:10.473233	2026-03-01 15:01:27.008384	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	154	\N
3619	103	102	222	text	t	2026-03-01 07:01:12.567393	2026-03-01 15:01:27.008384	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	155	\N
3620	103	102	333	text	t	2026-03-01 07:01:14.876423	2026-03-01 15:01:27.008384	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	156	\N
3621	102	103	444	text	t	2026-03-01 07:01:38.156613	2026-03-01 15:01:38.21344	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	188	\N
3440	103	102	999	text	t	2026-03-01 02:40:09.160049	2026-03-01 10:40:09.256142	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3446	103	102	999	text	t	2026-03-01 02:41:39.177914	2026-03-01 10:41:39.215135	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3567	102	103	b	text	t	2026-03-01 05:50:08.170242	2026-03-01 13:50:08.221333	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	179	\N
3447	103	102	999	text	t	2026-03-01 02:41:54.156573	2026-03-01 10:41:54.190154	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3573	102	103	a	text	t	2026-03-01 05:51:16.719362	2026-03-01 13:51:16.785896	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	178	\N
3456	103	102	000	text	t	2026-03-01 02:43:24.156779	2026-03-01 10:43:24.225441	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3454	103	102	999	text	t	2026-03-01 02:43:24.156722	2026-03-01 10:43:24.225441	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3579	102	103	2	text	t	2026-03-01 05:59:18.370381	2026-03-01 13:59:18.40029	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	186	\N
3460	103	102	111	text	t	2026-03-01 02:43:39.156117	2026-03-01 10:43:39.180578	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3461	103	102	000	text	t	2026-03-01 02:43:39.15608	2026-03-01 10:43:39.180578	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3459	103	102	999	text	t	2026-03-01 02:43:39.156033	2026-03-01 10:43:39.180578	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3462	103	102	222	text	t	2026-03-01 02:43:54.159156	2026-03-01 10:43:54.228381	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3465	103	102	111	text	t	2026-03-01 02:43:54.159118	2026-03-01 10:43:54.228381	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3464	103	102	000	text	t	2026-03-01 02:43:54.15908	2026-03-01 10:43:54.228381	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3463	103	102	999	text	t	2026-03-01 02:43:54.159028	2026-03-01 10:43:54.228381	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3469	103	102	999	text	t	2026-03-01 02:44:09.159023	2026-03-01 10:44:09.281364	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3468	103	102	111	text	t	2026-03-01 02:44:09.158784	2026-03-01 10:44:09.281364	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3467	103	102	222	text	t	2026-03-01 02:44:09.157733	2026-03-01 10:44:09.281364	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3466	103	102	000	text	t	2026-03-01 02:44:09.157418	2026-03-01 10:44:09.281364	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3473	103	102	222	text	t	2026-03-01 02:44:24.157814	2026-03-01 10:44:24.231616	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3472	103	102	999	text	t	2026-03-01 02:44:24.15754	2026-03-01 10:44:24.231616	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3471	103	102	111	text	t	2026-03-01 02:44:24.157429	2026-03-01 10:44:24.231616	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3470	103	102	000	text	t	2026-03-01 02:44:24.155699	2026-03-01 10:44:24.231616	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3477	103	102	111	text	t	2026-03-01 02:44:39.158243	2026-03-01 10:44:39.282373	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3475	103	102	000	text	t	2026-03-01 02:44:39.158239	2026-03-01 10:44:39.282373	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3476	103	102	999	text	t	2026-03-01 02:44:39.158222	2026-03-01 10:44:39.282373	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3474	103	102	222	text	t	2026-03-01 02:44:39.158029	2026-03-01 10:44:39.282373	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3481	103	102	000	text	t	2026-03-01 02:44:54.155598	2026-03-01 10:44:54.234682	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3480	103	102	111	text	t	2026-03-01 02:44:54.155134	2026-03-01 10:44:54.234682	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3479	103	102	222	text	t	2026-03-01 02:44:54.154481	2026-03-01 10:44:54.234682	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3478	103	102	999	text	t	2026-03-01 02:44:54.154403	2026-03-01 10:44:54.234682	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3485	103	102	111	text	t	2026-03-01 02:45:09.157348	2026-03-01 10:45:09.309801	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3484	103	102	000	text	t	2026-03-01 02:45:09.155349	2026-03-01 10:45:09.309801	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3483	103	102	999	text	t	2026-03-01 02:45:09.155279	2026-03-01 10:45:09.309801	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3482	103	102	222	text	t	2026-03-01 02:45:09.154194	2026-03-01 10:45:09.309801	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3489	103	102	000	text	t	2026-03-01 02:45:24.155121	2026-03-01 10:45:24.236794	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3487	103	102	222	text	t	2026-03-01 02:45:24.154954	2026-03-01 10:45:24.236794	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3488	103	102	111	text	t	2026-03-01 02:45:24.15485	2026-03-01 10:45:24.236794	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3486	103	102	999	text	t	2026-03-01 02:45:24.153874	2026-03-01 10:45:24.236794	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3569	102	103	d	text	t	2026-03-01 05:50:11.432467	2026-03-01 13:50:11.480818	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	181	\N
3570	102	103	e	text	t	2026-03-01 05:50:12.794533	2026-03-01 13:50:12.842261	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	182	\N
3493	103	102	000	text	t	2026-03-01 02:45:39.193201	2026-03-01 10:45:39.288264	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	167	\N
3492	103	102	111	text	t	2026-03-01 02:45:39.192496	2026-03-01 10:45:39.288264	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	168	\N
3491	103	102	999	text	t	2026-03-01 02:45:39.1558	2026-03-01 10:45:39.288264	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	166	\N
3490	103	102	222	text	t	2026-03-01 02:45:39.154871	2026-03-01 10:45:39.288264	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	169	\N
3494	103	102	33	text	t	2026-03-01 02:45:57.400665	2026-03-01 10:45:57.441928	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	170	\N
3572	102	103	g	text	t	2026-03-01 05:50:15.512347	2026-03-01 13:50:15.545642	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	184	\N
3495	103	102	44	text	t	2026-03-01 02:46:00.052711	2026-03-01 10:46:00.077831	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	171	\N
3496	103	102	55	text	t	2026-03-01 02:46:02.5685	2026-03-01 10:46:02.627302	测试2	测试01	\N	\N	\N	normal		https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg		\N	172	\N
3574	102	103	c	text	t	2026-03-01 05:51:16.71995	2026-03-01 13:51:16.785896	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	180	\N
3497	102	103	666	text	t	2026-03-01 02:47:46.278704	2026-03-01 10:47:46.306445	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	267	\N
3498	102	103	777	text	t	2026-03-01 02:47:47.599404	2026-03-01 10:47:47.66323	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	268	\N
3584	102	103	7	text	t	2026-03-01 05:59:22.104099	2026-03-01 13:59:22.157434	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	191	\N
3499	102	103	888	text	t	2026-03-01 02:47:49.006124	2026-03-01 10:47:49.034252	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	269	\N
3586	102	103	9	text	t	2026-03-01 05:59:23.512909	2026-03-01 13:59:23.614354	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	193	\N
3500	102	103	666	text	t	2026-03-01 02:48:24.150355	2026-03-01 10:48:24.190808	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	267	\N
3501	102	103	888	text	t	2026-03-01 02:48:24.150368	2026-03-01 10:48:24.190808	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	269	\N
3502	102	103	777	text	t	2026-03-01 02:48:24.15049	2026-03-01 10:48:24.190808	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	268	\N
3622	102	103	55	text	t	2026-03-01 07:01:39.155994	2026-03-01 15:01:39.209597	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	189	\N
3503	102	103	000	text	t	2026-03-01 03:22:33.013227	2026-03-01 11:22:33.042878	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	270	\N
3504	102	103	111	text	t	2026-03-01 03:22:34.617589	2026-03-01 11:22:34.645684	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	271	\N
3505	102	103	222	text	t	2026-03-01 03:22:36.464021	2026-03-01 11:22:36.490399	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	272	\N
3506	102	103	000	text	t	2026-03-01 03:22:46.630998	2026-03-01 11:22:46.66845	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	270	\N
3507	102	103	111	text	t	2026-03-01 03:22:46.631063	2026-03-01 11:22:46.66845	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	271	\N
3508	102	103	333	text	t	2026-03-01 03:23:38.631935	2026-03-01 11:23:38.66079	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	273	\N
3509	102	103	444	text	t	2026-03-01 03:23:39.910302	2026-03-01 11:23:39.936386	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	274	\N
3510	102	103	333	text	t	2026-03-01 03:23:51.628673	2026-03-01 11:23:51.656481	测试01	测试2	\N	\N	\N	normal			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	\N	273	\N
\.


--
-- Data for Name: private_message_synced; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.private_message_synced (id, message_id, user_id, synced_at) FROM stdin;
1	2474	144	2025-12-18 12:37:29.998752
2	3159	143	2025-12-18 12:43:56.828799
3	3160	143	2025-12-18 12:43:56.829813
124	1810	104	2025-12-19 09:46:31.76486
125	1812	104	2025-12-19 09:46:31.766022
126	1815	104	2025-12-19 09:46:31.76709
127	1820	104	2025-12-19 09:46:31.768109
128	1826	104	2025-12-19 09:46:31.768869
129	1851	104	2025-12-19 09:46:31.769628
130	1854	104	2025-12-19 09:46:31.770313
131	1988	104	2025-12-19 09:46:31.770925
132	2004	104	2025-12-19 09:46:31.771565
133	2005	104	2025-12-19 09:46:31.772156
134	2064	104	2025-12-19 09:46:31.77272
135	2065	104	2025-12-19 09:46:31.77353
136	2267	104	2025-12-19 09:46:31.774243
137	2367	136	2025-12-19 09:50:29.58363
138	1897	112	2025-12-19 10:04:21.586679
139	1898	112	2025-12-19 10:04:21.588365
140	1901	112	2025-12-19 10:04:21.589684
141	1909	112	2025-12-19 10:04:21.590382
142	2323	112	2025-12-19 10:04:21.591242
143	2324	112	2025-12-19 10:04:21.592181
144	2325	112	2025-12-19 10:04:21.593088
145	2326	112	2025-12-19 10:04:21.594371
147	1910	113	2025-12-19 10:08:03.833954
148	1911	113	2025-12-19 10:08:03.834969
149	1912	113	2025-12-19 10:08:03.835554
150	1913	113	2025-12-19 10:08:03.836014
151	1915	113	2025-12-19 10:08:03.83655
152	1916	113	2025-12-19 10:08:03.837044
153	1917	113	2025-12-19 10:08:03.83752
154	1918	113	2025-12-19 10:08:03.838374
155	1924	113	2025-12-19 10:08:03.839036
156	1925	113	2025-12-19 10:08:03.839626
157	1926	113	2025-12-19 10:08:03.840166
158	1930	113	2025-12-19 10:08:03.840647
159	1931	113	2025-12-19 10:08:03.843272
160	1932	113	2025-12-19 10:08:03.843778
161	1934	113	2025-12-19 10:08:03.844215
162	1935	113	2025-12-19 10:08:03.844666
163	1958	113	2025-12-19 10:08:03.84512
164	1960	113	2025-12-19 10:08:03.845704
165	1962	113	2025-12-19 10:08:03.846348
166	1963	113	2025-12-19 10:08:03.847078
167	1964	113	2025-12-19 10:08:03.847839
168	1998	113	2025-12-19 10:08:03.848429
169	1999	113	2025-12-19 10:08:03.848935
170	2001	113	2025-12-19 10:08:03.849417
171	2003	113	2025-12-19 10:08:03.849873
172	2006	113	2025-12-19 10:08:03.850306
173	2007	113	2025-12-19 10:08:03.850715
174	2008	113	2025-12-19 10:08:03.851177
175	2009	113	2025-12-19 10:08:03.851603
176	2032	113	2025-12-19 10:08:03.852023
177	2033	113	2025-12-19 10:08:03.852485
178	2034	113	2025-12-19 10:08:03.852971
179	2035	113	2025-12-19 10:08:03.85357
180	2036	113	2025-12-19 10:08:03.854306
181	2037	113	2025-12-19 10:08:03.854953
182	2039	113	2025-12-19 10:08:03.855573
183	2040	113	2025-12-19 10:08:03.856175
184	2041	113	2025-12-19 10:08:03.856858
185	2042	113	2025-12-19 10:08:03.857396
186	2043	113	2025-12-19 10:08:03.858223
187	2046	113	2025-12-19 10:08:03.858811
188	2047	113	2025-12-19 10:08:03.859494
189	2048	113	2025-12-19 10:08:03.860337
190	2049	113	2025-12-19 10:08:03.861048
191	2069	113	2025-12-19 10:08:03.861789
192	2070	113	2025-12-19 10:08:03.862521
193	2078	113	2025-12-19 10:08:03.863189
194	2079	113	2025-12-19 10:08:03.864153
195	2089	113	2025-12-19 10:08:03.864821
196	2090	113	2025-12-19 10:08:03.865443
197	2091	113	2025-12-19 10:08:03.866026
198	2092	113	2025-12-19 10:08:03.86656
199	2093	113	2025-12-19 10:08:03.867136
200	2094	113	2025-12-19 10:08:03.867718
201	2095	113	2025-12-19 10:08:03.868362
202	2127	113	2025-12-19 10:08:03.86904
203	2128	113	2025-12-19 10:08:03.869721
204	2129	113	2025-12-19 10:08:03.870397
205	2130	113	2025-12-19 10:08:03.871024
206	2131	113	2025-12-19 10:08:03.871764
207	2132	113	2025-12-19 10:08:03.872549
208	2133	113	2025-12-19 10:08:03.873217
209	2134	113	2025-12-19 10:08:03.873764
210	2135	113	2025-12-19 10:08:03.874334
211	2136	113	2025-12-19 10:08:03.874869
212	2137	113	2025-12-19 10:08:03.875372
213	2138	113	2025-12-19 10:08:03.875936
214	2139	113	2025-12-19 10:08:03.876561
215	2140	113	2025-12-19 10:08:03.877165
216	2141	113	2025-12-19 10:08:03.87775
217	2142	113	2025-12-19 10:08:03.87823
218	2143	113	2025-12-19 10:08:03.878765
219	2144	113	2025-12-19 10:08:03.87925
220	2145	113	2025-12-19 10:08:03.879822
221	2146	113	2025-12-19 10:08:03.880393
222	2147	113	2025-12-19 10:08:03.881099
223	2148	113	2025-12-19 10:08:03.881698
224	2149	113	2025-12-19 10:08:03.882232
225	2150	113	2025-12-19 10:08:03.882733
226	2151	113	2025-12-19 10:08:03.883228
227	2152	113	2025-12-19 10:08:03.883719
228	2153	113	2025-12-19 10:08:03.884204
229	2154	113	2025-12-19 10:08:03.884694
230	2155	113	2025-12-19 10:08:03.885242
231	2156	113	2025-12-19 10:08:03.885783
232	2157	113	2025-12-19 10:08:03.886305
233	2158	113	2025-12-19 10:08:03.886864
234	2159	113	2025-12-19 10:08:03.887377
235	2160	113	2025-12-19 10:08:03.88789
236	2161	113	2025-12-19 10:08:03.888568
237	2162	113	2025-12-19 10:08:03.88926
238	2163	113	2025-12-19 10:08:03.889892
239	2164	113	2025-12-19 10:08:03.890361
240	2165	113	2025-12-19 10:08:03.890813
241	2166	113	2025-12-19 10:08:03.891303
242	2167	113	2025-12-19 10:08:03.891722
243	2168	113	2025-12-19 10:08:03.892141
244	2169	113	2025-12-19 10:08:03.892645
245	2170	113	2025-12-19 10:08:03.893184
246	2174	113	2025-12-19 10:08:03.893697
247	2175	113	2025-12-19 10:08:03.89417
248	2176	113	2025-12-19 10:08:03.894706
249	2177	113	2025-12-19 10:08:03.89527
250	2179	113	2025-12-19 10:08:03.895806
251	2180	113	2025-12-19 10:08:03.896307
252	2188	113	2025-12-19 10:08:03.896823
253	2189	113	2025-12-19 10:08:03.897342
254	2210	113	2025-12-19 10:08:03.897894
255	2212	113	2025-12-19 10:08:03.898438
256	2216	113	2025-12-19 10:08:03.898968
257	2217	113	2025-12-19 10:08:03.89954
258	2240	113	2025-12-19 10:08:03.900072
259	2241	113	2025-12-19 10:08:03.900569
260	2242	113	2025-12-19 10:08:03.901075
261	2243	113	2025-12-19 10:08:03.901554
262	2245	113	2025-12-19 10:08:03.902008
263	2246	113	2025-12-19 10:08:03.902477
264	2247	113	2025-12-19 10:08:03.902993
265	2248	113	2025-12-19 10:08:03.903504
266	2249	113	2025-12-19 10:08:03.904061
267	2250	113	2025-12-19 10:08:03.904588
268	2251	113	2025-12-19 10:08:03.905106
269	2254	113	2025-12-19 10:08:03.905551
270	2256	113	2025-12-19 10:08:03.906052
271	2257	113	2025-12-19 10:08:03.90659
272	2259	113	2025-12-19 10:08:03.907124
273	2261	113	2025-12-19 10:08:03.907641
274	2375	113	2025-12-19 10:08:03.908099
275	2431	113	2025-12-19 10:08:03.90859
276	1914	114	2025-12-19 10:10:09.701704
277	1936	114	2025-12-19 10:10:09.702605
278	1937	114	2025-12-19 10:10:09.703286
279	1938	114	2025-12-19 10:10:09.703907
280	1939	114	2025-12-19 10:10:09.704449
281	1940	114	2025-12-19 10:10:09.705056
282	1942	114	2025-12-19 10:10:09.705653
283	1943	114	2025-12-19 10:10:09.706366
284	1944	114	2025-12-19 10:10:09.707898
285	1947	114	2025-12-19 10:10:09.70861
286	1948	114	2025-12-19 10:10:09.709178
287	1949	114	2025-12-19 10:10:09.709813
288	1950	114	2025-12-19 10:10:09.71033
289	1951	114	2025-12-19 10:10:09.710882
290	1952	114	2025-12-19 10:10:09.711366
291	1959	114	2025-12-19 10:10:09.71187
292	1961	114	2025-12-19 10:10:09.712366
293	1965	114	2025-12-19 10:10:09.712836
294	1966	114	2025-12-19 10:10:09.713367
295	1967	114	2025-12-19 10:10:09.713919
296	1968	114	2025-12-19 10:10:09.714364
297	1969	114	2025-12-19 10:10:09.714846
298	1970	114	2025-12-19 10:10:09.715343
299	1971	114	2025-12-19 10:10:09.71585
300	1972	114	2025-12-19 10:10:09.716321
301	1973	114	2025-12-19 10:10:09.716844
302	1974	114	2025-12-19 10:10:09.717318
303	1975	114	2025-12-19 10:10:09.717803
304	1978	114	2025-12-19 10:10:09.718364
305	1979	114	2025-12-19 10:10:09.718837
306	1980	114	2025-12-19 10:10:09.719332
307	1982	114	2025-12-19 10:10:09.719855
308	1985	114	2025-12-19 10:10:09.720498
309	1987	114	2025-12-19 10:10:09.721059
310	1989	114	2025-12-19 10:10:09.72153
311	1991	114	2025-12-19 10:10:09.722013
312	1992	114	2025-12-19 10:10:09.722476
313	1993	114	2025-12-19 10:10:09.722931
314	1995	114	2025-12-19 10:10:09.723376
315	1996	114	2025-12-19 10:10:09.723802
316	1997	114	2025-12-19 10:10:09.724482
317	2029	114	2025-12-19 10:10:09.724983
318	2030	114	2025-12-19 10:10:09.725511
319	2031	114	2025-12-19 10:10:09.726054
320	2044	114	2025-12-19 10:10:09.726495
321	2045	114	2025-12-19 10:10:09.726978
322	2055	114	2025-12-19 10:10:09.727489
323	2056	114	2025-12-19 10:10:09.727982
324	2057	114	2025-12-19 10:10:09.728428
325	2058	114	2025-12-19 10:10:09.728888
326	2059	114	2025-12-19 10:10:09.729351
327	2060	114	2025-12-19 10:10:09.729803
328	2061	114	2025-12-19 10:10:09.730245
329	2066	114	2025-12-19 10:10:09.730709
330	2067	114	2025-12-19 10:10:09.731249
331	2068	114	2025-12-19 10:10:09.731758
332	2071	114	2025-12-19 10:10:09.732216
333	2072	114	2025-12-19 10:10:09.732653
334	2073	114	2025-12-19 10:10:09.733204
335	2074	114	2025-12-19 10:10:09.733864
336	2075	114	2025-12-19 10:10:09.734431
337	2076	114	2025-12-19 10:10:09.735011
338	2077	114	2025-12-19 10:10:09.735555
339	2080	114	2025-12-19 10:10:09.736092
340	2081	114	2025-12-19 10:10:09.736624
341	2082	114	2025-12-19 10:10:09.737126
342	2083	114	2025-12-19 10:10:09.737679
343	2084	114	2025-12-19 10:10:09.738197
344	2085	114	2025-12-19 10:10:09.738699
345	2086	114	2025-12-19 10:10:09.739217
346	2087	114	2025-12-19 10:10:09.739749
347	2088	114	2025-12-19 10:10:09.740253
348	2096	114	2025-12-19 10:10:09.740739
349	2171	114	2025-12-19 10:10:09.741213
350	2172	114	2025-12-19 10:10:09.741729
351	2173	114	2025-12-19 10:10:09.742185
352	2178	114	2025-12-19 10:10:09.742631
353	2186	114	2025-12-19 10:10:09.743128
354	2187	114	2025-12-19 10:10:09.74362
355	2191	114	2025-12-19 10:10:09.744084
356	2192	114	2025-12-19 10:10:09.744523
357	2193	114	2025-12-19 10:10:09.744965
358	2194	114	2025-12-19 10:10:09.745402
359	2195	114	2025-12-19 10:10:09.745869
360	2196	114	2025-12-19 10:10:09.74643
361	2197	114	2025-12-19 10:10:09.746895
362	2198	114	2025-12-19 10:10:09.747355
363	2199	114	2025-12-19 10:10:09.747816
364	2200	114	2025-12-19 10:10:09.748261
365	2201	114	2025-12-19 10:10:09.748678
366	2202	114	2025-12-19 10:10:09.749188
367	2203	114	2025-12-19 10:10:09.749603
368	2204	114	2025-12-19 10:10:09.750061
369	2205	114	2025-12-19 10:10:09.750694
370	2206	114	2025-12-19 10:10:09.751219
371	2207	114	2025-12-19 10:10:09.751685
372	2208	114	2025-12-19 10:10:09.752136
373	2209	114	2025-12-19 10:10:09.752606
374	2213	114	2025-12-19 10:10:09.753077
375	2214	114	2025-12-19 10:10:09.753543
376	2215	114	2025-12-19 10:10:09.753996
377	2432	114	2025-12-19 10:10:09.754476
378	2433	114	2025-12-19 10:10:09.754919
379	2434	114	2025-12-19 10:10:09.755346
380	2437	114	2025-12-19 10:10:09.755812
391	1882	107	2025-12-19 11:07:46.388225
392	1883	107	2025-12-19 11:07:46.389428
393	1884	107	2025-12-19 11:07:46.390093
394	1885	107	2025-12-19 11:07:46.39069
395	1886	107	2025-12-19 11:07:46.391487
396	1981	107	2025-12-19 11:07:46.392334
397	1983	107	2025-12-19 11:07:46.392965
399	1887	108	2025-12-19 11:15:05.272672
400	1888	108	2025-12-19 11:15:05.274471
401	1889	108	2025-12-19 11:15:05.279679
402	2252	108	2025-12-19 11:15:05.280646
403	2297	108	2025-12-19 11:15:05.281369
404	3191	108	2025-12-19 13:00:35.739481
407	3211	108	2025-12-19 15:41:41.614819
412	1994	109	2025-12-19 21:45:11.153841
413	2253	109	2025-12-19 21:45:11.155397
414	2296	109	2025-12-19 21:45:11.15592
415	2299	109	2025-12-19 21:45:11.156497
416	2301	109	2025-12-19 21:45:11.157002
417	2376	109	2025-12-19 21:45:11.157483
418	2380	109	2025-12-19 21:45:11.15797
419	2382	109	2025-12-19 21:45:11.158448
420	3243	109	2025-12-19 22:06:02.554495
421	3247	109	2025-12-19 22:13:00.113073
422	3253	109	2025-12-19 22:20:18.141986
11922	1850	102	2026-06-28 08:33:57.277388
11923	1852	102	2026-06-28 08:33:57.27815
11924	1855	102	2026-06-28 08:33:57.278945
11925	1859	102	2026-06-28 08:33:57.280003
11926	1861	102	2026-06-28 08:33:57.280884
11927	1864	102	2026-06-28 08:33:57.281633
11928	1865	102	2026-06-28 08:33:57.282265
11929	1868	102	2026-06-28 08:33:57.28299
11930	1891	102	2026-06-28 08:33:57.283731
11931	1892	102	2026-06-28 08:33:57.284544
11932	1895	102	2026-06-28 08:33:57.285179
11933	1896	102	2026-06-28 08:33:57.285967
11934	1902	102	2026-06-28 08:33:57.286989
11935	1903	102	2026-06-28 08:33:57.287767
11936	1904	102	2026-06-28 08:33:57.288412
11937	1905	102	2026-06-28 08:33:57.289069
11938	1906	102	2026-06-28 08:33:57.289684
11939	1907	102	2026-06-28 08:33:57.290239
11940	1908	102	2026-06-28 08:33:57.290764
11941	2263	102	2026-06-28 08:33:57.291266
11942	2266	102	2026-06-28 08:33:57.292911
11943	3212	102	2026-06-28 08:33:57.293486
11944	3168	102	2026-06-28 08:33:57.294037
11945	3174	102	2026-06-28 08:33:57.294712
11946	1984	106	2026-06-28 08:34:19.429953
11154	1808	103	2026-03-16 23:48:42.805765
11155	1809	103	2026-03-16 23:48:42.80702
11156	1811	103	2026-03-16 23:48:42.807678
11157	1813	103	2026-03-16 23:48:42.80831
11158	1814	103	2026-03-16 23:48:42.809027
11159	1817	103	2026-03-16 23:48:42.809673
11160	1818	103	2026-03-16 23:48:42.810354
11161	1819	103	2026-03-16 23:48:42.810962
11162	1990	103	2026-03-16 23:48:42.811798
7262	1860	105	2026-01-11 17:30:25.90159
7263	1866	105	2026-01-11 17:30:25.902241
7264	1867	105	2026-01-11 17:30:25.902875
7265	1870	105	2026-01-11 17:30:25.903524
7266	1871	105	2026-01-11 17:30:25.904238
7267	1986	105	2026-01-11 17:30:25.904999
11163	2000	103	2026-03-16 23:48:42.812549
11164	2002	103	2026-03-16 23:48:42.813285
11165	2010	103	2026-03-16 23:48:42.813896
11166	2011	103	2026-03-16 23:48:42.814766
11167	2012	103	2026-03-16 23:48:42.815545
11168	2013	103	2026-03-16 23:48:42.816375
11169	2014	103	2026-03-16 23:48:42.81716
11170	2015	103	2026-03-16 23:48:42.818148
11171	2016	103	2026-03-16 23:48:42.81902
11172	2017	103	2026-03-16 23:48:42.819958
11173	2018	103	2026-03-16 23:48:42.820706
11174	2019	103	2026-03-16 23:48:42.82124
11175	2022	103	2026-03-16 23:48:42.821833
11176	2023	103	2026-03-16 23:48:42.822584
11177	2024	103	2026-03-16 23:48:42.823212
11178	2025	103	2026-03-16 23:48:42.823892
11179	2026	103	2026-03-16 23:48:42.8245
11180	2027	103	2026-03-16 23:48:42.825242
11181	2028	103	2026-03-16 23:48:42.825948
11182	2062	103	2026-03-16 23:48:42.826777
11183	2063	103	2026-03-16 23:48:42.82756
11184	2244	103	2026-03-16 23:48:42.828325
11185	2255	103	2026-03-16 23:48:42.828931
11186	2260	103	2026-03-16 23:48:42.829728
11187	2295	103	2026-03-16 23:48:42.830476
11188	2298	103	2026-03-16 23:48:42.831307
11189	2300	103	2026-03-16 23:48:42.832221
11190	2305	103	2026-03-16 23:48:42.833167
11191	2307	103	2026-03-16 23:48:42.833967
11192	2308	103	2026-03-16 23:48:42.834792
11193	2315	103	2026-03-16 23:48:42.835615
11194	2316	103	2026-03-16 23:48:42.83641
11195	2317	103	2026-03-16 23:48:42.837007
\.


--
-- Data for Name: scheduled_messages; Type: TABLE DATA; Schema: public; Owner: -
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
-- Data for Name: server_settings; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.server_settings (id, key, value, description, updated_at) FROM stdin;
\.


--
-- Data for Name: user_relations; Type: TABLE DATA; Schema: public; Owner: -
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
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, password, phone, email, avatar, created_at, updated_at, auth_code, full_name, gender, work_signature, status, landline, short_number, department, "position", region, invite_code, invited_by_code, voip_token, voip_token_updated_at, last_login_at, is_overseas, active_token, token_updated_at) FROM stdin;
105	test04	$2a$10$Fm3Q5vPVgXwYZwVI4iqG7.QUSXtXQ2FxUlehsmypbh6NzvtP3dEiO	\N	\N		2025-11-24 22:21:53.621795	2026-01-11 17:30:35.522203	\N	测试04	\N	\N	offline	\N	\N	\N	\N	\N	K3Ogct	\N	\N	\N	2026-01-11 09:30:24.95766	0	\N	\N
152	wxh1	$2a$10$zGp/1ngnW79Wvks7aBNFYOuK1GsoccGhmEKMeJkLU2jFlOrIG4P8S	\N	\N		2025-12-06 14:54:24.023958	2026-01-09 12:05:18.311506	\N	wxh	\N	\N	online	\N	\N	\N	\N	\N	ptrSum	666666	\N	\N	\N	0	\N	\N
104	test03	$2a$10$kByMCMm.Y47JpqWpOV9NG.WE0fuSLy2b5focqkbqSdcnF0lW9zGe.	\N	\N		2025-11-24 17:36:14.534498	2026-01-09 12:05:18.311506	\N	测试03	\N	\N	offline	\N	\N	\N	\N	\N	666666	\N	\N	\N	\N	0	\N	\N
150	dj001	$2a$10$rklcLD426DsuPgExqz..WOfAqHjFq1ple02HF4un8jXKiNHYplllC	\N	\N		2025-12-06 10:32:12.897471	2026-01-09 12:05:18.311506	\N	大江	\N	不成功便成仁，	offline	\N	\N	\N	\N	\N	6zQD3d	666666	\N	\N	\N	0	\N	\N
158	test922	$2a$10$.vc/gieNK3WJ1gbhkKum3exBNLs4v2HIO38Aiv1iOOoWLfp0fh72y	\N	\N		2025-12-19 09:52:27.699365	2026-01-09 12:05:18.311506	\N	ceshi922	\N	\N	offline	\N	\N	\N	\N	\N	eAH25u	666666	\N	\N	\N	0	\N	\N
107	test06	$2a$10$.KpWdHmmFNCIj/pMEH5BwuxShNCcz6TjXiEUiO8Eja1g/X23elPCu	\N	\N		2025-11-25 11:58:13.736898	2026-01-09 12:05:18.311506	\N	测试06	\N	\N	offline	\N	\N	\N	\N	\N	Rri1WK	\N	\N	\N	\N	0	\N	\N
154	sfq80801	$2a$10$3iEIP74SayUnQL3ZFqYA9ufHdjJLwUytWiwHWQajY1eElVJIPsug.	\N	\N		2025-12-13 09:42:50.879754	2026-01-09 12:05:18.311506	\N	夜风来袭	\N	\N	offline	\N	\N	\N	\N	\N	ce7fUb	666666	\N	\N	\N	0	\N	\N
146	WZH6688	$2a$10$efSJUY2Mxms0K0A4Zgm6Z.og4kGSc/Nzgu4.e5R6hYmdq7m7H08Um	\N	\N		2025-12-06 10:25:31.680899	2026-01-09 12:05:18.311506	\N	王志豪	\N	\N	offline	\N	\N	\N	\N	\N	s0ygTk	666666	\N	\N	\N	0	\N	\N
155	AA1122	$2a$10$6eA7cEPoAE1FYPW4XSee3OJHnViW8mlL5TCtIv6j2aWzrUp7vBqgK	\N	\N		2025-12-14 10:20:33.891178	2026-01-09 12:05:18.311506	\N	阿宇	\N	\N	offline	\N	\N	\N	\N	\N	l4xW3w	95hWRS	\N	\N	\N	0	\N	\N
111	test20	$2a$10$.G9/nBcXlJcoNIM6m61Ohu5BRWvvX0zZsH5vr4og9zVJDLM46OwNG	\N	\N		2025-11-25 13:19:01.898295	2026-01-09 12:05:18.311506	\N	测试20	\N	\N	offline	\N	\N	\N	\N	\N	8QCI6H	\N	\N	\N	\N	0	\N	\N
142	ces001	$2a$10$HuzBE8pUeKmC38beO1MhN.savf7qXXrD9ojebaNZrQlMhBgJPooDW	的广泛受到广泛的1111	<script>alter('1')</script>11111	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764393312_JPEG_20251129_131511_2366789718876412309.jpg	2025-11-29 04:45:00.855735	2026-01-09 12:05:18.311506	\N	1ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的ces001发顺丰到付公司的	male	1111<script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter('1')</script><script>alter(	offline	q11111	11111	<script>alter('1')</script>11111	<script>alter('1')</script>1111	<script>alter('1')</script>1111	xW9sEa	\N	\N	\N	\N	0	\N	\N
143	ces002	$2a$10$LGf56v6mB2ZoldDA/naiuuAhG533Tfn6s3ZIKOTzoGHc8V/ML35Fu	13852425252	jaajapappaapappad@qq.com	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764395761_屏幕截图 2025-08-12 125412.png	2025-11-29 05:06:33.640026	2026-01-09 12:05:18.311506	\N	可可粉咳咳咳咳咳咳咳咳姐咳xcyufguguuggu咳咳咳咳咳咳	male	vcxvxcv	online			啊撒撒撒的热热热特特	并不是说看快手咳咳咳咳上课上课可	老婆老婆热可可热热可热了fyfyytdyxxyffcycycyfuufuffuuggu	TywbzT	\N	\N	\N	\N	0	\N	\N
117	qiufeng1	$2a$10$KdRwqdss348crc51HldB5uIn1NdMtHfFl4L712T6zeeyKtcFQctX.			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167893_GH_20logo151639.png.png	2025-11-26 14:21:13.644025	2026-01-09 12:05:18.311506	\N	秋风2	male	\N	offline						Hsyde3	\N	\N	\N	\N	0	\N	\N
124	test31	$2a$10$Ab6B9CTJp7A1qh0jqTwMXOEn79/G/pUi2L83g9/waF.vaHU6f86/C	\N	\N		2025-11-27 06:32:25.759358	2026-01-09 12:05:18.311506	\N	测试31	\N	\N	online	\N	\N	\N	\N	\N	TtOCO7	\N	\N	\N	\N	0	\N	\N
148	adi1234	$2a$10$8SxDCLH6f8qqRbxp0LeoOu.Hzjhyhu2NlgR0h6mtruFZZTPlBY6KG			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/images/user/148/1765678342601134207_Screenshot_2025-12-09-21-03-08-753_com.miui.gallery-edit.jpg	2025-12-06 10:26:58.824751	2026-01-09 12:05:18.311506	\N	阿迪	male	\N	offline	\N	\N				95hWRS	666666	\N	\N	\N	0	\N	\N
147	sanpao888	$2a$10$e2vs0NDFWeXVfYHyg8Eo7.WxAg2q75JZn4bdTrmf9ZbcgE5kwfP7G	15816818817	pao@outlook.com	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002326_JPEG_20251206_142525_6675084135310091532.jpg	2025-12-06 10:26:26.269175	2026-01-09 12:05:18.311506	\N	风生水起	male	\N	offline	\N	\N	业务部	你猜	陕西	UlkXS4	666666	\N	\N	\N	0	\N	\N
149	sfq80810	$2a$10$YDfOr/LZBpnvz8QaArBW4OAl4eDbOMt68vGlRFNo8lvB3ziujfljW	13333333333	10000@qq.com	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765002345_JPEG_20251206_142548_1632189368049207096.jpg	2025-12-06 10:27:18.52056	2026-01-09 12:05:18.311506	\N	苏	male	\N	offline	\N	\N	1	1	1	md3ceI	666666	\N	\N	\N	0	\N	\N
153	wxh2	$2a$10$/uBnKOMh40urJ6m.QYvfqenCDVfxgcKYR9XHxM5wjjME6Ufw6W5ym	\N	\N		2025-12-06 14:55:07.139953	2026-01-09 12:05:18.311506	\N	wxhh	\N	\N	offline	\N	\N	\N	\N	\N	NvNdjl	666666	\N	\N	\N	0	\N	\N
157	ces006	$2a$10$29XPy0YWoJ8PvBIueDofAuacp39c/i2EjRUtg1GL1YY3xvGEd6wTm	\N	\N		2025-12-14 15:38:25.148958	2026-01-09 12:05:18.311506	\N	显示第 1 到第 1 条记录，总共 1 条记录显示第 1 到第 1 条记录，总共 1 条记录显示第 1 到第 1 条记录，总共 1 条记录	\N	\N	offline	\N	\N	\N	\N	\N	kbwmxg	666666	\N	\N	\N	0	\N	\N
156	ces004	$2a$10$9mxqETTEomRtw0092M80lePq7sGkGimxAffY3.DX97oL9wW4GJHZ2	\N	\N		2025-12-14 15:37:28.927357	2026-01-09 12:05:18.311506	\N	所有为了保证系统统一性，后台和客户端涉及地址地方都使用的该表，但新安装是不存在，地区表数据又庞大，所有我们也没有内置	\N	\N	offline	\N	\N	\N	\N	\N	DsgsWx	666666	\N	\N	\N	0	\N	\N
151	wxs6688	$2a$10$/5oH3YZWPgaqGyWXgnUfUuiiYDnqYnuL7qgN5i/KjGZqW/vrYoOmG			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1765004029_JPEG_20251206_145348_7283309526769554210.jpg	2025-12-06 10:36:34.44	2026-01-09 12:05:18.311506	\N	王先生	male	\N	offline	\N	\N				0pQZqw	666666	\N	\N	\N	0	\N	\N
145	qiufeng11	$2a$10$..hMi8/7Lal/Rb1EV0VZR.zBBYxlrW9W6a0cFBG3ErdYM5AI8JH3y	\N	\N		2025-12-03 21:35:31.86807	2026-01-09 12:05:18.311506	\N	秋风	\N	\N	offline	\N	\N	\N	\N	\N	jXMUZ7	666666	\N	\N	\N	0	\N	\N
159	test25	$2a$10$W77y582rSkWCBakCiSOimOAtTLNRZ/k2UZs5TctnA34IsdxU4okDe	\N	\N		2025-12-19 10:45:23.040448	2026-01-09 12:05:18.311506	\N	ceshi25	\N	\N	offline	\N	\N	\N	\N	\N	DS9ryR	666666	\N	\N	\N	0	\N	\N
126	test900	$2a$10$E.gJG.I6vsVU3GCbnk4jeuNMdgpeCJrLfU2qdbGWKmPxi1LBN6/Di	\N	\N		2025-11-28 00:00:57.496309	2026-01-09 12:05:18.311506	\N	123	\N	\N	offline	\N	\N	\N	\N	\N	x0dLTN	\N	\N	\N	\N	0	\N	\N
110	test09	$2a$10$1rrVDyQSoXiISY1ElZOQRO5dRCPPzFDiwtwp6ra0xI2UYzrd0zHMK	\N	\N		2025-11-25 13:02:50.353647	2026-01-09 12:05:18.311506	\N	测试09	\N	\N	offline	\N	\N	\N	\N	\N	rXVRb2	\N	\N	\N	\N	0	\N	\N
123	test100	$2a$10$L8n1JOJgagu85FNY2tZAPOI2vuaJMfoovP/QXGCkTv.yWVunqElc2	\N	\N		2025-11-27 01:30:16.374876	2026-01-09 12:05:18.311506	\N	测试100	\N	\N	offline	\N	\N	\N	\N	\N	xBPCUb	\N	\N	\N	\N	0	\N	\N
134	test909	$2a$10$9EWNU7fFsOtA8TEM8KIxpeOhk2Yz3mlExD5cqsIbIBjy2qHfFb8b2	\N	\N		2025-11-28 06:46:20.846748	2026-01-09 12:05:18.311506	\N	测试909	\N	\N	online	\N	\N	\N	\N	\N	nfMYHK	\N	\N	\N	\N	0	\N	\N
119	test10	$2a$10$7aWNurJ0HDU2FidMMXuH/Om3qtVMkedfiJsATq2ZSBUyvgpB4AMqS	\N	\N		2025-11-26 16:47:07.199907	2026-01-09 12:05:18.311506	\N	侧式0	\N	\N	offline	\N	\N	\N	\N	\N	0oBF4P	\N	\N	\N	\N	0	\N	\N
141	qiufeng2	$2a$10$tC2ydOFg1THLe1OC84qVJOpbrETZznCRqkTXiBi855XAIojZ1KXo.				2025-11-28 08:04:19.618639	2026-01-09 12:05:18.311506	\N	秋风2	male	\N	offline						ggzrDO	\N	\N	\N	\N	0	\N	\N
135	test910	$2a$10$4YfYLTGloHAW3FGml5JB8u1mYhAwJnWRE4GLsY5rOSYaEvcRe5vX2	\N	\N		2025-11-28 07:04:57.615503	2026-01-09 12:05:18.311506	\N	昵称910	\N	\N	online	\N	\N	\N	\N	\N	OqSnXZ	\N	\N	\N	\N	0	\N	\N
120	youdu2	$2a$10$VYeIyRBGcPJoaCMt/9UyN.et5f6vEjMMBcElt50IzjxRtF7Ujg4Ea	\N	\N		2025-11-26 19:35:18.663729	2026-01-09 12:05:18.311506	\N	有度2	\N	\N	offline	\N	\N	\N	\N	\N	OJvcX3	\N	\N	\N	\N	0	\N	\N
129	test904	$2a$10$aUwhqiUDk7P/w3DsDWKbF.933HGQ2lIsZKj8DgcaihQAE4hrBnmJi	\N	\N		2025-11-28 06:12:29.512534	2026-01-09 12:05:18.311506	\N	测试904	\N	\N	offline	\N	\N	\N	\N	\N	HQrHNw	\N	\N	\N	\N	0	\N	\N
125	test35	$2a$10$S96svAO/1hFW98e2rqA6Sukb54my2PbvDE3.8n/GNiYI0g1VEWxty	\N	\N		2025-11-27 11:47:10.959457	2026-01-09 12:05:18.311506	\N	测试35	\N	\N	offline	\N	\N	\N	\N	\N	IU28dJ	\N	\N	\N	\N	0	\N	\N
121	youdu3	$2a$10$QVve1LP3QSSKwj1h6CIas.yoHB3P/9oKr.yJh/yaM8gRAkCuw5mdG	\N	\N		2025-11-26 19:39:03.740618	2026-01-09 12:05:18.311506	\N	有度3	\N	\N	offline	\N	\N	\N	\N	\N	nqzSqr	\N	\N	\N	\N	0	\N	\N
132	test907	$2a$10$fqZ2Kgfyg2w6WRzLHo6L2e4ovGd2zUJmQAVKbIGcHMtzOYh/VTFD2	\N	\N		2025-11-28 06:26:40.752577	2026-01-09 12:05:18.311506	\N	测试907	\N	\N	offline	\N	\N	\N	\N	\N	wn6jF0	\N	\N	\N	\N	0	\N	\N
128	test902	$2a$10$cy4M4hutVkww8IOPOHsmyeIq8z87Rb0ngMq2rULB3z5k5yPQdw0ci	\N	\N		2025-11-28 06:10:06.367996	2026-01-09 12:05:18.311506	\N	测试902	\N	\N	offline	\N	\N	\N	\N	\N	8wps5g	\N	\N	\N	\N	0	\N	\N
122	test99	$2a$10$QJCu7Sn7S1KkJaKtoyLQIOoIc5fQC.a8K6wG3lSfF6KqnAEE7PRHq	\N	\N		2025-11-27 01:29:20.575165	2026-01-09 12:05:18.311506	\N	测试99	\N	\N	offline	\N	\N	\N	\N	\N	FbglOo	\N	\N	\N	\N	0	\N	\N
133	test908	$2a$10$MLLJza/ucdYYY66XtYNM9u7V5If5778oa.1cQGeP664ml5C9gy3.S	\N	\N		2025-11-28 06:42:23.148388	2026-01-09 12:05:18.311506	\N	测试908	\N	\N	offline	\N	\N	\N	\N	\N	zH967n	\N	\N	\N	\N	0	\N	\N
131	test906	$2a$10$iHElm5HaJ1kWnl0YyK1/AuH/PssqxMxh/bRrDGyVgbnUdN.qwcUdi	\N	\N		2025-11-28 06:24:39.616135	2026-01-09 12:05:18.311506	\N	测试906	\N	\N	offline	\N	\N	\N	\N	\N	CH3tDT	\N	\N	\N	\N	0	\N	\N
138	test913	$2a$10$XW/kzSD4ZAsZchiYtc7r2exoCf7bkmaerwe3h1bnWkzbnk8uz.n2O	\N	\N		2025-11-28 07:13:17.380187	2026-01-09 12:05:18.311506	\N	测试913	\N	\N	offline	\N	\N	\N	\N	\N	G6J4RD	\N	\N	\N	\N	0	\N	\N
137	test912	$2a$10$5lx/VIIdv4.e9Vbxd6WnjuL7NbYFYxJJpnIdEV6YSaRKnE7sNdC6a	\N	\N		2025-11-28 07:10:04.032567	2026-01-09 12:05:18.311506	\N	测试912	\N	\N	offline	\N	\N	\N	\N	\N	1wHDYc	\N	\N	\N	\N	0	\N	\N
139	test914	$2a$10$aao7IzRD7XOAZe1Q2ndfFesP/ombx0m2R3wfaO8TSZwDsUf9vIzIO	\N	\N		2025-11-28 07:15:30.723365	2026-01-09 12:05:18.311506	\N	测试914	\N	\N	online	\N	\N	\N	\N	\N	qCo4If	\N	\N	\N	\N	0	\N	\N
140	test831	$2a$10$03vQPQM0/o3VaWKLbpaAleb.r36W3oI7Le01vDcTF58uGcN3/j3XW	\N	\N		2025-11-28 07:59:03.687056	2026-01-09 12:05:18.311506	\N	测试831	\N	\N	offline	\N	\N	\N	\N	\N	jysqLT	\N	\N	\N	\N	0	\N	\N
130	test905	$2a$10$7X9uJNSwYKlIEggg0GEUauY209wkb6IvTSTguuIF9lzaUhjLEagrG	\N	\N		2025-11-28 06:22:59.560673	2026-01-09 12:05:18.311506	\N	测试905	\N	\N	offline	\N	\N	\N	\N	\N	gQGSLQ	\N	\N	\N	\N	0	\N	\N
116	qiufeng	$2a$10$WGT2RL6k9.TkDEifdDLmten/OysbtHphdRQefDWdawES4B.8UiiVC			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764167864_JPEG_20251126_223743_2801915060574922910.jpg	2025-11-26 14:19:55.691941	2026-01-09 12:05:18.311506	\N	秋风1	male	\N	offline	\N	\N				fPUgZ9	\N	\N	\N	\N	0	\N	\N
118	youdu1	$2a$10$GJTfWb9..2xL57zjpIAJUOghtjgNNiK4MB/dKDUkE6G64G3WXs2My	\N	\N		2025-11-26 14:30:37.444255	2026-01-09 12:05:18.311506	\N	有度	\N	\N	offline	\N	\N	\N	\N	\N	bHpjXp	\N	\N	\N	\N	0	\N	\N
136	test911	$2a$10$U9SX997s7aMYLEZQ9PYkLOHpEJmJ2CJfq5m6cpz9S/iXAAanyE2sy	\N	\N		2025-11-28 07:08:40.748777	2026-01-09 12:05:18.311506	\N	测试911	\N	\N	offline	\N	\N	\N	\N	\N	n9gT8U	\N	\N	\N	\N	0	\N	\N
113	test22	$2a$10$ATfNIdUDVtWLhSeF6dMvL.m3EQEUFaFDgVb/GK7yNlQFY8.b4XORa			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129559_ic_launcher.png	2025-11-25 17:55:13.217482	2026-01-09 12:05:18.311506	\N	测试22	male	errt	offline						hIAuk3	\N	\N	\N	\N	0	\N	\N
112	test21	$2a$10$Eaj1zQhgPJEqdQWaLa8P6.NIUf4Drc38eChifjExQSKJsWdDvlYxa	\N	\N		2025-11-25 13:19:49.620411	2026-01-09 12:05:18.311506	\N	测试21	\N	\N	offline	\N	\N	\N	\N	\N	9wjxQp	\N	\N	\N	\N	0	\N	\N
114	test23	$2a$10$GpkCQkQ4ra.Pv73rwAiYTuB/sz6Q5b2Vl34GBseFrAj1/jnQg2r4u			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129472_JPEG_20251126_115752_2461943808010734271.jpg	2025-11-25 17:56:40.890524	2026-01-09 12:05:18.311506	\N	测试23	male	\N	offline	\N	\N				zHxx7p	\N	\N	\N	\N	0	\N	\N
108	test07	$2a$10$yJCg/1THxS0reCHZuSmw0u4I15gQbBSrf50uTxeukvUWkUE2N4KIK	\N	\N		2025-11-25 12:33:05.712664	2026-01-09 12:05:18.311506	\N	测试07	\N	\N	offline	\N	\N	\N	\N	\N	pl3aH0	\N	\N	\N	\N	0	\N	\N
109	test08	$2a$10$F2bLFd0ymS2Z49VUu4ORnuPhwYYD6F557ux1Armlug.RgE0D5g/l6	\N	\N		2025-11-25 12:47:11.273864	2026-01-09 12:05:18.311506	\N	测试08	\N	\N	online	\N	\N	\N	\N	\N	tHQ0bH	\N	\N	\N	\N	0	\N	\N
205	test1046	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1046	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
206	test1047	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1047	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
207	test1048	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1048	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
208	test1049	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1049	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
209	test1050	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1050	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
210	test1051	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1051	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
211	test1052	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1052	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
212	test1053	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1053	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
213	test1054	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1054	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
214	test1055	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1055	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
215	test1056	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1056	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
216	test1057	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1057	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
106	test05	$2a$10$kn7TCvq3qQTaf8RaURSgauc6k9QRCE6.JWPwmPMw.1JiPa1ZrAcLm	\N	\N		2025-11-25 09:22:55.250863	2026-06-28 08:47:24.241389	\N	测试05	\N	\N	offline	\N	\N	\N	\N	\N	4cPntt	\N	\N	\N	2026-06-28 00:34:17.190354	0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMDYsInVzZXJuYW1lIjoidGVzdDA1IiwiZXhwIjoxNzgzMjExNjU3LCJuYmYiOjE3ODI2MDY4NTcsImlhdCI6MTc4MjYwNjg1N30.Y2GULt-usSy1RnnwDsaI0CUDj429II5NfQqhTfawFfg	2026-06-28 00:34:17.188223+08
160	test1001	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1001	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
161	test1002	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1002	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
162	test1003	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1003	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
163	test1004	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1004	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
164	test1005	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1005	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
165	test1006	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1006	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
166	test1007	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1007	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
167	test1008	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1008	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
168	test1009	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1009	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
169	test1010	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1010	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
144	ces003	$2a$10$nqEGOj6dyTAXFz6MQ8Utxuh/yonnlKsMhoskuhEHcwEAnLqboCBdG	13598797897	11@qq.com	https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764489309_图片合成.png	2025-11-29 06:56:36.541428	2026-01-09 12:05:18.311506	\N	cesfffff	female	fgdfhgdfgbb	online			11	11	11	mWHIp8	\N	\N	\N	\N	0	\N	\N
170	test1011	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1011	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
171	test1012	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1012	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
127	test901	$2a$10$HcS9fO18ZOv0JF5PY6wY1u/Dyjp.PwywGbveid6JXWrAb58EVlhP6				2025-11-28 00:02:04.303367	2026-01-09 12:05:18.311506	\N	测试901	male	\N	offline						ocfZbc	\N	\N	\N	\N	0	\N	\N
115	test30	$2a$10$5volaozylAbd5Z5N7mllWeMdgGy1EdmUtrJsgq2/UmUMhtIWxv9vi	\N	\N		2025-11-26 08:51:28.094057	2026-01-09 12:05:18.311506	\N	测试30	\N	\N	offline	\N	\N	\N	\N	\N	G5zSPm	\N	\N	\N	\N	0	\N	\N
172	test1013	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1013	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
173	test1014	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1014	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
174	test1015	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1015	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
175	test1016	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1016	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
176	test1017	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1017	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
177	test1018	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1018	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
178	test1019	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1019	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
179	test1020	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1020	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
180	test1021	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1021	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
181	test1022	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1022	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
182	test1023	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1023	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
183	test1024	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1024	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
184	test1025	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1025	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
185	test1026	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1026	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
186	test1027	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1027	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
187	test1028	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1028	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
188	test1029	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1029	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
189	test1030	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1030	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
190	test1031	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1031	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
191	test1032	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1032	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
192	test1033	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1033	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
193	test1034	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1034	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
194	test1035	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1035	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
195	test1036	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1036	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
196	test1037	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1037	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
197	test1038	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1038	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
198	test1039	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1039	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
199	test1040	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1040	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
200	test1041	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1041	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
201	test1042	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1042	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
202	test1043	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1043	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
203	test1044	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1044	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
204	test1045	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.434076	2026-01-23 21:18:25.434076	\N	测试用户1045	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
217	test1058	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1058	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
218	test1059	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1059	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
219	test1060	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1060	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
220	test1061	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1061	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
221	test1062	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1062	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
222	test1063	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1063	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
223	test1064	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1064	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
224	test1065	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1065	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
225	test1066	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1066	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
226	test1067	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1067	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
227	test1068	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1068	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
228	test1069	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1069	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
229	test1070	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1070	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
230	test1071	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1071	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
231	test1072	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1072	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
232	test1073	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1073	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
233	test1074	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1074	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
234	test1075	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1075	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
235	test1076	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1076	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
236	test1077	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1077	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
237	test1078	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1078	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
238	test1079	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1079	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
239	test1080	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1080	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
240	test1081	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1081	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
241	test1082	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1082	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
242	test1083	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1083	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
243	test1084	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1084	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
244	test1085	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1085	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
245	test1086	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1086	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
246	test1087	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1087	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
247	test1088	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1088	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
248	test1089	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1089	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
249	test1090	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1090	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
250	test1091	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1091	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
251	test1092	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1092	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
252	test1093	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1093	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
253	test1094	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1094	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
254	test1095	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1095	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
255	test1096	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1096	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
256	test1097	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1097	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
257	test1098	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1098	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
258	test1099	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1099	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
259	test1100	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.443904	2026-01-23 21:18:25.443904	\N	测试用户1100	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
260	test1101	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1101	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
261	test1102	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1102	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
262	test1103	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1103	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
263	test1104	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1104	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
264	test1105	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1105	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
265	test1106	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1106	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
266	test1107	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1107	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
267	test1108	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1108	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
268	test1109	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1109	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
269	test1110	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1110	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
270	test1111	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1111	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
271	test1112	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1112	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
272	test1113	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1113	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
273	test1114	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1114	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
274	test1115	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1115	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
275	test1116	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1116	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
276	test1117	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1117	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
277	test1118	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1118	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
278	test1119	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1119	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
279	test1120	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1120	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
280	test1121	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1121	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
281	test1122	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1122	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
282	test1123	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1123	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
283	test1124	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1124	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
284	test1125	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1125	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
285	test1126	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1126	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
286	test1127	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1127	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
287	test1128	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1128	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
288	test1129	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1129	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
289	test1130	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1130	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
290	test1131	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1131	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
291	test1132	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1132	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
292	test1133	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1133	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
293	test1134	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1134	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
294	test1135	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1135	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
295	test1136	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1136	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
296	test1137	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1137	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
297	test1138	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1138	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
298	test1139	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1139	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
299	test1140	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1140	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
300	test1141	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1141	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
301	test1142	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1142	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
302	test1143	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1143	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
303	test1144	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1144	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
304	test1145	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1145	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
305	test1146	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1146	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
306	test1147	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1147	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
307	test1148	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1148	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
308	test1149	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1149	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
309	test1150	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.447625	2026-01-23 21:18:25.447625	\N	测试用户1150	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
310	test1151	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1151	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
311	test1152	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1152	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
312	test1153	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1153	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
313	test1154	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1154	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
314	test1155	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1155	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
315	test1156	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1156	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
316	test1157	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1157	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
317	test1158	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1158	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
318	test1159	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1159	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
319	test1160	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1160	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
320	test1161	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1161	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
321	test1162	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1162	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
322	test1163	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1163	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
323	test1164	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1164	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
324	test1165	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1165	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
325	test1166	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1166	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
326	test1167	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1167	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
327	test1168	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1168	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
328	test1169	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1169	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
329	test1170	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1170	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
330	test1171	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1171	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
331	test1172	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1172	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
332	test1173	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1173	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
333	test1174	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1174	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
334	test1175	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1175	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
335	test1176	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1176	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
336	test1177	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1177	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
337	test1178	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1178	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
338	test1179	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1179	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
339	test1180	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1180	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
340	test1181	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1181	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
341	test1182	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1182	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
342	test1183	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1183	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
343	test1184	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1184	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
344	test1185	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1185	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
345	test1186	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1186	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
346	test1187	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1187	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
347	test1188	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1188	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
348	test1189	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1189	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
349	test1190	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1190	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
350	test1191	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1191	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
351	test1192	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1192	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
352	test1193	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1193	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
353	test1194	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1194	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
354	test1195	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1195	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
355	test1196	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1196	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
356	test1197	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1197	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
357	test1198	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1198	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
358	test1199	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1199	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
359	test1200	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.451235	2026-01-23 21:18:25.451235	\N	测试用户1200	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
360	test1201	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1201	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
361	test1202	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1202	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
362	test1203	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1203	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
363	test1204	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1204	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
364	test1205	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1205	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
365	test1206	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1206	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
366	test1207	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1207	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
367	test1208	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1208	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
368	test1209	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1209	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
369	test1210	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1210	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
370	test1211	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1211	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
371	test1212	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1212	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
372	test1213	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1213	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
373	test1214	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1214	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
374	test1215	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1215	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
375	test1216	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1216	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
376	test1217	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1217	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
377	test1218	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1218	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
378	test1219	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1219	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
379	test1220	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1220	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
380	test1221	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1221	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
381	test1222	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1222	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
382	test1223	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1223	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
383	test1224	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1224	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
384	test1225	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1225	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
385	test1226	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1226	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
386	test1227	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1227	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
387	test1228	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1228	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
388	test1229	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1229	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
389	test1230	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1230	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
390	test1231	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1231	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
391	test1232	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1232	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
392	test1233	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1233	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
393	test1234	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1234	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
394	test1235	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1235	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
395	test1236	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1236	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
396	test1237	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1237	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
397	test1238	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1238	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
398	test1239	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1239	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
399	test1240	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1240	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
400	test1241	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1241	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
401	test1242	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1242	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
402	test1243	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1243	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
403	test1244	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1244	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
404	test1245	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1245	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
405	test1246	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1246	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
406	test1247	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1247	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
407	test1248	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1248	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
408	test1249	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1249	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
409	test1250	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.454649	2026-01-23 21:18:25.454649	\N	测试用户1250	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
410	test1251	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1251	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
411	test1252	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1252	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
412	test1253	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1253	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
413	test1254	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1254	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
414	test1255	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1255	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
415	test1256	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1256	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
416	test1257	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1257	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
417	test1258	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1258	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
418	test1259	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1259	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
419	test1260	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1260	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
420	test1261	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1261	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
421	test1262	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1262	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
422	test1263	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1263	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
423	test1264	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1264	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
424	test1265	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1265	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
425	test1266	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1266	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
426	test1267	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1267	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
427	test1268	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1268	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
428	test1269	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1269	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
429	test1270	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1270	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
430	test1271	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1271	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
431	test1272	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1272	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
432	test1273	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1273	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
433	test1274	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1274	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
434	test1275	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1275	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
435	test1276	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1276	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
436	test1277	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1277	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
437	test1278	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1278	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
438	test1279	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1279	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
439	test1280	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1280	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
440	test1281	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1281	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
441	test1282	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1282	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
442	test1283	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1283	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
443	test1284	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1284	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
444	test1285	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1285	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
445	test1286	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1286	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
446	test1287	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1287	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
447	test1288	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1288	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
448	test1289	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1289	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
449	test1290	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1290	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
450	test1291	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1291	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
451	test1292	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1292	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
452	test1293	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1293	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
453	test1294	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1294	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
454	test1295	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1295	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
455	test1296	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1296	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
456	test1297	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1297	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
457	test1298	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1298	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
458	test1299	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1299	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
459	test1300	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.459271	2026-01-23 21:18:25.459271	\N	测试用户1300	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
460	test1301	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1301	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
461	test1302	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1302	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
462	test1303	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1303	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
463	test1304	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1304	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
464	test1305	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1305	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
465	test1306	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1306	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
466	test1307	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1307	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
467	test1308	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1308	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
468	test1309	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1309	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
469	test1310	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1310	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
470	test1311	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1311	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
471	test1312	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1312	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
472	test1313	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1313	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
473	test1314	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1314	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
474	test1315	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1315	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
475	test1316	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1316	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
476	test1317	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1317	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
477	test1318	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1318	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
478	test1319	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1319	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
479	test1320	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1320	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
480	test1321	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1321	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
481	test1322	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1322	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
482	test1323	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1323	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
483	test1324	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1324	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
484	test1325	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1325	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
485	test1326	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1326	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
486	test1327	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1327	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
487	test1328	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1328	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
488	test1329	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1329	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
489	test1330	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1330	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
490	test1331	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1331	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
491	test1332	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1332	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
492	test1333	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1333	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
493	test1334	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1334	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
494	test1335	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1335	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
495	test1336	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1336	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
496	test1337	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1337	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
497	test1338	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1338	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
498	test1339	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1339	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
499	test1340	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1340	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
500	test1341	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1341	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
501	test1342	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1342	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
502	test1343	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1343	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
503	test1344	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1344	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
504	test1345	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1345	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
505	test1346	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1346	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
506	test1347	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1347	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
507	test1348	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1348	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
508	test1349	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1349	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
509	test1350	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.462991	2026-01-23 21:18:25.462991	\N	测试用户1350	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
510	test1351	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1351	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
511	test1352	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1352	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
512	test1353	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1353	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
513	test1354	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1354	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
514	test1355	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1355	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
515	test1356	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1356	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
516	test1357	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1357	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
517	test1358	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1358	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
518	test1359	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1359	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
519	test1360	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1360	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
520	test1361	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1361	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
521	test1362	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1362	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
522	test1363	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1363	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
523	test1364	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1364	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
524	test1365	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1365	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
525	test1366	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1366	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
526	test1367	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1367	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
527	test1368	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1368	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
528	test1369	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1369	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
529	test1370	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1370	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
530	test1371	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1371	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
531	test1372	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1372	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
532	test1373	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1373	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
533	test1374	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1374	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
534	test1375	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1375	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
535	test1376	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1376	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
536	test1377	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1377	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
537	test1378	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1378	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
538	test1379	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1379	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
539	test1380	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1380	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
540	test1381	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1381	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
541	test1382	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1382	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
542	test1383	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1383	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
543	test1384	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1384	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
544	test1385	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1385	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
545	test1386	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1386	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
546	test1387	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1387	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
547	test1388	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1388	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
548	test1389	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1389	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
549	test1390	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1390	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
550	test1391	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1391	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
551	test1392	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1392	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
552	test1393	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1393	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
553	test1394	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1394	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
554	test1395	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1395	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
555	test1396	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1396	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
556	test1397	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1397	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
557	test1398	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1398	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
558	test1399	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1399	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
559	test1400	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.468556	2026-01-23 21:18:25.468556	\N	测试用户1400	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
560	test1401	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1401	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
561	test1402	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1402	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
562	test1403	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1403	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
563	test1404	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1404	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
564	test1405	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1405	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
565	test1406	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1406	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
566	test1407	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1407	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
567	test1408	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1408	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
568	test1409	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1409	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
569	test1410	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1410	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
570	test1411	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1411	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
571	test1412	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1412	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
572	test1413	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1413	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
573	test1414	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1414	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
574	test1415	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1415	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
575	test1416	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1416	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
576	test1417	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1417	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
577	test1418	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1418	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
578	test1419	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1419	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
579	test1420	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1420	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
580	test1421	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1421	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
581	test1422	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1422	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
582	test1423	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1423	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
583	test1424	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1424	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
584	test1425	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1425	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
585	test1426	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1426	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
586	test1427	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1427	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
587	test1428	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1428	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
588	test1429	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1429	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
589	test1430	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1430	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
590	test1431	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1431	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
591	test1432	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1432	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
592	test1433	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1433	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
593	test1434	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1434	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
594	test1435	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1435	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
595	test1436	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1436	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
596	test1437	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1437	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
597	test1438	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1438	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
598	test1439	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1439	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
599	test1440	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1440	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
600	test1441	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1441	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
601	test1442	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1442	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
602	test1443	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1443	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
603	test1444	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1444	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
604	test1445	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1445	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
605	test1446	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1446	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
606	test1447	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1447	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
607	test1448	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1448	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
608	test1449	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1449	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
609	test1450	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.471982	2026-01-23 21:18:25.471982	\N	测试用户1450	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
610	test1451	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1451	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
611	test1452	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1452	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
612	test1453	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1453	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
613	test1454	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1454	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
614	test1455	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1455	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
615	test1456	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1456	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
616	test1457	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1457	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
617	test1458	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1458	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
618	test1459	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1459	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
619	test1460	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1460	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
620	test1461	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1461	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
621	test1462	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1462	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
622	test1463	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1463	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
623	test1464	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1464	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
624	test1465	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1465	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
625	test1466	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1466	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
626	test1467	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1467	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
627	test1468	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1468	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
628	test1469	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1469	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
629	test1470	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1470	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
630	test1471	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1471	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
631	test1472	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1472	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
632	test1473	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1473	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
633	test1474	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1474	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
634	test1475	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1475	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
635	test1476	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1476	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
636	test1477	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1477	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
637	test1478	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1478	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
638	test1479	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1479	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
639	test1480	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1480	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
640	test1481	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1481	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
641	test1482	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1482	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
642	test1483	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1483	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
643	test1484	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1484	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
644	test1485	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1485	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
645	test1486	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1486	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
646	test1487	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1487	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
647	test1488	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1488	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
648	test1489	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1489	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
649	test1490	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1490	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
650	test1491	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1491	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
651	test1492	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1492	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
652	test1493	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1493	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
653	test1494	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1494	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
654	test1495	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1495	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
655	test1496	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1496	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
656	test1497	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1497	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
657	test1498	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1498	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
658	test1499	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1499	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
659	test1500	$2a$10$gJmPL4waxAmKoFaB5nNWn.RKa548VCiIapAXFfp0tPFqcEogI1Oqi	\N	\N		2026-01-23 21:18:25.476404	2026-01-23 21:18:25.476404	\N	测试用户1500	\N	\N	offline	\N	\N	\N	\N	\N	\N	\N	\N	\N	\N	1	\N	\N
103	test02	$2a$10$PrenWrXII9B6hC6nqFy9vuOytj6uwOMQr1wmSHG3buVhIKsJ7x8me			https://chat-youdu-2.oss-cn-hongkong.aliyuncs.com/avatars/1764129327_JPEG_20251126_115527_5144140681260080541.jpg	2025-11-24 15:17:23.407595	2026-03-17 00:49:15.172475	\N	测试2	male	\N	offline	\N	\N	yuhhg	hjvv		35YpXs	\N	805667c612b052cdfdbd278e7281afe88e190063db42b5d7d9cb7a20dd82708fd780d3ec4f2e3c1a964a3d55fc877c2a118770d79fcba0a55c6e45b5446ebdb6d3a5d89087e4d64f1abe777bb23a8ce3	2025-12-29 21:52:13.797704	2026-03-16 15:48:40.359673	0	\N	\N
102	test01	$2a$10$y.M5Avb0FHVgydjPs.8jL.rWFpTQpnm71kLBzHn37o8sB..HFtLf.	\N	\N		2025-11-24 15:13:50.435812	2026-06-28 08:47:26.568856	\N	测试01	\N	\N	offline	\N	\N	\N	\N	\N	qUXKnX	\N	b1b0820d8627e0499bd6bd5d092c1e71780a27863b886a8166f278343d60417a	2025-12-29 13:50:51.90804	2026-06-28 00:33:56.314313	0	eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxMDIsInVzZXJuYW1lIjoidGVzdDAxIiwiZXhwIjoxNzgzMjExNjM2LCJuYmYiOjE3ODI2MDY4MzYsImlhdCI6MTc4MjYwNjgzNn0.Bavo12TjGdc2Ep3nu70FVj2kywJPLNPhUhU11sMgy8Q	2026-06-28 00:33:56.309237+08
\.


--
-- Data for Name: verification_codes; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.verification_codes (id, account, code, type, expires_at, created_at) FROM stdin;
\.


--
-- Name: app_versions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.app_versions_id_seq', 4, true);


--
-- Name: device_registrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.device_registrations_id_seq', 331, true);


--
-- Name: favorite_contacts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorite_contacts_id_seq', 3, true);


--
-- Name: favorite_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorite_groups_id_seq', 4, true);


--
-- Name: favorites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.favorites_id_seq', 79, true);


--
-- Name: file_assistant_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.file_assistant_messages_id_seq', 11, true);


--
-- Name: group_members_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.group_members_id_seq', 260, true);


--
-- Name: group_message_reads_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.group_message_reads_id_seq', 2936, true);


--
-- Name: group_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.group_messages_id_seq', 1657, true);


--
-- Name: groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.groups_id_seq', 64, true);


--
-- Name: invite_code_usages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invite_code_usages_id_seq', 1, false);


--
-- Name: invite_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.invite_codes_id_seq', 1, false);


--
-- Name: messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.messages_id_seq', 3645, true);


--
-- Name: private_message_synced_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.private_message_synced_id_seq', 11946, true);


--
-- Name: scheduled_messages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.scheduled_messages_id_seq', 12, true);


--
-- Name: server_settings_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.server_settings_id_seq', 5, true);


--
-- Name: user_relations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.user_relations_id_seq', 238, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 659, true);


--
-- Name: verification_codes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.verification_codes_id_seq', 3, true);


--
-- Name: app_versions app_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_pkey PRIMARY KEY (id);


--
-- Name: app_versions app_versions_version_platform_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.app_versions
    ADD CONSTRAINT app_versions_version_platform_key UNIQUE (version, platform);


--
-- Name: device_registrations device_registrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_registrations
    ADD CONSTRAINT device_registrations_pkey PRIMARY KEY (id);


--
-- Name: device_registrations device_registrations_uuid_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.device_registrations
    ADD CONSTRAINT device_registrations_uuid_key UNIQUE (uuid);


--
-- Name: favorite_contacts favorite_contacts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_contacts
    ADD CONSTRAINT favorite_contacts_pkey PRIMARY KEY (id);


--
-- Name: favorite_contacts favorite_contacts_user_id_contact_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_contacts
    ADD CONSTRAINT favorite_contacts_user_id_contact_id_key UNIQUE (user_id, contact_id);


--
-- Name: favorite_groups favorite_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_groups
    ADD CONSTRAINT favorite_groups_pkey PRIMARY KEY (id);


--
-- Name: favorite_groups favorite_groups_user_id_group_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_groups
    ADD CONSTRAINT favorite_groups_user_id_group_id_key UNIQUE (user_id, group_id);


--
-- Name: favorites favorites_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_pkey PRIMARY KEY (id);


--
-- Name: file_assistant_messages file_assistant_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_assistant_messages
    ADD CONSTRAINT file_assistant_messages_pkey PRIMARY KEY (id);


--
-- Name: group_members group_members_group_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_user_id_key UNIQUE (group_id, user_id);


--
-- Name: group_members group_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_pkey PRIMARY KEY (id);


--
-- Name: group_message_reads group_message_reads_group_message_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_message_reads
    ADD CONSTRAINT group_message_reads_group_message_id_user_id_key UNIQUE (group_message_id, user_id);


--
-- Name: group_message_reads group_message_reads_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_message_reads
    ADD CONSTRAINT group_message_reads_pkey PRIMARY KEY (id);


--
-- Name: group_messages group_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages
    ADD CONSTRAINT group_messages_pkey PRIMARY KEY (id);


--
-- Name: groups groups_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_pkey PRIMARY KEY (id);


--
-- Name: invite_code_usages invite_code_usages_invite_code_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_code_usages
    ADD CONSTRAINT invite_code_usages_invite_code_id_user_id_key UNIQUE (invite_code_id, user_id);


--
-- Name: invite_code_usages invite_code_usages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_code_usages
    ADD CONSTRAINT invite_code_usages_pkey PRIMARY KEY (id);


--
-- Name: invite_codes invite_codes_code_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_codes
    ADD CONSTRAINT invite_codes_code_key UNIQUE (code);


--
-- Name: invite_codes invite_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_codes
    ADD CONSTRAINT invite_codes_pkey PRIMARY KEY (id);


--
-- Name: messages messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: private_message_synced private_message_synced_message_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_message_synced
    ADD CONSTRAINT private_message_synced_message_id_user_id_key UNIQUE (message_id, user_id);


--
-- Name: private_message_synced private_message_synced_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.private_message_synced
    ADD CONSTRAINT private_message_synced_pkey PRIMARY KEY (id);


--
-- Name: scheduled_messages scheduled_messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.scheduled_messages
    ADD CONSTRAINT scheduled_messages_pkey PRIMARY KEY (id);


--
-- Name: server_settings server_settings_key_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_settings
    ADD CONSTRAINT server_settings_key_key UNIQUE (key);


--
-- Name: server_settings server_settings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.server_settings
    ADD CONSTRAINT server_settings_pkey PRIMARY KEY (id);


--
-- Name: user_relations user_relations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_relations
    ADD CONSTRAINT user_relations_pkey PRIMARY KEY (id);


--
-- Name: user_relations user_relations_user_id_friend_id_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_relations
    ADD CONSTRAINT user_relations_user_id_friend_id_key UNIQUE (user_id, friend_id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: verification_codes verification_codes_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.verification_codes
    ADD CONSTRAINT verification_codes_pkey PRIMARY KEY (id);


--
-- Name: idx_app_versions_platform; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_versions_platform ON public.app_versions USING btree (platform);


--
-- Name: idx_app_versions_platform_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_versions_platform_status ON public.app_versions USING btree (platform, status);


--
-- Name: idx_app_versions_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_app_versions_status ON public.app_versions USING btree (status);


--
-- Name: idx_device_installed_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_installed_at ON public.device_registrations USING btree (installed_at);


--
-- Name: idx_device_platform; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_device_platform ON public.device_registrations USING btree (platform);


--
-- Name: idx_device_uuid; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_device_uuid ON public.device_registrations USING btree (uuid);


--
-- Name: idx_favorite_contacts_contact_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_contacts_contact_id ON public.favorite_contacts USING btree (contact_id);


--
-- Name: idx_favorite_contacts_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_contacts_created_at ON public.favorite_contacts USING btree (created_at DESC);


--
-- Name: idx_favorite_contacts_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_contacts_user_id ON public.favorite_contacts USING btree (user_id);


--
-- Name: idx_favorite_groups_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_groups_created_at ON public.favorite_groups USING btree (created_at DESC);


--
-- Name: idx_favorite_groups_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_groups_group_id ON public.favorite_groups USING btree (group_id);


--
-- Name: idx_favorite_groups_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorite_groups_user_id ON public.favorite_groups USING btree (user_id);


--
-- Name: idx_favorites_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorites_created_at ON public.favorites USING btree (created_at DESC);


--
-- Name: idx_favorites_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_favorites_user_id ON public.favorites USING btree (user_id);


--
-- Name: idx_file_assistant_messages_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_file_assistant_messages_created_at ON public.file_assistant_messages USING btree (created_at DESC);


--
-- Name: idx_file_assistant_messages_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_file_assistant_messages_status ON public.file_assistant_messages USING btree (status);


--
-- Name: idx_file_assistant_messages_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_file_assistant_messages_user_id ON public.file_assistant_messages USING btree (user_id);


--
-- Name: idx_group_members_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_members_group_id ON public.group_members USING btree (group_id);


--
-- Name: idx_group_members_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_members_user_id ON public.group_members USING btree (user_id);


--
-- Name: idx_group_message_reads_group_message_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_message_reads_group_message_id ON public.group_message_reads USING btree (group_message_id);


--
-- Name: idx_group_message_reads_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_message_reads_user_id ON public.group_message_reads USING btree (user_id);


--
-- Name: idx_group_messages_call_type; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_call_type ON public.group_messages USING btree (call_type) WHERE (call_type IS NOT NULL);


--
-- Name: idx_group_messages_channel_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_channel_name ON public.group_messages USING btree (channel_name) WHERE (channel_name IS NOT NULL);


--
-- Name: idx_group_messages_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_created_at ON public.group_messages USING btree (created_at);


--
-- Name: idx_group_messages_group_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_group_id ON public.group_messages USING btree (group_id);


--
-- Name: idx_group_messages_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_sender_id ON public.group_messages USING btree (sender_id);


--
-- Name: idx_group_messages_server_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_group_messages_server_id ON public.group_messages USING btree (server_id);


--
-- Name: idx_groups_owner_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_groups_owner_id ON public.groups USING btree (owner_id);


--
-- Name: idx_invite_code_usages_invite_code_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invite_code_usages_invite_code_id ON public.invite_code_usages USING btree (invite_code_id);


--
-- Name: idx_invite_code_usages_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_invite_code_usages_user_id ON public.invite_code_usages USING btree (user_id);


--
-- Name: idx_messages_created_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_created_at ON public.messages USING btree (created_at DESC);


--
-- Name: idx_messages_is_read; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_is_read ON public.messages USING btree (is_read) WHERE (is_read = false);


--
-- Name: idx_messages_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_receiver_id ON public.messages USING btree (receiver_id);


--
-- Name: idx_messages_receiver_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_receiver_name ON public.messages USING btree (receiver_name);


--
-- Name: idx_messages_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_sender_id ON public.messages USING btree (sender_id);


--
-- Name: idx_messages_sender_name; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_sender_name ON public.messages USING btree (sender_name);


--
-- Name: idx_messages_sender_receiver; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_sender_receiver ON public.messages USING btree (sender_id, receiver_id, created_at DESC);


--
-- Name: idx_messages_server_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_server_id ON public.messages USING btree (server_id);


--
-- Name: idx_messages_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_messages_status ON public.messages USING btree (status);


--
-- Name: idx_scheduled_messages_receiver_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_receiver_id ON public.scheduled_messages USING btree (receiver_id);


--
-- Name: idx_scheduled_messages_send_date; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_send_date ON public.scheduled_messages USING btree (send_date);


--
-- Name: idx_scheduled_messages_send_time; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_send_time ON public.scheduled_messages USING btree (send_time);


--
-- Name: idx_scheduled_messages_sender_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_sender_id ON public.scheduled_messages USING btree (sender_id);


--
-- Name: idx_scheduled_messages_sender_receiver; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_sender_receiver ON public.scheduled_messages USING btree (sender_id, receiver_id, message_type);


--
-- Name: idx_scheduled_messages_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_scheduled_messages_status ON public.scheduled_messages USING btree (status);


--
-- Name: idx_user_relations_approval_status; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_relations_approval_status ON public.user_relations USING btree (approval_status);


--
-- Name: idx_user_relations_friend_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_relations_friend_id ON public.user_relations USING btree (friend_id);


--
-- Name: idx_user_relations_is_blocked; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_relations_is_blocked ON public.user_relations USING btree (is_blocked) WHERE (is_blocked = true);


--
-- Name: idx_user_relations_is_deleted; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_relations_is_deleted ON public.user_relations USING btree (is_deleted) WHERE (is_deleted = true);


--
-- Name: idx_user_relations_user_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_user_relations_user_id ON public.user_relations USING btree (user_id);


--
-- Name: idx_users_active_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_active_token ON public.users USING btree (active_token);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_email ON public.users USING btree (email) WHERE (email IS NOT NULL);


--
-- Name: idx_users_invite_code; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX idx_users_invite_code ON public.users USING btree (invite_code) WHERE (invite_code IS NOT NULL);


--
-- Name: idx_users_invited_by_code; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_invited_by_code ON public.users USING btree (invited_by_code) WHERE (invited_by_code IS NOT NULL);


--
-- Name: idx_users_phone; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_phone ON public.users USING btree (phone) WHERE (phone IS NOT NULL);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: idx_users_voip_token; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_users_voip_token ON public.users USING btree (voip_token) WHERE (voip_token IS NOT NULL);


--
-- Name: idx_verification_codes_account; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_codes_account ON public.verification_codes USING btree (account);


--
-- Name: idx_verification_codes_expires_at; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX idx_verification_codes_expires_at ON public.verification_codes USING btree (expires_at);


--
-- Name: server_settings update_server_settings_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_server_settings_updated_at BEFORE UPDATE ON public.server_settings FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: users update_users_updated_at; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at_column();


--
-- Name: favorite_contacts favorite_contacts_contact_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_contacts
    ADD CONSTRAINT favorite_contacts_contact_id_fkey FOREIGN KEY (contact_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: favorite_contacts favorite_contacts_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_contacts
    ADD CONSTRAINT favorite_contacts_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: favorite_groups favorite_groups_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_groups
    ADD CONSTRAINT favorite_groups_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: favorite_groups favorite_groups_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorite_groups
    ADD CONSTRAINT favorite_groups_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: favorites favorites_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_message_id_fkey FOREIGN KEY (message_id) REFERENCES public.messages(id) ON DELETE CASCADE;


--
-- Name: favorites favorites_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: favorites favorites_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.favorites
    ADD CONSTRAINT favorites_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: file_assistant_messages file_assistant_messages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.file_assistant_messages
    ADD CONSTRAINT file_assistant_messages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: group_members group_members_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: group_members group_members_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_members
    ADD CONSTRAINT group_members_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: group_message_reads group_message_reads_group_message_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_message_reads
    ADD CONSTRAINT group_message_reads_group_message_id_fkey FOREIGN KEY (group_message_id) REFERENCES public.group_messages(id) ON DELETE CASCADE;


--
-- Name: group_message_reads group_message_reads_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_message_reads
    ADD CONSTRAINT group_message_reads_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: group_messages group_messages_group_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages
    ADD CONSTRAINT group_messages_group_id_fkey FOREIGN KEY (group_id) REFERENCES public.groups(id) ON DELETE CASCADE;


--
-- Name: group_messages group_messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.group_messages
    ADD CONSTRAINT group_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id);


--
-- Name: groups groups_owner_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.groups
    ADD CONSTRAINT groups_owner_id_fkey FOREIGN KEY (owner_id) REFERENCES public.users(id);


--
-- Name: invite_code_usages invite_code_usages_invite_code_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_code_usages
    ADD CONSTRAINT invite_code_usages_invite_code_id_fkey FOREIGN KEY (invite_code_id) REFERENCES public.invite_codes(id) ON DELETE CASCADE;


--
-- Name: invite_code_usages invite_code_usages_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_code_usages
    ADD CONSTRAINT invite_code_usages_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: invite_codes invite_codes_used_by_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.invite_codes
    ADD CONSTRAINT invite_codes_used_by_user_id_fkey FOREIGN KEY (used_by_user_id) REFERENCES public.users(id);


--
-- Name: messages messages_receiver_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: messages messages_sender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.messages
    ADD CONSTRAINT messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_relations user_relations_friend_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_relations
    ADD CONSTRAINT user_relations_friend_id_fkey FOREIGN KEY (friend_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: user_relations user_relations_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.user_relations
    ADD CONSTRAINT user_relations_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

