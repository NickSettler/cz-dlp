import { E_COLLECTIONS, TMetadata, TSingleSchema } from './types.js';
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
  DOCUMENTS = 'dlp_nazvydokumentu.csv',
  DOSAGE_FORM = 'dlp_obaly.csv',
  ORGANIZATION = 'dlp_organizace.csv',
  VALIDITY = 'dlp_platnost.csv',
  LEGAL_REGISTRATION_BASE = 'dlp_pravnizakladreg.csv',
  REGISTRATION_PROCEDURE = 'dlp_regproc.csv',
  COMPOSITION = 'dlp_slozeni.csv',
  COMPOSITION_SIGN = 'dlp_slozenipriznak.csv',
  SALTS = 'dlp_soli.csv',
  SPECIFIC_CURE = 'dlp_splp.csv',
  REGISTRATION_STATUS = 'dlp_stavyreg.csv',
  SYNONYMS = 'dlp_synonyma.csv',
  VPOIS = 'dlp_vpois.csv',
  DISPENSE = 'dlp_vydej.csv',
  ADDICTION = 'dlp_zavislost.csv',
  SOURCES = 'dlp_zdroje.csv',
  COUNTRY = 'dlp_zeme.csv',
  CANCELED_REGISTRATIONS = 'dlp_zruseneregistrace.csv',
  METADATA = 'dlp_metadata.csv',
  DRUG_TYPE = 'dlp_typlp.csv',
}

export const E_SOURCE_FILES_NORMALISED = Object.fromEntries(
  Object.entries(E_SOURCE_FILES).map(([key, value]) => [
    key,
    value.replaceAll('_', ''),
  ]),
);

export type TMapItem<Collection extends keyof TSingleSchema> = {
  collection: Collection;
  headersMap: Record<
    string,
    | keyof TSingleSchema[Collection]
    | [
        keyof TSingleSchema[Collection],
        <Field extends keyof TSingleSchema[Collection]>(
          sourceValue: TSingleSchema[Collection][Field],
          row: TSingleSchema[Collection],
        ) => any,
      ]
  >;
};

export type TDirectusMap = Record<string, TMapItem<any>>;

