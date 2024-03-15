-- 1 up
CREATE TABLE IF NOT EXISTS database_excludes
(
    database_excludes_pkey serial NOT NULL ,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    table_name varchar UNIQUE NOT NULL,
    CONSTRAINT database_excludes_pkey PRIMARY KEY (database_excludes_pkey)
);

CREATE TABLE IF NOT EXISTS database_specials
(
    database_specials_pkey serial NOT NULL ,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    table_name varchar NOT NULL,
    method varchar NOT NULL,
    CONSTRAINT database_specials_pkey PRIMARY KEY (database_specials_pkey)
);

INSERT INTO database_excludes (table_name) VALUES
        ('database_specials'),
        ('database_excludes'),
        ('workflow_stockitem'),
        ('workflow_pricelist'),
        ('workflow_companies'),
        ('workflow_users'),
        ('workflow_customer'),
        ('workflow_mail'),
        ('workflow_invoice');

-- 1 down

-- 2 up

ALTER TABLE database_specials
    ADD COLUMN select_fields VARCHAR NOT NULL DEFAULT '';

ALTER TABLE database_specials
    ADD COLUMN fkey VARCHAR NOT NULL DEFAULT '';

ALTER TABLE database_specials
    ADD COLUMN table_schema VARCHAR NOT NULL DEFAULT 'public';

-- 2 down

-- 3 up
ALTER TABLE database_specials
    ADD COLUMN method_pseudo_name VARCHAR NOT NULL DEFAULT 'public';

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name)
    VALUES('customers', 'list', '', 'active', 'active');

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name)
    VALUES('customers', 'list', '', 'blocked', 'blocked');

-- 3 down
-- 4 up
INSERT INTO database_excludes (table_name) VALUES
    ('mojo_migrations'),
    ('workflow'),
    ('workflow_history');

-- 4 down

-- 5 up
ALTER TABLE database_specials
    ADD COLUMN pkey VARCHAR NOT NULL DEFAULT '';

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name, pkey)
VALUES('companies', 'load', '*', '', '', 'companies_pkey');

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name, pkey)
VALUES('users', 'load', '*', '', '', 'users_pkey');

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name, pkey)
VALUES('customers', 'load', '*', '', '', 'customers_pkey');

INSERT INTO database_specials (table_name, method, select_fields, fkey, method_pseudo_name, pkey)
VALUES('customers', 'list', '*', 'companies_fkey', '', 'customers_pkey');
-- 5 down