-- 1 up

create table if not exists users
(
    users_pkey  serial                                             not null,
    editnum     bigint                                             NOT NULL DEFAULT 1,
    insby       character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone                        NOT NULL DEFAULT NOW(),
    modby       character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone                        NOT NULL DEFAULT NOW(),
    userid      varchar(100)                                       not null,
    username    varchar(100),
    passwd      varchar(100)                                       not null,
    CONSTRAINT users_pkey PRIMARY KEY (users_pkey)
    );

CREATE UNIQUE INDEX  idx_users_userid
    ON public.users USING btree
    (userid );

create table if not exists languages
(
    languages_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    lan character varying(10) NOT NULL,
    lan_name character varying(100) NOT NULL,
    CONSTRAINT languages_pkey PRIMARY KEY (languages_pkey)
    );

INSERT INTO languages (lan, lan_name) VALUES ('dan', 'Danish');
INSERT INTO languages (lan, lan_name) VALUES ('fin', 'Finnish');
INSERT INTO languages (lan, lan_name) VALUES ('deu', 'German');
INSERT INTO languages (lan, lan_name) VALUES ('nor', 'Norwegian');
INSERT INTO languages (lan, lan_name) VALUES ('eng', 'English');
INSERT INTO languages (lan, lan_name) VALUES ('swe', 'Swedish');

create table if not exists pages
(
    pages_pkey      serial                                             not null,
    editnum         bigint                                             NOT NULL DEFAULT 1,
    insby           character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime     timestamp without time zone                        NOT NULL DEFAULT NOW(),
    modby           character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime     timestamp without time zone                        NOT NULL DEFAULT NOW(),
    languages_fkey  bigint                                             not null,
    pagepath        varchar UNIQUE not null,
    markdown        text,
    html            text,
    CONSTRAINT pages_pkey PRIMARY KEY (pages_pkey),
    CONSTRAINT pages_languages_fkey FOREIGN KEY (languages_fkey)
    REFERENCES languages (languages_pkey) MATCH SIMPLE
                             ON UPDATE NO ACTION
                             ON DELETE NO ACTION
                                DEFERRABLE
    );

-- 1 down
-- 2 up

ALTER TABLE users
    RENAME COLUMN passwd TO password;

-- 2 down