export const MAIN_MAP: TDirectusMap = {
  [E_SOURCE_FILES_NORMALISED.ATC]: {
    collection: E_COLLECTIONS.ATC,
    headersMap: {
      ATC: 'atc',
      NT: 'nt',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
    },
  } as TMapItem<E_COLLECTIONS.ATC>,
  [E_SOURCE_FILES_NORMALISED.ROUTES]: {
    collection: E_COLLECTIONS.ROUTES,
    headersMap: {
      CESTA: 'route',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      NAZEV_LAT: 'name_lat',
      KOD_EDQM: 'edqm',
    },
  } as TMapItem<E_COLLECTIONS.ROUTES>,
  [E_SOURCE_FILES_NORMALISED.DOPING]: {
    collection: E_COLLECTIONS.DOPING,
    headersMap: {
      DOPING: 'doping',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.DOPING>,
  [E_SOURCE_FILES_NORMALISED.FORMS]: {
    collection: E_COLLECTIONS.FORMS,
    headersMap: {
      FORMA: 'form',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      NAZEV_LAT: 'name_lat',
      JE_KONOPI: ['is_cannabis', (value) => value === 'A'],
      KOD_EDQM: 'edqm',
    },
  } as TMapItem<E_COLLECTIONS.FORMS>,
  [E_SOURCE_FILES_NORMALISED.PHARM_CLASS]: {
    collection: E_COLLECTIONS.PHARM_CLASS,
    headersMap: {
      INDSK: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.PHARM_CLASS>,
  [E_SOURCE_FILES_NORMALISED.UNITS]: {
    collection: E_COLLECTIONS.UNITS,
    headersMap: {
      UN: 'unit',
      JD: 'unit',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.UNITS>,
  [E_SOURCE_FILES_NORMALISED.INGREDIENTS]: {
    collection: E_COLLECTIONS.INGREDIENTS,
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
  } as TMapItem<E_COLLECTIONS.INGREDIENTS>,
  [E_SOURCE_FILES_NORMALISED.SUBSTANCE]: {
    collection: E_COLLECTIONS.SUBSTANCE,
    headersMap: {
      KOD_LATKY: 'code',
      NAZEV_INN: 'name_intl',
      NAZEV_EN: 'name_en',
      NAZEV: 'name',
      ZAV: 'addiction',
    },
  } as TMapItem<E_COLLECTIONS.SUBSTANCE>,
  [E_SOURCE_FILES_NORMALISED.DRUGS]: {
    collection: E_COLLECTIONS.DRUGS,
    headersMap: {
      // Common
      KOD_SUKL: 'code',
      H: 'notification_sign',
      NAZEV: 'name',

      // General
      SILA: 'strength',
      FORMA: 'form',
      TYP_LP: 'type',
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
      OMEZENI_PRESKRIPCE_SMP: 'prescription_limitation',
    },
  } as TMapItem<E_COLLECTIONS.DRUGS>,
  [E_SOURCE_FILES_NORMALISED.HORMONES]: {
    collection: E_COLLECTIONS.HORMONES,
    headersMap: {
      NARVLA: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.HORMONES>,
  [E_SOURCE_FILES_NORMALISED.DOCUMENTS]: {
    collection: E_COLLECTIONS.DOCUMENTS,
    headersMap: {
      KOD_SUKL: 'code',
      PIL: 'pil_file',
      DAT_ROZ_PIL: 'pil_date',
      SPC: 'spc_file',
      DAT_ROZ_SPC: 'spc_date',
      OBAL_TEXT: 'package_text',
      DAT_ROZ_OBAL: 'package_date',
      NR: 'registration_approval',
      DAT_NPM_NR: 'registration_approval_date',
    },
  } as TMapItem<E_COLLECTIONS.DOCUMENTS>,
  [E_SOURCE_FILES_NORMALISED.DOSAGE_FORM]: {
    collection: E_COLLECTIONS.DOSAGE_FORM,
    headersMap: {
      OBAL: 'form',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      KOD_EDQM: 'edqm',
    },
  } as TMapItem<E_COLLECTIONS.DOSAGE_FORM>,
  [E_SOURCE_FILES_NORMALISED.ORGANIZATION]: {
    collection: E_COLLECTIONS.ORGANIZATION,
    headersMap: {
      ZKR_ORG: 'code',
      ZEM: 'country',
      NAZEV: 'name',
      VYROBCE: 'manufacturer',
      DRZITEL: 'holder',
    },
  } as TMapItem<E_COLLECTIONS.ORGANIZATION>,
  [E_SOURCE_FILES_NORMALISED.VALIDITY]: {
    collection: E_COLLECTIONS.VALIDITY,
    headersMap: {
      platnost_od: 'valid_from',
      platnost_do: 'valid_till',
      PLATNOST_OD: 'valid_from',
      PLATNOST_DO: 'valid_till',
    },
  } as TMapItem<E_COLLECTIONS.VALIDITY>,
  [E_SOURCE_FILES_NORMALISED.LEGAL_REGISTRATION_BASE]: {
    collection: E_COLLECTIONS.LEGAL_REGISTRATION_BASE,
    headersMap: {
      KOD: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.LEGAL_REGISTRATION_BASE>,
  [E_SOURCE_FILES_NORMALISED.REGISTRATION_PROCEDURE]: {
    collection: E_COLLECTIONS.REGISTRATION_PROCEDURE,
    headersMap: {
      REG_PROC: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.REGISTRATION_PROCEDURE>,
  [E_SOURCE_FILES_NORMALISED.COMPOSITION]: {
    collection: E_COLLECTIONS.COMPOSITION,
    headersMap: {
      KOD_SUKL: 'drug_code',
      KOD_LATKY: 'ingredient_code',
      SQ: 'order',
      S: 'sign',
      AMNT_OD: 'amount_from',
      AMNT: 'amount',
      UN: 'unit',
    },
  } as TMapItem<E_COLLECTIONS.COMPOSITION>,
  [E_SOURCE_FILES_NORMALISED.COMPOSITION_SIGN]: {
    collection: E_COLLECTIONS.COMPOSITION_SIGN,
    headersMap: {
      S: 'code',
      VYZNAM: 'description',
    },
  } as TMapItem<E_COLLECTIONS.COMPOSITION_SIGN>,
  [E_SOURCE_FILES_NORMALISED.SALTS]: {
    collection: E_COLLECTIONS.SALTS,
    headersMap: {
      KOD_LATKY: 'ingredient_code',
      KOD_SOLI: 'salt_code',
    },
  } as TMapItem<E_COLLECTIONS.SALTS>,
  [E_SOURCE_FILES_NORMALISED.SPECIFIC_CURE]: {
    collection: E_COLLECTIONS.SPECIFIC_CURE,
    headersMap: {
      KOD_SUKL: 'code',
      DATOD: 'date_from',
      DATDO: 'date_till',
      DAT_OD: 'date_from',
      DAT_DO: 'date_till',
      POVOL_BALENI: 'package_count',
      UCEL: 'purpose',
      PRACOVISTE: 'workplace',
      DISTRIBUTOR: 'distributor',
      POZNAMKA: 'note',
      PREDKLADATEL: 'submitter',
      VYROBCE: 'manufacturer',
    },
  } as TMapItem<E_COLLECTIONS.SPECIFIC_CURE>,
  [E_SOURCE_FILES_NORMALISED.REGISTRATION_STATUS]: {
    collection: E_COLLECTIONS.REGISTRATION_STATUS,
    headersMap: {
      REG: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.REGISTRATION_STATUS>,
  [E_SOURCE_FILES_NORMALISED.SYNONYMS]: {
    collection: E_COLLECTIONS.SYNONYMS,
    headersMap: {
      KOD_LATKY: 'ingredient_code',
      SQ: 'order',
      ZDROJ: 'source',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.SYNONYMS>,
  [E_SOURCE_FILES_NORMALISED.VPOIS]: {
    collection: E_COLLECTIONS.VPOIS,
    headersMap: {
      KOD_SUKL: 'code',
      VPOIS_NAZEV_SPOLECNOSTI: 'name',
      VPOIS_WWW: 'web',
      VPOIS_EMAIL: 'email',
      VPOIS_TEL: 'phone',
    },
  } as TMapItem<E_COLLECTIONS.VPOIS>,
  [E_SOURCE_FILES_NORMALISED.DISPENSE]: {
    collection: E_COLLECTIONS.DISPENSE,
    headersMap: {
      VYDEJ: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.DISPENSE>,
  [E_SOURCE_FILES_NORMALISED.ADDICTION]: {
    collection: E_COLLECTIONS.ADDICTION,
    headersMap: {
      ZAV: 'code',
      NAZEV_CS: 'name',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.ADDICTION>,
  [E_SOURCE_FILES_NORMALISED.SOURCES]: {
    collection: E_COLLECTIONS.SOURCE,
    headersMap: {
      ZDROJ: 'code',
      NAZEV: 'name',
    },
  } as TMapItem<E_COLLECTIONS.SOURCE>,
  [E_SOURCE_FILES_NORMALISED.COUNTRY]: {
    collection: E_COLLECTIONS.COUNTRY,
    headersMap: {
      ZEM: 'code',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
      KOD_EDQM: 'edqm',
    },
  } as TMapItem<E_COLLECTIONS.COUNTRY>,
  [E_SOURCE_FILES_NORMALISED.CANCELED_REGISTRATIONS]: {
    collection: E_COLLECTIONS.CANCELED_REGISTRATIONS,
    headersMap: {
      NAZEV: 'name',
      CESTA: 'route',
      FORMA: 'form',
      SILA: 'strength',
      REGISTRACNI_CISLO: 'registration_number',
      SOUBEZNY_DOVOZ: 'concurrent_import',
      MRP_CISLO: 'mrp_number',
      TYP_REGISTRACE: 'registration_type',
      PRAVNI_ZAKLAD_REGISTRACE: 'legal_registration_base',
      DRZITEL: 'holder',
      ZEME_DRZITELE: 'holder_country',
      KONEC_PLATNOSTI_REGISTRACE: 'valid_till',
      STAV_REGISTRACE: 'registration_status',
    },
  } as TMapItem<E_COLLECTIONS.CANCELED_REGISTRATIONS>,
  [E_SOURCE_FILES_NORMALISED.METADATA]: {
    collection: E_COLLECTIONS.METADATA,
    headersMap: {
      'Datová sada': 'dataset',
      'Pořadí sloupce': ['column_order', (value) => parseInt(value, 10)],
      'Typ položky': 'column_type',
      Význam: 'description',
      'Název sloupce': [
        'column_name',
        (value: string, row: TMetadata) => {
          const mapItem = MAIN_MAP[`${row.dataset.replaceAll('_', '')}.csv`];
          const mapItemColumn = mapItem?.headersMap?.[value];

          return Array.isArray(mapItemColumn)
            ? mapItemColumn[0]
            : mapItemColumn;
        },
      ],
    },
  },
  [E_SOURCE_FILES_NORMALISED.DRUG_TYPE]: {
    collection: E_COLLECTIONS.DRUG_TYPE,
    headersMap: {
      TYP_LP: 'type',
      NAZEV: 'name',
      NAZEV_EN: 'name_en',
    },
  } as TMapItem<E_COLLECTIONS.DRUG_TYPE>,
};
