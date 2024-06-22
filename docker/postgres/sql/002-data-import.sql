CREATE TABLE IF NOT EXISTS tmp
(
    c text
);

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_atc.json';

TRUNCATE atc;

INSERT INTO atc
SELECT q.*
FROM tmp,
     json_populate_record(null::atc, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_cesty.json';

TRUNCATE routes;

INSERT INTO routes
SELECT q.*
FROM tmp,
     json_populate_record(null::routes, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_doping.json';

TRUNCATE doping;

INSERT INTO doping
SELECT q.*
FROM tmp,
     json_populate_record(null::doping, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_formy.json';

TRUNCATE forms;

INSERT INTO forms
SELECT q.*
FROM tmp,
     json_populate_record(null::forms, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_indikacniskupiny.json';

TRUNCATE pharm_class;

INSERT INTO pharm_class
SELECT q.*
FROM tmp,
     json_populate_record(null::pharm_class, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_jednotky.json';

TRUNCATE units;

INSERT INTO units
SELECT q.*
FROM tmp,
     json_populate_record(null::units, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_narvla.json';

TRUNCATE hormones;

INSERT INTO hormones
SELECT q.*
FROM tmp,
     json_populate_record(null::hormones, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_obaly.json';

TRUNCATE dosage_form;

INSERT INTO dosage_form
SELECT q.*
FROM tmp,
     json_populate_record(null::dosage_form, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_pravnizakladreg.json';

TRUNCATE legal_registration_base;

INSERT INTO legal_registration_base
SELECT q.*
FROM tmp,
     json_populate_record(null::legal_registration_base, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_regproc.json';

TRUNCATE registration_procedure;

INSERT INTO registration_procedure
SELECT q.*
FROM tmp,
     json_populate_record(null::registration_procedure, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_slozenipriznak.json' CSV QUOTE e'\x01' DELIMITER e'\x02';

TRUNCATE composition_sign;

INSERT INTO composition_sign
SELECT q.*
FROM tmp,
     json_populate_record(null::composition_sign, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_stavyreg.json';

TRUNCATE registration_status;

INSERT INTO registration_status
SELECT q.*
FROM tmp,
     json_populate_record(null::registration_status, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_vydej.json';

TRUNCATE dispense;

INSERT INTO dispense
SELECT q.*
FROM tmp,
     json_populate_record(null::dispense, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_zavislost.json';

TRUNCATE addiction;

INSERT INTO addiction
SELECT q.*
FROM tmp,
     json_populate_record(null::addiction, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_zdroje.json';

TRUNCATE source;

INSERT INTO source
SELECT q.*
FROM tmp,
     json_populate_record(null::source, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_zeme.json';

TRUNCATE country;

INSERT INTO country
SELECT q.*
FROM tmp,
     json_populate_record(null::country, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_vpois.json' CSV QUOTE e'\x01' DELIMITER e'\x02';

TRUNCATE "VPOIS";

INSERT INTO "VPOIS"
SELECT q.*
FROM tmp,
     json_populate_record(null::"VPOIS", c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_latky.json';

TRUNCATE ingredients;

INSERT INTO source (code, name)
SELECT q.source, q.source
FROM tmp,
     json_populate_record(null::ingredients, c::json) AS q
WHERE q.source IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO ingredients
SELECT q.*
FROM tmp,
     json_populate_record(null::ingredients, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_lecivelatky.json';

TRUNCATE substance;

INSERT INTO substance
SELECT q.*
FROM tmp,
     json_populate_record(null::substance, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_organizace.json' CSV QUOTE e'\x01' DELIMITER e'\x02';

TRUNCATE organization;

INSERT INTO organization
SELECT q.*
FROM tmp,
     json_populate_record(null::organization, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_slozeni.json';

TRUNCATE composition;

INSERT INTO composition(code, ingredient, "order", sign, amount_from, amount, unit)
SELECT q.code, q.ingredient, q."order", q.sign, q.amount_from, q.amount, q.unit
FROM tmp,
     json_populate_record(null::composition, c::json) AS q;

TRUNCATE tmp;

COPY tmp FROM '/docker-entrypoint-initdb.d/dlp_lecivepripravky.json';

TRUNCATE drugs;

INSERT INTO legal_registration_base (code, name)
SELECT q.legal_registration_base, q.legal_registration_base
FROM tmp,
     json_populate_record(null::drugs, c::json) AS q
WHERE q.legal_registration_base IS NOT NULL
ON CONFLICT DO NOTHING;


INSERT INTO organization (code, country, name)
SELECT q.concurrent_import_organization, q.concurrent_import_country, CONCAT(q.concurrent_import_organization, ', ', q.concurrent_import_country)
FROM tmp,
     json_populate_record(null::drugs, c::json) AS q
WHERE q.concurrent_import_organization IS NOT NULL AND q.concurrent_import_country IS NOT NULL
ON CONFLICT DO NOTHING;

INSERT INTO drugs
SELECT q.*
FROM tmp,
     json_populate_record(null::drugs, c::json) AS q;

DROP TABLE tmp;