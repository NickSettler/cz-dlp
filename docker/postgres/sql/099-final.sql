ALTER TABLE public.composition
    ADD CONSTRAINT composition_drug_foreign
        FOREIGN KEY (drug_code) REFERENCES public.drugs (code) ON DELETE SET NULL NOT VALID;

SELECT public.create_index_if_not_exists('drugs', 'code');