
SQL File (etl.sql):



-- 1. Table for data from de-flux.csv
-- Your original definition was: Date DATE, Residence TEXT, Ouvertures DOUBLE PRECISION, Clotures DOUBLE PRECISION
-- Let's stick to that for consistency with your previous successful R code for this one table.
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_flows (
    Date DATE,
    Residence TEXT,
    Ouvertures DOUBLE PRECISION,
    Clotures DOUBLE PRECISION
    -- Consider adding: residency_category_broad TEXT
    -- PRIMARY KEY (Date, Residence) -- Example PK, adjust if needed
);
COMMENT ON TABLE student_fariba.job_seeker_flows IS 'Monthly flows (openings/closings) of job seekers by residency status. Source: de-flux.csv';

-- 2. Table for data from de-dispo-age.csv
-- Your original definition was: Date DATE, Genre TEXT, Age TEXT, Personnes DOUBLE PRECISION
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_by_age (
    Date DATE,
    Genre TEXT,
    Age TEXT,
    Personnes DOUBLE PRECISION -- Or INTEGER if counts are always whole numbers
    -- PRIMARY KEY (Date, Genre, Age) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_by_age IS 'Monthly count of available job seekers by age group and gender. Source: de-dispo-age.csv';

-- 3. Table for data from de-nationalite.csv
-- Your original was: Date DATE, Nationalite TEXT, Genre TEXT, Personnes DOUBLE PRECISION
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_nationalities (
    Date DATE,
    Nationalite TEXT,
    Genre TEXT,
    Personnes DOUBLE PRECISION -- Or INTEGER
    -- PRIMARY KEY (Date, Nationalite, Genre) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_nationalities IS 'Monthly count of job seekers by nationality and gender. Source: de-nationalite.csv';

-- 4. Table for data from de-metier.csv
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_professions (
    report_date DATE, -- Standardized name
    gender TEXT,
    rome_niveau2_code TEXT,
    rome_niveau2_label TEXT,
    rome_niveau1_code TEXT,
    rome_niveau1_label TEXT,
    profession_group TEXT, -- Original: Groupe
    person_count INTEGER     -- Original: Personnes
    -- PRIMARY KEY (report_date, gender, rome_niveau2_code, profession_group) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_professions IS 'Monthly count of job seekers by desired profession codes/labels, gender, and group. Source: de-metier.csv';

-- 5. Table for data from de-dispo-profils.csv
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_profiles (
    report_date DATE, -- Standardized name
    gender TEXT,
    age_group TEXT, -- Original: Age
    education_level TEXT, -- Original: Niveau_de_diplome
    registration_duration TEXT, -- Original: Duree_d_inscription
    inactivity_duration TEXT, -- Original: Duree_d_inactivite
    specific_status TEXT, -- Original: Statut_specifique
    person_count INTEGER  -- Original: Personnes
    -- PRIMARY KEY (report_date, gender, age_group, education_level, registration_duration, inactivity_duration, specific_status) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_profiles IS 'Monthly count of job seekers by various profile characteristics. Source: de-dispo-profils.csv';

-- 6. Table for data from offres-details.csv
CREATE TABLE IF NOT EXISTS student_fariba.job_vacancy_details (
    report_date DATE, -- Standardized name
    contract_nature TEXT, -- Original: Nature_contrat
    rome_niveau1_code TEXT,
    rome_niveau1_label TEXT,
    rome_niveau2_code TEXT,
    rome_niveau2_label TEXT,
    rome_code_metier TEXT, -- Original: ROME_code_metier
    profession_label_metier TEXT, -- Original: Libelle_metier_ROME
    qualification_level TEXT, -- Original: Niveau_qualification_demande
    work_location_canton TEXT, -- Original: Canton_lieu_de_travail
    work_location_commune TEXT, -- Original: Commune_lieu_de_travail
    economic_activity_section_code TEXT, -- Original: Code_Section_NACE
    economic_activity_section_label TEXT, -- Original: Libelle_Section_NACE
    declared_positions INTEGER, -- Original: Postes_declares
    stock_vacant_positions INTEGER -- Original: Stock_postes_vacants
    -- Add a suitable PK, perhaps an ID from the source if available, or a composite key.
);
COMMENT ON TABLE student_fariba.job_vacancy_details IS 'Detailed information about declared job vacancies. Source: offres-details.csv';

-- 7. Table for data from offres-series.csv
CREATE TABLE IF NOT EXISTS student_fariba.monthly_vacancy_summary (
    report_date DATE, -- Standardized name
    contract_nature TEXT, -- Original: Nature_contrat
    declared_positions INTEGER, -- Original: Postes_declares
    stock_vacant_positions INTEGER -- Original: Stock_postes_vacants
    -- PRIMARY KEY (report_date, contract_nature) -- Example PK
);
COMMENT ON TABLE student_fariba.monthly_vacancy_summary IS 'Monthly time series summary of job vacancies. Source: offres-series.csv';

-- 8. Table for data from de-indemnites.csv
CREATE TABLE IF NOT EXISTS student_fariba.unemployment_benefits (
    report_date DATE, -- Standardized name
    gender TEXT,
    age_group TEXT, -- Original: Age
    residency_status TEXT, -- Original: Residence
    full_unemployment_benefit_recipients INTEGER, -- Original: Chomage_complet
    professional_waiting_allowance_recipients INTEGER -- Original: Indemnite__professionnelle__d_attente
    -- PRIMARY KEY (report_date, gender, age_group, residency_status) -- Example PK
);
COMMENT ON TABLE student_fariba.unemployment_benefits IS 'Monthly count of unemployment benefit recipients by various demographics. Source: de-indemnites.csv';

-- 9. Table for data from de-jeunes.csv
CREATE TABLE IF NOT EXISTS student_fariba.youth_job_seekers (
    report_date DATE, -- Standardized name
    education_level TEXT, -- Original: Niveau_de_diplome
    registration_duration TEXT, -- Original: Duree_d_inscription
    inactivity_duration TEXT, -- Original: Duree_d_inactivite
    youth_16_24_count INTEGER, -- Original: _16_24_ans
    youth_25_29_count INTEGER -- Original: _25_29_ans
    -- PRIMARY KEY (report_date, education_level, registration_duration, inactivity_duration) -- Example PK
);
COMMENT ON TABLE student_fariba.youth_job_seekers IS 'Monthly data specific to young job seekers (16-29 years old). Source: de-jeunes.csv';

-- 10. Table for data from de-mesures.csv
CREATE TABLE IF NOT EXISTS student_fariba.employment_measures (
    report_date DATE, -- Standardized name
    gender TEXT,
    age_group TEXT, -- Original: Age
    measure_type TEXT, -- Original: Mesure
    person_count INTEGER -- Original: Personnes
    -- PRIMARY KEY (report_date, gender, age_group, measure_type) -- Example PK
);
COMMENT ON TABLE student_fariba.employment_measures IS 'Monthly count of participants in employment measures by demographics. Source: de-mesures.csv';

-- 11. Table for data from datasc-skills-vacancies.csv
CREATE TABLE IF NOT EXISTS student_fariba.datascience_skills_vacancies (
    report_date DATE, -- Derived from month and year columns in CSV
    vacancy_id INTEGER, -- This seemed to be the PK from your error message
    skill TEXT,
    skill_uri TEXT,
    canton TEXT,
    occupation_code TEXT,
    occupation_label TEXT,
    positions INTEGER,
    PRIMARY KEY (vacancy_id, skill) -- Example composite PK, adjust if skill_uri or other makes it unique
);
COMMENT ON TABLE student_fariba.datascience_skills_vacancies IS 'Skills (especially data science related) mentioned in job vacancies. Source: datasc-skills-vacancies.csv';

-- 12. Table for data from de-age-duree.csv (Job seekers by age and duration)
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_registration_duration (
    report_date DATE,
    age_group TEXT,
    registration_duration_category TEXT, -- e.g., "< 3 mois", "3-6 mois"
    person_count INTEGER
    -- PRIMARY KEY (report_date, age_group, registration_duration_category) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_registration_duration IS 'Monthly count of job seekers by age group and duration of registration. Source: de-age-duree.csv';

-- 13. Table for data from de-dispo-commune.csv (Job seekers by commune)
CREATE TABLE IF NOT EXISTS student_fariba.job_seeker_by_commune (
    report_date DATE,
    commune_name TEXT,
    person_count INTEGER
    -- PRIMARY KEY (report_date, commune_name) -- Example PK
);
COMMENT ON TABLE student_fariba.job_seeker_by_commune IS 'Monthly count of job seekers by commune/municipality. Source: de-dispo-commune.csv';


-- Log Tables (as per your schema image)
CREATE TABLE IF NOT EXISTS student_fariba.etl_run_log (
    log_id SERIAL PRIMARY KEY,
    file_name TEXT,
    table_name TEXT,
    load_time TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    status TEXT, -- e.g., 'success', 'failed', 'clean_failed', 'load_failed', 'file_not_found'
    rows_processed INTEGER,
    error_message TEXT
);
COMMENT ON TABLE student_fariba.etl_run_log IS 'Log of ETL process runs for each file and target table.';

-- These other log tables might be for your Shiny app or other processes
-- CREATE TABLE IF NOT EXISTS student_fariba.pipeline_logs ( ... );
-- CREATE TABLE IF NOT EXISTS student_fariba.search_logs ( ... );


