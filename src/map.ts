import { E_DIRECTUS_COLLECTIONS, TSingleSchema } from './types.js';
import moment from 'moment';

export enum E_SOURCE_FILES {
  ATC = 'dlp_atc.csv',
  ROUTES = 'dlp_cesty.csv',
  DOPING = 'dlp_doping.csv',
  FORMS = 'dlp_formy.csv',
  PHARM_CLASS = 'dlp_indikacniskupiny.csv',
  UNITS = 'dlp_jednotky.csv',
  INGREDIENTS = 'dlp_latky.csv',
  SUBSTANCE = 'dlp_lecivelatky.csv',
  DRUGS = 'dlp_lecivepripravky.csv',
  HORMONES = 'dlp_narvla.csv',
  DOSAGE_FORM = 'dlp_obaly.csv',
  ORGANIZATION = 'dlp_organizace.csv',
  LEGAL_REGISTRATION_BASE = 'dlp_pravnizakladreg.csv',
  REGISTRATION_PROCEDURE = 'dlp_regproc.csv',
  COMPOSITION = 'dlp_slozeni.csv',
  COMPOSITION_SIGN = 'dlp_slozenipriznak.csv',
  REGISTRATION_STATUS = 'dlp_stavyreg.csv',
  VPOIS = 'dlp_vpois.csv',
  DISPENSE = 'dlp_vydej.csv',
  ADDICTION = 'dlp_zavislost.csv',
  SOURCES = 'dlp_zdroje.csv',
  COUNTRY = 'dlp_zeme.csv',
}

export type TDirectusMapItem<Collection extends keyof TSingleSchema> = {
  collection: Collection;
  headersMap: Record<
    string,
    | keyof TSingleSchema[Collection]
    | [
        keyof TSingleSchema[Collection],
        <Field extends keyof TSingleSchema[Collection]>(
          sourceValue: TSingleSchema[Collection][Field],
        ) => any,
      ]
  >;
};

export type TDirectusMap = Record<string, TDirectusMapItem<any>>;

