begin;
SET statement_timeout = 0;
--SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
--SET row_security = off;

--CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;

--COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';

--SET search_path = public, pg_catalog;

SET default_with_oids = false;


CREATE TABLE alternative_medium (
    id integer NOT NULL,
    medium integer NOT NULL,
    alternative_release integer NOT NULL,
    name character varying,
    CONSTRAINT alternative_medium_name_check CHECK (((name)::text <> ''::text))
);

CREATE SEQUENCE alternative_medium_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE alternative_medium_id_seq OWNED BY alternative_medium.id;

CREATE TABLE alternative_medium_track (
    alternative_medium integer NOT NULL,
    track integer NOT NULL,
    alternative_track integer NOT NULL
);

CREATE TABLE alternative_release (
    id integer NOT NULL,
    gid uuid NOT NULL,
    release integer NOT NULL,
    name character varying,
    artist_credit integer,
    type integer NOT NULL,
    language integer NOT NULL,
    script integer NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT alternative_release_name_check CHECK (((name)::text <> ''::text))
);

CREATE SEQUENCE alternative_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE alternative_release_id_seq OWNED BY alternative_release.id;

CREATE TABLE alternative_release_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE alternative_release_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE alternative_release_type_id_seq OWNED BY alternative_release_type.id;

CREATE TABLE alternative_track (
    id integer NOT NULL,
    name character varying,
    artist_credit integer,
    ref_count integer DEFAULT 0 NOT NULL,
    CONSTRAINT alternative_track_check CHECK ((((name)::text <> ''::text) AND ((name IS NOT NULL) OR (artist_credit IS NOT NULL))))
);

CREATE SEQUENCE alternative_track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE alternative_track_id_seq OWNED BY alternative_track.id;

CREATE TABLE annotation (
    id integer NOT NULL,
    editor integer NOT NULL,
    text text,
    changelog character varying(255),
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE annotation_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE annotation_id_seq OWNED BY annotation.id;

CREATE TABLE application (
    id integer NOT NULL,
    owner integer NOT NULL,
    name text NOT NULL,
    oauth_id text NOT NULL,
    oauth_secret text NOT NULL,
    oauth_redirect_uri text
);

CREATE SEQUENCE application_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE application_id_seq OWNED BY application.id;

CREATE TABLE area (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    ended boolean DEFAULT false NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    CONSTRAINT area_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT area_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE area_alias (
    id integer NOT NULL,
    area integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT area_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT area_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL)))
);

CREATE SEQUENCE area_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE area_alias_id_seq OWNED BY area_alias.id;

CREATE TABLE area_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE area_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE area_alias_type_id_seq OWNED BY area_alias_type.id;

