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
        ('workflow_stockitem'),
        ('workflow_customer'),
        ('workflow_mail'),
        ('workflow_invoice');

-- 1 down