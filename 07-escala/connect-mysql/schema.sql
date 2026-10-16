CREATE TABLE users (
    id INT UNSIGNED AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(128) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE schools (
    id INT UNSIGNED AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    type ENUM('Primary', 'Secondary', 'Higher Education') NOT NULL,
    location VARCHAR(255) NOT NULL,
    founded_year SMALLINT UNSIGNED NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE companies (
    id INT UNSIGNED AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    industry ENUM('Technology', 'Education', 'Business') NOT NULL,
    location VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE connections (
    user_id_1 INT UNSIGNED NOT NULL,
    user_id_2 INT UNSIGNED NOT NULL,

    PRIMARY KEY (user_id_1, user_id_2),

    FOREIGN KEY (user_id_1) REFERENCES users(id),
    FOREIGN KEY (user_id_2) REFERENCES users(id),

    CHECK (user_id_1 < user_id_2)
);

CREATE TABLE school_affiliations (
    user_id INT UNSIGNED NOT NULL,
    school_id INT UNSIGNED NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    degree VARCHAR(50) NOT NULL,

    PRIMARY KEY (user_id, school_id, start_date),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (school_id) REFERENCES schools(id),

    CHECK (end_date IS NULL OR end_date >= start_date)
);

CREATE TABLE company_affiliations (
    user_id INT UNSIGNED NOT NULL,
    company_id INT UNSIGNED NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    title VARCHAR(255) NOT NULL,

    PRIMARY KEY (user_id, company_id, start_date),

    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (company_id) REFERENCES companies(id),

    CHECK (end_date IS NULL OR end_date >= start_date)
);