CREATE TABLE area_annotation (
    area integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE area_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE area_id_seq OWNED BY area.id;

CREATE TABLE area_tag (
    area integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE area_tag_raw (
    area integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE area_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE area_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE area_type_id_seq OWNED BY area_type.id;

CREATE TABLE artist (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    type integer,
    area integer,
    gender integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    begin_area integer,
    end_area integer,
    CONSTRAINT artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);

CREATE TABLE artist_alias (
    id integer NOT NULL,
    artist integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT artist_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT artist_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 3) OR ((type = 3) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);

CREATE SEQUENCE artist_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE artist_alias_id_seq OWNED BY artist_alias.id;

CREATE TABLE artist_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE artist_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE artist_alias_type_id_seq OWNED BY artist_alias_type.id;

CREATE TABLE artist_annotation (
    artist integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE artist_credit (
    id integer NOT NULL,
    name character varying NOT NULL,
    artist_count smallint NOT NULL,
    ref_count integer DEFAULT 0,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE artist_credit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE artist_credit_id_seq OWNED BY artist_credit.id;

CREATE TABLE artist_credit_name (
    artist_credit integer NOT NULL,
    "position" smallint NOT NULL,
    artist integer NOT NULL,
    name character varying NOT NULL,
    join_phrase text DEFAULT ''::text NOT NULL
);

CREATE TABLE artist_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE artist_id_seq OWNED BY artist.id;

CREATE TABLE artist_ipi (
    artist integer NOT NULL,
    ipi character(11) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT artist_ipi_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_ipi_ipi_check CHECK ((ipi ~ '^\d{11}$'::text))
);

CREATE TABLE artist_isni (
    artist integer NOT NULL,
    isni character(16) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT artist_isni_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT artist_isni_isni_check CHECK ((isni ~ '^\d{15}[\dX]$'::text))
);

CREATE TABLE artist_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT artist_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE artist_rating_raw (
    artist integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT artist_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE artist_tag (
    artist integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE artist_tag_raw (
    artist integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE artist_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE artist_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE artist_type_id_seq OWNED BY artist_type.id;

CREATE TABLE autoeditor_election (
    id integer NOT NULL,
    candidate integer NOT NULL,
    proposer integer NOT NULL,
    seconder_1 integer,
    seconder_2 integer,
    status integer DEFAULT 1 NOT NULL,
    yes_votes integer DEFAULT 0 NOT NULL,
    no_votes integer DEFAULT 0 NOT NULL,
    propose_time timestamp with time zone DEFAULT now() NOT NULL,
    open_time timestamp with time zone,
    close_time timestamp with time zone,
    CONSTRAINT autoeditor_election_status_check CHECK ((status = ANY (ARRAY[1, 2, 3, 4, 5, 6])))
);

CREATE SEQUENCE autoeditor_election_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE autoeditor_election_id_seq OWNED BY autoeditor_election.id;

CREATE TABLE autoeditor_election_vote (
    id integer NOT NULL,
    autoeditor_election integer NOT NULL,
    voter integer NOT NULL,
    vote integer NOT NULL,
    vote_time timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT autoeditor_election_vote_vote_check CHECK ((vote = ANY (ARRAY['-1'::integer, 0, 1])))
);

CREATE SEQUENCE autoeditor_election_vote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE autoeditor_election_vote_id_seq OWNED BY autoeditor_election_vote.id;

CREATE TABLE cdtoc (
    id integer NOT NULL,
    discid character(28) NOT NULL,
    freedb_id character(8) NOT NULL,
    track_count integer NOT NULL,
    leadout_offset integer NOT NULL,
    track_offset integer[] NOT NULL,
    degraded boolean DEFAULT false NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE cdtoc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE cdtoc_id_seq OWNED BY cdtoc.id;

CREATE TABLE cdtoc_raw (
    id integer NOT NULL,
    release integer NOT NULL,
    discid character(28) NOT NULL,
    track_count integer NOT NULL,
    leadout_offset integer NOT NULL,
    track_offset integer[] NOT NULL
);

CREATE SEQUENCE cdtoc_raw_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE cdtoc_raw_id_seq OWNED BY cdtoc_raw.id;

CREATE TABLE country_area (
    area integer NOT NULL
);

CREATE TABLE deleted_entity (
    gid uuid NOT NULL,
    deleted_at timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE edit (
    id integer NOT NULL,
    editor integer NOT NULL,
    type smallint NOT NULL,
    status smallint NOT NULL,
    autoedit smallint DEFAULT 0 NOT NULL,
    open_time timestamp with time zone DEFAULT now(),
    close_time timestamp with time zone,
    expire_time timestamp with time zone NOT NULL,
    language integer,
    quality smallint DEFAULT 1 NOT NULL
);

CREATE TABLE edit_area (
    edit integer NOT NULL,
    area integer NOT NULL
);

CREATE TABLE edit_artist (
    edit integer NOT NULL,
    artist integer NOT NULL,
    status smallint NOT NULL
);

CREATE TABLE edit_data (
    edit integer NOT NULL
);

CREATE TABLE edit_event (
    edit integer NOT NULL,
    event integer NOT NULL
);

CREATE SEQUENCE edit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE edit_id_seq OWNED BY edit.id;

CREATE TABLE edit_instrument (
    edit integer NOT NULL,
    instrument integer NOT NULL
);

CREATE TABLE edit_label (
    edit integer NOT NULL,
    label integer NOT NULL,
    status smallint NOT NULL
);

CREATE TABLE edit_note (
    id integer NOT NULL,
    editor integer NOT NULL,
    edit integer NOT NULL,
    text text NOT NULL,
    post_time timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE edit_note_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE edit_note_id_seq OWNED BY edit_note.id;

CREATE TABLE edit_note_recipient (
    recipient integer NOT NULL,
    edit_note integer NOT NULL
);

CREATE TABLE edit_place (
    edit integer NOT NULL,
    place integer NOT NULL
);

CREATE TABLE edit_recording (
    edit integer NOT NULL,
    recording integer NOT NULL
);

CREATE TABLE edit_release (
    edit integer NOT NULL,
    release integer NOT NULL
);

CREATE TABLE edit_release_group (
    edit integer NOT NULL,
    release_group integer NOT NULL
);

CREATE TABLE edit_series (
    edit integer NOT NULL,
    series integer NOT NULL
);

CREATE TABLE edit_url (
    edit integer NOT NULL,
    url integer NOT NULL
);

CREATE TABLE edit_work (
    edit integer NOT NULL,
    work integer NOT NULL
);

CREATE TABLE editor (
    id integer NOT NULL,
    name character varying(64) NOT NULL,
    privs integer DEFAULT 0,
    email character varying(64) DEFAULT NULL::character varying,
    website character varying(255) DEFAULT NULL::character varying,
    bio text,
    member_since timestamp with time zone DEFAULT now(),
    email_confirm_date timestamp with time zone,
    last_login_date timestamp with time zone DEFAULT now(),
    last_updated timestamp with time zone DEFAULT now(),
    birth_date date,
    gender integer,
    area integer,
    password character varying(128) NOT NULL,
    ha1 character(32) NOT NULL,
    deleted boolean DEFAULT false NOT NULL
);

CREATE TABLE editor_collection (
    id integer NOT NULL,
    gid uuid NOT NULL,
    editor integer NOT NULL,
    name character varying NOT NULL,
    public boolean DEFAULT false NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    type integer NOT NULL
);

CREATE TABLE editor_collection_area (
    collection integer NOT NULL,
    area integer NOT NULL
);

CREATE TABLE editor_collection_artist (
    collection integer NOT NULL,
    artist integer NOT NULL
);

CREATE TABLE editor_collection_deleted_entity (
    collection integer NOT NULL,
    gid uuid NOT NULL
);

CREATE TABLE editor_collection_event (
    collection integer NOT NULL,
    event integer NOT NULL
);

CREATE SEQUENCE editor_collection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_collection_id_seq OWNED BY editor_collection.id;

CREATE TABLE editor_collection_instrument (
    collection integer NOT NULL,
    instrument integer NOT NULL
);

CREATE TABLE editor_collection_label (
    collection integer NOT NULL,
    label integer NOT NULL
);

CREATE TABLE editor_collection_place (
    collection integer NOT NULL,
    place integer NOT NULL
);

CREATE TABLE editor_collection_recording (
    collection integer NOT NULL,
    recording integer NOT NULL
);

CREATE TABLE editor_collection_release (
    collection integer NOT NULL,
    release integer NOT NULL
);

CREATE TABLE editor_collection_release_group (
    collection integer NOT NULL,
    release_group integer NOT NULL
);

CREATE TABLE editor_collection_series (
    collection integer NOT NULL,
    series integer NOT NULL
);

CREATE TABLE editor_collection_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    entity_type character varying(50) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE editor_collection_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_collection_type_id_seq OWNED BY editor_collection_type.id;

CREATE TABLE editor_collection_work (
    collection integer NOT NULL,
    work integer NOT NULL
);

CREATE SEQUENCE editor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_id_seq OWNED BY editor.id;

CREATE TYPE fluency AS ENUM (
    'basic',
    'intermediate',
    'advanced',
    'native'
);

CREATE TABLE editor_language (
    editor integer NOT NULL,
    language integer NOT NULL,
    fluency fluency NOT NULL
);

CREATE TABLE editor_oauth_token (
    id integer NOT NULL,
    editor integer NOT NULL,
    application integer NOT NULL,
    authorization_code text,
    refresh_token text,
    access_token text,
    expire_time timestamp with time zone NOT NULL,
    scope integer DEFAULT 0 NOT NULL,
    granted timestamp with time zone DEFAULT now() NOT NULL
);

CREATE SEQUENCE editor_oauth_token_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_oauth_token_id_seq OWNED BY editor_oauth_token.id;

CREATE TABLE editor_preference (
    id integer NOT NULL,
    editor integer NOT NULL,
    name character varying(50) NOT NULL,
    value character varying(100) NOT NULL
);

CREATE SEQUENCE editor_preference_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_preference_id_seq OWNED BY editor_preference.id;

CREATE TABLE editor_subscribe_artist (
    id integer NOT NULL,
    editor integer NOT NULL,
    artist integer NOT NULL,
    last_edit_sent integer NOT NULL
);

CREATE TABLE editor_subscribe_artist_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);

CREATE SEQUENCE editor_subscribe_artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_subscribe_artist_id_seq OWNED BY editor_subscribe_artist.id;

CREATE TABLE editor_subscribe_collection (
    id integer NOT NULL,
    editor integer NOT NULL,
    collection integer NOT NULL,
    last_edit_sent integer NOT NULL,
    available boolean DEFAULT true NOT NULL,
    last_seen_name character varying(255)
);

CREATE SEQUENCE editor_subscribe_collection_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_subscribe_collection_id_seq OWNED BY editor_subscribe_collection.id;

CREATE TABLE editor_subscribe_editor (
    id integer NOT NULL,
    editor integer NOT NULL,
    subscribed_editor integer NOT NULL,
    last_edit_sent integer NOT NULL
);

CREATE SEQUENCE editor_subscribe_editor_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_subscribe_editor_id_seq OWNED BY editor_subscribe_editor.id;

CREATE TABLE editor_subscribe_label (
    id integer NOT NULL,
    editor integer NOT NULL,
    label integer NOT NULL,
    last_edit_sent integer NOT NULL
);

CREATE TABLE editor_subscribe_label_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);

CREATE SEQUENCE editor_subscribe_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_subscribe_label_id_seq OWNED BY editor_subscribe_label.id;

CREATE TABLE editor_subscribe_series (
    id integer NOT NULL,
    editor integer NOT NULL,
    series integer NOT NULL,
    last_edit_sent integer NOT NULL
);

CREATE TABLE editor_subscribe_series_deleted (
    editor integer NOT NULL,
    gid uuid NOT NULL,
    deleted_by integer NOT NULL
);

CREATE SEQUENCE editor_subscribe_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE editor_subscribe_series_id_seq OWNED BY editor_subscribe_series.id;

CREATE TABLE editor_watch_artist (
    artist integer NOT NULL,
    editor integer NOT NULL
);

CREATE TABLE editor_watch_preferences (
    editor integer NOT NULL,
    notify_via_email boolean DEFAULT true NOT NULL,
    notification_timeframe interval DEFAULT '7 days'::interval NOT NULL,
    last_checked timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE editor_watch_release_group_type (
    editor integer NOT NULL,
    release_group_type integer NOT NULL
);

CREATE TABLE editor_watch_release_status (
    editor integer NOT NULL,
    release_status integer NOT NULL
);

CREATE TABLE event (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    "time" time without time zone,
    type integer,
    cancelled boolean DEFAULT false NOT NULL,
    setlist text,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT event_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);

CREATE TABLE event_alias (
    id integer NOT NULL,
    event integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT event_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT event_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);

CREATE SEQUENCE event_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE event_alias_id_seq OWNED BY event_alias.id;

CREATE TABLE event_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE event_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE event_alias_type_id_seq OWNED BY event_alias_type.id;

CREATE TABLE event_annotation (
    event integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE event_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE event_id_seq OWNED BY event.id;

CREATE TABLE event_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT event_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE event_rating_raw (
    event integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT event_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE event_tag (
    event integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE event_tag_raw (
    event integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE event_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE event_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE event_type_id_seq OWNED BY event_type.id;

CREATE TABLE gender (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE gender_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE gender_id_seq OWNED BY gender.id;

CREATE TABLE instrument (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    CONSTRAINT instrument_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE instrument_alias (
    id integer NOT NULL,
    instrument integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT instrument_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT instrument_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);

CREATE SEQUENCE instrument_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE instrument_alias_id_seq OWNED BY instrument_alias.id;

CREATE TABLE instrument_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE instrument_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE instrument_alias_type_id_seq OWNED BY instrument_alias_type.id;

CREATE TABLE instrument_annotation (
    instrument integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE instrument_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE instrument_id_seq OWNED BY instrument.id;

CREATE TABLE instrument_tag (
    instrument integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE instrument_tag_raw (
    instrument integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE instrument_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE instrument_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE instrument_type_id_seq OWNED BY instrument_type.id;

CREATE TABLE iso_3166_1 (
    area integer NOT NULL,
    code character(2) NOT NULL
);

CREATE TABLE iso_3166_2 (
    area integer NOT NULL,
    code character varying(10) NOT NULL
);

CREATE TABLE iso_3166_3 (
    area integer NOT NULL,
    code character(4) NOT NULL
);

CREATE TABLE isrc (
    id integer NOT NULL,
    recording integer NOT NULL,
    isrc character(12) NOT NULL,
    source smallint,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT isrc_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT isrc_isrc_check CHECK ((isrc ~ '^[A-Z]{2}[A-Z0-9]{3}[0-9]{7}$'::text))
);

CREATE SEQUENCE isrc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE isrc_id_seq OWNED BY isrc.id;

CREATE TABLE iswc (
    id integer NOT NULL,
    work integer NOT NULL,
    iswc character(15),
    source smallint,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL,
    CONSTRAINT iswc_iswc_check CHECK ((iswc ~ '^T-?\d{3}.?\d{3}.?\d{3}[-.]?\d$'::text))
);

CREATE SEQUENCE iswc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE iswc_id_seq OWNED BY iswc.id;

CREATE TABLE l_area_area (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_area_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_area_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_area_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_area_id_seq OWNED BY l_area_area.id;

CREATE TABLE l_area_artist (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_artist_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_artist_id_seq OWNED BY l_area_artist.id;

CREATE TABLE l_area_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_event_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_event_id_seq OWNED BY l_area_event.id;

CREATE TABLE l_area_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_instrument_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_instrument_id_seq OWNED BY l_area_instrument.id;

CREATE TABLE l_area_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_label_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_label_id_seq OWNED BY l_area_label.id;

CREATE TABLE l_area_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_place_id_seq OWNED BY l_area_place.id;

CREATE TABLE l_area_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_recording_id_seq OWNED BY l_area_recording.id;

CREATE TABLE l_area_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_area_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_release_group_id_seq OWNED BY l_area_release_group.id;

CREATE SEQUENCE l_area_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_release_id_seq OWNED BY l_area_release.id;

CREATE TABLE l_area_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_series_id_seq OWNED BY l_area_series.id;

CREATE TABLE l_area_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_url_id_seq OWNED BY l_area_url.id;

CREATE TABLE l_area_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_area_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_area_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_area_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_area_work_id_seq OWNED BY l_area_work.id;

CREATE TABLE l_artist_artist (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_artist_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_artist_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_artist_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_artist_id_seq OWNED BY l_artist_artist.id;

CREATE TABLE l_artist_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_event_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_event_id_seq OWNED BY l_artist_event.id;

CREATE TABLE l_artist_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_instrument_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_instrument_id_seq OWNED BY l_artist_instrument.id;

CREATE TABLE l_artist_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_label_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_label_id_seq OWNED BY l_artist_label.id;

CREATE TABLE l_artist_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_place_id_seq OWNED BY l_artist_place.id;

CREATE TABLE l_artist_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_recording_id_seq OWNED BY l_artist_recording.id;

CREATE TABLE l_artist_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_artist_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_release_group_id_seq OWNED BY l_artist_release_group.id;

CREATE SEQUENCE l_artist_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_release_id_seq OWNED BY l_artist_release.id;

CREATE TABLE l_artist_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_series_id_seq OWNED BY l_artist_series.id;

CREATE TABLE l_artist_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_url_id_seq OWNED BY l_artist_url.id;

CREATE TABLE l_artist_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_artist_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_artist_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_artist_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_artist_work_id_seq OWNED BY l_artist_work.id;

CREATE TABLE l_event_event (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_event_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_event_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_event_id_seq OWNED BY l_event_event.id;

CREATE TABLE l_event_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_instrument_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_instrument_id_seq OWNED BY l_event_instrument.id;

CREATE TABLE l_event_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_label_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_label_id_seq OWNED BY l_event_label.id;

CREATE TABLE l_event_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_place_id_seq OWNED BY l_event_place.id;

CREATE TABLE l_event_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_recording_id_seq OWNED BY l_event_recording.id;

CREATE TABLE l_event_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_event_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_release_group_id_seq OWNED BY l_event_release_group.id;

CREATE SEQUENCE l_event_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_release_id_seq OWNED BY l_event_release.id;

CREATE TABLE l_event_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_series_id_seq OWNED BY l_event_series.id;

CREATE TABLE l_event_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_url_id_seq OWNED BY l_event_url.id;

CREATE TABLE l_event_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_event_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_event_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_event_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_event_work_id_seq OWNED BY l_event_work.id;

CREATE TABLE l_instrument_instrument (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_instrument_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_instrument_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_instrument_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_instrument_id_seq OWNED BY l_instrument_instrument.id;

CREATE TABLE l_instrument_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_label_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_label_id_seq OWNED BY l_instrument_label.id;

CREATE TABLE l_instrument_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_place_id_seq OWNED BY l_instrument_place.id;

CREATE TABLE l_instrument_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_recording_id_seq OWNED BY l_instrument_recording.id;

CREATE TABLE l_instrument_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_instrument_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_release_group_id_seq OWNED BY l_instrument_release_group.id;

CREATE SEQUENCE l_instrument_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_release_id_seq OWNED BY l_instrument_release.id;

CREATE TABLE l_instrument_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_series_id_seq OWNED BY l_instrument_series.id;

CREATE TABLE l_instrument_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_url_id_seq OWNED BY l_instrument_url.id;

CREATE TABLE l_instrument_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_instrument_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_instrument_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_instrument_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_instrument_work_id_seq OWNED BY l_instrument_work.id;

CREATE TABLE l_label_label (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_label_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_label_id_seq OWNED BY l_label_label.id;

CREATE TABLE l_label_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_place_id_seq OWNED BY l_label_place.id;

CREATE TABLE l_label_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_recording_id_seq OWNED BY l_label_recording.id;

CREATE TABLE l_label_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_label_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_release_group_id_seq OWNED BY l_label_release_group.id;

CREATE SEQUENCE l_label_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_release_id_seq OWNED BY l_label_release.id;

CREATE TABLE l_label_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_series_id_seq OWNED BY l_label_series.id;

CREATE TABLE l_label_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_url_id_seq OWNED BY l_label_url.id;

CREATE TABLE l_label_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_label_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_label_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_label_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_label_work_id_seq OWNED BY l_label_work.id;

CREATE TABLE l_place_place (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_place_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_place_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_place_id_seq OWNED BY l_place_place.id;

CREATE TABLE l_place_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_recording_id_seq OWNED BY l_place_recording.id;

CREATE TABLE l_place_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_place_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_release_group_id_seq OWNED BY l_place_release_group.id;

CREATE SEQUENCE l_place_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_release_id_seq OWNED BY l_place_release.id;

CREATE TABLE l_place_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_series_id_seq OWNED BY l_place_series.id;

CREATE TABLE l_place_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_url_id_seq OWNED BY l_place_url.id;

CREATE TABLE l_place_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_place_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_place_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_place_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_place_work_id_seq OWNED BY l_place_work.id;

CREATE TABLE l_recording_recording (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_recording_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_recording_recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_recording_id_seq OWNED BY l_recording_recording.id;

CREATE TABLE l_recording_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_recording_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_recording_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_release_group_id_seq OWNED BY l_recording_release_group.id;

CREATE SEQUENCE l_recording_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_release_id_seq OWNED BY l_recording_release.id;

CREATE TABLE l_recording_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_recording_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_series_id_seq OWNED BY l_recording_series.id;

CREATE TABLE l_recording_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_recording_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_url_id_seq OWNED BY l_recording_url.id;

CREATE TABLE l_recording_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_recording_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_recording_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_recording_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_recording_work_id_seq OWNED BY l_recording_work.id;

CREATE TABLE l_release_group_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_group_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_group_release_group_id_seq OWNED BY l_release_group_release_group.id;

CREATE TABLE l_release_group_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_group_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_group_series_id_seq OWNED BY l_release_group_series.id;

CREATE TABLE l_release_group_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_group_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_group_url_id_seq OWNED BY l_release_group_url.id;

CREATE TABLE l_release_group_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_group_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_group_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_group_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_group_work_id_seq OWNED BY l_release_group_work.id;

CREATE TABLE l_release_release (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_release_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_release_link_order_check CHECK ((link_order >= 0))
);

CREATE TABLE l_release_release_group (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_release_group_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_release_group_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_release_group_id_seq OWNED BY l_release_release_group.id;

CREATE SEQUENCE l_release_release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_release_id_seq OWNED BY l_release_release.id;

CREATE TABLE l_release_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_series_id_seq OWNED BY l_release_series.id;

CREATE TABLE l_release_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_url_id_seq OWNED BY l_release_url.id;

CREATE TABLE l_release_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_release_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_release_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_release_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_release_work_id_seq OWNED BY l_release_work.id;

CREATE TABLE l_series_series (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_series_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_series_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_series_series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_series_series_id_seq OWNED BY l_series_series.id;

CREATE TABLE l_series_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_series_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_series_url_id_seq OWNED BY l_series_url.id;

CREATE TABLE l_series_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_series_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_series_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_series_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_series_work_id_seq OWNED BY l_series_work.id;

CREATE TABLE l_url_url (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_url_url_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_url_url_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_url_url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_url_url_id_seq OWNED BY l_url_url.id;

CREATE TABLE l_url_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_url_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_url_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_url_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_url_work_id_seq OWNED BY l_url_work.id;

CREATE TABLE l_work_work (
    id integer NOT NULL,
    link integer NOT NULL,
    entity0 integer NOT NULL,
    entity1 integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    link_order integer DEFAULT 0 NOT NULL,
    entity0_credit text DEFAULT ''::text NOT NULL,
    entity1_credit text DEFAULT ''::text NOT NULL,
    CONSTRAINT l_work_work_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT l_work_work_link_order_check CHECK ((link_order >= 0))
);

CREATE SEQUENCE l_work_work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE l_work_work_id_seq OWNED BY l_work_work.id;

CREATE TABLE label (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    label_code integer,
    type integer,
    area integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT label_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT label_label_code_check CHECK (((label_code > 0) AND (label_code < 100000)))
);

CREATE TABLE label_alias (
    id integer NOT NULL,
    label integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT label_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT label_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);

CREATE SEQUENCE label_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE label_alias_id_seq OWNED BY label_alias.id;

CREATE TABLE label_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE label_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE label_alias_type_id_seq OWNED BY label_alias_type.id;

CREATE TABLE label_annotation (
    label integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE label_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE label_id_seq OWNED BY label.id;

CREATE TABLE label_ipi (
    label integer NOT NULL,
    ipi character(11) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT label_ipi_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_ipi_ipi_check CHECK ((ipi ~ '^\d{11}$'::text))
);

CREATE TABLE label_isni (
    label integer NOT NULL,
    isni character(16) NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    CONSTRAINT label_isni_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT label_isni_isni_check CHECK ((isni ~ '^\d{15}[\dX]$'::text))
);

CREATE TABLE label_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT label_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE label_rating_raw (
    label integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT label_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE label_tag (
    label integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE label_tag_raw (
    label integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE label_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE label_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE label_type_id_seq OWNED BY label_type.id;

CREATE TABLE language (
    id integer NOT NULL,
    iso_code_2t character(3),
    iso_code_2b character(3),
    iso_code_1 character(2),
    name character varying(100) NOT NULL,
    frequency integer DEFAULT 0 NOT NULL,
    iso_code_3 character(3),
    CONSTRAINT iso_code_check CHECK (((iso_code_2t IS NOT NULL) OR (iso_code_3 IS NOT NULL)))
);

CREATE SEQUENCE language_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE language_id_seq OWNED BY language.id;

CREATE TABLE link (
    id integer NOT NULL,
    link_type integer NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    attribute_count integer DEFAULT 0 NOT NULL,
    created timestamp with time zone DEFAULT now(),
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT link_ended_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL))))
);

CREATE TABLE link_attribute (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE TABLE link_attribute_credit (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    credited_as text NOT NULL
);

CREATE TABLE link_attribute_text_value (
    link integer NOT NULL,
    attribute_type integer NOT NULL,
    text_value text NOT NULL
);

CREATE TABLE link_attribute_type (
    id integer NOT NULL,
    parent integer,
    root integer NOT NULL,
    child_order integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE link_attribute_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE link_attribute_type_id_seq OWNED BY link_attribute_type.id;

CREATE TABLE link_creditable_attribute_type (
    attribute_type integer NOT NULL
);

CREATE SEQUENCE link_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE link_id_seq OWNED BY link.id;

CREATE TABLE link_text_attribute_type (
    attribute_type integer NOT NULL
);

CREATE TABLE link_type (
    id integer NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    gid uuid NOT NULL,
    entity_type0 character varying(50) NOT NULL,
    entity_type1 character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    link_phrase character varying(255) NOT NULL,
    reverse_link_phrase character varying(255) NOT NULL,
    long_link_phrase character varying(255) NOT NULL,
    priority integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    is_deprecated boolean DEFAULT false NOT NULL,
    has_dates boolean DEFAULT true NOT NULL,
    entity0_cardinality integer DEFAULT 0 NOT NULL,
    entity1_cardinality integer DEFAULT 0 NOT NULL
);

CREATE TABLE link_type_attribute_type (
    link_type integer NOT NULL,
    attribute_type integer NOT NULL,
    min smallint,
    max smallint,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE link_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE link_type_id_seq OWNED BY link_type.id;

CREATE TABLE medium (
    id integer NOT NULL,
    release integer NOT NULL,
    "position" integer NOT NULL,
    format integer,
    name character varying DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    track_count integer DEFAULT 0 NOT NULL,
    CONSTRAINT medium_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE medium_cdtoc (
    id integer NOT NULL,
    medium integer NOT NULL,
    cdtoc integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT medium_cdtoc_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE medium_cdtoc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE medium_cdtoc_id_seq OWNED BY medium_cdtoc.id;

CREATE TABLE medium_format (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    year smallint,
    has_discids boolean DEFAULT false NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE medium_format_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE medium_format_id_seq OWNED BY medium_format.id;

CREATE SEQUENCE medium_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE medium_id_seq OWNED BY medium.id;

CREATE TABLE medium_index (
    medium integer NOT NULL
);

CREATE TABLE orderable_link_type (
    link_type integer NOT NULL,
    direction smallint DEFAULT 1 NOT NULL,
    CONSTRAINT orderable_link_type_direction_check CHECK (((direction = 1) OR (direction = 2)))
);

CREATE TABLE place (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    address character varying DEFAULT ''::character varying NOT NULL,
    area integer,
    coordinates point,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT place_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT place_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE place_alias (
    id integer NOT NULL,
    place integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT place_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT place_alias_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL))))
);

CREATE SEQUENCE place_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE place_alias_id_seq OWNED BY place_alias.id;

CREATE TABLE place_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE place_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE place_alias_type_id_seq OWNED BY place_alias_type.id;

CREATE TABLE place_annotation (
    place integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE place_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE place_id_seq OWNED BY place.id;

CREATE TABLE place_tag (
    place integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE place_tag_raw (
    place integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE place_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE place_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE place_type_id_seq OWNED BY place_type.id;

CREATE TABLE recording (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    length integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    video boolean DEFAULT false NOT NULL,
    CONSTRAINT recording_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT recording_length_check CHECK (((length IS NULL) OR (length > 0)))
);

CREATE TABLE recording_alias (
    id integer NOT NULL,
    recording integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT recording_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT recording_alias_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE recording_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE recording_alias_id_seq OWNED BY recording_alias.id;

CREATE TABLE recording_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE recording_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE recording_alias_type_id_seq OWNED BY recording_alias_type.id;

CREATE TABLE recording_annotation (
    recording integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE recording_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE recording_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE recording_id_seq OWNED BY recording.id;

CREATE TABLE recording_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT recording_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE recording_rating_raw (
    recording integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT recording_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE recording_tag (
    recording integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE recording_tag_raw (
    recording integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE release (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    release_group integer NOT NULL,
    status integer,
    packaging integer,
    language integer,
    script integer,
    barcode character varying(255),
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    quality smallint DEFAULT '-1'::integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT release_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE release_alias (
    id integer NOT NULL,
    release integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT release_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT release_alias_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE release_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_alias_id_seq OWNED BY release_alias.id;

CREATE TABLE release_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_alias_type_id_seq OWNED BY release_alias_type.id;

CREATE TABLE release_annotation (
    release integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE release_country (
    release integer NOT NULL,
    country integer NOT NULL,
    date_year smallint,
    date_month smallint,
    date_day smallint
);

CREATE TABLE release_coverart (
    id integer NOT NULL,
    last_updated timestamp with time zone,
    cover_art_url character varying(255)
);

CREATE TABLE release_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE TABLE release_group (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    type integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT release_group_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE release_group_alias (
    id integer NOT NULL,
    release_group integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT release_group_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT release_group_alias_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE release_group_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_group_alias_id_seq OWNED BY release_group_alias.id;

CREATE TABLE release_group_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_group_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_group_alias_type_id_seq OWNED BY release_group_alias_type.id;

CREATE TABLE release_group_annotation (
    release_group integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE release_group_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE release_group_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_group_id_seq OWNED BY release_group.id;

CREATE TABLE release_group_meta (
    id integer NOT NULL,
    release_count integer DEFAULT 0 NOT NULL,
    first_release_date_year smallint,
    first_release_date_month smallint,
    first_release_date_day smallint,
    rating smallint,
    rating_count integer,
    CONSTRAINT release_group_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE release_group_primary_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_group_primary_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_group_primary_type_id_seq OWNED BY release_group_primary_type.id;

CREATE TABLE release_group_rating_raw (
    release_group integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT release_group_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE release_group_secondary_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_group_secondary_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_group_secondary_type_id_seq OWNED BY release_group_secondary_type.id;

CREATE TABLE release_group_secondary_type_join (
    release_group integer NOT NULL,
    secondary_type integer NOT NULL,
    created timestamp with time zone DEFAULT now() NOT NULL
);

CREATE TABLE release_group_tag (
    release_group integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE release_group_tag_raw (
    release_group integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE SEQUENCE release_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_id_seq OWNED BY release.id;

CREATE TABLE release_label (
    id integer NOT NULL,
    release integer NOT NULL,
    label integer,
    catalog_number character varying(255),
    last_updated timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE release_label_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_label_id_seq OWNED BY release_label.id;

CREATE TYPE cover_art_presence AS ENUM (
    'absent',
    'present',
    'darkened'
);

CREATE TABLE release_meta (
    id integer NOT NULL,
    date_added timestamp with time zone DEFAULT now(),
    info_url character varying(255),
    amazon_asin character varying(10),
    amazon_store character varying(20),
    cover_art_presence cover_art_presence DEFAULT 'absent'::cover_art_presence NOT NULL
);

CREATE TABLE release_packaging (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_packaging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_packaging_id_seq OWNED BY release_packaging.id;

CREATE TABLE release_raw (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    artist character varying(255),
    added timestamp with time zone DEFAULT now(),
    last_modified timestamp with time zone DEFAULT now(),
    lookup_count integer DEFAULT 0,
    modify_count integer DEFAULT 0,
    source integer DEFAULT 0,
    barcode character varying(255),
    comment character varying(255) DEFAULT ''::character varying NOT NULL
);

CREATE SEQUENCE release_raw_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_raw_id_seq OWNED BY release_raw.id;

CREATE TABLE release_status (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE release_status_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE release_status_id_seq OWNED BY release_status.id;

CREATE TABLE release_tag (
    release integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE release_tag_raw (
    release integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE release_unknown_country (
    release integer NOT NULL,
    date_year smallint,
    date_month smallint,
    date_day smallint
);

CREATE TABLE replication_control (
    id integer NOT NULL,
    current_schema_sequence integer NOT NULL,
    current_replication_sequence integer,
    last_replication_date timestamp with time zone
);

CREATE SEQUENCE replication_control_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE replication_control_id_seq OWNED BY replication_control.id;

CREATE TABLE script (
    id integer NOT NULL,
    iso_code character(4) NOT NULL,
    iso_number character(3) NOT NULL,
    name character varying(100) NOT NULL,
    frequency integer DEFAULT 0 NOT NULL
);

CREATE SEQUENCE script_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE script_id_seq OWNED BY script.id;

CREATE TABLE series (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    type integer NOT NULL,
    ordering_attribute integer NOT NULL,
    ordering_type integer NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT series_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE series_alias (
    id integer NOT NULL,
    series integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL)))),
    CONSTRAINT series_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT series_alias_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE series_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE series_alias_id_seq OWNED BY series_alias.id;

CREATE TABLE series_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE series_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE series_alias_type_id_seq OWNED BY series_alias_type.id;

CREATE TABLE series_annotation (
    series integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE series_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE series_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE series_id_seq OWNED BY series.id;

CREATE TABLE series_ordering_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE series_ordering_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE series_ordering_type_id_seq OWNED BY series_ordering_type.id;

CREATE TABLE series_tag (
    series integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE series_tag_raw (
    series integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE series_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    entity_type character varying(50) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE series_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE series_type_id_seq OWNED BY series_type.id;

CREATE TABLE tag (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    ref_count integer DEFAULT 0 NOT NULL
);

CREATE SEQUENCE tag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE tag_id_seq OWNED BY tag.id;

CREATE TABLE tag_relation (
    tag1 integer NOT NULL,
    tag2 integer NOT NULL,
    weight integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT tag_relation_check CHECK ((tag1 < tag2))
);

CREATE TABLE track (
    id integer NOT NULL,
    gid uuid NOT NULL,
    recording integer NOT NULL,
    medium integer NOT NULL,
    "position" integer NOT NULL,
    number text NOT NULL,
    name character varying NOT NULL,
    artist_credit integer NOT NULL,
    length integer,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    is_data_track boolean DEFAULT false NOT NULL,
    CONSTRAINT track_edits_pending_check CHECK ((edits_pending >= 0)),
    CONSTRAINT track_length_check CHECK (((length IS NULL) OR (length > 0)))
);

CREATE TABLE track_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE track_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE track_id_seq OWNED BY track.id;

CREATE TABLE track_raw (
    id integer NOT NULL,
    release integer NOT NULL,
    title character varying(255) NOT NULL,
    artist character varying(255),
    sequence integer NOT NULL
);

CREATE SEQUENCE track_raw_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE track_raw_id_seq OWNED BY track_raw.id;

CREATE TABLE url (
    id integer NOT NULL,
    gid uuid NOT NULL,
    url text NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    CONSTRAINT url_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE url_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE url_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE url_id_seq OWNED BY url.id;

CREATE TABLE vote (
    id integer NOT NULL,
    editor integer NOT NULL,
    edit integer NOT NULL,
    vote smallint NOT NULL,
    vote_time timestamp with time zone DEFAULT now(),
    superseded boolean DEFAULT false NOT NULL
);

CREATE SEQUENCE vote_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE vote_id_seq OWNED BY vote.id;

CREATE TABLE work (
    id integer NOT NULL,
    gid uuid NOT NULL,
    name character varying NOT NULL,
    type integer,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    language integer,
    CONSTRAINT work_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE TABLE work_alias (
    id integer NOT NULL,
    work integer NOT NULL,
    name character varying NOT NULL,
    locale text,
    edits_pending integer DEFAULT 0 NOT NULL,
    last_updated timestamp with time zone DEFAULT now(),
    type integer,
    sort_name character varying NOT NULL,
    begin_date_year smallint,
    begin_date_month smallint,
    begin_date_day smallint,
    end_date_year smallint,
    end_date_month smallint,
    end_date_day smallint,
    primary_for_locale boolean DEFAULT false NOT NULL,
    ended boolean DEFAULT false NOT NULL,
    CONSTRAINT primary_check CHECK ((((locale IS NULL) AND (primary_for_locale IS FALSE)) OR (locale IS NOT NULL))),
    CONSTRAINT search_hints_are_empty CHECK (((type <> 2) OR ((type = 2) AND ((sort_name)::text = (name)::text) AND (begin_date_year IS NULL) AND (begin_date_month IS NULL) AND (begin_date_day IS NULL) AND (end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL) AND (primary_for_locale IS FALSE) AND (locale IS NULL)))),
    CONSTRAINT work_alias_check CHECK (((((end_date_year IS NOT NULL) OR (end_date_month IS NOT NULL) OR (end_date_day IS NOT NULL)) AND (ended = true)) OR ((end_date_year IS NULL) AND (end_date_month IS NULL) AND (end_date_day IS NULL)))),
    CONSTRAINT work_alias_edits_pending_check CHECK ((edits_pending >= 0))
);

CREATE SEQUENCE work_alias_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_alias_id_seq OWNED BY work_alias.id;

CREATE TABLE work_alias_type (
    id integer NOT NULL,
    name text NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE work_alias_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_alias_type_id_seq OWNED BY work_alias_type.id;

CREATE TABLE work_annotation (
    work integer NOT NULL,
    annotation integer NOT NULL
);

CREATE TABLE work_attribute (
    id integer NOT NULL,
    work integer NOT NULL,
    work_attribute_type integer NOT NULL,
    work_attribute_type_allowed_value integer,
    work_attribute_text text,
    CONSTRAINT work_attribute_check CHECK ((((work_attribute_type_allowed_value IS NULL) AND (work_attribute_text IS NOT NULL)) OR ((work_attribute_type_allowed_value IS NOT NULL) AND (work_attribute_text IS NULL))))
);

CREATE SEQUENCE work_attribute_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_attribute_id_seq OWNED BY work_attribute.id;

CREATE TABLE work_attribute_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    comment character varying(255) DEFAULT ''::character varying NOT NULL,
    free_text boolean NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE TABLE work_attribute_type_allowed_value (
    id integer NOT NULL,
    work_attribute_type integer NOT NULL,
    value text,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE work_attribute_type_allowed_value_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_attribute_type_allowed_value_id_seq OWNED BY work_attribute_type_allowed_value.id;

CREATE SEQUENCE work_attribute_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_attribute_type_id_seq OWNED BY work_attribute_type.id;

CREATE TABLE work_gid_redirect (
    gid uuid NOT NULL,
    new_id integer NOT NULL,
    created timestamp with time zone DEFAULT now()
);

CREATE SEQUENCE work_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_id_seq OWNED BY work.id;

CREATE TABLE work_meta (
    id integer NOT NULL,
    rating smallint,
    rating_count integer,
    CONSTRAINT work_meta_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE work_rating_raw (
    work integer NOT NULL,
    editor integer NOT NULL,
    rating smallint NOT NULL,
    CONSTRAINT work_rating_raw_rating_check CHECK (((rating >= 0) AND (rating <= 100)))
);

CREATE TABLE work_tag (
    work integer NOT NULL,
    tag integer NOT NULL,
    count integer NOT NULL,
    last_updated timestamp with time zone DEFAULT now()
);

CREATE TABLE work_tag_raw (
    work integer NOT NULL,
    editor integer NOT NULL,
    tag integer NOT NULL,
    is_upvote boolean DEFAULT true NOT NULL
);

CREATE TABLE work_type (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    parent integer,
    child_order integer DEFAULT 0 NOT NULL,
    description text,
    gid uuid NOT NULL
);

CREATE SEQUENCE work_type_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE work_type_id_seq OWNED BY work_type.id;

ALTER TABLE ONLY alternative_medium ALTER COLUMN id SET DEFAULT nextval('alternative_medium_id_seq'::regclass);

ALTER TABLE ONLY alternative_release ALTER COLUMN id SET DEFAULT nextval('alternative_release_id_seq'::regclass);

ALTER TABLE ONLY alternative_release_type ALTER COLUMN id SET DEFAULT nextval('alternative_release_type_id_seq'::regclass);

ALTER TABLE ONLY alternative_track ALTER COLUMN id SET DEFAULT nextval('alternative_track_id_seq'::regclass);

ALTER TABLE ONLY annotation ALTER COLUMN id SET DEFAULT nextval('annotation_id_seq'::regclass);

ALTER TABLE ONLY application ALTER COLUMN id SET DEFAULT nextval('application_id_seq'::regclass);

ALTER TABLE ONLY area ALTER COLUMN id SET DEFAULT nextval('area_id_seq'::regclass);

ALTER TABLE ONLY area_alias ALTER COLUMN id SET DEFAULT nextval('area_alias_id_seq'::regclass);

ALTER TABLE ONLY area_alias_type ALTER COLUMN id SET DEFAULT nextval('area_alias_type_id_seq'::regclass);

ALTER TABLE ONLY area_type ALTER COLUMN id SET DEFAULT nextval('area_type_id_seq'::regclass);

ALTER TABLE ONLY artist ALTER COLUMN id SET DEFAULT nextval('artist_id_seq'::regclass);

ALTER TABLE ONLY artist_alias ALTER COLUMN id SET DEFAULT nextval('artist_alias_id_seq'::regclass);

ALTER TABLE ONLY artist_alias_type ALTER COLUMN id SET DEFAULT nextval('artist_alias_type_id_seq'::regclass);

ALTER TABLE ONLY artist_credit ALTER COLUMN id SET DEFAULT nextval('artist_credit_id_seq'::regclass);

ALTER TABLE ONLY artist_type ALTER COLUMN id SET DEFAULT nextval('artist_type_id_seq'::regclass);

ALTER TABLE ONLY autoeditor_election ALTER COLUMN id SET DEFAULT nextval('autoeditor_election_id_seq'::regclass);

ALTER TABLE ONLY autoeditor_election_vote ALTER COLUMN id SET DEFAULT nextval('autoeditor_election_vote_id_seq'::regclass);

ALTER TABLE ONLY cdtoc ALTER COLUMN id SET DEFAULT nextval('cdtoc_id_seq'::regclass);

ALTER TABLE ONLY cdtoc_raw ALTER COLUMN id SET DEFAULT nextval('cdtoc_raw_id_seq'::regclass);

ALTER TABLE ONLY edit ALTER COLUMN id SET DEFAULT nextval('edit_id_seq'::regclass);

ALTER TABLE ONLY edit_note ALTER COLUMN id SET DEFAULT nextval('edit_note_id_seq'::regclass);

ALTER TABLE ONLY editor ALTER COLUMN id SET DEFAULT nextval('editor_id_seq'::regclass);

ALTER TABLE ONLY editor_collection ALTER COLUMN id SET DEFAULT nextval('editor_collection_id_seq'::regclass);

ALTER TABLE ONLY editor_collection_type ALTER COLUMN id SET DEFAULT nextval('editor_collection_type_id_seq'::regclass);

ALTER TABLE ONLY editor_oauth_token ALTER COLUMN id SET DEFAULT nextval('editor_oauth_token_id_seq'::regclass);

ALTER TABLE ONLY editor_preference ALTER COLUMN id SET DEFAULT nextval('editor_preference_id_seq'::regclass);

ALTER TABLE ONLY editor_subscribe_artist ALTER COLUMN id SET DEFAULT nextval('editor_subscribe_artist_id_seq'::regclass);

ALTER TABLE ONLY editor_subscribe_collection ALTER COLUMN id SET DEFAULT nextval('editor_subscribe_collection_id_seq'::regclass);

ALTER TABLE ONLY editor_subscribe_editor ALTER COLUMN id SET DEFAULT nextval('editor_subscribe_editor_id_seq'::regclass);

ALTER TABLE ONLY editor_subscribe_label ALTER COLUMN id SET DEFAULT nextval('editor_subscribe_label_id_seq'::regclass);

ALTER TABLE ONLY editor_subscribe_series ALTER COLUMN id SET DEFAULT nextval('editor_subscribe_series_id_seq'::regclass);

ALTER TABLE ONLY event ALTER COLUMN id SET DEFAULT nextval('event_id_seq'::regclass);

ALTER TABLE ONLY event_alias ALTER COLUMN id SET DEFAULT nextval('event_alias_id_seq'::regclass);

ALTER TABLE ONLY event_alias_type ALTER COLUMN id SET DEFAULT nextval('event_alias_type_id_seq'::regclass);

ALTER TABLE ONLY event_type ALTER COLUMN id SET DEFAULT nextval('event_type_id_seq'::regclass);

ALTER TABLE ONLY gender ALTER COLUMN id SET DEFAULT nextval('gender_id_seq'::regclass);

ALTER TABLE ONLY instrument ALTER COLUMN id SET DEFAULT nextval('instrument_id_seq'::regclass);

ALTER TABLE ONLY instrument_alias ALTER COLUMN id SET DEFAULT nextval('instrument_alias_id_seq'::regclass);

ALTER TABLE ONLY instrument_alias_type ALTER COLUMN id SET DEFAULT nextval('instrument_alias_type_id_seq'::regclass);

ALTER TABLE ONLY instrument_type ALTER COLUMN id SET DEFAULT nextval('instrument_type_id_seq'::regclass);

ALTER TABLE ONLY isrc ALTER COLUMN id SET DEFAULT nextval('isrc_id_seq'::regclass);

ALTER TABLE ONLY iswc ALTER COLUMN id SET DEFAULT nextval('iswc_id_seq'::regclass);

ALTER TABLE ONLY l_area_area ALTER COLUMN id SET DEFAULT nextval('l_area_area_id_seq'::regclass);

ALTER TABLE ONLY l_area_artist ALTER COLUMN id SET DEFAULT nextval('l_area_artist_id_seq'::regclass);

ALTER TABLE ONLY l_area_event ALTER COLUMN id SET DEFAULT nextval('l_area_event_id_seq'::regclass);

ALTER TABLE ONLY l_area_instrument ALTER COLUMN id SET DEFAULT nextval('l_area_instrument_id_seq'::regclass);

ALTER TABLE ONLY l_area_label ALTER COLUMN id SET DEFAULT nextval('l_area_label_id_seq'::regclass);

ALTER TABLE ONLY l_area_place ALTER COLUMN id SET DEFAULT nextval('l_area_place_id_seq'::regclass);

ALTER TABLE ONLY l_area_recording ALTER COLUMN id SET DEFAULT nextval('l_area_recording_id_seq'::regclass);

ALTER TABLE ONLY l_area_release ALTER COLUMN id SET DEFAULT nextval('l_area_release_id_seq'::regclass);

ALTER TABLE ONLY l_area_release_group ALTER COLUMN id SET DEFAULT nextval('l_area_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_area_series ALTER COLUMN id SET DEFAULT nextval('l_area_series_id_seq'::regclass);

ALTER TABLE ONLY l_area_url ALTER COLUMN id SET DEFAULT nextval('l_area_url_id_seq'::regclass);

ALTER TABLE ONLY l_area_work ALTER COLUMN id SET DEFAULT nextval('l_area_work_id_seq'::regclass);

ALTER TABLE ONLY l_artist_artist ALTER COLUMN id SET DEFAULT nextval('l_artist_artist_id_seq'::regclass);

ALTER TABLE ONLY l_artist_event ALTER COLUMN id SET DEFAULT nextval('l_artist_event_id_seq'::regclass);

ALTER TABLE ONLY l_artist_instrument ALTER COLUMN id SET DEFAULT nextval('l_artist_instrument_id_seq'::regclass);

ALTER TABLE ONLY l_artist_label ALTER COLUMN id SET DEFAULT nextval('l_artist_label_id_seq'::regclass);

ALTER TABLE ONLY l_artist_place ALTER COLUMN id SET DEFAULT nextval('l_artist_place_id_seq'::regclass);

ALTER TABLE ONLY l_artist_recording ALTER COLUMN id SET DEFAULT nextval('l_artist_recording_id_seq'::regclass);

ALTER TABLE ONLY l_artist_release ALTER COLUMN id SET DEFAULT nextval('l_artist_release_id_seq'::regclass);

ALTER TABLE ONLY l_artist_release_group ALTER COLUMN id SET DEFAULT nextval('l_artist_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_artist_series ALTER COLUMN id SET DEFAULT nextval('l_artist_series_id_seq'::regclass);

ALTER TABLE ONLY l_artist_url ALTER COLUMN id SET DEFAULT nextval('l_artist_url_id_seq'::regclass);

ALTER TABLE ONLY l_artist_work ALTER COLUMN id SET DEFAULT nextval('l_artist_work_id_seq'::regclass);

ALTER TABLE ONLY l_event_event ALTER COLUMN id SET DEFAULT nextval('l_event_event_id_seq'::regclass);

ALTER TABLE ONLY l_event_instrument ALTER COLUMN id SET DEFAULT nextval('l_event_instrument_id_seq'::regclass);

ALTER TABLE ONLY l_event_label ALTER COLUMN id SET DEFAULT nextval('l_event_label_id_seq'::regclass);

ALTER TABLE ONLY l_event_place ALTER COLUMN id SET DEFAULT nextval('l_event_place_id_seq'::regclass);

ALTER TABLE ONLY l_event_recording ALTER COLUMN id SET DEFAULT nextval('l_event_recording_id_seq'::regclass);

ALTER TABLE ONLY l_event_release ALTER COLUMN id SET DEFAULT nextval('l_event_release_id_seq'::regclass);

ALTER TABLE ONLY l_event_release_group ALTER COLUMN id SET DEFAULT nextval('l_event_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_event_series ALTER COLUMN id SET DEFAULT nextval('l_event_series_id_seq'::regclass);

ALTER TABLE ONLY l_event_url ALTER COLUMN id SET DEFAULT nextval('l_event_url_id_seq'::regclass);

ALTER TABLE ONLY l_event_work ALTER COLUMN id SET DEFAULT nextval('l_event_work_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_instrument ALTER COLUMN id SET DEFAULT nextval('l_instrument_instrument_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_label ALTER COLUMN id SET DEFAULT nextval('l_instrument_label_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_place ALTER COLUMN id SET DEFAULT nextval('l_instrument_place_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_recording ALTER COLUMN id SET DEFAULT nextval('l_instrument_recording_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_release ALTER COLUMN id SET DEFAULT nextval('l_instrument_release_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_release_group ALTER COLUMN id SET DEFAULT nextval('l_instrument_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_series ALTER COLUMN id SET DEFAULT nextval('l_instrument_series_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_url ALTER COLUMN id SET DEFAULT nextval('l_instrument_url_id_seq'::regclass);

ALTER TABLE ONLY l_instrument_work ALTER COLUMN id SET DEFAULT nextval('l_instrument_work_id_seq'::regclass);

ALTER TABLE ONLY l_label_label ALTER COLUMN id SET DEFAULT nextval('l_label_label_id_seq'::regclass);

ALTER TABLE ONLY l_label_place ALTER COLUMN id SET DEFAULT nextval('l_label_place_id_seq'::regclass);

ALTER TABLE ONLY l_label_recording ALTER COLUMN id SET DEFAULT nextval('l_label_recording_id_seq'::regclass);

ALTER TABLE ONLY l_label_release ALTER COLUMN id SET DEFAULT nextval('l_label_release_id_seq'::regclass);

ALTER TABLE ONLY l_label_release_group ALTER COLUMN id SET DEFAULT nextval('l_label_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_label_series ALTER COLUMN id SET DEFAULT nextval('l_label_series_id_seq'::regclass);

ALTER TABLE ONLY l_label_url ALTER COLUMN id SET DEFAULT nextval('l_label_url_id_seq'::regclass);

ALTER TABLE ONLY l_label_work ALTER COLUMN id SET DEFAULT nextval('l_label_work_id_seq'::regclass);

ALTER TABLE ONLY l_place_place ALTER COLUMN id SET DEFAULT nextval('l_place_place_id_seq'::regclass);

ALTER TABLE ONLY l_place_recording ALTER COLUMN id SET DEFAULT nextval('l_place_recording_id_seq'::regclass);

ALTER TABLE ONLY l_place_release ALTER COLUMN id SET DEFAULT nextval('l_place_release_id_seq'::regclass);

ALTER TABLE ONLY l_place_release_group ALTER COLUMN id SET DEFAULT nextval('l_place_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_place_series ALTER COLUMN id SET DEFAULT nextval('l_place_series_id_seq'::regclass);

ALTER TABLE ONLY l_place_url ALTER COLUMN id SET DEFAULT nextval('l_place_url_id_seq'::regclass);

ALTER TABLE ONLY l_place_work ALTER COLUMN id SET DEFAULT nextval('l_place_work_id_seq'::regclass);

ALTER TABLE ONLY l_recording_recording ALTER COLUMN id SET DEFAULT nextval('l_recording_recording_id_seq'::regclass);

ALTER TABLE ONLY l_recording_release ALTER COLUMN id SET DEFAULT nextval('l_recording_release_id_seq'::regclass);

ALTER TABLE ONLY l_recording_release_group ALTER COLUMN id SET DEFAULT nextval('l_recording_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_recording_series ALTER COLUMN id SET DEFAULT nextval('l_recording_series_id_seq'::regclass);

ALTER TABLE ONLY l_recording_url ALTER COLUMN id SET DEFAULT nextval('l_recording_url_id_seq'::regclass);

ALTER TABLE ONLY l_recording_work ALTER COLUMN id SET DEFAULT nextval('l_recording_work_id_seq'::regclass);

ALTER TABLE ONLY l_release_group_release_group ALTER COLUMN id SET DEFAULT nextval('l_release_group_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_release_group_series ALTER COLUMN id SET DEFAULT nextval('l_release_group_series_id_seq'::regclass);

ALTER TABLE ONLY l_release_group_url ALTER COLUMN id SET DEFAULT nextval('l_release_group_url_id_seq'::regclass);

ALTER TABLE ONLY l_release_group_work ALTER COLUMN id SET DEFAULT nextval('l_release_group_work_id_seq'::regclass);

ALTER TABLE ONLY l_release_release ALTER COLUMN id SET DEFAULT nextval('l_release_release_id_seq'::regclass);

ALTER TABLE ONLY l_release_release_group ALTER COLUMN id SET DEFAULT nextval('l_release_release_group_id_seq'::regclass);

ALTER TABLE ONLY l_release_series ALTER COLUMN id SET DEFAULT nextval('l_release_series_id_seq'::regclass);

ALTER TABLE ONLY l_release_url ALTER COLUMN id SET DEFAULT nextval('l_release_url_id_seq'::regclass);

ALTER TABLE ONLY l_release_work ALTER COLUMN id SET DEFAULT nextval('l_release_work_id_seq'::regclass);

ALTER TABLE ONLY l_series_series ALTER COLUMN id SET DEFAULT nextval('l_series_series_id_seq'::regclass);

ALTER TABLE ONLY l_series_url ALTER COLUMN id SET DEFAULT nextval('l_series_url_id_seq'::regclass);

ALTER TABLE ONLY l_series_work ALTER COLUMN id SET DEFAULT nextval('l_series_work_id_seq'::regclass);

ALTER TABLE ONLY l_url_url ALTER COLUMN id SET DEFAULT nextval('l_url_url_id_seq'::regclass);

ALTER TABLE ONLY l_url_work ALTER COLUMN id SET DEFAULT nextval('l_url_work_id_seq'::regclass);

ALTER TABLE ONLY l_work_work ALTER COLUMN id SET DEFAULT nextval('l_work_work_id_seq'::regclass);

ALTER TABLE ONLY label ALTER COLUMN id SET DEFAULT nextval('label_id_seq'::regclass);

ALTER TABLE ONLY label_alias ALTER COLUMN id SET DEFAULT nextval('label_alias_id_seq'::regclass);

ALTER TABLE ONLY label_alias_type ALTER COLUMN id SET DEFAULT nextval('label_alias_type_id_seq'::regclass);

ALTER TABLE ONLY label_type ALTER COLUMN id SET DEFAULT nextval('label_type_id_seq'::regclass);

ALTER TABLE ONLY language ALTER COLUMN id SET DEFAULT nextval('language_id_seq'::regclass);

ALTER TABLE ONLY link ALTER COLUMN id SET DEFAULT nextval('link_id_seq'::regclass);

ALTER TABLE ONLY link_attribute_type ALTER COLUMN id SET DEFAULT nextval('link_attribute_type_id_seq'::regclass);

ALTER TABLE ONLY link_type ALTER COLUMN id SET DEFAULT nextval('link_type_id_seq'::regclass);

ALTER TABLE ONLY medium ALTER COLUMN id SET DEFAULT nextval('medium_id_seq'::regclass);

ALTER TABLE ONLY medium_cdtoc ALTER COLUMN id SET DEFAULT nextval('medium_cdtoc_id_seq'::regclass);

ALTER TABLE ONLY medium_format ALTER COLUMN id SET DEFAULT nextval('medium_format_id_seq'::regclass);

ALTER TABLE ONLY place ALTER COLUMN id SET DEFAULT nextval('place_id_seq'::regclass);

ALTER TABLE ONLY place_alias ALTER COLUMN id SET DEFAULT nextval('place_alias_id_seq'::regclass);

ALTER TABLE ONLY place_alias_type ALTER COLUMN id SET DEFAULT nextval('place_alias_type_id_seq'::regclass);

ALTER TABLE ONLY place_type ALTER COLUMN id SET DEFAULT nextval('place_type_id_seq'::regclass);

ALTER TABLE ONLY recording ALTER COLUMN id SET DEFAULT nextval('recording_id_seq'::regclass);

ALTER TABLE ONLY recording_alias ALTER COLUMN id SET DEFAULT nextval('recording_alias_id_seq'::regclass);

ALTER TABLE ONLY recording_alias_type ALTER COLUMN id SET DEFAULT nextval('recording_alias_type_id_seq'::regclass);

ALTER TABLE ONLY release ALTER COLUMN id SET DEFAULT nextval('release_id_seq'::regclass);

ALTER TABLE ONLY release_alias ALTER COLUMN id SET DEFAULT nextval('release_alias_id_seq'::regclass);

ALTER TABLE ONLY release_alias_type ALTER COLUMN id SET DEFAULT nextval('release_alias_type_id_seq'::regclass);

ALTER TABLE ONLY release_group ALTER COLUMN id SET DEFAULT nextval('release_group_id_seq'::regclass);

ALTER TABLE ONLY release_group_alias ALTER COLUMN id SET DEFAULT nextval('release_group_alias_id_seq'::regclass);

ALTER TABLE ONLY release_group_alias_type ALTER COLUMN id SET DEFAULT nextval('release_group_alias_type_id_seq'::regclass);

ALTER TABLE ONLY release_group_primary_type ALTER COLUMN id SET DEFAULT nextval('release_group_primary_type_id_seq'::regclass);

ALTER TABLE ONLY release_group_secondary_type ALTER COLUMN id SET DEFAULT nextval('release_group_secondary_type_id_seq'::regclass);

ALTER TABLE ONLY release_label ALTER COLUMN id SET DEFAULT nextval('release_label_id_seq'::regclass);

ALTER TABLE ONLY release_packaging ALTER COLUMN id SET DEFAULT nextval('release_packaging_id_seq'::regclass);

ALTER TABLE ONLY release_raw ALTER COLUMN id SET DEFAULT nextval('release_raw_id_seq'::regclass);

ALTER TABLE ONLY release_status ALTER COLUMN id SET DEFAULT nextval('release_status_id_seq'::regclass);

ALTER TABLE ONLY replication_control ALTER COLUMN id SET DEFAULT nextval('replication_control_id_seq'::regclass);

ALTER TABLE ONLY script ALTER COLUMN id SET DEFAULT nextval('script_id_seq'::regclass);

ALTER TABLE ONLY series ALTER COLUMN id SET DEFAULT nextval('series_id_seq'::regclass);

ALTER TABLE ONLY series_alias ALTER COLUMN id SET DEFAULT nextval('series_alias_id_seq'::regclass);

ALTER TABLE ONLY series_alias_type ALTER COLUMN id SET DEFAULT nextval('series_alias_type_id_seq'::regclass);

ALTER TABLE ONLY series_ordering_type ALTER COLUMN id SET DEFAULT nextval('series_ordering_type_id_seq'::regclass);

ALTER TABLE ONLY series_type ALTER COLUMN id SET DEFAULT nextval('series_type_id_seq'::regclass);

ALTER TABLE ONLY tag ALTER COLUMN id SET DEFAULT nextval('tag_id_seq'::regclass);

ALTER TABLE ONLY track ALTER COLUMN id SET DEFAULT nextval('track_id_seq'::regclass);

ALTER TABLE ONLY track_raw ALTER COLUMN id SET DEFAULT nextval('track_raw_id_seq'::regclass);

ALTER TABLE ONLY url ALTER COLUMN id SET DEFAULT nextval('url_id_seq'::regclass);

ALTER TABLE ONLY vote ALTER COLUMN id SET DEFAULT nextval('vote_id_seq'::regclass);

ALTER TABLE ONLY work ALTER COLUMN id SET DEFAULT nextval('work_id_seq'::regclass);

ALTER TABLE ONLY work_alias ALTER COLUMN id SET DEFAULT nextval('work_alias_id_seq'::regclass);

ALTER TABLE ONLY work_alias_type ALTER COLUMN id SET DEFAULT nextval('work_alias_type_id_seq'::regclass);

ALTER TABLE ONLY work_attribute ALTER COLUMN id SET DEFAULT nextval('work_attribute_id_seq'::regclass);

ALTER TABLE ONLY work_attribute_type ALTER COLUMN id SET DEFAULT nextval('work_attribute_type_id_seq'::regclass);

ALTER TABLE ONLY work_attribute_type_allowed_value ALTER COLUMN id SET DEFAULT nextval('work_attribute_type_allowed_value_id_seq'::regclass);

ALTER TABLE ONLY work_type ALTER COLUMN id SET DEFAULT nextval('work_type_id_seq'::regclass);

ALTER TABLE ONLY alternative_medium
    ADD CONSTRAINT alternative_medium_pkey PRIMARY KEY (id);

ALTER TABLE ONLY alternative_medium_track
    ADD CONSTRAINT alternative_medium_track_pkey PRIMARY KEY (alternative_medium, track);

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY alternative_release_type
    ADD CONSTRAINT alternative_release_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY alternative_track
    ADD CONSTRAINT alternative_track_pkey PRIMARY KEY (id);

ALTER TABLE ONLY annotation
    ADD CONSTRAINT annotation_pkey PRIMARY KEY (id);

ALTER TABLE ONLY application
    ADD CONSTRAINT application_pkey PRIMARY KEY (id);

ALTER TABLE ONLY area_alias
    ADD CONSTRAINT area_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY area_alias_type
    ADD CONSTRAINT area_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY area_annotation
    ADD CONSTRAINT area_annotation_pkey PRIMARY KEY (area, annotation);

ALTER TABLE ONLY area_gid_redirect
    ADD CONSTRAINT area_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY area
    ADD CONSTRAINT area_pkey PRIMARY KEY (id);

ALTER TABLE ONLY area_tag
    ADD CONSTRAINT area_tag_pkey PRIMARY KEY (area, tag);

ALTER TABLE ONLY area_tag_raw
    ADD CONSTRAINT area_tag_raw_pkey PRIMARY KEY (area, editor, tag);

ALTER TABLE ONLY area_type
    ADD CONSTRAINT area_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist_alias
    ADD CONSTRAINT artist_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist_alias_type
    ADD CONSTRAINT artist_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist_annotation
    ADD CONSTRAINT artist_annotation_pkey PRIMARY KEY (artist, annotation);

ALTER TABLE ONLY artist_credit_name
    ADD CONSTRAINT artist_credit_name_pkey PRIMARY KEY (artist_credit, "position");

ALTER TABLE ONLY artist_credit
    ADD CONSTRAINT artist_credit_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist_gid_redirect
    ADD CONSTRAINT artist_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY artist_ipi
    ADD CONSTRAINT artist_ipi_pkey PRIMARY KEY (artist, ipi);

ALTER TABLE ONLY artist_isni
    ADD CONSTRAINT artist_isni_pkey PRIMARY KEY (artist, isni);

ALTER TABLE ONLY artist_meta
    ADD CONSTRAINT artist_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_pkey PRIMARY KEY (id);

ALTER TABLE ONLY artist_rating_raw
    ADD CONSTRAINT artist_rating_raw_pkey PRIMARY KEY (artist, editor);

ALTER TABLE ONLY artist_tag
    ADD CONSTRAINT artist_tag_pkey PRIMARY KEY (artist, tag);

ALTER TABLE ONLY artist_tag_raw
    ADD CONSTRAINT artist_tag_raw_pkey PRIMARY KEY (artist, editor, tag);

ALTER TABLE ONLY artist_type
    ADD CONSTRAINT artist_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY autoeditor_election
    ADD CONSTRAINT autoeditor_election_pkey PRIMARY KEY (id);

ALTER TABLE ONLY autoeditor_election_vote
    ADD CONSTRAINT autoeditor_election_vote_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cdtoc
    ADD CONSTRAINT cdtoc_pkey PRIMARY KEY (id);

ALTER TABLE ONLY cdtoc_raw
    ADD CONSTRAINT cdtoc_raw_pkey PRIMARY KEY (id);

ALTER TABLE ONLY country_area
    ADD CONSTRAINT country_area_pkey PRIMARY KEY (area);

ALTER TABLE ONLY deleted_entity
    ADD CONSTRAINT deleted_entity_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY edit_area
    ADD CONSTRAINT edit_area_pkey PRIMARY KEY (edit, area);

ALTER TABLE ONLY edit_artist
    ADD CONSTRAINT edit_artist_pkey PRIMARY KEY (edit, artist);

ALTER TABLE ONLY edit_data
    ADD CONSTRAINT edit_data_pkey PRIMARY KEY (edit);

ALTER TABLE ONLY edit_event
    ADD CONSTRAINT edit_event_pkey PRIMARY KEY (edit, event);

ALTER TABLE ONLY edit_instrument
    ADD CONSTRAINT edit_instrument_pkey PRIMARY KEY (edit, instrument);

ALTER TABLE ONLY edit_label
    ADD CONSTRAINT edit_label_pkey PRIMARY KEY (edit, label);

ALTER TABLE ONLY edit_note
    ADD CONSTRAINT edit_note_pkey PRIMARY KEY (id);

ALTER TABLE ONLY edit_note_recipient
    ADD CONSTRAINT edit_note_recipient_pkey PRIMARY KEY (recipient, edit_note);

ALTER TABLE ONLY edit
    ADD CONSTRAINT edit_pkey PRIMARY KEY (id);

ALTER TABLE ONLY edit_place
    ADD CONSTRAINT edit_place_pkey PRIMARY KEY (edit, place);

ALTER TABLE ONLY edit_recording
    ADD CONSTRAINT edit_recording_pkey PRIMARY KEY (edit, recording);

ALTER TABLE ONLY edit_release_group
    ADD CONSTRAINT edit_release_group_pkey PRIMARY KEY (edit, release_group);

ALTER TABLE ONLY edit_release
    ADD CONSTRAINT edit_release_pkey PRIMARY KEY (edit, release);

ALTER TABLE ONLY edit_series
    ADD CONSTRAINT edit_series_pkey PRIMARY KEY (edit, series);

ALTER TABLE ONLY edit_url
    ADD CONSTRAINT edit_url_pkey PRIMARY KEY (edit, url);

ALTER TABLE ONLY edit_work
    ADD CONSTRAINT edit_work_pkey PRIMARY KEY (edit, work);

ALTER TABLE ONLY editor_collection_area
    ADD CONSTRAINT editor_collection_area_pkey PRIMARY KEY (collection, area);

ALTER TABLE ONLY editor_collection_artist
    ADD CONSTRAINT editor_collection_artist_pkey PRIMARY KEY (collection, artist);

ALTER TABLE ONLY editor_collection_deleted_entity
    ADD CONSTRAINT editor_collection_deleted_entity_pkey PRIMARY KEY (collection, gid);

ALTER TABLE ONLY editor_collection_event
    ADD CONSTRAINT editor_collection_event_pkey PRIMARY KEY (collection, event);

ALTER TABLE ONLY editor_collection_instrument
    ADD CONSTRAINT editor_collection_instrument_pkey PRIMARY KEY (collection, instrument);

ALTER TABLE ONLY editor_collection_label
    ADD CONSTRAINT editor_collection_label_pkey PRIMARY KEY (collection, label);

ALTER TABLE ONLY editor_collection
    ADD CONSTRAINT editor_collection_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_collection_place
    ADD CONSTRAINT editor_collection_place_pkey PRIMARY KEY (collection, place);

ALTER TABLE ONLY editor_collection_recording
    ADD CONSTRAINT editor_collection_recording_pkey PRIMARY KEY (collection, recording);

ALTER TABLE ONLY editor_collection_release_group
    ADD CONSTRAINT editor_collection_release_group_pkey PRIMARY KEY (collection, release_group);

ALTER TABLE ONLY editor_collection_release
    ADD CONSTRAINT editor_collection_release_pkey PRIMARY KEY (collection, release);

ALTER TABLE ONLY editor_collection_series
    ADD CONSTRAINT editor_collection_series_pkey PRIMARY KEY (collection, series);

ALTER TABLE ONLY editor_collection_type
    ADD CONSTRAINT editor_collection_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_collection_work
    ADD CONSTRAINT editor_collection_work_pkey PRIMARY KEY (collection, work);

ALTER TABLE ONLY editor_language
    ADD CONSTRAINT editor_language_pkey PRIMARY KEY (editor, language);

ALTER TABLE ONLY editor_oauth_token
    ADD CONSTRAINT editor_oauth_token_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_preference
    ADD CONSTRAINT editor_preference_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_subscribe_artist_deleted
    ADD CONSTRAINT editor_subscribe_artist_deleted_pkey PRIMARY KEY (editor, gid);

ALTER TABLE ONLY editor_subscribe_artist
    ADD CONSTRAINT editor_subscribe_artist_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_subscribe_collection
    ADD CONSTRAINT editor_subscribe_collection_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_subscribe_editor
    ADD CONSTRAINT editor_subscribe_editor_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_subscribe_label_deleted
    ADD CONSTRAINT editor_subscribe_label_deleted_pkey PRIMARY KEY (editor, gid);

ALTER TABLE ONLY editor_subscribe_label
    ADD CONSTRAINT editor_subscribe_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_subscribe_series_deleted
    ADD CONSTRAINT editor_subscribe_series_deleted_pkey PRIMARY KEY (editor, gid);

ALTER TABLE ONLY editor_subscribe_series
    ADD CONSTRAINT editor_subscribe_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY editor_watch_artist
    ADD CONSTRAINT editor_watch_artist_pkey PRIMARY KEY (artist, editor);

ALTER TABLE ONLY editor_watch_preferences
    ADD CONSTRAINT editor_watch_preferences_pkey PRIMARY KEY (editor);

ALTER TABLE ONLY editor_watch_release_group_type
    ADD CONSTRAINT editor_watch_release_group_type_pkey PRIMARY KEY (editor, release_group_type);

ALTER TABLE ONLY editor_watch_release_status
    ADD CONSTRAINT editor_watch_release_status_pkey PRIMARY KEY (editor, release_status);

ALTER TABLE ONLY event_alias
    ADD CONSTRAINT event_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY event_alias_type
    ADD CONSTRAINT event_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY event_annotation
    ADD CONSTRAINT event_annotation_pkey PRIMARY KEY (event, annotation);

ALTER TABLE ONLY event_gid_redirect
    ADD CONSTRAINT event_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY event_meta
    ADD CONSTRAINT event_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY event
    ADD CONSTRAINT event_pkey PRIMARY KEY (id);

ALTER TABLE ONLY event_rating_raw
    ADD CONSTRAINT event_rating_raw_pkey PRIMARY KEY (event, editor);

ALTER TABLE ONLY event_tag
    ADD CONSTRAINT event_tag_pkey PRIMARY KEY (event, tag);

ALTER TABLE ONLY event_tag_raw
    ADD CONSTRAINT event_tag_raw_pkey PRIMARY KEY (event, editor, tag);

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_pkey PRIMARY KEY (id);

ALTER TABLE ONLY instrument_alias
    ADD CONSTRAINT instrument_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY instrument_alias_type
    ADD CONSTRAINT instrument_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY instrument_annotation
    ADD CONSTRAINT instrument_annotation_pkey PRIMARY KEY (instrument, annotation);

ALTER TABLE ONLY instrument_gid_redirect
    ADD CONSTRAINT instrument_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY instrument
    ADD CONSTRAINT instrument_pkey PRIMARY KEY (id);

ALTER TABLE ONLY instrument_tag
    ADD CONSTRAINT instrument_tag_pkey PRIMARY KEY (instrument, tag);

ALTER TABLE ONLY instrument_tag_raw
    ADD CONSTRAINT instrument_tag_raw_pkey PRIMARY KEY (instrument, editor, tag);

ALTER TABLE ONLY instrument_type
    ADD CONSTRAINT instrument_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY iso_3166_1
    ADD CONSTRAINT iso_3166_1_pkey PRIMARY KEY (code);

ALTER TABLE ONLY iso_3166_2
    ADD CONSTRAINT iso_3166_2_pkey PRIMARY KEY (code);

ALTER TABLE ONLY iso_3166_3
    ADD CONSTRAINT iso_3166_3_pkey PRIMARY KEY (code);

ALTER TABLE ONLY isrc
    ADD CONSTRAINT isrc_pkey PRIMARY KEY (id);

ALTER TABLE ONLY iswc
    ADD CONSTRAINT iswc_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_area
    ADD CONSTRAINT l_area_area_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_artist
    ADD CONSTRAINT l_area_artist_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_event
    ADD CONSTRAINT l_area_event_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_instrument
    ADD CONSTRAINT l_area_instrument_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_label
    ADD CONSTRAINT l_area_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_place
    ADD CONSTRAINT l_area_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_recording
    ADD CONSTRAINT l_area_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_release_group
    ADD CONSTRAINT l_area_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_release
    ADD CONSTRAINT l_area_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_series
    ADD CONSTRAINT l_area_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_url
    ADD CONSTRAINT l_area_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_area_work
    ADD CONSTRAINT l_area_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_artist
    ADD CONSTRAINT l_artist_artist_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_event
    ADD CONSTRAINT l_artist_event_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_instrument
    ADD CONSTRAINT l_artist_instrument_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_label
    ADD CONSTRAINT l_artist_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_place
    ADD CONSTRAINT l_artist_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_recording
    ADD CONSTRAINT l_artist_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_release_group
    ADD CONSTRAINT l_artist_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_release
    ADD CONSTRAINT l_artist_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_series
    ADD CONSTRAINT l_artist_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_url
    ADD CONSTRAINT l_artist_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_artist_work
    ADD CONSTRAINT l_artist_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_event
    ADD CONSTRAINT l_event_event_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_instrument
    ADD CONSTRAINT l_event_instrument_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_label
    ADD CONSTRAINT l_event_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_place
    ADD CONSTRAINT l_event_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_recording
    ADD CONSTRAINT l_event_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_release_group
    ADD CONSTRAINT l_event_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_release
    ADD CONSTRAINT l_event_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_series
    ADD CONSTRAINT l_event_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_url
    ADD CONSTRAINT l_event_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_event_work
    ADD CONSTRAINT l_event_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_instrument
    ADD CONSTRAINT l_instrument_instrument_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_label
    ADD CONSTRAINT l_instrument_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_place
    ADD CONSTRAINT l_instrument_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_recording
    ADD CONSTRAINT l_instrument_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_release_group
    ADD CONSTRAINT l_instrument_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_release
    ADD CONSTRAINT l_instrument_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_series
    ADD CONSTRAINT l_instrument_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_url
    ADD CONSTRAINT l_instrument_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_instrument_work
    ADD CONSTRAINT l_instrument_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_label
    ADD CONSTRAINT l_label_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_place
    ADD CONSTRAINT l_label_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_recording
    ADD CONSTRAINT l_label_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_release_group
    ADD CONSTRAINT l_label_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_release
    ADD CONSTRAINT l_label_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_series
    ADD CONSTRAINT l_label_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_url
    ADD CONSTRAINT l_label_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_label_work
    ADD CONSTRAINT l_label_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_place
    ADD CONSTRAINT l_place_place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_recording
    ADD CONSTRAINT l_place_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_release_group
    ADD CONSTRAINT l_place_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_release
    ADD CONSTRAINT l_place_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_series
    ADD CONSTRAINT l_place_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_url
    ADD CONSTRAINT l_place_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_place_work
    ADD CONSTRAINT l_place_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_recording
    ADD CONSTRAINT l_recording_recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_release_group
    ADD CONSTRAINT l_recording_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_release
    ADD CONSTRAINT l_recording_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_series
    ADD CONSTRAINT l_recording_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_url
    ADD CONSTRAINT l_recording_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_recording_work
    ADD CONSTRAINT l_recording_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_group_release_group
    ADD CONSTRAINT l_release_group_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_group_series
    ADD CONSTRAINT l_release_group_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_group_url
    ADD CONSTRAINT l_release_group_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_group_work
    ADD CONSTRAINT l_release_group_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_release_group
    ADD CONSTRAINT l_release_release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_release
    ADD CONSTRAINT l_release_release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_series
    ADD CONSTRAINT l_release_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_url
    ADD CONSTRAINT l_release_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_release_work
    ADD CONSTRAINT l_release_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_series_series
    ADD CONSTRAINT l_series_series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_series_url
    ADD CONSTRAINT l_series_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_series_work
    ADD CONSTRAINT l_series_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_url_url
    ADD CONSTRAINT l_url_url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_url_work
    ADD CONSTRAINT l_url_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY l_work_work
    ADD CONSTRAINT l_work_work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY label_alias
    ADD CONSTRAINT label_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY label_alias_type
    ADD CONSTRAINT label_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY label_annotation
    ADD CONSTRAINT label_annotation_pkey PRIMARY KEY (label, annotation);

ALTER TABLE ONLY label_gid_redirect
    ADD CONSTRAINT label_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY label_ipi
    ADD CONSTRAINT label_ipi_pkey PRIMARY KEY (label, ipi);

ALTER TABLE ONLY label_isni
    ADD CONSTRAINT label_isni_pkey PRIMARY KEY (label, isni);

ALTER TABLE ONLY label_meta
    ADD CONSTRAINT label_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY label
    ADD CONSTRAINT label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY label_rating_raw
    ADD CONSTRAINT label_rating_raw_pkey PRIMARY KEY (label, editor);

ALTER TABLE ONLY label_tag
    ADD CONSTRAINT label_tag_pkey PRIMARY KEY (label, tag);

ALTER TABLE ONLY label_tag_raw
    ADD CONSTRAINT label_tag_raw_pkey PRIMARY KEY (label, editor, tag);

ALTER TABLE ONLY label_type
    ADD CONSTRAINT label_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY language
    ADD CONSTRAINT language_pkey PRIMARY KEY (id);

ALTER TABLE ONLY link_attribute_credit
    ADD CONSTRAINT link_attribute_credit_pkey PRIMARY KEY (link, attribute_type);

ALTER TABLE ONLY link_attribute
    ADD CONSTRAINT link_attribute_pkey PRIMARY KEY (link, attribute_type);

ALTER TABLE ONLY link_attribute_text_value
    ADD CONSTRAINT link_attribute_text_value_pkey PRIMARY KEY (link, attribute_type);

ALTER TABLE ONLY link_attribute_type
    ADD CONSTRAINT link_attribute_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY link_creditable_attribute_type
    ADD CONSTRAINT link_creditable_attribute_type_pkey PRIMARY KEY (attribute_type);

ALTER TABLE ONLY link
    ADD CONSTRAINT link_pkey PRIMARY KEY (id);

ALTER TABLE ONLY link_text_attribute_type
    ADD CONSTRAINT link_text_attribute_type_pkey PRIMARY KEY (attribute_type);

ALTER TABLE ONLY link_type_attribute_type
    ADD CONSTRAINT link_type_attribute_type_pkey PRIMARY KEY (link_type, attribute_type);

ALTER TABLE ONLY link_type
    ADD CONSTRAINT link_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY medium_cdtoc
    ADD CONSTRAINT medium_cdtoc_pkey PRIMARY KEY (id);

ALTER TABLE ONLY medium_format
    ADD CONSTRAINT medium_format_pkey PRIMARY KEY (id);

ALTER TABLE ONLY medium_index
    ADD CONSTRAINT medium_index_pkey PRIMARY KEY (medium);

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_pkey PRIMARY KEY (id);

ALTER TABLE ONLY orderable_link_type
    ADD CONSTRAINT orderable_link_type_pkey PRIMARY KEY (link_type);

ALTER TABLE ONLY place_alias
    ADD CONSTRAINT place_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY place_alias_type
    ADD CONSTRAINT place_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY place_annotation
    ADD CONSTRAINT place_annotation_pkey PRIMARY KEY (place, annotation);

ALTER TABLE ONLY place_gid_redirect
    ADD CONSTRAINT place_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY place
    ADD CONSTRAINT place_pkey PRIMARY KEY (id);

ALTER TABLE ONLY place_tag
    ADD CONSTRAINT place_tag_pkey PRIMARY KEY (place, tag);

ALTER TABLE ONLY place_tag_raw
    ADD CONSTRAINT place_tag_raw_pkey PRIMARY KEY (place, editor, tag);

ALTER TABLE ONLY place_type
    ADD CONSTRAINT place_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY recording_alias
    ADD CONSTRAINT recording_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY recording_alias_type
    ADD CONSTRAINT recording_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY recording_annotation
    ADD CONSTRAINT recording_annotation_pkey PRIMARY KEY (recording, annotation);

ALTER TABLE ONLY recording_gid_redirect
    ADD CONSTRAINT recording_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY recording_meta
    ADD CONSTRAINT recording_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY recording
    ADD CONSTRAINT recording_pkey PRIMARY KEY (id);

ALTER TABLE ONLY recording_rating_raw
    ADD CONSTRAINT recording_rating_raw_pkey PRIMARY KEY (recording, editor);

ALTER TABLE ONLY recording_tag
    ADD CONSTRAINT recording_tag_pkey PRIMARY KEY (recording, tag);

ALTER TABLE ONLY recording_tag_raw
    ADD CONSTRAINT recording_tag_raw_pkey PRIMARY KEY (recording, editor, tag);

ALTER TABLE ONLY release_alias
    ADD CONSTRAINT release_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_alias_type
    ADD CONSTRAINT release_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_annotation
    ADD CONSTRAINT release_annotation_pkey PRIMARY KEY (release, annotation);

ALTER TABLE ONLY release_country
    ADD CONSTRAINT release_country_pkey PRIMARY KEY (release, country);

ALTER TABLE ONLY release_coverart
    ADD CONSTRAINT release_coverart_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_gid_redirect
    ADD CONSTRAINT release_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY release_group_alias
    ADD CONSTRAINT release_group_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group_alias_type
    ADD CONSTRAINT release_group_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group_annotation
    ADD CONSTRAINT release_group_annotation_pkey PRIMARY KEY (release_group, annotation);

ALTER TABLE ONLY release_group_gid_redirect
    ADD CONSTRAINT release_group_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY release_group_meta
    ADD CONSTRAINT release_group_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group
    ADD CONSTRAINT release_group_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group_primary_type
    ADD CONSTRAINT release_group_primary_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group_rating_raw
    ADD CONSTRAINT release_group_rating_raw_pkey PRIMARY KEY (release_group, editor);

ALTER TABLE ONLY release_group_secondary_type_join
    ADD CONSTRAINT release_group_secondary_type_join_pkey PRIMARY KEY (release_group, secondary_type);

ALTER TABLE ONLY release_group_secondary_type
    ADD CONSTRAINT release_group_secondary_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_group_tag
    ADD CONSTRAINT release_group_tag_pkey PRIMARY KEY (release_group, tag);

ALTER TABLE ONLY release_group_tag_raw
    ADD CONSTRAINT release_group_tag_raw_pkey PRIMARY KEY (release_group, editor, tag);

ALTER TABLE ONLY release_label
    ADD CONSTRAINT release_label_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_meta
    ADD CONSTRAINT release_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_packaging
    ADD CONSTRAINT release_packaging_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release
    ADD CONSTRAINT release_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_raw
    ADD CONSTRAINT release_raw_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_status
    ADD CONSTRAINT release_status_pkey PRIMARY KEY (id);

ALTER TABLE ONLY release_tag
    ADD CONSTRAINT release_tag_pkey PRIMARY KEY (release, tag);

ALTER TABLE ONLY release_tag_raw
    ADD CONSTRAINT release_tag_raw_pkey PRIMARY KEY (release, editor, tag);

ALTER TABLE ONLY release_unknown_country
    ADD CONSTRAINT release_unknown_country_pkey PRIMARY KEY (release);

ALTER TABLE ONLY replication_control
    ADD CONSTRAINT replication_control_pkey PRIMARY KEY (id);

ALTER TABLE ONLY script
    ADD CONSTRAINT script_pkey PRIMARY KEY (id);

ALTER TABLE ONLY series_alias
    ADD CONSTRAINT series_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY series_alias_type
    ADD CONSTRAINT series_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY series_annotation
    ADD CONSTRAINT series_annotation_pkey PRIMARY KEY (series, annotation);

ALTER TABLE ONLY series_gid_redirect
    ADD CONSTRAINT series_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY series_ordering_type
    ADD CONSTRAINT series_ordering_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY series
    ADD CONSTRAINT series_pkey PRIMARY KEY (id);

ALTER TABLE ONLY series_tag
    ADD CONSTRAINT series_tag_pkey PRIMARY KEY (series, tag);

ALTER TABLE ONLY series_tag_raw
    ADD CONSTRAINT series_tag_raw_pkey PRIMARY KEY (series, editor, tag);

ALTER TABLE ONLY series_type
    ADD CONSTRAINT series_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (id);

ALTER TABLE ONLY tag_relation
    ADD CONSTRAINT tag_relation_pkey PRIMARY KEY (tag1, tag2);

ALTER TABLE ONLY track_gid_redirect
    ADD CONSTRAINT track_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY track
    ADD CONSTRAINT track_pkey PRIMARY KEY (id);

ALTER TABLE ONLY track_raw
    ADD CONSTRAINT track_raw_pkey PRIMARY KEY (id);

ALTER TABLE ONLY url_gid_redirect
    ADD CONSTRAINT url_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY url
    ADD CONSTRAINT url_pkey PRIMARY KEY (id);

ALTER TABLE ONLY vote
    ADD CONSTRAINT vote_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_alias
    ADD CONSTRAINT work_alias_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_alias_type
    ADD CONSTRAINT work_alias_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_annotation
    ADD CONSTRAINT work_annotation_pkey PRIMARY KEY (work, annotation);

ALTER TABLE ONLY work_attribute
    ADD CONSTRAINT work_attribute_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_attribute_type_allowed_value
    ADD CONSTRAINT work_attribute_type_allowed_value_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_attribute_type
    ADD CONSTRAINT work_attribute_type_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_gid_redirect
    ADD CONSTRAINT work_gid_redirect_pkey PRIMARY KEY (gid);

ALTER TABLE ONLY work_meta
    ADD CONSTRAINT work_meta_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work
    ADD CONSTRAINT work_pkey PRIMARY KEY (id);

ALTER TABLE ONLY work_rating_raw
    ADD CONSTRAINT work_rating_raw_pkey PRIMARY KEY (work, editor);

ALTER TABLE ONLY work_tag
    ADD CONSTRAINT work_tag_pkey PRIMARY KEY (work, tag);

ALTER TABLE ONLY work_tag_raw
    ADD CONSTRAINT work_tag_raw_pkey PRIMARY KEY (work, editor, tag);

ALTER TABLE ONLY work_type
    ADD CONSTRAINT work_type_pkey PRIMARY KEY (id);

CREATE INDEX alternative_medium_idx_alternative_release ON alternative_medium USING btree (alternative_release);

CREATE INDEX alternative_release_idx_artist_credit ON alternative_release USING btree (artist_credit);

CREATE UNIQUE INDEX alternative_release_idx_gid ON alternative_release USING btree (gid);

CREATE INDEX alternative_release_idx_language_script ON alternative_release USING btree (language, script);

CREATE INDEX alternative_release_idx_name ON alternative_release USING btree (name);

CREATE INDEX alternative_release_idx_release ON alternative_release USING btree (release);

CREATE INDEX alternative_track_idx_artist_credit ON alternative_track USING btree (artist_credit);

CREATE INDEX alternative_track_idx_name ON alternative_track USING btree (name);

CREATE UNIQUE INDEX application_idx_oauth_id ON application USING btree (oauth_id);

CREATE INDEX application_idx_owner ON application USING btree (owner);

CREATE INDEX area_alias_idx_area ON area_alias USING btree (area);

CREATE UNIQUE INDEX area_alias_idx_primary ON area_alias USING btree (area, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX area_alias_type_idx_gid ON area_alias_type USING btree (gid);

CREATE INDEX area_gid_redirect_idx_new_id ON area_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX area_idx_gid ON area USING btree (gid);

CREATE INDEX area_idx_name ON area USING btree (name);

CREATE INDEX area_tag_idx_tag ON area_tag USING btree (tag);

CREATE INDEX area_tag_raw_idx_area ON area_tag_raw USING btree (area);

CREATE INDEX area_tag_raw_idx_editor ON area_tag_raw USING btree (editor);

CREATE INDEX area_tag_raw_idx_tag ON area_tag_raw USING btree (tag);

CREATE UNIQUE INDEX area_type_idx_gid ON area_type USING btree (gid);

CREATE INDEX artist_alias_idx_artist ON artist_alias USING btree (artist);

CREATE UNIQUE INDEX artist_alias_idx_primary ON artist_alias USING btree (artist, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX artist_alias_type_idx_gid ON artist_alias_type USING btree (gid);

CREATE INDEX artist_credit_name_idx_artist ON artist_credit_name USING btree (artist);

CREATE INDEX artist_gid_redirect_idx_new_id ON artist_gid_redirect USING btree (new_id);

CREATE INDEX artist_idx_area ON artist USING btree (area);

CREATE INDEX artist_idx_begin_area ON artist USING btree (begin_area);

CREATE INDEX artist_idx_end_area ON artist USING btree (end_area);

CREATE UNIQUE INDEX artist_idx_gid ON artist USING btree (gid);

CREATE INDEX artist_idx_lower_name ON artist USING btree (lower((name)::text));

CREATE INDEX artist_idx_name ON artist USING btree (name);

CREATE UNIQUE INDEX artist_idx_null_comment ON artist USING btree (name) WHERE (comment IS NULL);

CREATE INDEX artist_idx_sort_name ON artist USING btree (sort_name);

CREATE UNIQUE INDEX artist_idx_uniq_name_comment ON artist USING btree (name, comment) WHERE (comment IS NOT NULL);

CREATE INDEX artist_rating_raw_idx_artist ON artist_rating_raw USING btree (artist);

CREATE INDEX artist_rating_raw_idx_editor ON artist_rating_raw USING btree (editor);

CREATE INDEX artist_tag_idx_tag ON artist_tag USING btree (tag);

CREATE INDEX artist_tag_raw_idx_editor ON artist_tag_raw USING btree (editor);

CREATE INDEX artist_tag_raw_idx_tag ON artist_tag_raw USING btree (tag);

CREATE UNIQUE INDEX artist_type_idx_gid ON artist_type USING btree (gid);

CREATE UNIQUE INDEX cdtoc_idx_discid ON cdtoc USING btree (discid);

CREATE INDEX cdtoc_idx_freedb_id ON cdtoc USING btree (freedb_id);

CREATE INDEX cdtoc_raw_discid ON cdtoc_raw USING btree (discid);

CREATE UNIQUE INDEX cdtoc_raw_toc ON cdtoc_raw USING btree (track_count, leadout_offset, track_offset);

CREATE INDEX cdtoc_raw_track_offset ON cdtoc_raw USING btree (track_offset);

CREATE INDEX edit_area_idx ON edit_area USING btree (area);

CREATE INDEX edit_artist_idx ON edit_artist USING btree (artist);

CREATE INDEX edit_artist_idx_status ON edit_artist USING btree (status);

CREATE INDEX edit_event_idx ON edit_event USING btree (event);

CREATE INDEX edit_idx_editor_id_desc ON edit USING btree (editor, id DESC);

CREATE INDEX edit_idx_editor_open_time ON edit USING btree (editor, open_time);

CREATE INDEX edit_idx_status_id ON edit USING btree (status, id) WHERE (status <> 2);

CREATE INDEX edit_idx_type_id ON edit USING btree (type, id);

CREATE INDEX edit_instrument_idx ON edit_instrument USING btree (instrument);

CREATE INDEX edit_label_idx ON edit_label USING btree (label);

CREATE INDEX edit_label_idx_status ON edit_label USING btree (status);

CREATE INDEX edit_note_idx_edit ON edit_note USING btree (edit);

CREATE INDEX edit_note_idx_editor ON edit_note USING btree (editor);

CREATE INDEX edit_note_idx_post_time_edit ON edit_note USING btree (post_time DESC NULLS LAST, edit DESC);

CREATE INDEX edit_note_recipient_idx_recipient ON edit_note_recipient USING btree (recipient);

CREATE INDEX edit_place_idx ON edit_place USING btree (place);

CREATE INDEX edit_recording_idx ON edit_recording USING btree (recording);

CREATE INDEX edit_release_group_idx ON edit_release_group USING btree (release_group);

CREATE INDEX edit_release_idx ON edit_release USING btree (release);

CREATE INDEX edit_series_idx ON edit_series USING btree (series);

CREATE INDEX edit_url_idx ON edit_url USING btree (url);

CREATE INDEX edit_work_idx ON edit_work USING btree (work);

CREATE INDEX editor_collection_idx_editor ON editor_collection USING btree (editor);

CREATE UNIQUE INDEX editor_collection_idx_gid ON editor_collection USING btree (gid);

CREATE INDEX editor_collection_idx_name ON editor_collection USING btree (name);

CREATE UNIQUE INDEX editor_collection_type_idx_gid ON editor_collection_type USING btree (gid);

CREATE UNIQUE INDEX editor_idx_name ON editor USING btree (lower((name)::text));

CREATE INDEX editor_language_idx_language ON editor_language USING btree (language);

CREATE UNIQUE INDEX editor_oauth_token_idx_access_token ON editor_oauth_token USING btree (access_token);

CREATE INDEX editor_oauth_token_idx_editor ON editor_oauth_token USING btree (editor);

CREATE UNIQUE INDEX editor_oauth_token_idx_refresh_token ON editor_oauth_token USING btree (refresh_token);

CREATE UNIQUE INDEX editor_preference_idx_editor_name ON editor_preference USING btree (editor, name);

CREATE INDEX editor_subscribe_artist_idx_artist ON editor_subscribe_artist USING btree (artist);

CREATE UNIQUE INDEX editor_subscribe_artist_idx_uniq ON editor_subscribe_artist USING btree (editor, artist);

CREATE INDEX editor_subscribe_collection_idx_collection ON editor_subscribe_collection USING btree (collection);

CREATE UNIQUE INDEX editor_subscribe_collection_idx_uniq ON editor_subscribe_collection USING btree (editor, collection);

CREATE UNIQUE INDEX editor_subscribe_editor_idx_uniq ON editor_subscribe_editor USING btree (editor, subscribed_editor);

CREATE INDEX editor_subscribe_label_idx_label ON editor_subscribe_label USING btree (label);

CREATE UNIQUE INDEX editor_subscribe_label_idx_uniq ON editor_subscribe_label USING btree (editor, label);

CREATE INDEX editor_subscribe_series_idx_series ON editor_subscribe_series USING btree (series);

CREATE UNIQUE INDEX editor_subscribe_series_idx_uniq ON editor_subscribe_series USING btree (editor, series);

CREATE INDEX event_alias_idx_event ON event_alias USING btree (event);

CREATE UNIQUE INDEX event_alias_idx_primary ON event_alias USING btree (event, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX event_alias_type_idx_gid ON event_alias_type USING btree (gid);

CREATE INDEX event_gid_redirect_idx_new_id ON event_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX event_idx_gid ON event USING btree (gid);

CREATE INDEX event_idx_name ON event USING btree (name);

CREATE INDEX event_rating_raw_idx_editor ON event_rating_raw USING btree (editor);

CREATE INDEX event_rating_raw_idx_event ON event_rating_raw USING btree (event);

CREATE INDEX event_tag_idx_tag ON event_tag USING btree (tag);

CREATE INDEX event_tag_raw_idx_editor ON event_tag_raw USING btree (editor);

CREATE INDEX event_tag_raw_idx_tag ON event_tag_raw USING btree (tag);

CREATE UNIQUE INDEX event_type_idx_gid ON event_type USING btree (gid);

CREATE UNIQUE INDEX gender_idx_gid ON gender USING btree (gid);

CREATE INDEX instrument_alias_idx_instrument ON instrument_alias USING btree (instrument);

CREATE UNIQUE INDEX instrument_alias_idx_primary ON instrument_alias USING btree (instrument, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX instrument_alias_type_idx_gid ON instrument_alias_type USING btree (gid);

CREATE INDEX instrument_gid_redirect_idx_new_id ON instrument_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX instrument_idx_gid ON instrument USING btree (gid);

CREATE INDEX instrument_idx_name ON instrument USING btree (name);

CREATE INDEX instrument_tag_idx_tag ON instrument_tag USING btree (tag);

CREATE INDEX instrument_tag_raw_idx_editor ON instrument_tag_raw USING btree (editor);

CREATE INDEX instrument_tag_raw_idx_instrument ON instrument_tag_raw USING btree (instrument);

CREATE INDEX instrument_tag_raw_idx_tag ON instrument_tag_raw USING btree (tag);

CREATE UNIQUE INDEX instrument_type_idx_gid ON instrument_type USING btree (gid);

CREATE INDEX iso_3166_1_idx_area ON iso_3166_1 USING btree (area);

CREATE INDEX iso_3166_2_idx_area ON iso_3166_2 USING btree (area);

CREATE INDEX iso_3166_3_idx_area ON iso_3166_3 USING btree (area);

CREATE INDEX isrc_idx_isrc ON isrc USING btree (isrc);

CREATE UNIQUE INDEX isrc_idx_isrc_recording ON isrc USING btree (isrc, recording);

CREATE INDEX isrc_idx_recording ON isrc USING btree (recording);

CREATE UNIQUE INDEX iswc_idx_iswc ON iswc USING btree (iswc, work);

CREATE INDEX iswc_idx_work ON iswc USING btree (work);

CREATE INDEX l_area_area_idx_entity1 ON l_area_area USING btree (entity1);

CREATE UNIQUE INDEX l_area_area_idx_uniq ON l_area_area USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_artist_idx_entity1 ON l_area_artist USING btree (entity1);

CREATE UNIQUE INDEX l_area_artist_idx_uniq ON l_area_artist USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_event_idx_entity1 ON l_area_event USING btree (entity1);

CREATE UNIQUE INDEX l_area_event_idx_uniq ON l_area_event USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_instrument_idx_entity1 ON l_area_instrument USING btree (entity1);

CREATE UNIQUE INDEX l_area_instrument_idx_uniq ON l_area_instrument USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_label_idx_entity1 ON l_area_label USING btree (entity1);

CREATE UNIQUE INDEX l_area_label_idx_uniq ON l_area_label USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_place_idx_entity1 ON l_area_place USING btree (entity1);

CREATE UNIQUE INDEX l_area_place_idx_uniq ON l_area_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_recording_idx_entity1 ON l_area_recording USING btree (entity1);

CREATE UNIQUE INDEX l_area_recording_idx_uniq ON l_area_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_release_group_idx_entity1 ON l_area_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_area_release_group_idx_uniq ON l_area_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_release_idx_entity1 ON l_area_release USING btree (entity1);

CREATE UNIQUE INDEX l_area_release_idx_uniq ON l_area_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_series_idx_entity1 ON l_area_series USING btree (entity1);

CREATE UNIQUE INDEX l_area_series_idx_uniq ON l_area_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_url_idx_entity1 ON l_area_url USING btree (entity1);

CREATE UNIQUE INDEX l_area_url_idx_uniq ON l_area_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_area_work_idx_entity1 ON l_area_work USING btree (entity1);

CREATE UNIQUE INDEX l_area_work_idx_uniq ON l_area_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_artist_idx_entity1 ON l_artist_artist USING btree (entity1);

CREATE UNIQUE INDEX l_artist_artist_idx_uniq ON l_artist_artist USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_event_idx_entity1 ON l_artist_event USING btree (entity1);

CREATE UNIQUE INDEX l_artist_event_idx_uniq ON l_artist_event USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_instrument_idx_entity1 ON l_artist_instrument USING btree (entity1);

CREATE UNIQUE INDEX l_artist_instrument_idx_uniq ON l_artist_instrument USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_label_idx_entity1 ON l_artist_label USING btree (entity1);

CREATE UNIQUE INDEX l_artist_label_idx_uniq ON l_artist_label USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_place_idx_entity1 ON l_artist_place USING btree (entity1);

CREATE UNIQUE INDEX l_artist_place_idx_uniq ON l_artist_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_recording_idx_entity1 ON l_artist_recording USING btree (entity1);

CREATE UNIQUE INDEX l_artist_recording_idx_uniq ON l_artist_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_release_group_idx_entity1 ON l_artist_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_artist_release_group_idx_uniq ON l_artist_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_release_idx_entity1 ON l_artist_release USING btree (entity1);

CREATE UNIQUE INDEX l_artist_release_idx_uniq ON l_artist_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_series_idx_entity1 ON l_artist_series USING btree (entity1);

CREATE UNIQUE INDEX l_artist_series_idx_uniq ON l_artist_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_url_idx_entity1 ON l_artist_url USING btree (entity1);

CREATE UNIQUE INDEX l_artist_url_idx_uniq ON l_artist_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_artist_work_idx_entity1 ON l_artist_work USING btree (entity1);

CREATE UNIQUE INDEX l_artist_work_idx_uniq ON l_artist_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_event_idx_entity1 ON l_event_event USING btree (entity1);

CREATE UNIQUE INDEX l_event_event_idx_uniq ON l_event_event USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_instrument_idx_entity1 ON l_event_instrument USING btree (entity1);

CREATE UNIQUE INDEX l_event_instrument_idx_uniq ON l_event_instrument USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_label_idx_entity1 ON l_event_label USING btree (entity1);

CREATE UNIQUE INDEX l_event_label_idx_uniq ON l_event_label USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_place_idx_entity1 ON l_event_place USING btree (entity1);

CREATE UNIQUE INDEX l_event_place_idx_uniq ON l_event_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_recording_idx_entity1 ON l_event_recording USING btree (entity1);

CREATE UNIQUE INDEX l_event_recording_idx_uniq ON l_event_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_release_group_idx_entity1 ON l_event_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_event_release_group_idx_uniq ON l_event_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_release_idx_entity1 ON l_event_release USING btree (entity1);

CREATE UNIQUE INDEX l_event_release_idx_uniq ON l_event_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_series_idx_entity1 ON l_event_series USING btree (entity1);

CREATE UNIQUE INDEX l_event_series_idx_uniq ON l_event_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_url_idx_entity1 ON l_event_url USING btree (entity1);

CREATE UNIQUE INDEX l_event_url_idx_uniq ON l_event_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_event_work_idx_entity1 ON l_event_work USING btree (entity1);

CREATE UNIQUE INDEX l_event_work_idx_uniq ON l_event_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_instrument_idx_entity1 ON l_instrument_instrument USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_instrument_idx_uniq ON l_instrument_instrument USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_label_idx_entity1 ON l_instrument_label USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_label_idx_uniq ON l_instrument_label USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_place_idx_entity1 ON l_instrument_place USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_place_idx_uniq ON l_instrument_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_recording_idx_entity1 ON l_instrument_recording USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_recording_idx_uniq ON l_instrument_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_release_group_idx_entity1 ON l_instrument_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_release_group_idx_uniq ON l_instrument_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_release_idx_entity1 ON l_instrument_release USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_release_idx_uniq ON l_instrument_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_series_idx_entity1 ON l_instrument_series USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_series_idx_uniq ON l_instrument_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_url_idx_entity1 ON l_instrument_url USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_url_idx_uniq ON l_instrument_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_instrument_work_idx_entity1 ON l_instrument_work USING btree (entity1);

CREATE UNIQUE INDEX l_instrument_work_idx_uniq ON l_instrument_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_label_idx_entity1 ON l_label_label USING btree (entity1);

CREATE UNIQUE INDEX l_label_label_idx_uniq ON l_label_label USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_place_idx_entity1 ON l_label_place USING btree (entity1);

CREATE UNIQUE INDEX l_label_place_idx_uniq ON l_label_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_recording_idx_entity1 ON l_label_recording USING btree (entity1);

CREATE UNIQUE INDEX l_label_recording_idx_uniq ON l_label_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_release_group_idx_entity1 ON l_label_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_label_release_group_idx_uniq ON l_label_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_release_idx_entity1 ON l_label_release USING btree (entity1);

CREATE UNIQUE INDEX l_label_release_idx_uniq ON l_label_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_series_idx_entity1 ON l_label_series USING btree (entity1);

CREATE UNIQUE INDEX l_label_series_idx_uniq ON l_label_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_url_idx_entity1 ON l_label_url USING btree (entity1);

CREATE UNIQUE INDEX l_label_url_idx_uniq ON l_label_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_label_work_idx_entity1 ON l_label_work USING btree (entity1);

CREATE UNIQUE INDEX l_label_work_idx_uniq ON l_label_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_place_idx_entity1 ON l_place_place USING btree (entity1);

CREATE UNIQUE INDEX l_place_place_idx_uniq ON l_place_place USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_recording_idx_entity1 ON l_place_recording USING btree (entity1);

CREATE UNIQUE INDEX l_place_recording_idx_uniq ON l_place_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_release_group_idx_entity1 ON l_place_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_place_release_group_idx_uniq ON l_place_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_release_idx_entity1 ON l_place_release USING btree (entity1);

CREATE UNIQUE INDEX l_place_release_idx_uniq ON l_place_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_series_idx_entity1 ON l_place_series USING btree (entity1);

CREATE UNIQUE INDEX l_place_series_idx_uniq ON l_place_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_url_idx_entity1 ON l_place_url USING btree (entity1);

CREATE UNIQUE INDEX l_place_url_idx_uniq ON l_place_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_place_work_idx_entity1 ON l_place_work USING btree (entity1);

CREATE UNIQUE INDEX l_place_work_idx_uniq ON l_place_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_recording_idx_entity1 ON l_recording_recording USING btree (entity1);

CREATE UNIQUE INDEX l_recording_recording_idx_uniq ON l_recording_recording USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_release_group_idx_entity1 ON l_recording_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_recording_release_group_idx_uniq ON l_recording_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_release_idx_entity1 ON l_recording_release USING btree (entity1);

CREATE UNIQUE INDEX l_recording_release_idx_uniq ON l_recording_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_series_idx_entity1 ON l_recording_series USING btree (entity1);

CREATE UNIQUE INDEX l_recording_series_idx_uniq ON l_recording_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_url_idx_entity1 ON l_recording_url USING btree (entity1);

CREATE UNIQUE INDEX l_recording_url_idx_uniq ON l_recording_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_recording_work_idx_entity1 ON l_recording_work USING btree (entity1);

CREATE UNIQUE INDEX l_recording_work_idx_uniq ON l_recording_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_group_release_group_idx_entity1 ON l_release_group_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_release_group_release_group_idx_uniq ON l_release_group_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_group_series_idx_entity1 ON l_release_group_series USING btree (entity1);

CREATE UNIQUE INDEX l_release_group_series_idx_uniq ON l_release_group_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_group_url_idx_entity1 ON l_release_group_url USING btree (entity1);

CREATE UNIQUE INDEX l_release_group_url_idx_uniq ON l_release_group_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_group_work_idx_entity1 ON l_release_group_work USING btree (entity1);

CREATE UNIQUE INDEX l_release_group_work_idx_uniq ON l_release_group_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_release_group_idx_entity1 ON l_release_release_group USING btree (entity1);

CREATE UNIQUE INDEX l_release_release_group_idx_uniq ON l_release_release_group USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_release_idx_entity1 ON l_release_release USING btree (entity1);

CREATE UNIQUE INDEX l_release_release_idx_uniq ON l_release_release USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_series_idx_entity1 ON l_release_series USING btree (entity1);

CREATE UNIQUE INDEX l_release_series_idx_uniq ON l_release_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_url_idx_entity1 ON l_release_url USING btree (entity1);

CREATE UNIQUE INDEX l_release_url_idx_uniq ON l_release_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_release_work_idx_entity1 ON l_release_work USING btree (entity1);

CREATE UNIQUE INDEX l_release_work_idx_uniq ON l_release_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_series_series_idx_entity1 ON l_series_series USING btree (entity1);

CREATE UNIQUE INDEX l_series_series_idx_uniq ON l_series_series USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_series_url_idx_entity1 ON l_series_url USING btree (entity1);

CREATE UNIQUE INDEX l_series_url_idx_uniq ON l_series_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_series_work_idx_entity1 ON l_series_work USING btree (entity1);

CREATE UNIQUE INDEX l_series_work_idx_uniq ON l_series_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_url_url_idx_entity1 ON l_url_url USING btree (entity1);

CREATE UNIQUE INDEX l_url_url_idx_uniq ON l_url_url USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_url_work_idx_entity1 ON l_url_work USING btree (entity1);

CREATE UNIQUE INDEX l_url_work_idx_uniq ON l_url_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX l_work_work_idx_entity1 ON l_work_work USING btree (entity1);

CREATE UNIQUE INDEX l_work_work_idx_uniq ON l_work_work USING btree (entity0, entity1, link, link_order);

CREATE INDEX label_alias_idx_label ON label_alias USING btree (label);

CREATE UNIQUE INDEX label_alias_idx_primary ON label_alias USING btree (label, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX label_alias_type_idx_gid ON label_alias_type USING btree (gid);

CREATE INDEX label_gid_redirect_idx_new_id ON label_gid_redirect USING btree (new_id);

CREATE INDEX label_idx_area ON label USING btree (area);

CREATE UNIQUE INDEX label_idx_gid ON label USING btree (gid);

CREATE INDEX label_idx_lower_name ON label USING btree (lower((name)::text));

CREATE INDEX label_idx_name ON label USING btree (name);

CREATE UNIQUE INDEX label_idx_null_comment ON label USING btree (name) WHERE (comment IS NULL);

CREATE UNIQUE INDEX label_idx_uniq_name_comment ON label USING btree (name, comment) WHERE (comment IS NOT NULL);

CREATE INDEX label_rating_raw_idx_editor ON label_rating_raw USING btree (editor);

CREATE INDEX label_rating_raw_idx_label ON label_rating_raw USING btree (label);

CREATE INDEX label_tag_idx_tag ON label_tag USING btree (tag);

CREATE INDEX label_tag_raw_idx_editor ON label_tag_raw USING btree (editor);

CREATE INDEX label_tag_raw_idx_tag ON label_tag_raw USING btree (tag);

CREATE UNIQUE INDEX label_type_idx_gid ON label_type USING btree (gid);

CREATE UNIQUE INDEX language_idx_iso_code_1 ON language USING btree (iso_code_1);

CREATE UNIQUE INDEX language_idx_iso_code_2b ON language USING btree (iso_code_2b);

CREATE UNIQUE INDEX language_idx_iso_code_2t ON language USING btree (iso_code_2t);

CREATE UNIQUE INDEX language_idx_iso_code_3 ON language USING btree (iso_code_3);

CREATE UNIQUE INDEX link_attribute_type_idx_gid ON link_attribute_type USING btree (gid);

CREATE INDEX link_idx_type_attr ON link USING btree (link_type, attribute_count);

CREATE UNIQUE INDEX link_type_idx_gid ON link_type USING btree (gid);

CREATE INDEX medium_cdtoc_idx_cdtoc ON medium_cdtoc USING btree (cdtoc);

CREATE INDEX medium_cdtoc_idx_medium ON medium_cdtoc USING btree (medium);

CREATE UNIQUE INDEX medium_cdtoc_idx_uniq ON medium_cdtoc USING btree (medium, cdtoc);

CREATE UNIQUE INDEX medium_format_idx_gid ON medium_format USING btree (gid);

CREATE INDEX medium_idx_track_count ON medium USING btree (track_count);

CREATE INDEX place_alias_idx_place ON place_alias USING btree (place);

CREATE UNIQUE INDEX place_alias_idx_primary ON place_alias USING btree (place, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE UNIQUE INDEX place_alias_type_idx_gid ON place_alias_type USING btree (gid);

CREATE INDEX place_gid_redirect_idx_new_id ON place_gid_redirect USING btree (new_id);

CREATE INDEX place_idx_area ON place USING btree (area);

CREATE UNIQUE INDEX place_idx_gid ON place USING btree (gid);

CREATE INDEX place_idx_name ON place USING btree (name);

CREATE INDEX place_tag_idx_tag ON place_tag USING btree (tag);

CREATE INDEX place_tag_raw_idx_editor ON place_tag_raw USING btree (editor);

CREATE INDEX place_tag_raw_idx_tag ON place_tag_raw USING btree (tag);

CREATE UNIQUE INDEX place_type_idx_gid ON place_type USING btree (gid);

CREATE UNIQUE INDEX recording_alias_idx_primary ON recording_alias USING btree (recording, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE INDEX recording_alias_idx_recording ON recording_alias USING btree (recording);

CREATE UNIQUE INDEX recording_alias_type_idx_gid ON recording_alias_type USING btree (gid);

CREATE INDEX recording_gid_redirect_idx_new_id ON recording_gid_redirect USING btree (new_id);

CREATE INDEX recording_idx_artist_credit ON recording USING btree (artist_credit);

CREATE UNIQUE INDEX recording_idx_gid ON recording USING btree (gid);

CREATE INDEX recording_idx_name ON recording USING btree (name);

CREATE INDEX recording_rating_raw_idx_editor ON recording_rating_raw USING btree (editor);

CREATE INDEX recording_tag_idx_tag ON recording_tag USING btree (tag);

CREATE INDEX recording_tag_raw_idx_editor ON recording_tag_raw USING btree (editor);

CREATE INDEX recording_tag_raw_idx_tag ON recording_tag_raw USING btree (tag);

CREATE INDEX recording_tag_raw_idx_track ON recording_tag_raw USING btree (recording);

CREATE UNIQUE INDEX release_alias_idx_primary ON release_alias USING btree (release, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE INDEX release_alias_idx_release ON release_alias USING btree (release);

CREATE INDEX release_country_idx_country ON release_country USING btree (country);

CREATE INDEX release_gid_redirect_idx_new_id ON release_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX release_group_alias_idx_primary ON release_group_alias USING btree (release_group, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE INDEX release_group_alias_idx_release_group ON release_group_alias USING btree (release_group);

CREATE UNIQUE INDEX release_group_alias_type_idx_gid ON release_group_alias_type USING btree (gid);

CREATE INDEX release_group_gid_redirect_idx_new_id ON release_group_gid_redirect USING btree (new_id);

CREATE INDEX release_group_idx_artist_credit ON release_group USING btree (artist_credit);

CREATE UNIQUE INDEX release_group_idx_gid ON release_group USING btree (gid);

CREATE INDEX release_group_idx_name ON release_group USING btree (name);

CREATE UNIQUE INDEX release_group_primary_type_idx_gid ON release_group_primary_type USING btree (gid);

CREATE INDEX release_group_rating_raw_idx_editor ON release_group_rating_raw USING btree (editor);

CREATE INDEX release_group_rating_raw_idx_release_group ON release_group_rating_raw USING btree (release_group);

CREATE UNIQUE INDEX release_group_secondary_type_idx_gid ON release_group_secondary_type USING btree (gid);

CREATE INDEX release_group_tag_idx_tag ON release_group_tag USING btree (tag);

CREATE INDEX release_group_tag_raw_idx_editor ON release_group_tag_raw USING btree (editor);

CREATE INDEX release_group_tag_raw_idx_tag ON release_group_tag_raw USING btree (tag);

CREATE INDEX release_idx_artist_credit ON release USING btree (artist_credit);

CREATE UNIQUE INDEX release_idx_gid ON release USING btree (gid);

CREATE INDEX release_idx_name ON release USING btree (name);

CREATE INDEX release_idx_release_group ON release USING btree (release_group);

CREATE INDEX release_label_idx_label ON release_label USING btree (label);

CREATE INDEX release_label_idx_release ON release_label USING btree (release);

CREATE UNIQUE INDEX release_packaging_idx_gid ON release_packaging USING btree (gid);

CREATE INDEX release_raw_idx_last_modified ON release_raw USING btree (last_modified);

CREATE INDEX release_raw_idx_lookup_count ON release_raw USING btree (lookup_count);

CREATE INDEX release_raw_idx_modify_count ON release_raw USING btree (modify_count);

CREATE UNIQUE INDEX release_status_idx_gid ON release_status USING btree (gid);

CREATE INDEX release_tag_idx_tag ON release_tag USING btree (tag);

CREATE INDEX release_tag_raw_idx_editor ON release_tag_raw USING btree (editor);

CREATE INDEX release_tag_raw_idx_tag ON release_tag_raw USING btree (tag);

CREATE UNIQUE INDEX script_idx_iso_code ON script USING btree (iso_code);

CREATE UNIQUE INDEX series_alias_idx_primary ON series_alias USING btree (series, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE INDEX series_alias_idx_series ON series_alias USING btree (series);

CREATE UNIQUE INDEX series_alias_type_idx_gid ON series_alias_type USING btree (gid);

CREATE INDEX series_gid_redirect_idx_new_id ON series_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX series_idx_gid ON series USING btree (gid);

CREATE INDEX series_idx_name ON series USING btree (name);

CREATE UNIQUE INDEX series_ordering_type_idx_gid ON series_ordering_type USING btree (gid);

CREATE INDEX series_tag_idx_tag ON series_tag USING btree (tag);

CREATE INDEX series_tag_raw_idx_editor ON series_tag_raw USING btree (editor);

CREATE INDEX series_tag_raw_idx_series ON series_tag_raw USING btree (series);

CREATE INDEX series_tag_raw_idx_tag ON series_tag_raw USING btree (tag);

CREATE UNIQUE INDEX series_type_idx_gid ON series_type USING btree (gid);

CREATE UNIQUE INDEX tag_idx_name ON tag USING btree (name);

CREATE INDEX track_gid_redirect_idx_new_id ON track_gid_redirect USING btree (new_id);

CREATE INDEX track_idx_artist_credit ON track USING btree (artist_credit);

CREATE UNIQUE INDEX track_idx_gid ON track USING btree (gid);

CREATE INDEX track_idx_name ON track USING btree (name);

CREATE INDEX track_idx_recording ON track USING btree (recording);

CREATE INDEX track_raw_idx_release ON track_raw USING btree (release);

CREATE INDEX url_gid_redirect_idx_new_id ON url_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX url_idx_gid ON url USING btree (gid);

CREATE UNIQUE INDEX url_idx_url ON url USING btree (url);

CREATE INDEX vote_idx_edit ON vote USING btree (edit);

CREATE INDEX vote_idx_editor_edit ON vote USING btree (editor, edit) WHERE (superseded = false);

CREATE INDEX vote_idx_editor_vote_time ON vote USING btree (editor, vote_time);

CREATE UNIQUE INDEX work_alias_idx_primary ON work_alias USING btree (work, locale) WHERE ((primary_for_locale = true) AND (locale IS NOT NULL));

CREATE INDEX work_alias_idx_work ON work_alias USING btree (work);

CREATE UNIQUE INDEX work_alias_type_idx_gid ON work_alias_type USING btree (gid);

CREATE INDEX work_attribute_idx_work ON work_attribute USING btree (work);

CREATE UNIQUE INDEX work_attribute_type_allowed_value_idx_gid ON work_attribute_type_allowed_value USING btree (gid);

CREATE INDEX work_attribute_type_allowed_value_idx_name ON work_attribute_type_allowed_value USING btree (work_attribute_type);

CREATE UNIQUE INDEX work_attribute_type_idx_gid ON work_attribute_type USING btree (gid);

CREATE INDEX work_gid_redirect_idx_new_id ON work_gid_redirect USING btree (new_id);

CREATE UNIQUE INDEX work_idx_gid ON work USING btree (gid);

CREATE INDEX work_idx_name ON work USING btree (name);

CREATE INDEX work_tag_idx_tag ON work_tag USING btree (tag);

CREATE INDEX work_tag_raw_idx_tag ON work_tag_raw USING btree (tag);

CREATE UNIQUE INDEX work_type_idx_gid ON work_type USING btree (gid);

ALTER TABLE ONLY alternative_medium
    ADD CONSTRAINT alternative_medium_fk_alternative_release FOREIGN KEY (alternative_release) REFERENCES alternative_release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_medium
    ADD CONSTRAINT alternative_medium_fk_medium FOREIGN KEY (medium) REFERENCES medium(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_medium_track
    ADD CONSTRAINT alternative_medium_track_fk_alternative_medium FOREIGN KEY (alternative_medium) REFERENCES alternative_medium(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_medium_track
    ADD CONSTRAINT alternative_medium_track_fk_alternative_track FOREIGN KEY (alternative_track) REFERENCES alternative_track(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_medium_track
    ADD CONSTRAINT alternative_medium_track_fk_track FOREIGN KEY (track) REFERENCES track(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_fk_language FOREIGN KEY (language) REFERENCES language(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_fk_script FOREIGN KEY (script) REFERENCES script(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release
    ADD CONSTRAINT alternative_release_fk_type FOREIGN KEY (type) REFERENCES alternative_release_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_release_type
    ADD CONSTRAINT alternative_release_type_fk_parent FOREIGN KEY (parent) REFERENCES alternative_release_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY alternative_track
    ADD CONSTRAINT alternative_track_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY annotation
    ADD CONSTRAINT annotation_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY application
    ADD CONSTRAINT application_fk_owner FOREIGN KEY (owner) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_alias
    ADD CONSTRAINT area_alias_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_alias
    ADD CONSTRAINT area_alias_fk_type FOREIGN KEY (type) REFERENCES area_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_alias_type
    ADD CONSTRAINT area_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES area_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_annotation
    ADD CONSTRAINT area_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_annotation
    ADD CONSTRAINT area_annotation_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area
    ADD CONSTRAINT area_fk_type FOREIGN KEY (type) REFERENCES area_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_gid_redirect
    ADD CONSTRAINT area_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_tag
    ADD CONSTRAINT area_tag_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_tag
    ADD CONSTRAINT area_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_tag_raw
    ADD CONSTRAINT area_tag_raw_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_tag_raw
    ADD CONSTRAINT area_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_tag_raw
    ADD CONSTRAINT area_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY area_type
    ADD CONSTRAINT area_type_fk_parent FOREIGN KEY (parent) REFERENCES area_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_alias
    ADD CONSTRAINT artist_alias_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_alias
    ADD CONSTRAINT artist_alias_fk_type FOREIGN KEY (type) REFERENCES artist_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_alias_type
    ADD CONSTRAINT artist_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES artist_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_annotation
    ADD CONSTRAINT artist_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_annotation
    ADD CONSTRAINT artist_annotation_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_credit_name
    ADD CONSTRAINT artist_credit_name_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_credit_name
    ADD CONSTRAINT artist_credit_name_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_fk_begin_area FOREIGN KEY (begin_area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_fk_end_area FOREIGN KEY (end_area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_fk_gender FOREIGN KEY (gender) REFERENCES gender(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist
    ADD CONSTRAINT artist_fk_type FOREIGN KEY (type) REFERENCES artist_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_gid_redirect
    ADD CONSTRAINT artist_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_ipi
    ADD CONSTRAINT artist_ipi_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_isni
    ADD CONSTRAINT artist_isni_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_meta
    ADD CONSTRAINT artist_meta_fk_id FOREIGN KEY (id) REFERENCES artist(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_rating_raw
    ADD CONSTRAINT artist_rating_raw_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_rating_raw
    ADD CONSTRAINT artist_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_tag
    ADD CONSTRAINT artist_tag_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_tag
    ADD CONSTRAINT artist_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_tag_raw
    ADD CONSTRAINT artist_tag_raw_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_tag_raw
    ADD CONSTRAINT artist_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_tag_raw
    ADD CONSTRAINT artist_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY artist_type
    ADD CONSTRAINT artist_type_fk_parent FOREIGN KEY (parent) REFERENCES artist_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election
    ADD CONSTRAINT autoeditor_election_fk_candidate FOREIGN KEY (candidate) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election
    ADD CONSTRAINT autoeditor_election_fk_proposer FOREIGN KEY (proposer) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election
    ADD CONSTRAINT autoeditor_election_fk_seconder_1 FOREIGN KEY (seconder_1) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election
    ADD CONSTRAINT autoeditor_election_fk_seconder_2 FOREIGN KEY (seconder_2) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election_vote
    ADD CONSTRAINT autoeditor_election_vote_fk_autoeditor_election FOREIGN KEY (autoeditor_election) REFERENCES autoeditor_election(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY autoeditor_election_vote
    ADD CONSTRAINT autoeditor_election_vote_fk_voter FOREIGN KEY (voter) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY cdtoc_raw
    ADD CONSTRAINT cdtoc_raw_fk_release FOREIGN KEY (release) REFERENCES release_raw(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY country_area
    ADD CONSTRAINT country_area_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_area
    ADD CONSTRAINT edit_area_fk_area FOREIGN KEY (area) REFERENCES area(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_area
    ADD CONSTRAINT edit_area_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_artist
    ADD CONSTRAINT edit_artist_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_artist
    ADD CONSTRAINT edit_artist_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_data
    ADD CONSTRAINT edit_data_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_event
    ADD CONSTRAINT edit_event_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_event
    ADD CONSTRAINT edit_event_fk_event FOREIGN KEY (event) REFERENCES event(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit
    ADD CONSTRAINT edit_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit
    ADD CONSTRAINT edit_fk_language FOREIGN KEY (language) REFERENCES language(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_instrument
    ADD CONSTRAINT edit_instrument_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_instrument
    ADD CONSTRAINT edit_instrument_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_label
    ADD CONSTRAINT edit_label_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_label
    ADD CONSTRAINT edit_label_fk_label FOREIGN KEY (label) REFERENCES label(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_note
    ADD CONSTRAINT edit_note_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_note
    ADD CONSTRAINT edit_note_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_note_recipient
    ADD CONSTRAINT edit_note_recipient_fk_edit_note FOREIGN KEY (edit_note) REFERENCES edit_note(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_note_recipient
    ADD CONSTRAINT edit_note_recipient_fk_recipient FOREIGN KEY (recipient) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_place
    ADD CONSTRAINT edit_place_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_place
    ADD CONSTRAINT edit_place_fk_place FOREIGN KEY (place) REFERENCES place(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_recording
    ADD CONSTRAINT edit_recording_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_recording
    ADD CONSTRAINT edit_recording_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_release
    ADD CONSTRAINT edit_release_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_release
    ADD CONSTRAINT edit_release_fk_release FOREIGN KEY (release) REFERENCES release(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_release_group
    ADD CONSTRAINT edit_release_group_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_release_group
    ADD CONSTRAINT edit_release_group_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_series
    ADD CONSTRAINT edit_series_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_series
    ADD CONSTRAINT edit_series_fk_series FOREIGN KEY (series) REFERENCES series(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_url
    ADD CONSTRAINT edit_url_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_url
    ADD CONSTRAINT edit_url_fk_url FOREIGN KEY (url) REFERENCES url(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_work
    ADD CONSTRAINT edit_work_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY edit_work
    ADD CONSTRAINT edit_work_fk_work FOREIGN KEY (work) REFERENCES work(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_area
    ADD CONSTRAINT editor_collection_area_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_area
    ADD CONSTRAINT editor_collection_area_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_artist
    ADD CONSTRAINT editor_collection_artist_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_artist
    ADD CONSTRAINT editor_collection_artist_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_deleted_entity
    ADD CONSTRAINT editor_collection_deleted_entity_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_deleted_entity
    ADD CONSTRAINT editor_collection_deleted_entity_fk_gid FOREIGN KEY (gid) REFERENCES deleted_entity(gid) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_event
    ADD CONSTRAINT editor_collection_event_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_event
    ADD CONSTRAINT editor_collection_event_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection
    ADD CONSTRAINT editor_collection_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection
    ADD CONSTRAINT editor_collection_fk_type FOREIGN KEY (type) REFERENCES editor_collection_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_instrument
    ADD CONSTRAINT editor_collection_instrument_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_instrument
    ADD CONSTRAINT editor_collection_instrument_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_label
    ADD CONSTRAINT editor_collection_label_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_label
    ADD CONSTRAINT editor_collection_label_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_place
    ADD CONSTRAINT editor_collection_place_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_place
    ADD CONSTRAINT editor_collection_place_fk_place FOREIGN KEY (place) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_recording
    ADD CONSTRAINT editor_collection_recording_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_recording
    ADD CONSTRAINT editor_collection_recording_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_release
    ADD CONSTRAINT editor_collection_release_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_release
    ADD CONSTRAINT editor_collection_release_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_release_group
    ADD CONSTRAINT editor_collection_release_group_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_release_group
    ADD CONSTRAINT editor_collection_release_group_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_series
    ADD CONSTRAINT editor_collection_series_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_series
    ADD CONSTRAINT editor_collection_series_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_type
    ADD CONSTRAINT editor_collection_type_fk_parent FOREIGN KEY (parent) REFERENCES editor_collection_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_work
    ADD CONSTRAINT editor_collection_work_fk_collection FOREIGN KEY (collection) REFERENCES editor_collection(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_collection_work
    ADD CONSTRAINT editor_collection_work_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor
    ADD CONSTRAINT editor_fk_gender FOREIGN KEY (gender) REFERENCES gender(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_language
    ADD CONSTRAINT editor_language_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_language
    ADD CONSTRAINT editor_language_fk_language FOREIGN KEY (language) REFERENCES language(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_oauth_token
    ADD CONSTRAINT editor_oauth_token_fk_application FOREIGN KEY (application) REFERENCES application(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_oauth_token
    ADD CONSTRAINT editor_oauth_token_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_preference
    ADD CONSTRAINT editor_preference_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist_deleted
    ADD CONSTRAINT editor_subscribe_artist_deleted_fk_deleted_by FOREIGN KEY (deleted_by) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist_deleted
    ADD CONSTRAINT editor_subscribe_artist_deleted_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist_deleted
    ADD CONSTRAINT editor_subscribe_artist_deleted_fk_gid FOREIGN KEY (gid) REFERENCES deleted_entity(gid) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist
    ADD CONSTRAINT editor_subscribe_artist_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist
    ADD CONSTRAINT editor_subscribe_artist_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_artist
    ADD CONSTRAINT editor_subscribe_artist_fk_last_edit_sent FOREIGN KEY (last_edit_sent) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_collection
    ADD CONSTRAINT editor_subscribe_collection_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_editor
    ADD CONSTRAINT editor_subscribe_editor_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_editor
    ADD CONSTRAINT editor_subscribe_editor_fk_subscribed_editor FOREIGN KEY (subscribed_editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label_deleted
    ADD CONSTRAINT editor_subscribe_label_deleted_fk_deleted_by FOREIGN KEY (deleted_by) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label_deleted
    ADD CONSTRAINT editor_subscribe_label_deleted_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label_deleted
    ADD CONSTRAINT editor_subscribe_label_deleted_fk_gid FOREIGN KEY (gid) REFERENCES deleted_entity(gid) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label
    ADD CONSTRAINT editor_subscribe_label_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label
    ADD CONSTRAINT editor_subscribe_label_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_label
    ADD CONSTRAINT editor_subscribe_label_fk_last_edit_sent FOREIGN KEY (last_edit_sent) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series_deleted
    ADD CONSTRAINT editor_subscribe_series_deleted_fk_deleted_by FOREIGN KEY (deleted_by) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series_deleted
    ADD CONSTRAINT editor_subscribe_series_deleted_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series_deleted
    ADD CONSTRAINT editor_subscribe_series_deleted_fk_gid FOREIGN KEY (gid) REFERENCES deleted_entity(gid) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series
    ADD CONSTRAINT editor_subscribe_series_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series
    ADD CONSTRAINT editor_subscribe_series_fk_last_edit_sent FOREIGN KEY (last_edit_sent) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_subscribe_series
    ADD CONSTRAINT editor_subscribe_series_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_artist
    ADD CONSTRAINT editor_watch_artist_fk_artist FOREIGN KEY (artist) REFERENCES artist(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_artist
    ADD CONSTRAINT editor_watch_artist_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_preferences
    ADD CONSTRAINT editor_watch_preferences_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_release_group_type
    ADD CONSTRAINT editor_watch_release_group_type_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_release_group_type
    ADD CONSTRAINT editor_watch_release_group_type_fk_release_group_type FOREIGN KEY (release_group_type) REFERENCES release_group_primary_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_release_status
    ADD CONSTRAINT editor_watch_release_status_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY editor_watch_release_status
    ADD CONSTRAINT editor_watch_release_status_fk_release_status FOREIGN KEY (release_status) REFERENCES release_status(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_alias
    ADD CONSTRAINT event_alias_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_alias
    ADD CONSTRAINT event_alias_fk_type FOREIGN KEY (type) REFERENCES event_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_alias_type
    ADD CONSTRAINT event_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES event_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_annotation
    ADD CONSTRAINT event_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_annotation
    ADD CONSTRAINT event_annotation_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event
    ADD CONSTRAINT event_fk_type FOREIGN KEY (type) REFERENCES event_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_gid_redirect
    ADD CONSTRAINT event_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_meta
    ADD CONSTRAINT event_meta_fk_id FOREIGN KEY (id) REFERENCES event(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_rating_raw
    ADD CONSTRAINT event_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_rating_raw
    ADD CONSTRAINT event_rating_raw_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_tag
    ADD CONSTRAINT event_tag_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_tag
    ADD CONSTRAINT event_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_tag_raw
    ADD CONSTRAINT event_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_tag_raw
    ADD CONSTRAINT event_tag_raw_fk_event FOREIGN KEY (event) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_tag_raw
    ADD CONSTRAINT event_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY event_type
    ADD CONSTRAINT event_type_fk_parent FOREIGN KEY (parent) REFERENCES event_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY gender
    ADD CONSTRAINT gender_fk_parent FOREIGN KEY (parent) REFERENCES gender(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_alias
    ADD CONSTRAINT instrument_alias_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_alias
    ADD CONSTRAINT instrument_alias_fk_type FOREIGN KEY (type) REFERENCES instrument_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_alias_type
    ADD CONSTRAINT instrument_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES instrument_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_annotation
    ADD CONSTRAINT instrument_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_annotation
    ADD CONSTRAINT instrument_annotation_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument
    ADD CONSTRAINT instrument_fk_type FOREIGN KEY (type) REFERENCES instrument_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_gid_redirect
    ADD CONSTRAINT instrument_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_tag
    ADD CONSTRAINT instrument_tag_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_tag
    ADD CONSTRAINT instrument_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_tag_raw
    ADD CONSTRAINT instrument_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_tag_raw
    ADD CONSTRAINT instrument_tag_raw_fk_instrument FOREIGN KEY (instrument) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_tag_raw
    ADD CONSTRAINT instrument_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY instrument_type
    ADD CONSTRAINT instrument_type_fk_parent FOREIGN KEY (parent) REFERENCES instrument_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY iso_3166_1
    ADD CONSTRAINT iso_3166_1_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY iso_3166_2
    ADD CONSTRAINT iso_3166_2_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY iso_3166_3
    ADD CONSTRAINT iso_3166_3_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY isrc
    ADD CONSTRAINT isrc_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY iswc
    ADD CONSTRAINT iswc_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_area
    ADD CONSTRAINT l_area_area_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_area
    ADD CONSTRAINT l_area_area_fk_entity1 FOREIGN KEY (entity1) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_area
    ADD CONSTRAINT l_area_area_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_artist
    ADD CONSTRAINT l_area_artist_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_artist
    ADD CONSTRAINT l_area_artist_fk_entity1 FOREIGN KEY (entity1) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_artist
    ADD CONSTRAINT l_area_artist_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_event
    ADD CONSTRAINT l_area_event_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_event
    ADD CONSTRAINT l_area_event_fk_entity1 FOREIGN KEY (entity1) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_event
    ADD CONSTRAINT l_area_event_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_instrument
    ADD CONSTRAINT l_area_instrument_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_instrument
    ADD CONSTRAINT l_area_instrument_fk_entity1 FOREIGN KEY (entity1) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_instrument
    ADD CONSTRAINT l_area_instrument_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_label
    ADD CONSTRAINT l_area_label_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_label
    ADD CONSTRAINT l_area_label_fk_entity1 FOREIGN KEY (entity1) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_label
    ADD CONSTRAINT l_area_label_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_place
    ADD CONSTRAINT l_area_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_place
    ADD CONSTRAINT l_area_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_place
    ADD CONSTRAINT l_area_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_recording
    ADD CONSTRAINT l_area_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_recording
    ADD CONSTRAINT l_area_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_recording
    ADD CONSTRAINT l_area_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release
    ADD CONSTRAINT l_area_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release
    ADD CONSTRAINT l_area_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release
    ADD CONSTRAINT l_area_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release_group
    ADD CONSTRAINT l_area_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release_group
    ADD CONSTRAINT l_area_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_release_group
    ADD CONSTRAINT l_area_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_series
    ADD CONSTRAINT l_area_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_series
    ADD CONSTRAINT l_area_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_series
    ADD CONSTRAINT l_area_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_url
    ADD CONSTRAINT l_area_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_url
    ADD CONSTRAINT l_area_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_url
    ADD CONSTRAINT l_area_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_work
    ADD CONSTRAINT l_area_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_work
    ADD CONSTRAINT l_area_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_area_work
    ADD CONSTRAINT l_area_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_artist
    ADD CONSTRAINT l_artist_artist_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_artist
    ADD CONSTRAINT l_artist_artist_fk_entity1 FOREIGN KEY (entity1) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_artist
    ADD CONSTRAINT l_artist_artist_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_event
    ADD CONSTRAINT l_artist_event_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_event
    ADD CONSTRAINT l_artist_event_fk_entity1 FOREIGN KEY (entity1) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_event
    ADD CONSTRAINT l_artist_event_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_instrument
    ADD CONSTRAINT l_artist_instrument_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_instrument
    ADD CONSTRAINT l_artist_instrument_fk_entity1 FOREIGN KEY (entity1) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_instrument
    ADD CONSTRAINT l_artist_instrument_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_label
    ADD CONSTRAINT l_artist_label_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_label
    ADD CONSTRAINT l_artist_label_fk_entity1 FOREIGN KEY (entity1) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_label
    ADD CONSTRAINT l_artist_label_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_place
    ADD CONSTRAINT l_artist_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_place
    ADD CONSTRAINT l_artist_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_place
    ADD CONSTRAINT l_artist_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_recording
    ADD CONSTRAINT l_artist_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_recording
    ADD CONSTRAINT l_artist_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_recording
    ADD CONSTRAINT l_artist_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release
    ADD CONSTRAINT l_artist_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release
    ADD CONSTRAINT l_artist_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release
    ADD CONSTRAINT l_artist_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release_group
    ADD CONSTRAINT l_artist_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release_group
    ADD CONSTRAINT l_artist_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_release_group
    ADD CONSTRAINT l_artist_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_series
    ADD CONSTRAINT l_artist_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_series
    ADD CONSTRAINT l_artist_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_series
    ADD CONSTRAINT l_artist_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_url
    ADD CONSTRAINT l_artist_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_url
    ADD CONSTRAINT l_artist_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_url
    ADD CONSTRAINT l_artist_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_work
    ADD CONSTRAINT l_artist_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES artist(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_work
    ADD CONSTRAINT l_artist_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_artist_work
    ADD CONSTRAINT l_artist_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_event
    ADD CONSTRAINT l_event_event_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_event
    ADD CONSTRAINT l_event_event_fk_entity1 FOREIGN KEY (entity1) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_event
    ADD CONSTRAINT l_event_event_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_instrument
    ADD CONSTRAINT l_event_instrument_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_instrument
    ADD CONSTRAINT l_event_instrument_fk_entity1 FOREIGN KEY (entity1) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_instrument
    ADD CONSTRAINT l_event_instrument_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_label
    ADD CONSTRAINT l_event_label_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_label
    ADD CONSTRAINT l_event_label_fk_entity1 FOREIGN KEY (entity1) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_label
    ADD CONSTRAINT l_event_label_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_place
    ADD CONSTRAINT l_event_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_place
    ADD CONSTRAINT l_event_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_place
    ADD CONSTRAINT l_event_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_recording
    ADD CONSTRAINT l_event_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_recording
    ADD CONSTRAINT l_event_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_recording
    ADD CONSTRAINT l_event_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release
    ADD CONSTRAINT l_event_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release
    ADD CONSTRAINT l_event_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release
    ADD CONSTRAINT l_event_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release_group
    ADD CONSTRAINT l_event_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release_group
    ADD CONSTRAINT l_event_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_release_group
    ADD CONSTRAINT l_event_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_series
    ADD CONSTRAINT l_event_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_series
    ADD CONSTRAINT l_event_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_series
    ADD CONSTRAINT l_event_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_url
    ADD CONSTRAINT l_event_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_url
    ADD CONSTRAINT l_event_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_url
    ADD CONSTRAINT l_event_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_work
    ADD CONSTRAINT l_event_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES event(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_work
    ADD CONSTRAINT l_event_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_event_work
    ADD CONSTRAINT l_event_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_instrument
    ADD CONSTRAINT l_instrument_instrument_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_instrument
    ADD CONSTRAINT l_instrument_instrument_fk_entity1 FOREIGN KEY (entity1) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_instrument
    ADD CONSTRAINT l_instrument_instrument_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_label
    ADD CONSTRAINT l_instrument_label_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_label
    ADD CONSTRAINT l_instrument_label_fk_entity1 FOREIGN KEY (entity1) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_label
    ADD CONSTRAINT l_instrument_label_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_place
    ADD CONSTRAINT l_instrument_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_place
    ADD CONSTRAINT l_instrument_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_place
    ADD CONSTRAINT l_instrument_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_recording
    ADD CONSTRAINT l_instrument_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_recording
    ADD CONSTRAINT l_instrument_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_recording
    ADD CONSTRAINT l_instrument_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release
    ADD CONSTRAINT l_instrument_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release
    ADD CONSTRAINT l_instrument_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release
    ADD CONSTRAINT l_instrument_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release_group
    ADD CONSTRAINT l_instrument_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release_group
    ADD CONSTRAINT l_instrument_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_release_group
    ADD CONSTRAINT l_instrument_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_series
    ADD CONSTRAINT l_instrument_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_series
    ADD CONSTRAINT l_instrument_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_series
    ADD CONSTRAINT l_instrument_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_url
    ADD CONSTRAINT l_instrument_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_url
    ADD CONSTRAINT l_instrument_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_url
    ADD CONSTRAINT l_instrument_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_work
    ADD CONSTRAINT l_instrument_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES instrument(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_work
    ADD CONSTRAINT l_instrument_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_instrument_work
    ADD CONSTRAINT l_instrument_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_label
    ADD CONSTRAINT l_label_label_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_label
    ADD CONSTRAINT l_label_label_fk_entity1 FOREIGN KEY (entity1) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_label
    ADD CONSTRAINT l_label_label_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_place
    ADD CONSTRAINT l_label_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_place
    ADD CONSTRAINT l_label_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_place
    ADD CONSTRAINT l_label_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_recording
    ADD CONSTRAINT l_label_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_recording
    ADD CONSTRAINT l_label_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_recording
    ADD CONSTRAINT l_label_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release
    ADD CONSTRAINT l_label_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release
    ADD CONSTRAINT l_label_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release
    ADD CONSTRAINT l_label_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release_group
    ADD CONSTRAINT l_label_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release_group
    ADD CONSTRAINT l_label_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_release_group
    ADD CONSTRAINT l_label_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_series
    ADD CONSTRAINT l_label_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_series
    ADD CONSTRAINT l_label_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_series
    ADD CONSTRAINT l_label_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_url
    ADD CONSTRAINT l_label_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_url
    ADD CONSTRAINT l_label_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_url
    ADD CONSTRAINT l_label_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_work
    ADD CONSTRAINT l_label_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_work
    ADD CONSTRAINT l_label_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_label_work
    ADD CONSTRAINT l_label_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_place
    ADD CONSTRAINT l_place_place_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_place
    ADD CONSTRAINT l_place_place_fk_entity1 FOREIGN KEY (entity1) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_place
    ADD CONSTRAINT l_place_place_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_recording
    ADD CONSTRAINT l_place_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_recording
    ADD CONSTRAINT l_place_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_recording
    ADD CONSTRAINT l_place_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release
    ADD CONSTRAINT l_place_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release
    ADD CONSTRAINT l_place_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release
    ADD CONSTRAINT l_place_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release_group
    ADD CONSTRAINT l_place_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release_group
    ADD CONSTRAINT l_place_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_release_group
    ADD CONSTRAINT l_place_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_series
    ADD CONSTRAINT l_place_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_series
    ADD CONSTRAINT l_place_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_series
    ADD CONSTRAINT l_place_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_url
    ADD CONSTRAINT l_place_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_url
    ADD CONSTRAINT l_place_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_url
    ADD CONSTRAINT l_place_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_work
    ADD CONSTRAINT l_place_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_work
    ADD CONSTRAINT l_place_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_place_work
    ADD CONSTRAINT l_place_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_recording
    ADD CONSTRAINT l_recording_recording_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_recording
    ADD CONSTRAINT l_recording_recording_fk_entity1 FOREIGN KEY (entity1) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_recording
    ADD CONSTRAINT l_recording_recording_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release
    ADD CONSTRAINT l_recording_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release
    ADD CONSTRAINT l_recording_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release
    ADD CONSTRAINT l_recording_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release_group
    ADD CONSTRAINT l_recording_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release_group
    ADD CONSTRAINT l_recording_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_release_group
    ADD CONSTRAINT l_recording_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_series
    ADD CONSTRAINT l_recording_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_series
    ADD CONSTRAINT l_recording_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_series
    ADD CONSTRAINT l_recording_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_url
    ADD CONSTRAINT l_recording_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_url
    ADD CONSTRAINT l_recording_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_url
    ADD CONSTRAINT l_recording_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_work
    ADD CONSTRAINT l_recording_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_work
    ADD CONSTRAINT l_recording_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_recording_work
    ADD CONSTRAINT l_recording_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_release_group
    ADD CONSTRAINT l_release_group_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_release_group
    ADD CONSTRAINT l_release_group_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_release_group
    ADD CONSTRAINT l_release_group_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_series
    ADD CONSTRAINT l_release_group_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_series
    ADD CONSTRAINT l_release_group_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_series
    ADD CONSTRAINT l_release_group_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_url
    ADD CONSTRAINT l_release_group_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_url
    ADD CONSTRAINT l_release_group_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_url
    ADD CONSTRAINT l_release_group_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_work
    ADD CONSTRAINT l_release_group_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_work
    ADD CONSTRAINT l_release_group_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_group_work
    ADD CONSTRAINT l_release_group_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release
    ADD CONSTRAINT l_release_release_fk_entity0 FOREIGN KEY (entity0) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release
    ADD CONSTRAINT l_release_release_fk_entity1 FOREIGN KEY (entity1) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release
    ADD CONSTRAINT l_release_release_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release_group
    ADD CONSTRAINT l_release_release_group_fk_entity0 FOREIGN KEY (entity0) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release_group
    ADD CONSTRAINT l_release_release_group_fk_entity1 FOREIGN KEY (entity1) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_release_group
    ADD CONSTRAINT l_release_release_group_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_series
    ADD CONSTRAINT l_release_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_series
    ADD CONSTRAINT l_release_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_series
    ADD CONSTRAINT l_release_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_url
    ADD CONSTRAINT l_release_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_url
    ADD CONSTRAINT l_release_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_url
    ADD CONSTRAINT l_release_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_work
    ADD CONSTRAINT l_release_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_work
    ADD CONSTRAINT l_release_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_release_work
    ADD CONSTRAINT l_release_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_series
    ADD CONSTRAINT l_series_series_fk_entity0 FOREIGN KEY (entity0) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_series
    ADD CONSTRAINT l_series_series_fk_entity1 FOREIGN KEY (entity1) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_series
    ADD CONSTRAINT l_series_series_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_url
    ADD CONSTRAINT l_series_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_url
    ADD CONSTRAINT l_series_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_url
    ADD CONSTRAINT l_series_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_work
    ADD CONSTRAINT l_series_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_work
    ADD CONSTRAINT l_series_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_series_work
    ADD CONSTRAINT l_series_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_url
    ADD CONSTRAINT l_url_url_fk_entity0 FOREIGN KEY (entity0) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_url
    ADD CONSTRAINT l_url_url_fk_entity1 FOREIGN KEY (entity1) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_url
    ADD CONSTRAINT l_url_url_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_work
    ADD CONSTRAINT l_url_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_work
    ADD CONSTRAINT l_url_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_url_work
    ADD CONSTRAINT l_url_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_work_work
    ADD CONSTRAINT l_work_work_fk_entity0 FOREIGN KEY (entity0) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_work_work
    ADD CONSTRAINT l_work_work_fk_entity1 FOREIGN KEY (entity1) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY l_work_work
    ADD CONSTRAINT l_work_work_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_alias
    ADD CONSTRAINT label_alias_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_alias
    ADD CONSTRAINT label_alias_fk_type FOREIGN KEY (type) REFERENCES label_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_alias_type
    ADD CONSTRAINT label_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES label_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_annotation
    ADD CONSTRAINT label_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_annotation
    ADD CONSTRAINT label_annotation_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label
    ADD CONSTRAINT label_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label
    ADD CONSTRAINT label_fk_type FOREIGN KEY (type) REFERENCES label_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_gid_redirect
    ADD CONSTRAINT label_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_ipi
    ADD CONSTRAINT label_ipi_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_isni
    ADD CONSTRAINT label_isni_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_meta
    ADD CONSTRAINT label_meta_fk_id FOREIGN KEY (id) REFERENCES label(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_rating_raw
    ADD CONSTRAINT label_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_rating_raw
    ADD CONSTRAINT label_rating_raw_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_tag
    ADD CONSTRAINT label_tag_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_tag
    ADD CONSTRAINT label_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_tag_raw
    ADD CONSTRAINT label_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_tag_raw
    ADD CONSTRAINT label_tag_raw_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_tag_raw
    ADD CONSTRAINT label_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY label_type
    ADD CONSTRAINT label_type_fk_parent FOREIGN KEY (parent) REFERENCES label_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_credit
    ADD CONSTRAINT link_attribute_credit_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_creditable_attribute_type(attribute_type) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_credit
    ADD CONSTRAINT link_attribute_credit_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute
    ADD CONSTRAINT link_attribute_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute
    ADD CONSTRAINT link_attribute_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_text_value
    ADD CONSTRAINT link_attribute_text_value_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_text_attribute_type(attribute_type) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_text_value
    ADD CONSTRAINT link_attribute_text_value_fk_link FOREIGN KEY (link) REFERENCES link(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_type
    ADD CONSTRAINT link_attribute_type_fk_parent FOREIGN KEY (parent) REFERENCES link_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_attribute_type
    ADD CONSTRAINT link_attribute_type_fk_root FOREIGN KEY (root) REFERENCES link_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_creditable_attribute_type
    ADD CONSTRAINT link_creditable_attribute_type_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_attribute_type(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link
    ADD CONSTRAINT link_fk_link_type FOREIGN KEY (link_type) REFERENCES link_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_text_attribute_type
    ADD CONSTRAINT link_text_attribute_type_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_attribute_type(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_type_attribute_type
    ADD CONSTRAINT link_type_attribute_type_fk_attribute_type FOREIGN KEY (attribute_type) REFERENCES link_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_type_attribute_type
    ADD CONSTRAINT link_type_attribute_type_fk_link_type FOREIGN KEY (link_type) REFERENCES link_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY link_type
    ADD CONSTRAINT link_type_fk_parent FOREIGN KEY (parent) REFERENCES link_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium_cdtoc
    ADD CONSTRAINT medium_cdtoc_fk_cdtoc FOREIGN KEY (cdtoc) REFERENCES cdtoc(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium_cdtoc
    ADD CONSTRAINT medium_cdtoc_fk_medium FOREIGN KEY (medium) REFERENCES medium(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_fk_format FOREIGN KEY (format) REFERENCES medium_format(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium
    ADD CONSTRAINT medium_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium_format
    ADD CONSTRAINT medium_format_fk_parent FOREIGN KEY (parent) REFERENCES medium_format(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY medium_index
    ADD CONSTRAINT medium_index_fk_medium FOREIGN KEY (medium) REFERENCES medium(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY orderable_link_type
    ADD CONSTRAINT orderable_link_type_fk_link_type FOREIGN KEY (link_type) REFERENCES link_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_alias
    ADD CONSTRAINT place_alias_fk_place FOREIGN KEY (place) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_alias
    ADD CONSTRAINT place_alias_fk_type FOREIGN KEY (type) REFERENCES place_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_alias_type
    ADD CONSTRAINT place_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES place_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_annotation
    ADD CONSTRAINT place_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_annotation
    ADD CONSTRAINT place_annotation_fk_place FOREIGN KEY (place) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place
    ADD CONSTRAINT place_fk_area FOREIGN KEY (area) REFERENCES area(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place
    ADD CONSTRAINT place_fk_type FOREIGN KEY (type) REFERENCES place_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_gid_redirect
    ADD CONSTRAINT place_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_tag
    ADD CONSTRAINT place_tag_fk_place FOREIGN KEY (place) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_tag
    ADD CONSTRAINT place_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_tag_raw
    ADD CONSTRAINT place_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_tag_raw
    ADD CONSTRAINT place_tag_raw_fk_place FOREIGN KEY (place) REFERENCES place(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_tag_raw
    ADD CONSTRAINT place_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY place_type
    ADD CONSTRAINT place_type_fk_parent FOREIGN KEY (parent) REFERENCES place_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_alias
    ADD CONSTRAINT recording_alias_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_alias
    ADD CONSTRAINT recording_alias_fk_type FOREIGN KEY (type) REFERENCES recording_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_alias_type
    ADD CONSTRAINT recording_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES recording_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_annotation
    ADD CONSTRAINT recording_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_annotation
    ADD CONSTRAINT recording_annotation_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording
    ADD CONSTRAINT recording_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_gid_redirect
    ADD CONSTRAINT recording_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_meta
    ADD CONSTRAINT recording_meta_fk_id FOREIGN KEY (id) REFERENCES recording(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_rating_raw
    ADD CONSTRAINT recording_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_rating_raw
    ADD CONSTRAINT recording_rating_raw_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_tag
    ADD CONSTRAINT recording_tag_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_tag
    ADD CONSTRAINT recording_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_tag_raw
    ADD CONSTRAINT recording_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_tag_raw
    ADD CONSTRAINT recording_tag_raw_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY recording_tag_raw
    ADD CONSTRAINT recording_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_alias
    ADD CONSTRAINT release_alias_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_alias
    ADD CONSTRAINT release_alias_fk_type FOREIGN KEY (type) REFERENCES release_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_alias_type
    ADD CONSTRAINT release_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES release_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_annotation
    ADD CONSTRAINT release_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_annotation
    ADD CONSTRAINT release_annotation_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_country
    ADD CONSTRAINT release_country_fk_country FOREIGN KEY (country) REFERENCES country_area(area) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_country
    ADD CONSTRAINT release_country_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_coverart
    ADD CONSTRAINT release_coverart_fk_id FOREIGN KEY (id) REFERENCES release(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_language FOREIGN KEY (language) REFERENCES language(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_packaging FOREIGN KEY (packaging) REFERENCES release_packaging(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_script FOREIGN KEY (script) REFERENCES script(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release
    ADD CONSTRAINT release_fk_status FOREIGN KEY (status) REFERENCES release_status(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_gid_redirect
    ADD CONSTRAINT release_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_alias
    ADD CONSTRAINT release_group_alias_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_alias
    ADD CONSTRAINT release_group_alias_fk_type FOREIGN KEY (type) REFERENCES release_group_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_alias_type
    ADD CONSTRAINT release_group_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES release_group_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_annotation
    ADD CONSTRAINT release_group_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_annotation
    ADD CONSTRAINT release_group_annotation_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group
    ADD CONSTRAINT release_group_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group
    ADD CONSTRAINT release_group_fk_type FOREIGN KEY (type) REFERENCES release_group_primary_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_gid_redirect
    ADD CONSTRAINT release_group_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_meta
    ADD CONSTRAINT release_group_meta_fk_id FOREIGN KEY (id) REFERENCES release_group(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_primary_type
    ADD CONSTRAINT release_group_primary_type_fk_parent FOREIGN KEY (parent) REFERENCES release_group_primary_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_rating_raw
    ADD CONSTRAINT release_group_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_rating_raw
    ADD CONSTRAINT release_group_rating_raw_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_secondary_type
    ADD CONSTRAINT release_group_secondary_type_fk_parent FOREIGN KEY (parent) REFERENCES release_group_secondary_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_secondary_type_join
    ADD CONSTRAINT release_group_secondary_type_join_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_secondary_type_join
    ADD CONSTRAINT release_group_secondary_type_join_fk_secondary_type FOREIGN KEY (secondary_type) REFERENCES release_group_secondary_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_tag
    ADD CONSTRAINT release_group_tag_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_tag
    ADD CONSTRAINT release_group_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_tag_raw
    ADD CONSTRAINT release_group_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_tag_raw
    ADD CONSTRAINT release_group_tag_raw_fk_release_group FOREIGN KEY (release_group) REFERENCES release_group(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_group_tag_raw
    ADD CONSTRAINT release_group_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_label
    ADD CONSTRAINT release_label_fk_label FOREIGN KEY (label) REFERENCES label(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_label
    ADD CONSTRAINT release_label_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_meta
    ADD CONSTRAINT release_meta_fk_id FOREIGN KEY (id) REFERENCES release(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_packaging
    ADD CONSTRAINT release_packaging_fk_parent FOREIGN KEY (parent) REFERENCES release_packaging(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_status
    ADD CONSTRAINT release_status_fk_parent FOREIGN KEY (parent) REFERENCES release_status(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_tag
    ADD CONSTRAINT release_tag_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_tag
    ADD CONSTRAINT release_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_tag_raw
    ADD CONSTRAINT release_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_tag_raw
    ADD CONSTRAINT release_tag_raw_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_tag_raw
    ADD CONSTRAINT release_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY release_unknown_country
    ADD CONSTRAINT release_unknown_country_fk_release FOREIGN KEY (release) REFERENCES release(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_alias
    ADD CONSTRAINT series_alias_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_alias
    ADD CONSTRAINT series_alias_fk_type FOREIGN KEY (type) REFERENCES series_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_alias_type
    ADD CONSTRAINT series_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES series_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_annotation
    ADD CONSTRAINT series_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_annotation
    ADD CONSTRAINT series_annotation_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series
    ADD CONSTRAINT series_fk_ordering_attribute FOREIGN KEY (ordering_attribute) REFERENCES link_text_attribute_type(attribute_type) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series
    ADD CONSTRAINT series_fk_ordering_type FOREIGN KEY (ordering_type) REFERENCES series_ordering_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series
    ADD CONSTRAINT series_fk_type FOREIGN KEY (type) REFERENCES series_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_gid_redirect
    ADD CONSTRAINT series_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_ordering_type
    ADD CONSTRAINT series_ordering_type_fk_parent FOREIGN KEY (parent) REFERENCES series_ordering_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_tag
    ADD CONSTRAINT series_tag_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_tag
    ADD CONSTRAINT series_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_tag_raw
    ADD CONSTRAINT series_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_tag_raw
    ADD CONSTRAINT series_tag_raw_fk_series FOREIGN KEY (series) REFERENCES series(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_tag_raw
    ADD CONSTRAINT series_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY series_type
    ADD CONSTRAINT series_type_fk_parent FOREIGN KEY (parent) REFERENCES series_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY tag_relation
    ADD CONSTRAINT tag_relation_fk_tag1 FOREIGN KEY (tag1) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY tag_relation
    ADD CONSTRAINT tag_relation_fk_tag2 FOREIGN KEY (tag2) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY track
    ADD CONSTRAINT track_fk_artist_credit FOREIGN KEY (artist_credit) REFERENCES artist_credit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY track
    ADD CONSTRAINT track_fk_medium FOREIGN KEY (medium) REFERENCES medium(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY track
    ADD CONSTRAINT track_fk_recording FOREIGN KEY (recording) REFERENCES recording(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY track_gid_redirect
    ADD CONSTRAINT track_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES track(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY track_raw
    ADD CONSTRAINT track_raw_fk_release FOREIGN KEY (release) REFERENCES release_raw(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY url_gid_redirect
    ADD CONSTRAINT url_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES url(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY vote
    ADD CONSTRAINT vote_fk_edit FOREIGN KEY (edit) REFERENCES edit(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY vote
    ADD CONSTRAINT vote_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_alias
    ADD CONSTRAINT work_alias_fk_type FOREIGN KEY (type) REFERENCES work_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_alias
    ADD CONSTRAINT work_alias_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_alias_type
    ADD CONSTRAINT work_alias_type_fk_parent FOREIGN KEY (parent) REFERENCES work_alias_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_annotation
    ADD CONSTRAINT work_annotation_fk_annotation FOREIGN KEY (annotation) REFERENCES annotation(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_annotation
    ADD CONSTRAINT work_annotation_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute
    ADD CONSTRAINT work_attribute_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute
    ADD CONSTRAINT work_attribute_fk_work_attribute_type FOREIGN KEY (work_attribute_type) REFERENCES work_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute
    ADD CONSTRAINT work_attribute_fk_work_attribute_type_allowed_value FOREIGN KEY (work_attribute_type_allowed_value) REFERENCES work_attribute_type_allowed_value(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute_type_allowed_value
    ADD CONSTRAINT work_attribute_type_allowed_value_fk_parent FOREIGN KEY (parent) REFERENCES work_attribute_type_allowed_value(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute_type_allowed_value
    ADD CONSTRAINT work_attribute_type_allowed_value_fk_work_attribute_type FOREIGN KEY (work_attribute_type) REFERENCES work_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_attribute_type
    ADD CONSTRAINT work_attribute_type_fk_parent FOREIGN KEY (parent) REFERENCES work_attribute_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work
    ADD CONSTRAINT work_fk_language FOREIGN KEY (language) REFERENCES language(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work
    ADD CONSTRAINT work_fk_type FOREIGN KEY (type) REFERENCES work_type(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_gid_redirect
    ADD CONSTRAINT work_gid_redirect_fk_new_id FOREIGN KEY (new_id) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_meta
    ADD CONSTRAINT work_meta_fk_id FOREIGN KEY (id) REFERENCES work(id) ON DELETE CASCADE DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_rating_raw
    ADD CONSTRAINT work_rating_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_rating_raw
    ADD CONSTRAINT work_rating_raw_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_tag
    ADD CONSTRAINT work_tag_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_tag
    ADD CONSTRAINT work_tag_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_tag_raw
    ADD CONSTRAINT work_tag_raw_fk_editor FOREIGN KEY (editor) REFERENCES editor(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_tag_raw
    ADD CONSTRAINT work_tag_raw_fk_tag FOREIGN KEY (tag) REFERENCES tag(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_tag_raw
    ADD CONSTRAINT work_tag_raw_fk_work FOREIGN KEY (work) REFERENCES work(id) DEFERRABLE INITIALLY DEFERRED;

ALTER TABLE ONLY work_type
    ADD CONSTRAINT work_type_fk_parent FOREIGN KEY (parent) REFERENCES work_type(id) DEFERRABLE INITIALLY DEFERRED;

commit;