export enum E_COLLECTIONS {
  ATC = 'atc',
  DISPENSE = 'dispense',
  DOSAGE_FORM = 'dosage_form',
  FORMS = 'forms',
  PHARM_CLASS = 'pharm_class',
  ROUTES = 'routes',
  COMPOSITION = 'composition',
  COMPOSITION_SIGN = 'composition_sign',
  SALTS = 'salts',
  SPECIFIC_CURE = 'specific_cure',
  INGREDIENTS = 'ingredients',
  SUBSTANCE = 'substance',
  UNITS = 'units',
  ADDICTION = 'addiction',
  DOPING = 'doping',
  HORMONES = 'hormones',
  DOCUMENTS = 'documents',
  DRUGS = 'drugs',
  DRUGS_INGREDIENTS = 'drugs_ingredients',
  VPOIS = 'VPOIS',
  LEGAL_REGISTRATION_BASE = 'legal_registration_base',
  REGISTRATION_STATUS = 'registration_status',
  SYNONYMS = 'synonyms',
  REGISTRATION_PROCEDURE = 'registration_procedure',
  SOURCE = 'source',
  ORGANIZATION = 'organization',
  VALIDITY = 'validity',
  COUNTRY = 'country',
  CANCELED_REGISTRATIONS = 'canceled_registrations',
  METADATA = 'metadata',
  DRUG_TYPE = 'drug_type',
}

export type TATC = {
  atc: string;
  nt: string;
  name: string;
  name_en: string;
};

export type TRoute = {
  route: string;
  name: string;
  name_en: string;
  name_lat: string;
  edqm?: string;
};

export type TDoping = {
  doping: string;
  name: string;
};

export type TForm = {
  form: string;
  name: string;
  name_en: string;
  name_lat: string;
  is_cannabis: boolean;
  edqm?: string;
};

export type TPharmClass = {
  code: string;
  name: string;
};

export type TUnit = {
  unit: string;
  name: string;
};

export type TIngredient = {
  code: string;
  source?: TSource;
  name_intl?: string;
  name_en?: string;
  name?: string;
  addiction?: TAddiction;
  doping?: TDoping;
  hormones?: THormone;
};

export type TSubstance = {
  code: string;
  name_intl?: string;
  name_en?: string;
  name?: string;
  addiction?: TAddiction;
};

export type TDrug = {
  code: string;
  notification_sign?: string;
  name: string;

  strength?: string;
  form?: TForm;
  type?: TDrugType;
  package?: string;
  route?: TRoute;
  complement: string;
  dosage?: TDosageForm;
  pharm_class: TPharmClass;

  organization?: TOrganization;
  organization_country?: TCountry;
  actual_organization?: TOrganization;
  actual_organization_country?: TCountry;
  concurrent_import?: string;
  concurrent_import_organization?: TOrganization;
  concurrent_import_country?: TCountry;

  registration_status?: TRegistrationStatus;
  valid_till?: Date;
  present_till?: Date;
  unlimited_registration?: string;
  registration_number?: string;
  registration_procedure?: TRegistrationProcedure;
  registration_name: string;
  legal_registration_base?: TLegalRegistrationBase;
  source: TSource;

  daily_amount: number;
  daily_unit?: TUnit;
  daily_count: number;
  dispense?: TDispense;

  ingredients?: Array<TIngredient>;

  addiction?: TAddiction;
  doping?: TDoping;
  hormones?: THormone;

  atc: TATC;
  supplied: string;
  EAN?: string;
  brail_sign?: string;
  expiration?: number;
  expiration_period?: string;
  mrp_number?: string;
  safety_element?: string;
  prescription_limitation?: string;
};

export type TDrugIngredient = {
  id: number;
  drugs_code: string;
  ingredients_code: string;
};

export type THormone = {
  code: string;
  name: string;
};

export type TDosageForm = {
  form: string;
  name: string;
  name_en: string;
  edqm?: string;
};

export type TOrganization = {
  code: string;
  country: TCountry;
  name: string;
  manufacturer?: string;
  holder?: string;
};

export type TLegalRegistrationBase = {
  code: string;
  name: string;
};

export type TRegistrationProcedure = {
  code: string;
  name: string;
};

export type TComposition = {
  id: number;
  drug_code: TDrug;
  ingredient_code?: TIngredient;
  order: number;
  sign?: TCompositionSign;
  amount?: string;
  amount_from?: string;
  unit?: TUnit;
};

export type TCompositionSign = {
  code: string;
  description: string;
};

export type TRegistrationStatus = {
  code: string;
  name: string;
};

export type TVPOIS = {
  code: string;
  name?: string;
  web?: string;
  email?: string;
  phone?: string;
};

export type TDispense = {
  code: string;
  name: string;
};

export type TAddiction = {
  code: string;
  name: string;
};

export type TSource = {
  code: string;
  name: string;
};

export type TCountry = {
  code: string;
  name: string;
  name_en: string;
  edqm?: string;
};

export type TMetadata = {
  dataset: string;
  column_order: number;
  column_name: string;
  column_type: string;
  description: string;
};

export type TDrugType = {
  type: string;
  name: string;
  name_en: string;
};

export type TSingleSchema = {
  [E_COLLECTIONS.ATC]: TATC;
  [E_COLLECTIONS.DISPENSE]: TDispense;
  [E_COLLECTIONS.DOSAGE_FORM]: TDosageForm;
  [E_COLLECTIONS.FORMS]: TForm;
  [E_COLLECTIONS.PHARM_CLASS]: TPharmClass;
  [E_COLLECTIONS.ROUTES]: TRoute;
  [E_COLLECTIONS.COMPOSITION]: TComposition;
  [E_COLLECTIONS.COMPOSITION_SIGN]: TCompositionSign;
  [E_COLLECTIONS.SALTS]: Record<string, never>;
  [E_COLLECTIONS.SPECIFIC_CURE]: Record<string, never>;
  [E_COLLECTIONS.INGREDIENTS]: TIngredient;
  [E_COLLECTIONS.SUBSTANCE]: TSubstance;
  [E_COLLECTIONS.UNITS]: TUnit;
  [E_COLLECTIONS.ADDICTION]: TAddiction;
  [E_COLLECTIONS.DOPING]: TDoping;
  [E_COLLECTIONS.HORMONES]: THormone;
  [E_COLLECTIONS.DOCUMENTS]: Record<string, never>;
  [E_COLLECTIONS.DRUGS]: TDrug;
  [E_COLLECTIONS.DRUGS_INGREDIENTS]: TDrugIngredient;
  [E_COLLECTIONS.VPOIS]: TVPOIS;
  [E_COLLECTIONS.LEGAL_REGISTRATION_BASE]: TLegalRegistrationBase;
  [E_COLLECTIONS.REGISTRATION_STATUS]: TRegistrationStatus;
  [E_COLLECTIONS.SYNONYMS]: Record<string, never>;
  [E_COLLECTIONS.REGISTRATION_PROCEDURE]: TRegistrationProcedure;
  [E_COLLECTIONS.SOURCE]: TSource;
  [E_COLLECTIONS.ORGANIZATION]: TOrganization;
  [E_COLLECTIONS.VALIDITY]: Record<string, never>;
  [E_COLLECTIONS.COUNTRY]: TCountry;
  [E_COLLECTIONS.CANCELED_REGISTRATIONS]: Record<string, never>;
  [E_COLLECTIONS.METADATA]: TMetadata;
  [E_COLLECTIONS.DRUG_TYPE]: TDrugType;
};
