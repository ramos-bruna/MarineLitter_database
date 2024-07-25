-- Table: Beach
CREATE TABLE Beach (
    beach_id VARCHAR PRIMARY KEY,
    name VARCHAR NOT NULL,
    country VARCHAR NOT NULL,
    state VARCHAR NOT NULL,
    city VARCHAR NOT NULL,
    urbanization VARCHAR NOT NULL
);

-- Table: SurveyDetails
CREATE TABLE SurveyDetails (
    survey_id VARCHAR PRIMARY KEY,
    survey_date DATE NOT NULL,
    beach_id VARCHAR REFERENCES Beach(beach_id),
    lat_begin DECIMAL,
    lon_begin DECIMAL,
    lat_end DECIMAL,
    lon_end DECIMAL,
    transect VARCHAR
);

-- Table: LitterData
CREATE TABLE LitterData (
    litter_id SERIAL PRIMARY KEY,
    survey_id VARCHAR REFERENCES SurveyDetails(survey_id),
    beach_id VARCHAR REFERENCES Beach(beach_id),
    area_m2 DECIMAL,
	weight_g DECIMAL,
    CL01 INT,
    CL05 INT,
    CL06 INT,
    FP02 INT,
    FP03 INT,
    FP04 INT,
    FP05 INT,
    GC01 INT,
    GC02 INT,
    GC07 INT,
    GC08 INT,
    ME01 INT,
    ME02 INT,
    ME03 INT,
    ME06 INT,
    ME07 INT,
    ME08 INT,
    ME09 INT,
    OT01 INT,
    OT02 INT,
    OT04 INT,
    OT05_1 INT,
    OT05_2 INT,
    OT05_3 INT,
    PC01 INT,
    PC03 INT,
    PC05 INT,
    PL01 INT,
    PL02 INT,
    PL02_1 INT,
    PL03 INT,
    PL04 INT,
    PL06 INT,
    PL07 INT,
    PL08 INT,
    PL09 INT,
    PL10 INT,
    PL11 INT,
    PL12 INT,
    PL15 INT,
    PL17 INT,
    PL18 INT,
    PL19 INT,
    PL20 INT,
    PL21 INT,
    PL22 INT,
    PL24 INT,
    PL24_1 INT,
    PL24_2 INT,
    PL24_3 INT,
    PL24_4 INT,
    PL24_6 INT,
    PL24_7 INT,
    PL25 INT,
    RB01 INT,
    RB02 INT,
    RB04 INT,
    RB06 INT,
    RB07 INT,
    RB08 INT,
    WD01 INT,
    WD03 INT,
    WD04 INT,
    WD05 INT
);

-- Table: WeatherData
CREATE TABLE WeatherData (
    weather_id SERIAL PRIMARY KEY,
    beach_id VARCHAR REFERENCES Beach(beach_id),
    time TIME,
    day DATE,
    wind_dir VARCHAR,
    wind_int DECIMAL,
    precipitation DECIMAL,
    tide DECIMAL,
    wave_height DECIMAL,
    wave_dir VARCHAR,
    wave_period DECIMAL
);

-- Table: BeachLog
CREATE TABLE BeachLog (
    log_id SERIAL PRIMARY KEY,
    survey_month INT,
    year INT,
    beach_id VARCHAR REFERENCES Beach(beach_id),
    erosion_marks BOOLEAN,
    wrack BOOLEAN,
    odors BOOLEAN,
    noise BOOLEAN,
    geological_features BOOLEAN,
    water_quality DECIMAL,
    beach_litter BOOLEAN,
    exotic_species BOOLEAN,
    recreation_services BOOLEAN,
    access BOOLEAN,
    toilets_showers BOOLEAN,
    food_service BOOLEAN,
    cleaning_services BOOLEAN,
    historical_assets BOOLEAN,
    policing BOOLEAN,
    user_security BOOLEAN,
    lifeguards BOOLEAN,
    environmental_information BOOLEAN,
    mpa BOOLEAN,
    zoning BOOLEAN,
    carrying_capacity BOOLEAN,
    monitoring BOOLEAN,
    scientific_literature BOOLEAN
);