export const MAIN_MAP: TDirectusMap = {
  [E_SOURCE_FILES.ATC]: {
    collection: E_DIRECTUS_COLLECTIONS.ATC,
    headersMap: {
      ATC: 'atc',
      NT: 'nt',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.ATC>,
  [E_SOURCE_FILES.ROUTES]: {
    collection: E_DIRECTUS_COLLECTIONS.ROUTES,
    headersMap: {
      CESTA: 'route',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      NAZEV_LAT: 'name_lat',
      KOD_EDQM: 'edqm',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.ROUTES>,
  [E_SOURCE_FILES.DOPING]: {
    collection: E_DIRECTUS_COLLECTIONS.DOPING,
    headersMap: {
      DOPING: 'doping',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.DOPING>,
  [E_SOURCE_FILES.FORMS]: {
    collection: E_DIRECTUS_COLLECTIONS.FORMS,
    headersMap: {
      FORMA: 'form',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      NAZEV_LAT: 'name_lat',
      JE_KONOPI: ['is_cannabis', (value) => value === 'A'],
      KOD_EDQM: 'edqm',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.FORMS>,
  [E_SOURCE_FILES.PHARM_CLASS]: {
    collection: E_DIRECTUS_COLLECTIONS.PHARM_CLASS,
    headersMap: {
      INDSK: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.PHARM_CLASS>,
  [E_SOURCE_FILES.UNITS]: {
    collection: E_DIRECTUS_COLLECTIONS.UNITS,
    headersMap: {
      UN: 'unit',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.UNITS>,
  [E_SOURCE_FILES.INGREDIENTS]: {
    collection: E_DIRECTUS_COLLECTIONS.INGREDIENTS,
    headersMap: {
      KOD_LATKY: 'code',
      ZDROJ: 'source',
      NAZEV_INN: 'name_intl',
      NAZEV_EN: 'name_en',
      NAZEV: 'name',
      ZAV: 'addiction',
      DOP: 'doping',
      NARVLA: 'hormones',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.INGREDIENTS>,
  [E_SOURCE_FILES.SUBSTANCE]: {
    collection: E_DIRECTUS_COLLECTIONS.SUBSTANCE,
    headersMap: {
      KOD_LATKY: 'code',
      NAZEV_INN: 'name_intl',
      NAZEV_EN: 'name_en',
      NAZEV: 'name',
      ZAV: 'addiction',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.SUBSTANCE>,
  [E_SOURCE_FILES.DRUGS]: {
    collection: E_DIRECTUS_COLLECTIONS.DRUGS,
    headersMap: {
      // Common
      KOD_SUKL: 'code',
      H: 'notification_sign',
      NAZEV: 'name',

      // General
      SILA: 'strength',
      FORMA: 'form',
      BALENI: 'package',
      CESTA: 'route',
      DOPLNEK: 'complement',
      OBAL: 'dosage',
      DRZ: 'organization',
      ZEMDRZ: 'organization_country',
      AKT_DRZ: 'actual_organization',
      AKT_ZEM: 'actual_organization_country',
      REG: 'registration_status',
      V_PLATDO: [
        'valid_till',
        (value: string) => moment(value, 'DDMMYY').toISOString(),
      ],
      NEOMEZ: 'unlimited_registration',
      UVADENIDO: [
        'present_till',
        (value: string) => moment(value, 'DDMMYY').toISOString(),
      ],
      IS_: 'pharm_class',
      ATC_WHO: 'atc',
      RC: 'registration_number',
      SDOV: 'concurrent_import',
      SDOV_DOD: 'concurrent_import_organization',
      SDOV_ZEM: 'concurrent_import_country',
      REG_PROC: 'registration_procedure',
      DDDAMNT_WHO: [
        'daily_amount',
        (value: string) => parseFloat(value.replace(',', '.')),
      ],
      DDDUN_WHO: 'daily_unit',
      DDDP_WHO: [
        'daily_count',
        (value: string) => parseFloat(value.replace(',', '.')),
      ],
      ZDROJ_WHO: 'source',
      LL: 'ingredients',
      VYDEJ: 'dispense',
      ZAV: 'addiction',
      DOPING: 'doping',
      NARVLA: 'hormones',
      DODAVKY: 'supplied',
      EAN: 'EAN',
      BRAILLOVO_PISMO: 'brail_sign',
      EXP: 'expiration',
      EXP_T: 'expiration_period',
      NAZEV_REG: 'registration_name',
      MRP_CISLO: 'mrp_number',
      PRAVNI_ZAKLAD_REGISTRACE: 'legal_registration_base',
      OCHRANNY_PRVEK: 'safety_element',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.DRUGS>,
  [E_SOURCE_FILES.HORMONES]: {
    collection: E_DIRECTUS_COLLECTIONS.HORMONES,
    headersMap: {
      NARVLA: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.HORMONES>,
  [E_SOURCE_FILES.DOSAGE_FORM]: {
    collection: E_DIRECTUS_COLLECTIONS.DOSAGE_FORM,
    headersMap: {
      OBAL: 'form',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      KOD_EDQM: 'edqm',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.DOSAGE_FORM>,
  [E_SOURCE_FILES.ORGANIZATION]: {
    collection: E_DIRECTUS_COLLECTIONS.ORGANIZATION,
    headersMap: {
      ZKR_ORG: 'code',
      ZEM: 'country',
      NAZEV: 'name',
      VYROBCE: 'manufacturer',
      DRZITEL: 'holder',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.ORGANIZATION>,
  [E_SOURCE_FILES.LEGAL_REGISTRATION_BASE]: {
    collection: E_DIRECTUS_COLLECTIONS.LEGAL_REGISTRATION_BASE,
    headersMap: {
      KOD: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.LEGAL_REGISTRATION_BASE>,
  [E_SOURCE_FILES.REGISTRATION_PROCEDURE]: {
    collection: E_DIRECTUS_COLLECTIONS.REGISTRATION_PROCEDURE,
    headersMap: {
      REG_PROC: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.REGISTRATION_PROCEDURE>,
  [E_SOURCE_FILES.COMPOSITION]: {
    collection: E_DIRECTUS_COLLECTIONS.COMPOSITION,
    headersMap: {
      KOD_SUKL: 'code',
      KOD_LATKY: 'ingredient',
      SQ: 'order',
      S: 'sign',
      AMNT_OD: 'amount_from',
      AMNT: 'amount',
      UN: 'unit',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.COMPOSITION>,
  [E_SOURCE_FILES.COMPOSITION_SIGN]: {
    collection: E_DIRECTUS_COLLECTIONS.COMPOSITION_SIGN,
    headersMap: {
      S: 'code',
      VYZNAM: 'description',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.COMPOSITION_SIGN>,
  [E_SOURCE_FILES.REGISTRATION_STATUS]: {
    collection: E_DIRECTUS_COLLECTIONS.REGISTRATION_STATUS,
    headersMap: {
      REG: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.REGISTRATION_STATUS>,
  [E_SOURCE_FILES.VPOIS]: {
    collection: E_DIRECTUS_COLLECTIONS.VPOIS,
    headersMap: {
      KOD_SUKL: 'code',
      VPOIS_NAZEV_SPOLECNOSTI: 'name',
      VPOIS_WWW: 'web',
      VPOIS_EMAIL: 'email',
      VPOIS_TEL: 'phone',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.VPOIS>,
  [E_SOURCE_FILES.DISPENSE]: {
    collection: E_DIRECTUS_COLLECTIONS.DISPENSE,
    headersMap: {
      VYDEJ: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.DISPENSE>,
  [E_SOURCE_FILES.ADDICTION]: {
    collection: E_DIRECTUS_COLLECTIONS.ADDICTION,
    headersMap: {
      ZAV: 'code',
      NAZEV_CS: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.ADDICTION>,
  [E_SOURCE_FILES.SOURCES]: {
    collection: E_DIRECTUS_COLLECTIONS.SOURCE,
    headersMap: {
      ZDROJ: 'code',
      NAZEV: 'name',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.SOURCE>,
  [E_SOURCE_FILES.COUNTRY]: {
    collection: E_DIRECTUS_COLLECTIONS.COUNTRY,
    headersMap: {
      ZEM: 'code',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      KOD_EDQM: 'edqm',
    },
  } as TDirectusMapItem<E_DIRECTUS_COLLECTIONS.COUNTRY>,
};
