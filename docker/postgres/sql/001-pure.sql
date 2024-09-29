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

CREATE TABLE IF NOT EXISTS public."VPOIS"
(
    code  character varying(255) NOT NULL,
    name  character varying(255),
    web   character varying(255),
    email character varying(255),
    phone character varying(255)
);

CREATE TABLE IF NOT EXISTS public.addiction
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.atc
(
    atc     character varying(255)                                 NOT NULL,
    nt      character varying(255)                                 NOT NULL,
    name    character varying(255)                                 NOT NULL,
    name_en character varying(255) DEFAULT NULL::character varying NOT NULL
);

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

CREATE TABLE IF NOT EXISTS public.composition_sign
(
    code        character varying(255) NOT NULL,
    description text                   NOT NULL
);

CREATE TABLE IF NOT EXISTS public.country
(
    code    character varying(255) NOT NULL,
    name    character varying(255),
    edqm    character varying(255),
    name_en character varying(255) DEFAULT NULL::character varying
);

CREATE TABLE IF NOT EXISTS public.dispense
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.doping
(
    doping character varying(255) NOT NULL,
    name   character varying(255)
);

CREATE TABLE IF NOT EXISTS public.dosage_form
(
    form    character varying(255)                                 NOT NULL,
    name    character varying(255) DEFAULT NULL::character varying,
    edqm    character varying(255),
    name_en character varying(255) DEFAULT NULL::character varying NOT NULL
);

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
    safety_element                 character varying(1),
    prescription_limitation        character varying(1)
);

CREATE TABLE IF NOT EXISTS public.drugs_ingredients
(
    id               integer NOT NULL,
    drugs_code       character varying(255),
    ingredients_code character varying(255),
    CONSTRAINT unique_drug_ingredient UNIQUE (drugs_code, ingredients_code)
);

CREATE TABLE IF NOT EXISTS public.forms
(
    form        character varying(255)                                 NOT NULL,
    name        character varying(255)                                 NOT NULL,
    edqm        character varying(255),
    name_en     character varying(255) DEFAULT NULL::character varying NOT NULL,
    name_lat    character varying(255),
    is_cannabis boolean                DEFAULT false                   NOT NULL
);

CREATE TABLE IF NOT EXISTS public.hormones
(
    code character varying(255) NOT NULL,
    name character varying(255)
);

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

CREATE TABLE IF NOT EXISTS public.legal_registration_base
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.metadata
(
    dataset      character varying(255) NOT NULL,
    column_name  character varying(255) NOT NULL,
    column_order numeric(10, 5)         NOT NULL,
    column_type  character varying(255) NOT NULL,
    description  character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.organization
(
    code         character varying(255) NOT NULL,
    name         character varying(255),
    country      character varying(255) NOT NULL,
    manufacturer character varying(255),
    holder       character varying(255)
);

CREATE TABLE IF NOT EXISTS public.pharm_class
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.registration_procedure
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.registration_status
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.routes
(
    route    character varying(255)                                 NOT NULL,
    name     character varying(255)                                 NOT NULL,
    edqm     character varying(255),
    name_en  character varying(255) DEFAULT NULL::character varying NOT NULL,
    name_lat character varying(255) DEFAULT NULL::character varying NOT NULL
);

CREATE TABLE IF NOT EXISTS public.source
(
    code character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS public.substance
(
    code      character varying(255) NOT NULL,
    name      character varying(255),
    addiction character varying(255),
    name_intl character varying(255) DEFAULT NULL::character varying,
    name_en   character varying(255) DEFAULT NULL::character varying
);

CREATE TABLE IF NOT EXISTS public.units
(
    unit character varying(255) NOT NULL,
    name character varying(255) NOT NULL
);



CREATE SEQUENCE IF NOT EXISTS public.composition_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.composition_id_seq OWNED BY public.composition.id;

CREATE SEQUENCE IF NOT EXISTS public.drugs_ingredients_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER SEQUENCE public.drugs_ingredients_id_seq OWNED BY public.drugs_ingredients.id;

ALTER TABLE ONLY public.composition
    ALTER COLUMN id SET DEFAULT nextval('public.composition_id_seq'::regclass);
ALTER TABLE ONLY public.drugs_ingredients
    ALTER COLUMN id SET DEFAULT nextval('public.drugs_ingredients_id_seq'::regclass);



SELECT public.create_constraint_if_not_exists('public."VPOIS"', 'vpois_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.addiction', 'addiction_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.atc', 'atc_pkey', 'PRIMARY KEY (atc)');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.composition_sign', 'composition_sign_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.country', 'country_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.dispense', 'dispense_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.doping', 'doping_pkey', 'PRIMARY KEY (doping)');
SELECT public.create_constraint_if_not_exists('public.dosage_form', 'dosage_form_pkey', 'PRIMARY KEY (form)');
SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_pkey', 'PRIMARY KEY (id)');
SELECT public.create_constraint_if_not_exists('public.drugs', 'drugs_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.forms', 'forms_pkey', 'PRIMARY KEY (form)');
SELECT public.create_constraint_if_not_exists('public.hormones', 'hormones_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.legal_registration_base', 'legal_registration_base_pkey',
                                              'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.organization', 'organization_pkey',
                                              'PRIMARY KEY (code, country)');
SELECT public.create_constraint_if_not_exists('public.pharm_class', 'pharm_class_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.registration_procedure', 'registration_procedure_pkey',
                                              'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.registration_status', 'registration_status_pkey',
                                              'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.routes', 'routes_pkey', 'PRIMARY KEY (route)');
SELECT public.create_constraint_if_not_exists('public.source', 'source_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.substance', 'substance_pkey', 'PRIMARY KEY (code)');
SELECT public.create_constraint_if_not_exists('public.units', 'units_pkey', 'PRIMARY KEY (unit)');



SELECT public.create_constraint_if_not_exists('public.composition', 'composition_ingredient_foreign',
                                              'FOREIGN KEY (ingredient) REFERENCES public.ingredients (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_sign_foreign',
                                              'FOREIGN KEY (sign) REFERENCES public.composition_sign (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.composition', 'composition_unit_foreign',
                                              'FOREIGN KEY (unit) REFERENCES public.units (unit) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_drugs_code_foreign',
                                              'FOREIGN KEY (drugs_code) REFERENCES public.drugs (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.drugs_ingredients', 'drugs_ingredients_ingredients_code_foreign',
                                              'FOREIGN KEY (ingredients_code) REFERENCES public.ingredients (code) ON DELETE SET NULL');
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
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_addiction_foreign',
                                              'FOREIGN KEY (addiction) REFERENCES public.addiction (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_doping_foreign',
                                              'FOREIGN KEY (doping) REFERENCES public.doping (doping) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_hormones_foreign',
                                              'FOREIGN KEY (hormones) REFERENCES public.hormones (code) ON DELETE SET NULL');
SELECT public.create_constraint_if_not_exists('public.ingredients', 'ingredients_source_foreign',
                                              'FOREIGN KEY (source) REFERENCES public.source (code)');
SELECT public.create_constraint_if_not_exists('public.organization', 'organization_country_foreign',
                                              'FOREIGN KEY (country) REFERENCES public.country (code)');
SELECT public.create_constraint_if_not_exists('public.substance', 'substance_addiction_foreign',
                                              'FOREIGN KEY (addiction) REFERENCES public.addiction (code) ON DELETE SET NULL');
