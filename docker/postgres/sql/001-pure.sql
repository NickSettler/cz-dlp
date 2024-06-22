--
-- PostgreSQL database dump
--

-- Dumped from database version 16.3
-- Dumped by pg_dump version 16.3

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

SET default_tablespace = '';

SET default_table_access_method = heap;

CREATE OR REPLACE FUNCTION public.create_constraint_if_not_exists(t_name text, c_name text, constraint_sql text)
    RETURNS void
AS
$BODY$
BEGIN
    IF NOT EXISTS (SELECT constraint_name
                   FROM information_schema.constraint_column_usage
                   WHERE constraint_name = c_name) THEN
        EXECUTE 'ALTER TABLE ' || t_name || ' ADD CONSTRAINT ' || c_name || ' ' || constraint_sql;
    END IF;
END;
$BODY$
    LANGUAGE plpgsql VOLATILE;

--
-- Name: VPOIS; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public."VPOIS"
(
    code  character varying(255) NOT NULL,
    name  character varying(255),
    web   character varying(255),
    email character varying(255),
    phone character varying(255)
);


ALTER TABLE public."VPOIS"
    OWNER TO directus;

--
-- Name: addiction; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.addiction
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.addiction
    OWNER TO directus;

--
-- Name: atc; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.atc
(
    atc     character varying(255)                                 NOT NULL,
    nt      character varying(255)                                 NOT NULL,
    name    character varying(255)                                 NOT NULL,
    name_en character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.atc
    OWNER TO directus;

--
-- Name: composition; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.composition
(
    id          integer              NOT NULL,
    code        character varying(7) NOT NULL,
    ingredient  character varying(255),
    "order"     integer              NOT NULL,
    sign        character varying(255),
    amount_from character varying(255),
    amount      character varying(255),
    unit        character varying(255)
);


ALTER TABLE public.composition
    OWNER TO directus;

--
-- Name: composition_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.composition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.composition_id_seq OWNER TO directus;

--
-- Name: composition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.composition_id_seq OWNED BY public.composition.id;


--
-- Name: composition_sign; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.composition_sign
(
    code        character varying(255) NOT NULL,
    description text                   NOT NULL
);


ALTER TABLE public.composition_sign
    OWNER TO directus;

--
-- Name: country; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.country
(
    code    character varying(255) NOT NULL,
    name    character varying(255),
    edqm    character varying(255),
    name_en character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.country
    OWNER TO directus;

--
-- Name: directus_activity; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_activity
(
    id          integer                                            NOT NULL,
    action      character varying(45)                              NOT NULL,
    "user"      uuid,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ip          character varying(50),
    user_agent  text,
    collection  character varying(64)                              NOT NULL,
    item        character varying(255)                             NOT NULL,
    comment     text,
    origin      character varying(255)
);


ALTER TABLE public.directus_activity
    OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_activity_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_activity_id_seq OWNER TO directus;

--
-- Name: directus_activity_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_activity_id_seq OWNED BY public.directus_activity.id;


--
-- Name: directus_collections; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_collections
(
    collection              character varying(64)                                    NOT NULL,
    icon                    character varying(30),
    note                    text,
    display_template        character varying(255),
    hidden                  boolean                DEFAULT false                     NOT NULL,
    singleton               boolean                DEFAULT false                     NOT NULL,
    translations            json,
    archive_field           character varying(64),
    archive_app_filter      boolean                DEFAULT true                      NOT NULL,
    archive_value           character varying(255),
    unarchive_value         character varying(255),
    sort_field              character varying(64),
    accountability          character varying(255) DEFAULT 'all'::character varying,
    color                   character varying(255),
    item_duplication_fields json,
    sort                    integer,
    "group"                 character varying(64),
    collapse                character varying(255) DEFAULT 'open'::character varying NOT NULL,
    preview_url             character varying(255),
    versioning              boolean                DEFAULT false                     NOT NULL
);


ALTER TABLE public.directus_collections
    OWNER TO directus;

--
-- Name: directus_dashboards; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_dashboards
(
    id           uuid                                                            NOT NULL,
    name         character varying(255)                                          NOT NULL,
    icon         character varying(30)    DEFAULT 'dashboard'::character varying NOT NULL,
    note         text,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    color        character varying(255)
);


ALTER TABLE public.directus_dashboards
    OWNER TO directus;

--
-- Name: directus_extensions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_extensions
(
    enabled boolean DEFAULT true   NOT NULL,
    id      uuid                   NOT NULL,
    folder  character varying(255) NOT NULL,
    source  character varying(255) NOT NULL,
    bundle  uuid
);


ALTER TABLE public.directus_extensions
    OWNER TO directus;

--
-- Name: directus_fields; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_fields
(
    id                 integer                             NOT NULL,
    collection         character varying(64)               NOT NULL,
    field              character varying(64)               NOT NULL,
    special            character varying(64),
    interface          character varying(64),
    options            json,
    display            character varying(64),
    display_options    json,
    readonly           boolean               DEFAULT false NOT NULL,
    hidden             boolean               DEFAULT false NOT NULL,
    sort               integer,
    width              character varying(30) DEFAULT 'full'::character varying,
    translations       json,
    note               text,
    conditions         json,
    required           boolean               DEFAULT false,
    "group"            character varying(64),
    validation         json,
    validation_message text
);


ALTER TABLE public.directus_fields
    OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_fields_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_fields_id_seq OWNER TO directus;

--
-- Name: directus_fields_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_fields_id_seq OWNED BY public.directus_fields.id;


--
-- Name: directus_files; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_files
(
    id                uuid                                               NOT NULL,
    storage           character varying(255)                             NOT NULL,
    filename_disk     character varying(255),
    filename_download character varying(255)                             NOT NULL,
    title             character varying(255),
    type              character varying(255),
    folder            uuid,
    uploaded_by       uuid,
    uploaded_on       timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    modified_by       uuid,
    modified_on       timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    charset           character varying(50),
    filesize          bigint,
    width             integer,
    height            integer,
    duration          integer,
    embed             character varying(200),
    description       text,
    location          text,
    tags              text,
    metadata          json,
    focal_point_x     integer,
    focal_point_y     integer
);


ALTER TABLE public.directus_files
    OWNER TO directus;

--
-- Name: directus_flows; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_flows
(
    id             uuid                                                         NOT NULL,
    name           character varying(255)                                       NOT NULL,
    icon           character varying(30),
    color          character varying(255),
    description    text,
    status         character varying(255)   DEFAULT 'active'::character varying NOT NULL,
    trigger        character varying(255),
    accountability character varying(255)   DEFAULT 'all'::character varying,
    options        json,
    operation      uuid,
    date_created   timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created   uuid
);


ALTER TABLE public.directus_flows
    OWNER TO directus;

--
-- Name: directus_folders; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_folders
(
    id     uuid                   NOT NULL,
    name   character varying(255) NOT NULL,
    parent uuid
);


ALTER TABLE public.directus_folders
    OWNER TO directus;

--
-- Name: directus_migrations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_migrations
(
    version     character varying(255) NOT NULL,
    name        character varying(255) NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.directus_migrations
    OWNER TO directus;

--
-- Name: directus_notifications; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_notifications
(
    id          integer                NOT NULL,
    "timestamp" timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    status      character varying(255)   DEFAULT 'inbox'::character varying,
    recipient   uuid                   NOT NULL,
    sender      uuid,
    subject     character varying(255) NOT NULL,
    message     text,
    collection  character varying(64),
    item        character varying(255)
);


ALTER TABLE public.directus_notifications
    OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_notifications_id_seq OWNER TO directus;

--
-- Name: directus_notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_notifications_id_seq OWNED BY public.directus_notifications.id;


--
-- Name: directus_operations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_operations
(
    id           uuid                   NOT NULL,
    name         character varying(255),
    key          character varying(255) NOT NULL,
    type         character varying(255) NOT NULL,
    position_x   integer                NOT NULL,
    position_y   integer                NOT NULL,
    options      json,
    resolve      uuid,
    reject       uuid,
    flow         uuid                   NOT NULL,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_operations
    OWNER TO directus;

--
-- Name: directus_panels; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_panels
(
    id           uuid                                   NOT NULL,
    dashboard    uuid                                   NOT NULL,
    name         character varying(255),
    icon         character varying(30)    DEFAULT NULL::character varying,
    color        character varying(10),
    show_header  boolean                  DEFAULT false NOT NULL,
    note         text,
    type         character varying(255)                 NOT NULL,
    position_x   integer                                NOT NULL,
    position_y   integer                                NOT NULL,
    width        integer                                NOT NULL,
    height       integer                                NOT NULL,
    options      json,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid
);


ALTER TABLE public.directus_panels
    OWNER TO directus;

--
-- Name: directus_permissions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_permissions
(
    id          integer               NOT NULL,
    role        uuid,
    collection  character varying(64) NOT NULL,
    action      character varying(10) NOT NULL,
    permissions json,
    validation  json,
    presets     json,
    fields      text
);


ALTER TABLE public.directus_permissions
    OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_permissions_id_seq OWNER TO directus;

--
-- Name: directus_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_permissions_id_seq OWNED BY public.directus_permissions.id;


--
-- Name: directus_presets; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_presets
(
    id               integer NOT NULL,
    bookmark         character varying(255),
    "user"           uuid,
    role             uuid,
    collection       character varying(64),
    search           character varying(100),
    layout           character varying(100) DEFAULT 'tabular'::character varying,
    layout_query     json,
    layout_options   json,
    refresh_interval integer,
    filter           json,
    icon             character varying(30)  DEFAULT 'bookmark'::character varying,
    color            character varying(255)
);


ALTER TABLE public.directus_presets
    OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_presets_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_presets_id_seq OWNER TO directus;

--
-- Name: directus_presets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_presets_id_seq OWNED BY public.directus_presets.id;


--
-- Name: directus_relations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_relations
(
    id                      integer                                                     NOT NULL,
    many_collection         character varying(64)                                       NOT NULL,
    many_field              character varying(64)                                       NOT NULL,
    one_collection          character varying(64),
    one_field               character varying(64),
    one_collection_field    character varying(64),
    one_allowed_collections text,
    junction_field          character varying(64),
    sort_field              character varying(64),
    one_deselect_action     character varying(255) DEFAULT 'nullify'::character varying NOT NULL
);


ALTER TABLE public.directus_relations
    OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_relations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_relations_id_seq OWNER TO directus;

--
-- Name: directus_relations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_relations_id_seq OWNED BY public.directus_relations.id;


--
-- Name: directus_revisions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_revisions
(
    id         integer                NOT NULL,
    activity   integer                NOT NULL,
    collection character varying(64)  NOT NULL,
    item       character varying(255) NOT NULL,
    data       json,
    delta      json,
    parent     integer,
    version    uuid
);


ALTER TABLE public.directus_revisions
    OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_revisions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_revisions_id_seq OWNER TO directus;

--
-- Name: directus_revisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_revisions_id_seq OWNED BY public.directus_revisions.id;


--
-- Name: directus_roles; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_roles
(
    id           uuid                                                                      NOT NULL,
    name         character varying(100)                                                    NOT NULL,
    icon         character varying(30) DEFAULT 'supervised_user_circle'::character varying NOT NULL,
    description  text,
    ip_access    text,
    enforce_tfa  boolean               DEFAULT false                                       NOT NULL,
    admin_access boolean               DEFAULT false                                       NOT NULL,
    app_access   boolean               DEFAULT true                                        NOT NULL
);


ALTER TABLE public.directus_roles
    OWNER TO directus;

--
-- Name: directus_sessions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_sessions
(
    token      character varying(64)    NOT NULL,
    "user"     uuid,
    expires    timestamp with time zone NOT NULL,
    ip         character varying(255),
    user_agent text,
    share      uuid,
    origin     character varying(255),
    next_token character varying(64)
);


ALTER TABLE public.directus_sessions
    OWNER TO directus;

--
-- Name: directus_settings; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_settings
(
    id                               integer                                                      NOT NULL,
    project_name                     character varying(100) DEFAULT 'Directus'::character varying NOT NULL,
    project_url                      character varying(255),
    project_color                    character varying(255) DEFAULT '#6644FF'::character varying  NOT NULL,
    project_logo                     uuid,
    public_foreground                uuid,
    public_background                uuid,
    public_note                      text,
    auth_login_attempts              integer                DEFAULT 25,
    auth_password_policy             character varying(100),
    storage_asset_transform          character varying(7)   DEFAULT 'all'::character varying,
    storage_asset_presets            json,
    custom_css                       text,
    storage_default_folder           uuid,
    basemaps                         json,
    mapbox_key                       character varying(255),
    module_bar                       json,
    project_descriptor               character varying(100),
    default_language                 character varying(255) DEFAULT 'en-US'::character varying    NOT NULL,
    custom_aspect_ratios             json,
    public_favicon                   uuid,
    default_appearance               character varying(255) DEFAULT 'auto'::character varying     NOT NULL,
    default_theme_light              character varying(255),
    theme_light_overrides            json,
    default_theme_dark               character varying(255),
    theme_dark_overrides             json,
    report_error_url                 character varying(255),
    report_bug_url                   character varying(255),
    report_feature_url               character varying(255),
    public_registration              boolean                DEFAULT false                         NOT NULL,
    public_registration_verify_email boolean                DEFAULT true                          NOT NULL,
    public_registration_role         uuid,
    public_registration_email_filter json
);


ALTER TABLE public.directus_settings
    OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_settings_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_settings_id_seq OWNER TO directus;

--
-- Name: directus_settings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_settings_id_seq OWNED BY public.directus_settings.id;


--
-- Name: directus_shares; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_shares
(
    id           uuid                   NOT NULL,
    name         character varying(255),
    collection   character varying(64)  NOT NULL,
    item         character varying(255) NOT NULL,
    role         uuid,
    password     character varying(255),
    user_created uuid,
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_start   timestamp with time zone,
    date_end     timestamp with time zone,
    times_used   integer                  DEFAULT 0,
    max_uses     integer
);


ALTER TABLE public.directus_shares
    OWNER TO directus;

--
-- Name: directus_translations; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_translations
(
    id       uuid                   NOT NULL,
    language character varying(255) NOT NULL,
    key      character varying(255) NOT NULL,
    value    text                   NOT NULL
);


ALTER TABLE public.directus_translations
    OWNER TO directus;

--
-- Name: directus_users; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_users
(
    id                    uuid                                                        NOT NULL,
    first_name            character varying(50),
    last_name             character varying(50),
    email                 character varying(128),
    password              character varying(255),
    location              character varying(255),
    title                 character varying(50),
    description           text,
    tags                  json,
    avatar                uuid,
    language              character varying(255) DEFAULT NULL::character varying,
    tfa_secret            character varying(255),
    status                character varying(16)  DEFAULT 'active'::character varying  NOT NULL,
    role                  uuid,
    token                 character varying(255),
    last_access           timestamp with time zone,
    last_page             character varying(255),
    provider              character varying(128) DEFAULT 'default'::character varying NOT NULL,
    external_identifier   character varying(255),
    auth_data             json,
    email_notifications   boolean                DEFAULT true,
    appearance            character varying(255),
    theme_dark            character varying(255),
    theme_light           character varying(255),
    theme_light_overrides json,
    theme_dark_overrides  json
);


ALTER TABLE public.directus_users
    OWNER TO directus;

--
-- Name: directus_versions; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_versions
(
    id           uuid                   NOT NULL,
    key          character varying(64)  NOT NULL,
    name         character varying(255),
    collection   character varying(64)  NOT NULL,
    item         character varying(255) NOT NULL,
    hash         character varying(255),
    date_created timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    date_updated timestamp with time zone DEFAULT CURRENT_TIMESTAMP,
    user_created uuid,
    user_updated uuid
);


ALTER TABLE public.directus_versions
    OWNER TO directus;

--
-- Name: directus_webhooks; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.directus_webhooks
(
    id                            integer                                                   NOT NULL,
    name                          character varying(255)                                    NOT NULL,
    method                        character varying(10) DEFAULT 'POST'::character varying   NOT NULL,
    url                           character varying(255)                                    NOT NULL,
    status                        character varying(10) DEFAULT 'active'::character varying NOT NULL,
    data                          boolean               DEFAULT true                        NOT NULL,
    actions                       character varying(100)                                    NOT NULL,
    collections                   character varying(255)                                    NOT NULL,
    headers                       json,
    was_active_before_deprecation boolean               DEFAULT false                       NOT NULL,
    migrated_flow                 uuid
);


ALTER TABLE public.directus_webhooks
    OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.directus_webhooks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.directus_webhooks_id_seq OWNER TO directus;

--
-- Name: directus_webhooks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.directus_webhooks_id_seq OWNED BY public.directus_webhooks.id;


--
-- Name: dispense; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.dispense
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.dispense
    OWNER TO directus;

--
-- Name: doping; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.doping
(
    doping character varying(255) NOT NULL,
    name   character varying(255)
);


ALTER TABLE public.doping
    OWNER TO directus;

--
-- Name: dosage_form; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.dosage_form
(
    form    character varying(255)                                 NOT NULL,
    name    character varying(255) DEFAULT NULL::character varying,
    edqm    character varying(255),
    name_en character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.dosage_form
    OWNER TO directus;

--
-- Name: drugs; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.drugs
(
    code                           character varying(255) NOT NULL,
    notification_sign              character varying(1),
    name                           character varying(100) NOT NULL,
    strength                       character varying(30),
    form                           character varying(255),
    package                        character varying(32),
    route                          character varying(255),
    complement                     character varying(100) NOT NULL,
    dosage                         character varying(255),
    organization                   character varying(255),
    organization_country           character varying(255),
    actual_organization            character varying(255),
    actual_organization_country    character varying(255),
    registration_status            character varying(255) NOT NULL,
    valid_till                     date,
    unlimited_registration         character varying(1),
    present_till                   date,
    pharm_class                    character varying(255) NOT NULL,
    atc                            character varying(255) NOT NULL,
    registration_number            character varying(32),
    concurrent_import              character varying(32),
    concurrent_import_organization character varying(255),
    concurrent_import_country      character varying(255),
    registration_procedure         character varying(255),
    daily_amount                   numeric(10, 5)         NOT NULL,
    daily_unit                     character varying(255),
    daily_count                    numeric(10, 5)         NOT NULL,
    source                         character varying(255) NOT NULL,
    dispense                       character varying(255),
    addiction                      character varying(255),
    doping                         character varying(255),
    hormones                       character varying(255),
    supplied                       character varying(1)   NOT NULL,
    "EAN"                          character varying(255),
    brail_sign                     character varying(1),
    expiration                     integer,
    expiration_period              character varying(1),
    registration_name              character varying(255) NOT NULL,
    mrp_number                     character varying(255),
    legal_registration_base        character varying(255),
    safety_element                 character varying(1)
);


ALTER TABLE public.drugs
    OWNER TO directus;

--
-- Name: drugs_ingredients; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.drugs_ingredients
(
    id               integer NOT NULL,
    drugs_code       character varying(255),
    ingredients_code character varying(255)
);


ALTER TABLE public.drugs_ingredients
    OWNER TO directus;

--
-- Name: drugs_ingredients_id_seq; Type: SEQUENCE; Schema: public; Owner: directus
--

CREATE SEQUENCE IF NOT EXISTS public.drugs_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.drugs_ingredients_id_seq OWNER TO directus;

--
-- Name: drugs_ingredients_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: directus
--

ALTER SEQUENCE public.drugs_ingredients_id_seq OWNED BY public.drugs_ingredients.id;


--
-- Name: forms; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.forms
(
    form        character varying(255)                                 NOT NULL,
    name        character varying(255)                                 NOT NULL,
    edqm        character varying(255),
    name_en     character varying(255) DEFAULT NULL::character varying NOT NULL,
    name_lat    character varying(255),
    is_cannabis boolean                DEFAULT false                   NOT NULL
);


ALTER TABLE public.forms
    OWNER TO directus;

--
-- Name: hormones; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.hormones
(
    code character varying(255) NOT NULL,
    name character varying(255)
);


ALTER TABLE public.hormones
    OWNER TO directus;

--
-- Name: ingredients; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.ingredients
(
    code      character varying(255) NOT NULL,
    source    character varying(255) DEFAULT NULL::character varying,
    name      character varying(255),
    addiction character varying(255),
    doping    character varying(255),
    hormones  character varying(255),
    name_intl character varying(255) DEFAULT NULL::character varying,
    name_en   character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.ingredients
    OWNER TO directus;

--
-- Name: legal_registration_base; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.legal_registration_base
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.legal_registration_base
    OWNER TO directus;

--
-- Name: organization; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.organization
(
    code         character varying(255) NOT NULL,
    name         character varying(255),
    country      character varying(255) NOT NULL,
    manufacturer character varying(255),
    holder       character varying(255)
);


ALTER TABLE public.organization
    OWNER TO directus;

--
-- Name: pharm_class; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.pharm_class
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.pharm_class
    OWNER TO directus;

--
-- Name: registration_procedure; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.registration_procedure
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.registration_procedure
    OWNER TO directus;

--
-- Name: registration_status; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.registration_status
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.registration_status
    OWNER TO directus;

--
-- Name: routes; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.routes
(
    route    character varying(255)                                 NOT NULL,
    name     character varying(255)                                 NOT NULL,
    edqm     character varying(255),
    name_en  character varying(255) DEFAULT NULL::character varying NOT NULL,
    name_lat character varying(255) DEFAULT NULL::character varying NOT NULL
);


ALTER TABLE public.routes
    OWNER TO directus;

--
-- Name: source; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.source
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.source
    OWNER TO directus;

--
-- Name: substance; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.substance
(
    code      character varying(255) NOT NULL,
    name      character varying(255),
    addiction character varying(255),
    name_intl character varying(255) DEFAULT NULL::character varying,
    name_en   character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE public.substance
    OWNER TO directus;

--
-- Name: units; Type: TABLE; Schema: public; Owner: directus
--

CREATE TABLE IF NOT EXISTS public.units
(
    unit character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.units
    OWNER TO directus;

--
-- Name: composition id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.composition
    ALTER COLUMN id SET DEFAULT nextval('public.composition_id_seq'::regclass);


--
-- Name: directus_activity id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_activity
    ALTER COLUMN id SET DEFAULT nextval('public.directus_activity_id_seq'::regclass);


--
-- Name: directus_fields id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_fields
    ALTER COLUMN id SET DEFAULT nextval('public.directus_fields_id_seq'::regclass);


--
-- Name: directus_notifications id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_notifications
    ALTER COLUMN id SET DEFAULT nextval('public.directus_notifications_id_seq'::regclass);


--
-- Name: directus_permissions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_permissions
    ALTER COLUMN id SET DEFAULT nextval('public.directus_permissions_id_seq'::regclass);


--
-- Name: directus_presets id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_presets
    ALTER COLUMN id SET DEFAULT nextval('public.directus_presets_id_seq'::regclass);


--
-- Name: directus_relations id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_relations
    ALTER COLUMN id SET DEFAULT nextval('public.directus_relations_id_seq'::regclass);


--
-- Name: directus_revisions id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_revisions
    ALTER COLUMN id SET DEFAULT nextval('public.directus_revisions_id_seq'::regclass);


--
-- Name: directus_settings id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_settings
    ALTER COLUMN id SET DEFAULT nextval('public.directus_settings_id_seq'::regclass);


--
-- Name: directus_webhooks id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.directus_webhooks
    ALTER COLUMN id SET DEFAULT nextval('public.directus_webhooks_id_seq'::regclass);


--
-- Name: drugs_ingredients id; Type: DEFAULT; Schema: public; Owner: directus
--

ALTER TABLE ONLY public.drugs_ingredients
    ALTER COLUMN id SET DEFAULT nextval('public.drugs_ingredients_id_seq'::regclass);

--
-- Data for Name: directus_collections; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_collections_temp AS
SELECT *
FROM public.directus_collections
    WITH NO DATA;

COPY directus_collections_temp (collection, icon, note, display_template, hidden, singleton, translations,
                                archive_field, archive_app_filter, archive_value, unarchive_value, sort_field,
                                accountability, color, item_duplication_fields, sort, "group", collapse, preview_url,
                                versioning) FROM stdin;
Sources	folder	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#2ECDA7	\N	6	\N	open	\N	f
source	barcode	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#2ECDA7	\N	1	Sources	open	\N	f
organization	account_balance	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#2ECDA7	\N	2	Sources	open	\N	f
country	globe_uk	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#2ECDA7	\N	3	Sources	open	\N	f
general	circle	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#3399FF	\N	1	\N	open	\N	f
Composition	stacked_bar_chart	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#FFA439	\N	2	\N	open	\N	f
composition	view_compact	\N	\N	f	f	\N	\N	t	\N	\N	order	all	#FFA439	\N	1	Composition	open	\N	f
composition_sign	exposure_neg_1	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#FFA439	\N	2	Composition	open	\N	f
ingredients	format_list_bulleted	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#FFA439	\N	3	Composition	open	\N	f
substance	pie_chart	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#FFA439	\N	4	Composition	open	\N	f
units	percent	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#FFA439	\N	5	Composition	open	\N	f
dispense	back_hand	Dispense information	{{code}} - {{name}}	f	f	[{"language":"en-US","translation":"Dispense","singular":"Dispense type","plural":"Dispense types"},{"language":"cs-CZ","translation":"Výdej","singular":"Způsob výdeje","plural":"Způsoby výdeje"},{"language":"ru-RU","translation":"Выдача","singular":"Способ выдачи","plural":"Способы выдачи"}]	\N	t	\N	\N	\N	all	#3399FF	\N	2	general	open	\N	f
dosage_form	thermostat_carbon	Dosage form	{{form}} - {{name}}	f	f	\N	\N	t	\N	\N	\N	all	#3399FF	\N	3	general	open	\N	f
forms	medication_liquid	Medical form	{{form}} - {{name}} ({{name_lat}})	f	f	[{"language":"en-US","translation":"Forms","singular":"Form","plural":"Forms"}]	\N	t	\N	\N	\N	all	#3399FF	\N	4	general	open	\N	f
pharm_class	123	Pharmacologic Class	{{code}} - {{name}}	f	f	\N	\N	t	\N	\N	\N	all	#3399FF	\N	5	general	open	\N	f
routes	conversion_path	Medicine application route	\N	f	f	\N	\N	t	\N	\N	\N	all	#3399FF	\N	6	general	open	\N	f
Effects	folder	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#E35169	\N	3	\N	open	\N	f
addiction	potted_plant	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#E35169	\N	1	Effects	open	\N	f
doping	add	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#E35169	\N	2	Effects	open	\N	f
hormones	woman	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#E35169	\N	3	Effects	open	\N	f
Registration	unknown_document	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#A2B5CD	\N	5	\N	open	\N	f
VPOIS	house_siding	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#A2B5CD	\N	1	Registration	open	\N	f
legal_registration_base	document_scanner	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#A2B5CD	\N	2	Registration	open	\N	f
registration_status	incomplete_circle	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#A2B5CD	\N	3	Registration	open	\N	f
registration_procedure	function	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#A2B5CD	\N	4	Registration	open	\N	f
atc	full_stacked_bar_chart	Anatomical Therapeutic Chemical code	{{atc}} / {{name}} ({{name_en}})	f	f	[{"language":"en-US","translation":"Anatomical Therapeutic Chemical codes","singular":"Anatomical Therapeutic Chemical code","plural":"Anatomical Therapeutic Chemical codes"},{"language":"cs-CZ","translation":"Anatomicko-terapeuticko-chemická skupiny","singular":"Anatomicko-terapeuticko-chemická skupina","plural":"Anatomicko-terapeuticko-chemická skupiny"},{"language":"ru-RU","translation":"Анатомо-терапевтическо-химическая классификация","singular":"Анатомо-терапевтическо-химический код","plural":"Анатомо-терапевтическо-химический коды"}]	\N	t	\N	\N	\N	all	#3399FF	\N	1	general	open	\N	f
Drugs	star	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#6644FF	\N	4	\N	open	\N	f
drugs	pill	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#6644FF	\N	1	Drugs	open	\N	f
drugs_ingredients	import_export	\N	\N	f	f	\N	\N	t	\N	\N	\N	all	#6644FF	\N	2	Drugs	open	\N	f
\.

INSERT INTO public.directus_collections
SELECT *
FROM directus_collections_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_collections_temp;


--
-- Data for Name: directus_fields; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_fields_temp AS
SELECT *
FROM public.directus_fields
    WITH NO DATA;

COPY directus_fields_temp (id, collection, field, special, interface, options, display, display_options, readonly,
                           hidden, sort, width, translations, note, conditions, required, "group", validation,
                           validation_message) FROM stdin;
178	drugs	effects	alias,no-data,group	group-detail	{"start":"closed"}	\N	\N	f	f	9	full	\N	\N	\N	f	\N	\N	\N
86	composition	amount	\N	input	\N	formatted-value	{"format":true,"font":"monospace"}	f	f	6	full	\N	\N	\N	f	\N	\N	\N
39	hormones	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
40	hormones	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
27	source	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
28	source	name	\N	input	\N	formatted-value	{}	f	f	2	full	\N	\N	\N	t	\N	\N	\N
63	VPOIS	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
33	units	unit	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
34	units	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
35	addiction	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
36	addiction	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
37	doping	doping	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
38	doping	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
64	VPOIS	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
48	organization	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
49	organization	name	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
50	organization	country	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	full	\N	\N	\N	t	\N	\N	\N
51	organization	manufacturer	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
52	organization	holder	\N	input	\N	formatted-value	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
66	VPOIS	email	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
59	pharm_class	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
67	VPOIS	phone	\N	input	\N	formatted-value	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
70	registration_procedure	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
72	registration_status	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
73	registration_status	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
76	composition_sign	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
79	composition_sign	description	\N	input-multiline	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
84	composition	sign	m2o	select-dropdown-m2o	{"template":"{{code}} - {{description}}"}	related-values	{"template":"{{code}}"}	f	f	5	full	\N	\N	\N	f	\N	\N	\N
87	composition	unit	m2o	select-dropdown-m2o	{"template":"{{unit}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	9	full	\N	\N	\N	f	\N	\N	\N
80	composition	id	\N	input	\N	\N	\N	t	t	1	full	\N	\N	\N	f	\N	\N	\N
85	composition	amount_from	\N	input	\N	formatted-value	{"format":true,"font":"monospace"}	f	f	8	full	\N	\N	\N	f	\N	\N	\N
65	VPOIS	web	\N	input	\N	extension-display-link	{"conditionalFormatting":null}	f	f	3	full	\N	\N	\N	f	\N	\N	\N
81	composition	code	\N	input	\N	formatted-value	{"bold":true}	f	f	2	full	\N	\N	\N	t	\N	\N	\N
83	composition	order	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
93	legal_registration_base	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
94	legal_registration_base	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
114	drugs	organization	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	1	half	\N	\N	\N	f	sources	\N	\N
175	drugs	composition	alias,no-data,group	group-detail	{"accordionMode":false,"start":"closed"}	\N	\N	f	f	8	full	\N	\N	\N	f	\N	\N	\N
110	drugs	package	\N	input	\N	formatted-value	\N	f	f	3	half	\N	\N	\N	t	general	\N	\N
41	ingredients	addiction	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	6	full	\N	\N	\N	f	\N	\N	\N
22	routes	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
32	ingredients	name	\N	input	\N	formatted-value	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
42	ingredients	doping	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	7	full	\N	\N	\N	f	\N	\N	\N
43	ingredients	hormones	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	8	full	\N	\N	\N	f	\N	\N	\N
57	substance	name	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
29	ingredients	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
30	ingredients	source	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	full	\N	\N	\N	f	\N	\N	\N
58	substance	addiction	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	5	full	\N	\N	\N	f	\N	\N	\N
56	substance	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
44	country	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
45	country	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	t	\N	\N	\N
46	country	edqm	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
109	drugs	form	m2o	select-dropdown-m2o	{"template":"{{form}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	half	\N	\N	\N	t	general	\N	\N
53	atc	atc	\N	input	\N	formatted-value	\N	f	f	1	full	[{"language":"en-US","translation":"ATC code"},{"language":"cs-CZ","translation":"ATC skupina"},{"language":"ru-RU","translation":"АТХ код"}]	ATC code	\N	t	\N	\N	\N
54	atc	nt	\N	input	\N	formatted-value	\N	f	f	2	full	\N	N - according to ATC index; C - according to SUKL index	\N	t	\N	\N	\N
16	forms	form	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	Medical form	\N	t	\N	\N	\N
24	dosage_form	form	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	Form code	\N	t	\N	\N	\N
26	dosage_form	edqm	\N	input	\N	formatted-value	{"icon":"barcode","border":true}	f	f	4	full	\N	$t:edqm_code	\N	f	\N	\N	\N
25	dosage_form	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	$t:czech_name	\N	t	\N	\N	\N
55	atc	name	\N	input	\N	formatted-value	\N	f	f	3	full	\N	$t:czech_name	\N	t	\N	\N	\N
17	forms	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	$t:czech_name	\N	t	\N	\N	\N
20	forms	edqm	\N	input	\N	formatted-value	{"icon":"barcode","border":true}	f	f	6	half	\N	$t:edqm_code	\N	f	\N	\N	\N
60	pharm_class	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	$t:czech_name	\N	t	\N	\N	\N
71	registration_procedure	name	\N	input	\N	formatted-value	\N	f	f	2	full	\N	$t:czech_name	\N	t	\N	\N	\N
180	drugs	general	alias,no-data,group	group-detail	{"headerColor":"#3399FF","headerIcon":"circle"}	\N	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
111	drugs	route	m2o	select-dropdown-m2o	{"template":"{{route}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	4	half	\N	\N	\N	f	general	\N	\N
113	drugs	dosage	m2o	select-dropdown-m2o	{"template":"{{form}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	6	full	\N	\N	\N	f	general	\N	\N
118	drugs	registration_status	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	1	full	\N	\N	\N	t	registration	\N	\N
122	drugs	pharm_class	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{name}}"}	f	f	7	full	\N	\N	\N	t	general	\N	\N
132	drugs	source	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	9	full	\N	\N	\N	t	registration	\N	\N
131	drugs	daily_count	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	t	dispense_info	\N	\N
138	drugs	dispense	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	4	full	\N	\N	\N	f	dispense_info	\N	\N
176	drugs	sources	alias,no-data,group	group-detail	{"accordionMode":false,"start":"closed"}	\N	\N	f	f	5	full	\N	\N	\N	f	\N	\N	\N
112	drugs	complement	\N	input	\N	formatted-value	\N	f	f	5	full	\N	\N	\N	t	general	\N	\N
146	drugs	expiration_period	\N	input	\N	formatted-value	\N	f	f	6	half	\N	\N	\N	f	miscellaneous	\N	\N
82	composition	ingredient	m2o	select-dropdown-m2o	{"template":"{{name}}"}	related-values	{"template":"{{code}} - {{name}}"}	f	f	3	full	\N	\N	\N	f	\N	\N	\N
123	drugs	atc	m2o	select-dropdown-m2o	{"template":"{{atc}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	1	full	\N	\N	\N	t	miscellaneous	\N	\N
142	drugs	supplied	\N	input	\N	formatted-value	\N	f	f	2	half	\N	\N	\N	t	miscellaneous	\N	\N
139	drugs	addiction	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	1	full	\N	\N	\N	f	effects	\N	\N
140	drugs	doping	m2o	select-dropdown-m2o	{"template":"{{doping}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	full	\N	\N	\N	f	effects	\N	\N
141	drugs	hormones	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	3	full	\N	\N	\N	f	effects	\N	\N
119	drugs	valid_till	\N	datetime	\N	datetime	{"format":"short"}	f	f	2	half	\N	Drug registration validity till this date	\N	f	registration	\N	\N
179	drugs	dispense_info	alias,no-data,group	group-detail	{"start":"closed"}	\N	\N	f	f	7	full	\N	\N	\N	f	\N	\N	\N
120	drugs	unlimited_registration	\N	input	\N	formatted-value	\N	f	f	4	full	\N	If "X" then the drug has limitless registration period	\N	f	registration	{"_and":[{"unlimited_registration":{"_regex":"X"}}]}	\N
150	drugs	safety_element	\N	input	\N	formatted-value	\N	f	f	8	full	\N	\N	\N	f	miscellaneous	\N	\N
121	drugs	present_till	\N	datetime	\N	datetime	\N	f	f	3	half	\N	Present on market till this date	\N	f	registration	\N	\N
124	drugs	registration_number	\N	input	\N	formatted-value	\N	f	f	5	full	\N	\N	\N	f	registration	\N	\N
147	drugs	registration_name	\N	input	\N	formatted-value	\N	f	f	7	full	\N	\N	\N	t	registration	\N	\N
128	drugs	registration_procedure	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	6	full	\N	\N	\N	f	registration	\N	\N
148	drugs	mrp_number	\N	input	\N	formatted-value	\N	f	f	7	full	\N	\N	\N	f	miscellaneous	\N	\N
107	drugs	name	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
135	drugs_ingredients	id	\N	\N	\N	\N	\N	f	t	1	full	\N	\N	\N	f	\N	\N	\N
136	drugs_ingredients	drugs_code	\N	\N	\N	\N	\N	f	t	2	full	\N	\N	\N	f	\N	\N	\N
137	drugs_ingredients	ingredients_code	\N	\N	\N	\N	\N	f	t	3	full	\N	\N	\N	f	\N	\N	\N
149	drugs	legal_registration_base	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	8	full	\N	\N	\N	f	registration	\N	\N
143	drugs	EAN	\N	input	\N	formatted-value	\N	f	f	3	half	\N	\N	\N	f	miscellaneous	\N	\N
116	drugs	actual_organization	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	3	half	\N	\N	\N	f	sources	\N	\N
129	drugs	daily_amount	\N	input	\N	formatted-value	\N	f	f	1	half	\N	\N	\N	t	dispense_info	\N	\N
126	drugs	concurrent_import_organization	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	6	half	\N	\N	\N	f	sources	\N	\N
117	drugs	actual_organization_country	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	4	half	\N	\N	\N	f	sources	\N	\N
127	drugs	concurrent_import_country	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	7	half	\N	\N	\N	f	sources	\N	\N
144	drugs	brail_sign	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	f	miscellaneous	\N	\N
145	drugs	expiration	\N	input	\N	formatted-value	\N	f	f	5	half	\N	\N	\N	f	miscellaneous	\N	\N
177	drugs	registration	alias,no-data,group	group-detail	{"accordionMode":false,"start":"closed"}	\N	\N	f	f	6	full	\N	\N	\N	f	\N	\N	\N
130	drugs	daily_unit	m2o	select-dropdown-m2o	{"template":"{{unit}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	half	\N	\N	\N	f	dispense_info	\N	\N
115	drugs	organization_country	m2o	select-dropdown-m2o	{"template":"{{code}} - {{name}}"}	related-values	{"template":"{{name}}"}	f	f	2	half	\N	\N	\N	f	sources	\N	\N
181	drugs	miscellaneous	alias,no-data,group	group-detail	{"start":"closed"}	\N	\N	f	f	10	full	\N	\N	\N	f	\N	\N	\N
134	drugs	ingredients	m2m	list-m2m	{"layout":"table","enableSearchFilter":true,"enableLink":true,"fields":["ingredients_code.code","ingredients_code.name"]}	related-values	\N	f	f	1	full	\N	\N	\N	f	composition	\N	\N
105	drugs	code	\N	input	\N	formatted-value	{"bold":true}	f	f	1	half	\N	\N	\N	t	\N	{"_and":[{"code":{"_regex":"\\\\d{7}"}}]}	\N
106	drugs	notification_sign	\N	input	\N	\N	\N	f	f	2	half	\N	\N	\N	f	\N	{"_and":[{"notification_sign":{"_contains":"H"}}]}	\N
125	drugs	concurrent_import	\N	input	\N	formatted-value	\N	f	f	5	full	\N	Usually in the form PI/xxx/yyyy	\N	f	sources	\N	\N
21	routes	route	\N	input	\N	formatted-value	{"bold":true}	f	f	1	full	\N	\N	\N	t	\N	\N	\N
258	routes	name_en	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
259	routes	name_lat	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	t	\N	\N	\N
23	routes	edqm	\N	input	\N	formatted-value	{"icon":"barcode","border":true}	f	f	5	full	\N	\N	\N	f	\N	\N	\N
263	ingredients	name_intl	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
264	ingredients	name_en	\N	input	\N	formatted-value	\N	f	f	4	full	\N	\N	\N	f	\N	\N	\N
265	substance	name_intl	\N	input	\N	formatted-value	\N	f	f	2	full	\N	\N	\N	f	\N	\N	\N
266	substance	name_en	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	f	\N	\N	\N
268	country	name_en	\N	input	\N	formatted-value	\N	f	f	3	full	\N	\N	\N	t	\N	\N	\N
61	dispense	code	\N	input	\N	formatted-value	{"bold":true,"conditionalFormatting":[{"operator":"eq","value":"V","color":"#E35169","icon":"close"},{"operator":"eq","value":"C","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"L","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"R","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"P","color":"#FFC23B","icon":"counter_7"},{"operator":"eq","value":"O","color":"#FFC23B","icon":"counter_6"},{"operator":"eq","value":"F","color":"#2ECDA7","icon":"counter_0"}]}	f	f	1	full	\N	Dispense code of the drug	\N	t	\N	\N	\N
267	dosage_form	name_en	\N	input	\N	formatted-value	\N	f	f	3	full	\N	$t:english_name	\N	t	\N	\N	\N
257	atc	name_en	\N	input	{"iconLeft":"language_international"}	formatted-value	\N	f	f	4	full	\N	$t:english_name	\N	t	\N	\N	\N
62	dispense	name	\N	input	\N	formatted-value	{"conditionalFormatting":[{"operator":"eq","value":"V","color":"#E35169","icon":"close"},{"operator":"eq","value":"C","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"L","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"R","color":"#FFA439","icon":"counter_9"},{"operator":"eq","value":"P","color":"#FFC23B","icon":"counter_7"},{"operator":"eq","value":"O","color":"#FFC23B","icon":"counter_6"},{"operator":"eq","value":"F","color":"#2ECDA7","icon":"counter_0"}]}	f	f	2	full	\N	$t:czech_name	\N	t	\N	\N	\N
260	forms	name_en	\N	input	\N	formatted-value	\N	f	f	3	full	\N	$t:english_name	\N	t	\N	\N	\N
261	forms	name_lat	\N	input	\N	formatted-value	\N	f	f	4	full	\N	$t:latin_name	\N	f	\N	\N	\N
262	forms	is_cannabis	cast-boolean	boolean	\N	boolean	{"iconOff":"smoke_free","iconOn":"smoking_rooms","colorOff":"#2ECDA7","colorOn":"#FFA439"}	f	f	5	half	[{"language":"cs-CZ","translation":"Je konopi"}]	The form is used when prescribing medical cannabis	\N	t	\N	\N	\N
108	drugs	strength	\N	input	\N	formatted-value	{"format":true,"conditionalFormatting":[{"operator":"contains","value":"MG","color":"#FFA439","icon":"avg_pace"},{"operator":"contains","value":"mg","color":"#FFA439","icon":"avg_pace"},{"operator":"contains","value":"ml","color":"#3399FF","icon":"water_drop"},{"operator":"contains","value":"ML","color":"#3399FF","icon":"water_drop"},{"operator":"contains","value":"%","color":"#6644FF","icon":"percent"}],"color":null}	f	f	1	half	\N	\N	[{"name":"Is milliliters","rule":{"_and":[{"_or":[{"strength":{"_contains":"ML"}},{"strength":{"_contains":"ml"}}]}]},"options":{"font":"sans-serif","trim":false,"masked":false,"clear":false,"slug":false,"iconLeft":"water_drop"}}]	f	general	\N	\N
\.

INSERT INTO public.directus_fields
SELECT *
FROM directus_fields_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_fields_temp;

--
-- Data for Name: directus_migrations; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_migrations_temp AS
SELECT *
FROM public.directus_migrations
    WITH NO DATA;

COPY directus_migrations_temp (version, name, "timestamp") FROM stdin;
20201028A	Remove Collection Foreign Keys	2023-09-12 16:56:27.501076+00
20201029A	Remove System Relations	2023-09-12 16:56:27.506998+00
20201029B	Remove System Collections	2023-09-12 16:56:27.51331+00
20201029C	Remove System Fields	2023-09-12 16:56:27.526572+00
20201105A	Add Cascade System Relations	2023-09-12 16:56:28.567277+00
20201105B	Change Webhook URL Type	2023-09-12 16:56:29.266014+00
20210225A	Add Relations Sort Field	2023-09-12 16:56:29.568072+00
20210304A	Remove Locked Fields	2023-09-12 16:56:29.714537+00
20210312A	Webhooks Collections Text	2023-09-12 16:56:29.791102+00
20210331A	Add Refresh Interval	2023-09-12 16:56:29.798359+00
20210415A	Make Filesize Nullable	2023-09-12 16:56:29.809674+00
20210416A	Add Collections Accountability	2023-09-12 16:56:29.815775+00
20210422A	Remove Files Interface	2023-09-12 16:56:29.819104+00
20210506A	Rename Interfaces	2023-09-12 16:56:29.853191+00
20210510A	Restructure Relations	2023-09-12 16:56:29.882754+00
20210518A	Add Foreign Key Constraints	2023-09-12 16:56:29.891665+00
20210519A	Add System Fk Triggers	2023-09-12 16:56:29.924774+00
20210521A	Add Collections Icon Color	2023-09-12 16:56:29.928676+00
20210525A	Add Insights	2023-09-12 16:56:29.958611+00
20210608A	Add Deep Clone Config	2023-09-12 16:56:29.963121+00
20210626A	Change Filesize Bigint	2023-09-12 16:56:29.980489+00
20210716A	Add Conditions to Fields	2023-09-12 16:56:29.984201+00
20210721A	Add Default Folder	2023-09-12 16:56:29.992123+00
20210802A	Replace Groups	2023-09-12 16:56:29.997496+00
20210803A	Add Required to Fields	2023-09-12 16:56:30.00137+00
20210805A	Update Groups	2023-09-12 16:56:30.006471+00
20210805B	Change Image Metadata Structure	2023-09-12 16:56:30.0114+00
20210811A	Add Geometry Config	2023-09-12 16:56:30.015986+00
20210831A	Remove Limit Column	2023-09-12 16:56:30.019759+00
20210903A	Add Auth Provider	2023-09-12 16:56:30.043332+00
20210907A	Webhooks Collections Not Null	2023-09-12 16:56:30.05235+00
20210910A	Move Module Setup	2023-09-12 16:56:30.057338+00
20210920A	Webhooks URL Not Null	2023-09-12 16:56:30.066205+00
20210924A	Add Collection Organization	2023-09-12 16:56:30.072905+00
20210927A	Replace Fields Group	2023-09-12 16:56:30.082553+00
20210927B	Replace M2M Interface	2023-09-12 16:56:30.085338+00
20210929A	Rename Login Action	2023-09-12 16:56:30.08823+00
20211007A	Update Presets	2023-09-12 16:56:30.09528+00
20211009A	Add Auth Data	2023-09-12 16:56:30.099924+00
20211016A	Add Webhook Headers	2023-09-12 16:56:30.103735+00
20211103A	Set Unique to User Token	2023-09-12 16:56:30.109836+00
20211103B	Update Special Geometry	2023-09-12 16:56:30.11318+00
20211104A	Remove Collections Listing	2023-09-12 16:56:30.116753+00
20211118A	Add Notifications	2023-09-12 16:56:30.133868+00
20211211A	Add Shares	2023-09-12 16:56:30.155475+00
20211230A	Add Project Descriptor	2023-09-12 16:56:30.158959+00
20220303A	Remove Default Project Color	2023-09-12 16:56:30.167184+00
20220308A	Add Bookmark Icon and Color	2023-09-12 16:56:30.171199+00
20220314A	Add Translation Strings	2023-09-12 16:56:30.174726+00
20220322A	Rename Field Typecast Flags	2023-09-12 16:56:30.180112+00
20220323A	Add Field Validation	2023-09-12 16:56:30.184079+00
20220325A	Fix Typecast Flags	2023-09-12 16:56:30.190166+00
20220325B	Add Default Language	2023-09-12 16:56:30.202065+00
20220402A	Remove Default Value Panel Icon	2023-09-12 16:56:30.210808+00
20220429A	Add Flows	2023-09-12 16:56:30.25396+00
20220429B	Add Color to Insights Icon	2023-09-12 16:56:30.258364+00
20220429C	Drop Non Null From IP of Activity	2023-09-12 16:56:30.261758+00
20220429D	Drop Non Null From Sender of Notifications	2023-09-12 16:56:30.264803+00
20220614A	Rename Hook Trigger to Event	2023-09-12 16:56:30.267482+00
20220801A	Update Notifications Timestamp Column	2023-09-12 16:56:30.276552+00
20220802A	Add Custom Aspect Ratios	2023-09-12 16:56:30.28023+00
20220826A	Add Origin to Accountability	2023-09-12 16:56:30.285398+00
20230401A	Update Material Icons	2023-09-12 16:56:30.295271+00
20230525A	Add Preview Settings	2023-09-12 16:56:30.299304+00
20230526A	Migrate Translation Strings	2023-09-12 16:56:30.314243+00
20230721A	Require Shares Fields	2023-09-12 16:56:30.319745+00
20230823A	Add Content Versioning	2023-10-29 20:30:19.465353+00
20230927A	Themes	2023-10-29 20:30:19.824658+00
20231009A	Update CSV Fields to Text	2023-10-29 20:30:19.858828+00
20231009B	Update Panel Options	2023-10-29 20:30:19.880479+00
20231010A	Add Extensions	2023-10-29 20:30:19.975425+00
20231215A	Add Focalpoints	2024-02-08 10:13:59.433093+00
20240204A	Marketplace	2024-03-30 22:47:39.354256+00
20240122A	Add Report URL Fields	2024-06-13 11:50:47.830659+00
20240305A	Change Useragent Type	2024-06-13 11:50:47.879434+00
20240311A	Deprecate Webhooks	2024-06-13 11:50:48.347335+00
20240422A	Public Registration	2024-06-13 11:50:48.507546+00
20240515A	Add Session Window	2024-06-13 11:50:48.51778+00
\.

INSERT INTO public.directus_migrations
SELECT *
FROM directus_migrations_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_migrations_temp;

--
-- Data for Name: directus_permissions; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_permissions_temp AS
SELECT *
FROM public.directus_permissions
    WITH NO DATA;

COPY directus_permissions_temp (id, role, collection, action, permissions, validation, presets, fields) FROM stdin;
7	\N	forms	read	{}	{}	\N	*
12	\N	routes	read	{}	{}	\N	*
21	\N	dosage_form	read	{}	{}	\N	*
23	\N	ingredients	read	{}	{}	\N	*
30	\N	source	read	{}	{}	\N	*
32	\N	units	read	{}	{}	\N	*
33	\N	addiction	read	{}	{}	\N	*
35	\N	hormones	read	{}	{}	\N	*
36	\N	doping	read	{}	{}	\N	*
37	\N	atc	read	{}	{}	\N	*
38	\N	country	read	{}	{}	\N	*
39	\N	dispense	read	{}	{}	\N	*
40	\N	organization	read	{}	{}	\N	*
41	\N	pharm_class	read	{}	{}	\N	*
42	\N	substance	read	{}	{}	\N	*
43	\N	VPOIS	read	{}	{}	\N	*
73	\N	composition	read	{}	{}	\N	*
74	\N	composition_sign	read	{}	{}	\N	*
75	\N	registration_status	read	{}	{}	\N	*
76	\N	registration_procedure	read	{}	{}	\N	*
78	\N	legal_registration_base	read	{}	{}	\N	*
79	\N	drugs	read	{}	{}	\N	*
80	\N	drugs_ingredients	read	{}	{}	\N	*
\.

INSERT INTO public.directus_permissions
SELECT *
FROM directus_permissions_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_permissions_temp;

--
-- Data for Name: directus_relations; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_relations_temp AS
SELECT *
FROM public.directus_relations
    WITH NO DATA;

COPY directus_relations_temp (id, many_collection, many_field, one_collection, one_field, one_collection_field,
                              one_allowed_collections, junction_field, sort_field, one_deselect_action) FROM stdin;
3	ingredients	source	source	\N	\N	\N	\N	\N	nullify
4	ingredients	addiction	addiction	\N	\N	\N	\N	\N	nullify
5	ingredients	doping	doping	\N	\N	\N	\N	\N	nullify
6	ingredients	hormones	hormones	\N	\N	\N	\N	\N	nullify
7	organization	country	country	\N	\N	\N	\N	\N	nullify
8	substance	addiction	addiction	\N	\N	\N	\N	\N	nullify
9	composition	ingredient	ingredients	\N	\N	\N	\N	\N	nullify
10	composition	sign	composition_sign	\N	\N	\N	\N	\N	nullify
11	composition	unit	units	\N	\N	\N	\N	\N	nullify
15	drugs	form	forms	\N	\N	\N	\N	\N	nullify
16	drugs	route	routes	\N	\N	\N	\N	\N	nullify
17	drugs	dosage	dosage_form	\N	\N	\N	\N	\N	nullify
18	drugs	organization	organization	\N	\N	\N	\N	\N	nullify
19	drugs	organization_country	country	\N	\N	\N	\N	\N	nullify
20	drugs	actual_organization	organization	\N	\N	\N	\N	\N	nullify
21	drugs	actual_organization_country	country	\N	\N	\N	\N	\N	nullify
22	drugs	registration_status	registration_status	\N	\N	\N	\N	\N	nullify
23	drugs	pharm_class	pharm_class	\N	\N	\N	\N	\N	nullify
24	drugs	atc	atc	\N	\N	\N	\N	\N	nullify
25	drugs	concurrent_import_organization	organization	\N	\N	\N	\N	\N	nullify
26	drugs	concurrent_import_country	country	\N	\N	\N	\N	\N	nullify
27	drugs	registration_procedure	registration_procedure	\N	\N	\N	\N	\N	nullify
28	drugs	daily_unit	units	\N	\N	\N	\N	\N	nullify
29	drugs	source	source	\N	\N	\N	\N	\N	nullify
30	drugs_ingredients	ingredients_code	ingredients	\N	\N	\N	drugs_code	\N	nullify
31	drugs_ingredients	drugs_code	drugs	ingredients	\N	\N	ingredients_code	\N	nullify
32	drugs	dispense	dispense	\N	\N	\N	\N	\N	nullify
33	drugs	addiction	addiction	\N	\N	\N	\N	\N	nullify
34	drugs	doping	doping	\N	\N	\N	\N	\N	nullify
35	drugs	hormones	hormones	\N	\N	\N	\N	\N	nullify
36	drugs	legal_registration_base	legal_registration_base	\N	\N	\N	\N	\N	nullify
\.

INSERT INTO public.directus_relations
SELECT *
FROM directus_relations_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_relations_temp;

--
-- Data for Name: directus_settings; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_settings_temp AS
SELECT *
FROM public.directus_settings
    WITH NO DATA;

COPY directus_settings_temp (id, project_name, project_url, project_color, project_logo, public_foreground,
                             public_background, public_note, auth_login_attempts, auth_password_policy,
                             storage_asset_transform, storage_asset_presets, custom_css, storage_default_folder,
                             basemaps, mapbox_key, module_bar, project_descriptor, default_language,
                             custom_aspect_ratios, public_favicon, default_appearance, default_theme_light,
                             theme_light_overrides, default_theme_dark, theme_dark_overrides, report_error_url,
                             report_bug_url, report_feature_url, public_registration,
                             public_registration_verify_email, public_registration_role,
                             public_registration_email_filter) FROM stdin;
1	Czech Drugs Database	directus.settler.tech	#2ECDA7	\N	\N	\N	\N	25	\N	all	\N		\N	\N	\N	[{"type":"module","id":"content","enabled":true},{"type":"module","id":"users","enabled":true},{"type":"module","id":"files","enabled":true},{"type":"module","id":"insights","enabled":true},{"type":"module","id":"settings","enabled":true,"locked":true}]	All Czech Republic drugs available. Data taken from State Institute for Drug Control - Open Data	en-US	\N	\N	dark	Directus Color Match	{}	Directus Default	\N	\N	\N	\N	f	t	\N	\N
\.

INSERT INTO public.directus_settings
SELECT *
FROM directus_settings_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_settings_temp;

--
-- Data for Name: directus_translations; Type: TABLE DATA; Schema: public; Owner: directus
--

CREATE TEMP TABLE directus_translations_temp AS
SELECT *
FROM public.directus_translations
    WITH NO DATA;

COPY directus_translations_temp (id, language, key, value) FROM stdin;
734766d1-e156-40e6-8daf-1f231a424704	en-US	czech_name	Czech name
59bf94ad-f6de-4445-8311-56e684b3ebe5	en-US	english_name	English name
45d18db1-a937-41b9-853b-4c36a00f076c	en-US	edqm_code	EDQM code
d2d76e71-d69a-4a27-b457-8cf68d51ece2	cs-CZ	edqm_code	Kód EDQM
2c37314f-bd86-481a-b6c2-6e0e256af523	cs-CZ	english_name	Anglický název
d719018b-774d-4153-8c89-7fe8ab594752	cs-CZ	czech_name	Český název
ad796ca3-ce1a-4540-9a98-f7e44350a000	en-US	latin_name	Latin name
\.

INSERT INTO public.directus_translations
SELECT *
FROM directus_translations_temp
ON CONFLICT DO NOTHING;

DROP TABLE directus_translations_temp;



SELECT pg_catalog.setval('public.directus_fields_id_seq', 268, true);
SELECT pg_catalog.setval('public.directus_permissions_id_seq', 80, true);
SELECT pg_catalog.setval('public.directus_relations_id_seq', 36, true);
SELECT pg_catalog.setval('public.directus_settings_id_seq', 1, true);



SELECT public.create_constraint_if_not_exists('public."VPOIS"', 'VPOIS_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.addiction', 'addiction_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.atc', 'atc_pkey', 'PRIMARY KEY (atc)');

SELECT public.create_constraint_if_not_exists('public.composition', 'composition_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_ingredient_foreign',
                                              'FOREIGN KEY (ingredient) REFERENCES public.ingredients (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_sign_foreign',
                                              'FOREIGN KEY (sign) REFERENCES public.composition_sign (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_unit_foreign',
                                              'FOREIGN KEY (unit) REFERENCES public.units (unit) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.composition_sign', 'composition_sign_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.country', 'country_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.directus_activity', 'directus_activity_pkey', 'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_collections', 'directus_collections_pkey',
                                              'PRIMARY KEY (collection)');
SELECT public.create_constraint_if_not_exists('public.directus_collections', 'directus_collections_group_foreign',
                                              'FOREIGN KEY ("group") REFERENCES public.directus_collections (collection)');

SELECT public.create_constraint_if_not_exists('public.directus_dashboards', 'directus_dashboards_pkey',
                                              'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_dashboards', 'directus_dashboards_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_extensions', 'directus_extensions_pkey',
                                              'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_fields', 'directus_fields_pkey', 'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_files', 'directus_files_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_files', 'directus_files_folder_foreign',
                                              'FOREIGN KEY (folder) REFERENCES public.directus_folders (id) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.directus_files', 'directus_files_modified_by_foreign',
                                              'FOREIGN KEY (modified_by) REFERENCES public.directus_users (id)');
SELECT public.create_constraint_if_not_exists('public.directus_files', 'directus_files_uploaded_by_foreign',
                                              'FOREIGN KEY (uploaded_by) REFERENCES public.directus_users (id)');

SELECT public.create_constraint_if_not_exists('public.directus_flows', 'directus_flows_operation_unique',
                                              'UNIQUE (operation)');
SELECT public.create_constraint_if_not_exists('public.directus_flows', 'directus_flows_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_flows', 'directus_flows_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_folders', 'directus_folders_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_folders', 'directus_folders_parent_foreign',
                                              'FOREIGN KEY (parent) REFERENCES public.directus_folders (id)');

SELECT public.create_constraint_if_not_exists('public.directus_migrations', 'directus_migrations_pkey',
                                              'PRIMARY KEY (version)');

SELECT public.create_constraint_if_not_exists('public.directus_notifications', 'directus_notifications_pkey',
                                              'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_notifications',
                                              'directus_notifications_recipient_foreign',
                                              'FOREIGN KEY (recipient) REFERENCES public.directus_users (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_notifications', 'directus_notifications_sender_foreign',
                                              'FOREIGN KEY (sender) REFERENCES public.directus_users (id)');

SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_pkey',
                                              'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_reject_unique',
                                              'UNIQUE (reject)');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_resolve_unique',
                                              'UNIQUE (resolve)');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_flow_foreign',
                                              'FOREIGN KEY (flow) REFERENCES public.directus_flows (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_reject_foreign',
                                              'FOREIGN KEY (reject) REFERENCES public.directus_operations (id)');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_resolve_foreign',
                                              'FOREIGN KEY (resolve) REFERENCES public.directus_operations (id)');
SELECT public.create_constraint_if_not_exists('public.directus_operations', 'directus_operations_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_panels', 'directus_panels_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_panels', 'directus_panels_dashboard_foreign',
                                              'FOREIGN KEY (dashboard) REFERENCES public.directus_dashboards (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_panels', 'directus_panels_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_permissions', 'directus_permissions_pkey',
                                              'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_permissions', 'directus_permissions_role_foreign',
                                              'FOREIGN KEY (role) REFERENCES public.directus_roles (id) ON DELETE CASCADE');

SELECT public.create_constraint_if_not_exists('public.directus_presets', 'directus_presets_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_presets', 'directus_presets_role_foreign',
                                              'FOREIGN KEY (role) REFERENCES public.directus_roles (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_presets', 'directus_presets_user_foreign',
                                              'FOREIGN KEY ("user") REFERENCES public.directus_users (id) ON DELETE CASCADE');

SELECT public.create_constraint_if_not_exists('public.directus_relations', 'directus_relations_pkey',
                                              'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_revisions', 'directus_revisions_pkey',
                                              'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_revisions', 'directus_revisions_activity_foreign',
                                              'FOREIGN KEY (activity) REFERENCES public.directus_activity (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_revisions', 'directus_revisions_parent_foreign',
                                              'FOREIGN KEY (parent) REFERENCES public.directus_revisions (id)');
SELECT public.create_constraint_if_not_exists('public.directus_revisions', 'directus_revisions_version_foreign',
                                              'FOREIGN KEY (version) REFERENCES public.directus_versions (id) ON DELETE CASCADE');

SELECT public.create_constraint_if_not_exists('public.directus_roles', 'directus_roles_pkey', 'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_sessions', 'directus_sessions_pkey',
                                              'PRIMARY KEY (token)');

SELECT public.create_constraint_if_not_exists('public.directus_settings', 'directus_settings_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_sessions', 'directus_sessions_share_foreign',
                                              'FOREIGN KEY (share) REFERENCES public.directus_shares (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_sessions', 'directus_sessions_user_foreign',
                                              'FOREIGN KEY ("user") REFERENCES public.directus_users (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_settings', 'directus_settings_project_logo_foreign',
                                              'FOREIGN KEY (project_logo) REFERENCES public.directus_files (id)');
SELECT public.create_constraint_if_not_exists('public.directus_settings', 'directus_settings_public_background_foreign',
                                              'FOREIGN KEY (public_background) REFERENCES public.directus_files (id)');
SELECT public.create_constraint_if_not_exists('public.directus_settings', 'directus_settings_public_favicon_foreign',
                                              'FOREIGN KEY (public_favicon) REFERENCES public.directus_files (id)');
SELECT public.create_constraint_if_not_exists('public.directus_settings', 'directus_settings_public_foreground_foreign',
                                              'FOREIGN KEY (public_foreground) REFERENCES public.directus_files (id)');
SELECT public.create_constraint_if_not_exists('public.directus_settings',
                                              'directus_settings_public_registration_role_foreign',
                                              'FOREIGN KEY (public_registration_role) REFERENCES public.directus_roles (id) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.directus_settings',
                                              'directus_settings_storage_default_folder_foreign',
                                              'FOREIGN KEY (storage_default_folder) REFERENCES public.directus_folders (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_shares', 'directus_shares_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_shares', 'directus_shares_collection_foreign',
                                              'FOREIGN KEY (collection) REFERENCES public.directus_collections (collection) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_shares', 'directus_shares_role_foreign',
                                              'FOREIGN KEY (role) REFERENCES public.directus_roles (id) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_shares', 'directus_shares_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_translations', 'directus_translations_pkey',
                                              'PRIMARY KEY (id)');

SELECT public.create_constraint_if_not_exists('public.directus_users', 'directus_users_email_unique', 'UNIQUE (email)');
SELECT public.create_constraint_if_not_exists('public.directus_users', 'directus_users_external_identifier_unique',
                                              'UNIQUE (external_identifier)');
SELECT public.create_constraint_if_not_exists('public.directus_users', 'directus_users_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_users', 'directus_users_token_unique', 'UNIQUE (token)');
SELECT public.create_constraint_if_not_exists('public.directus_users', 'directus_users_role_foreign',
                                              'FOREIGN KEY (role) REFERENCES public.directus_roles (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.directus_versions', 'directus_versions_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_versions', 'directus_versions_collection_foreign',
                                              'FOREIGN KEY (collection) REFERENCES public.directus_collections (collection) ON DELETE CASCADE');
SELECT public.create_constraint_if_not_exists('public.directus_versions', 'directus_versions_user_created_foreign',
                                              'FOREIGN KEY (user_created) REFERENCES public.directus_users (id) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.directus_versions', 'directus_versions_user_updated_foreign',
                                              'FOREIGN KEY (user_updated) REFERENCES public.directus_users (id)');

SELECT public.create_constraint_if_not_exists('public.directus_webhooks', 'directus_webhooks_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.directus_webhooks', 'directus_webhooks_migrated_flow_foreign',
                                              'FOREIGN KEY (migrated_flow) REFERENCES public.directus_flows (id) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.dispense', 'dispense_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.doping', 'doping_pkey', 'PRIMARY KEY (doping)');

SELECT public.create_constraint_if_not_exists('public.dosage_form', 'dosage_form_pkey', 'PRIMARY KEY (form)');

SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_drugs_code_foreign',
                                              'FOREIGN KEY (drugs_code) REFERENCES public.drugs (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_ingredients_code_foreign',
                                              'FOREIGN KEY (ingredients_code) REFERENCES public.ingredients (code) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_actual_organization_foreign',
                                              'FOREIGN KEY (actual_organization, actual_organization_country) REFERENCES public.organization (code, country) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_addiction_foreign',
                                              'FOREIGN KEY (addiction) REFERENCES public.addiction (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_atc_foreign',
                                              'FOREIGN KEY (atc) REFERENCES public.atc (atc)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_concurrent_import_organization_foreign',
                                              'FOREIGN KEY (concurrent_import_organization, concurrent_import_country) REFERENCES public.organization (code, country) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_daily_unit_foreign',
                                              'FOREIGN KEY (daily_unit) REFERENCES public.units (unit) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_dispense_foreign',
                                              'FOREIGN KEY (dispense) REFERENCES public.dispense (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_doping_foreign',
                                              'FOREIGN KEY (doping) REFERENCES public.doping (doping) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_dosage_foreign',
                                              'FOREIGN KEY (dosage) REFERENCES public.dosage_form (form) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_form_foreign',
                                              'FOREIGN KEY (form) REFERENCES public.forms (form)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_hormones_foreign',
                                              'FOREIGN KEY (hormones) REFERENCES public.hormones (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_legal_registration_base_foreign',
                                              'FOREIGN KEY (legal_registration_base) REFERENCES public.legal_registration_base (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_organization_foreign',
                                              'FOREIGN KEY (organization, organization_country) REFERENCES public.organization (code, country) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_pharm_class_foreign',
                                              'FOREIGN KEY (pharm_class) REFERENCES public.pharm_class (code)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_registration_procedure_foreign',
                                              'FOREIGN KEY (registration_procedure) REFERENCES public.registration_procedure (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_registration_status_foreign',
                                              'FOREIGN KEY (registration_status) REFERENCES public.registration_status (code)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_route_foreign',
                                              'FOREIGN KEY (route) REFERENCES public.routes (route) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_source_foreign',
                                              'FOREIGN KEY (source) REFERENCES public.source (code)');

SELECT public.create_constraint_if_not_exists('public.forms', 'forms_pkey', 'PRIMARY KEY (form)');

SELECT public.create_constraint_if_not_exists('public.hormones', 'hormones_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_addiction_foreign',
                                              'FOREIGN KEY (addiction) REFERENCES public.addiction (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_doping_foreign',
                                              'FOREIGN KEY (doping) REFERENCES public.doping (doping) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_hormones_foreign',
                                              'FOREIGN KEY (hormones) REFERENCES public.hormones (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_source_foreign',
                                              'FOREIGN KEY (source) REFERENCES public.source (code)');

SELECT public.create_constraint_if_not_exists('public.legal_registration_base', 'legal_registration_base_pkey',
                                              'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.organization', 'organization_pkey',
                                              'PRIMARY KEY (code, country)');
SELECT public.create_constraint_if_not_exists('public.organization', 'organization_country_foreign',
                                              'FOREIGN KEY (country) REFERENCES public.country (code)');

SELECT public.create_constraint_if_not_exists('public.pharm_class', 'pharm_class_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.registration_procedure', 'registration_procedure_pkey',
                                              'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.registration_status', 'registration_status_pkey',
                                              'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.routes', 'routes_pkey', 'PRIMARY KEY (route)');

SELECT public.create_constraint_if_not_exists('public.source', 'source_pkey', 'PRIMARY KEY (code)');

SELECT public.create_constraint_if_not_exists('public.substance', 'substance_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.substance', 'substance_addiction_foreign',
                                              'FOREIGN KEY (addiction) REFERENCES public.addiction (code) ON DELETE SET NULL');

SELECT public.create_constraint_if_not_exists('public.units', 'units_pkey', 'PRIMARY KEY (unit)');

--
-- PostgreSQL database dump complete
--

