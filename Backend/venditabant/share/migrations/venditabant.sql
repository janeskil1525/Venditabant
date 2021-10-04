-- 1 up

create table if not exists companies
(
    companies_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    company varchar(100) not null default '',
    name varchar(100) not null default '',
    registrationnumber VARCHAR(50) not null default '',
    homepage VARCHAR(100) not null default '',
    phone VARCHAR(50) not null default '',
    CONSTRAINT companies_pkey PRIMARY KEY (companies_pkey)
);

CREATE UNIQUE INDEX idx_companies_company
    ON public.companies USING btree
        (company COLLATE pg_catalog."default");


create table if not exists stockitems
(
      stockitems_pkey serial not null ,
      editnum bigint NOT NULL DEFAULT 1,
      insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
      insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
      modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
      moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
      stockitem varchar(100) not null default '',
      description varchar(200) not null default '',
      companies_fkey bigint DEFAULT 0,
      CONSTRAINT stockitems_pkey PRIMARY KEY (stockitems_pkey)
) ;

CREATE UNIQUE INDEX idx_stockitems_stockitem_companies_fkey
    ON public.stockitems USING btree
        (stockitem, companies_fkey);

drop table if exists menu_group_links;
drop table if exists menu;
drop table if exists menu_groups;

create table if not exists menu (
    menu_pkey bigint not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    parent_menu_fkey bigint,
    sortorder bigint not null default 0,
    menu varchar(50) not null,
    menuaction varchar (100) not null default '#',
    orientation varchar(20),
    is_admin int NOT NULL DEFAULT 0,
    CONSTRAINT menu_pkey PRIMARY KEY (menu_pkey),
    CONSTRAINT menu_fkey_fkey FOREIGN KEY (parent_menu_fkey)
        REFERENCES public.menu (menu_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
) ;

CREATE  INDEX fki_menu_fkey_fkey
    ON public.menu(parent_menu_fkey);

CREATE  INDEX idx_unique_menu
    ON public.menu(menu);

DELETE FROM menu;

create table if not exists users
(
     users_pkey serial not null,
     editnum bigint NOT NULL DEFAULT 1,
     insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
     insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
     moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     userid varchar not null,
     username varchar not null default '',
     passwd varchar not null,
     support bigint DEFAULT 0,
     active bigint not null default 0,
     is_admin bigint not null default 0,
     CONSTRAINT users_pkey PRIMARY KEY (users_pkey)
) ;

CREATE UNIQUE INDEX  idx_users_userid
    ON public.users USING btree
        (userid );

create table if not exists users_companies
(
   users_companies_pkey serial not null,
   editnum bigint NOT NULL DEFAULT 1,
   insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
   insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
   modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
   moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
   companies_fkey bigint not null,
   users_fkey bigint not null,
   CONSTRAINT users_companies_pkey PRIMARY KEY (users_companies_pkey)
);

CREATE INDEX idx_users_companies_companies
    ON public.users_companies USING btree
        (companies_fkey ASC NULLS LAST);

CREATE INDEX idx_users_companies_users
    ON public.users_companies USING btree
        (users_fkey ASC NULLS LAST);

CREATE UNIQUE INDEX idx_users_companies_unique
    ON public.users_companies USING btree
        (users_fkey, companies_fkey);


create table if not exists user_changepassword
(
       user_changepassword_pkey serial not null,
       editnum bigint NOT NULL DEFAULT 1,
       insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
       insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
       modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
       moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
       token varchar,
       users_fkey BIGINT NOT NULL,
       expires timestamp without time zone NOT NULL DEFAULT NOW() + interval '24 hours',
       CONSTRAINT pki_user_changepassword_pkey PRIMARY KEY (user_changepassword_pkey),
       CONSTRAINT user_changepassword_users_fkey FOREIGN KEY (users_fkey)
           REFERENCES public.users (users_pkey) MATCH SIMPLE
           ON UPDATE NO ACTION
           ON DELETE NO ACTION
           DEFERRABLE
) ;

CREATE UNIQUE INDEX if not exists idx_user_changepassword_users_fkey
    ON user_changepassword(users_fkey);

create table if not exists users_token
(
       users_token_pkey serial not null,
       editnum bigint NOT NULL DEFAULT 1,
       insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
       insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
       modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
       moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
       token varchar(100),
       expiers timestamp without time zone NOT NULL DEFAULT NOW() + interval '8 hour',
       users_fkey bigint not null,
       CONSTRAINT users_token_pkey PRIMARY KEY (users_token_pkey),
       CONSTRAINT users_token FOREIGN KEY (users_fkey)
           REFERENCES public.users (users_pkey) MATCH SIMPLE
           ON UPDATE NO ACTION
           ON DELETE NO ACTION
           DEFERRABLE
) ;

CREATE UNIQUE INDEX users_token_users_fkey
    ON public.users_token(users_fkey);

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


CREATE OR REPLACE FUNCTION public.get_company_fkey(IN p_token character varying DEFAULT '')
    RETURNS bigint
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE companies_fkey BIGINT := 0;
BEGIN

    select into companies_fkey  (select a.companies_fkey
                                 from users_companies as a
                                          join users_token as b on a.users_fkey = b.users_fkey and token = p_token);

    return companies_fkey;
END
$BODY$;

create table if not exists companies_companies
(
    companies_companies_pkey serial not null,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    parent_companies_fkey bigint not null,
    child_companies_fkey bigint not null,
    CONSTRAINT companies_companies_pkey PRIMARY KEY (companies_companies_pkey),
    CONSTRAINT parent_companies_fkey FOREIGN KEY (parent_companies_fkey)
        REFERENCES public.companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT child_companies_fkey FOREIGN KEY (child_companies_fkey)
        REFERENCES public.companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
) ;

CREATE UNIQUE INDEX idx_companies_companies_unique
    ON public.companies_companies USING btree
        (parent_companies_fkey, child_companies_fkey);

CREATE TABLE if not exists warehouses
(
    warehouses_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    warehouse character varying(200) COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    warehouse_name varchar not null default '',
    companies_fkey bigint NOT NULL DEFAULT 0,
    CONSTRAINT warehouses_pkey PRIMARY KEY (warehouses_pkey)
) ;

CREATE UNIQUE INDEX if not exists idx_warehouses_warehouse_unique
    ON warehouses USING btree
        (warehouse);

CREATE TABLE if not exists  stockitems_stock
(
    stockitems_stock_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    stockitems_fkey bigint NOT NULL,
    quantity bigint NOT NULL DEFAULT 0,
    warehouses_fkey bigint NOT NULL DEFAULT 0,
    CONSTRAINT stockitems_stock_pkey PRIMARY KEY (stockitems_stock_pkey)
        USING INDEX TABLESPACE webshop,
    CONSTRAINT stockitems_stock_fkey_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES public.stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE if not exists stockitems_stock_trans
(
    stockitems_stock_trans_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    stockitems_stock_fkey bigint NOT NULL,
    quantity bigint NOT NULL DEFAULT 0,
    trans_type int not null default 0,
    trans_reference character varying(100) not null default '',
    CONSTRAINT stockitems_stock_trans_pkey PRIMARY KEY (stockitems_stock_trans_pkey),
    CONSTRAINT idx_stockitems_stock_fkey_fkey_fkey FOREIGN KEY (stockitems_stock_fkey)
        REFERENCES public.stockitems_stock (stockitems_stock_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);

CREATE TABLE if not exists stockitems_stock_reservations
(
    stockitems_stock_reservations_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    stockitems_stock_fkey bigint NOT NULL,
    quantity bigint NOT NULL DEFAULT 0,
    reservation_type int not null default 0, -- 1 = basket, 2 = quote, 3 = order
    reservation_reference character varying(100) not null default '',
    expirydate timestamp without time zone NOT NULL DEFAULT now(),
    reservation_source character varying(200) NOT NULL DEFAULT ''::character varying,
    source_fkey bigint NOT NULL,
    CONSTRAINT stockitems_stock_reservations_pkey PRIMARY KEY (stockitems_stock_reservations_pkey),
    CONSTRAINT idx_stockitems_stock_reservations_fkey_fkey_fkey FOREIGN KEY (stockitems_stock_fkey)
        REFERENCES public.stockitems_stock (stockitems_stock_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
);



CREATE INDEX fki_stockitem_stock_fkey_warehouse_fkey__unique
    ON public.stockitems_stock USING btree
        (stockitems_fkey, warehouses_fkey);

CREATE INDEX fki_stockitem_stock_warehouse_fkey
    ON public.stockitems_stock USING btree
        (warehouses_fkey);

CREATE INDEX fki_stockitem_stock_stockitems_stock_trans_fkey
    ON public.stockitems_stock_trans USING btree
        (stockitems_stock_fkey);

create table if not exists addresses
(
     addresses_pkey serial not null,
     editnum bigint NOT NULL DEFAULT 1,
     insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
     insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
     moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     name varchar(200) default '',
     address1 varchar(200) default '',
     address2 varchar(200) default '',
     address3 varchar(200) default '',
     city varchar(200) default '',
     zipcode varchar(200) default '',
     country varchar(30) default '',
     CONSTRAINT addresses_pkey PRIMARY KEY (addresses_pkey)
) ;

create table if not exists addresses_company
(
     addresses_company_pkey serial not null,
     editnum bigint NOT NULL DEFAULT 1,
     insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
     insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'Unknown',
     moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
     companies_fkey bigint not null,
     addresses_fkey bigint not null,
     address_type varchar NOT NULL DEFAULT 'invoice',
     CONSTRAINT addresses_company_pkey PRIMARY KEY (addresses_company_pkey),
     CONSTRAINT address_company_companies_fkey_fkey_fkey FOREIGN KEY (companies_fkey)
         REFERENCES public.companies (companies_pkey) MATCH SIMPLE
         ON UPDATE NO ACTION
         ON DELETE NO ACTION
         DEFERRABLE,
     CONSTRAINT addresses_company_address_fkey_fkey FOREIGN KEY (addresses_fkey)
         REFERENCES public.addresses (addresses_pkey) MATCH SIMPLE
         ON UPDATE NO ACTION
         ON DELETE NO ACTION
         DEFERRABLE
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_address_company_address_type_unique
    ON public.addresses_company USING btree
        (companies_fkey, addresses_fkey, address_type);

CREATE TABLE if not exists warehouses_addresses
(
    warehouses_addresses_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    warehouses_fkey bigint NOT NULL DEFAULT 0,
    addresses_fkey bigint NOT NULL DEFAULT 0,
    address_type character varying(25) NOT NULL DEFAULT 'Main',
    CONSTRAINT warehouses_addresses_pkey PRIMARY KEY (warehouses_addresses_pkey),
    CONSTRAINT idx_warehouses_addresses_warehouses_fkey FOREIGN KEY (warehouses_fkey)
        REFERENCES public.warehouses (warehouses_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID,
    CONSTRAINT idx_warehouses_addresses_addresses_fkey FOREIGN KEY (addresses_fkey)
        REFERENCES public.addresses (addresses_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID
) ;

CREATE UNIQUE INDEX idx_warehouses_addresses_warehouses_fkey_address_type
    ON warehouses_addresses (warehouses_fkey, address_type);

DROP INDEX IF EXISTS fki_stockitem_stock_fkey_warehouse_fkey__unique;

CREATE UNIQUE INDEX IF NOT EXISTS fki_stockitem_stock_fkey_warehouse_fkey__unique
    ON stockitems_stock (stockitems_fkey, warehouses_fkey);

CREATE TABLE IF NOT EXISTS translations
(
    translations_pkey SERIAL NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    languages_fkey integer NOT NULL DEFAULT 0,
    module character varying(100)  NOT NULL,
    tag character varying(100) NOT NULL,
    translation text NOT NULL,
    CONSTRAINT translations_pkey PRIMARY KEY (translations_pkey),
    CONSTRAINT languages_translations_fkey FOREIGN KEY (languages_fkey)
        REFERENCES languages (languages_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX if not exists idx_translations_languages_fkey_module_tag_unique
    ON translations USING btree
        (languages_fkey, module, tag);

CREATE  INDEX if not exists idx_translations_languages_fkey
    ON translations USING btree
        (languages_fkey);

INSERT INTO menu (menu_pkey, parent_menu_fkey, sortorder, menu, menuaction, orientation)
VALUES (1,null, 10, 'Home','/home','left'),
       (2,null, 20, 'Sales','/sales','left'),
       (3,2, 10, 'Salesorder','/salesorder','left'),
       (5,2, 20, 'Purchaseorder','/purchaseorders','left'),
       (4,null, 40, 'Administration','#','left');

INSERT INTO menu (menu_pkey, parent_menu_fkey, sortorder, menu, menuaction, orientation, is_admin)
VALUES (6,4, 10, 'All users','/allusers','left', 1),
       (7,4, 20, 'All companies','/companies','left', 1);

INSERT INTO menu (menu_pkey, parent_menu_fkey, sortorder, menu, menuaction, orientation)
VALUES (9,4, 10, 'User','/user','left'),
       (10,4, 20, 'Company','/company','left'),
       (11,4, 30, 'Customers','/customers','left'),
       (12,4, 30, 'Suppliers','/suppliers','left'),
       (26,null, 60, 'Stock','#','right'),
       (27,26, 10, 'Stockitems','/stockitems','left');

INSERT INTO translations (languages_fkey, module, tag, translation) VALUES
(6, 'MENU', 'Home','Hem'),
(6, 'MENU', 'Sales','Försäljning'),
(6, 'MENU', 'Administration','Administration'),
(6, 'MENU', 'All users','Alla användare'),
(6, 'MENU', 'All companies','Alla företag'),
(6, 'MENU', 'User','Användare'),
(6, 'MENU', 'Company','Företag'),
(6, 'MENU', 'Customers','Kunder'),
(6, 'MENU', 'Salesorder','Kundorder'),
(6, 'MENU', 'Purchaseorder','Inköpsorder'),
(6, 'MENU', 'Stock','Lager'),
(6, 'MENU', 'Stockitems','Artiklar'),
(6, 'MENU', 'Suppliers','Leverantörer');


-- 1 down

-- 2 up

CREATE TABLE IF NOT EXISTS company_functions
(
    company_functions_pkey SERIAL NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    companies_fkey bigint not null,
    module varchar  NOT NULL,
    function varchar NOT NULL,
    CONSTRAINT company_functions_pkey PRIMARY KEY (company_functions_pkey),
    CONSTRAINT company_functions_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE

);

create unique index idx_company_functions_companies_fkey_module_function
    on company_functions(companies_fkey, module, function);

create index idx_company_functions_companies_fkey
    on company_functions(companies_fkey);

create index idx_company_functions_module
    on company_functions(module);

create index idx_company_functions_function
    on company_functions(function);

-- 2 down

-- 3 up
INSERT INTO translations (languages_fkey, module, tag, translation) VALUES
(6, 'NewUser', 'email','Email...'),
(6, 'NewUser', 'username','Namn...'),
(6, 'NewUser', 'companyname','Företag...'),
(6, 'NewUser', 'registrationmber','Organisationsnummer...'),
(6, 'NewUser', 'password1','Lösenord...'),
(6, 'NewUser', 'password2','Lösenord igen...'),
(6, 'NewUser', 'savebutton','Spara...'),
(6, 'NewUser', 'passworderror','Något är fel med lösenordet, antingen är de inte lika eller så är det kortare än 7 tecken'),
(6, 'NewUser', 'registerheader','Registrera dig och ditt företag');

DROP TABLE IF EXISTS company_functions;

CREATE TABLE IF NOT EXISTS company_functions
(
    company_functions_pkey SERIAL NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    companies_fkey bigint not null,
    menu_fkey bigint not null,
    CONSTRAINT company_functions_pkey PRIMARY KEY (company_functions_pkey),
    CONSTRAINT company_functions_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT company_functions_menu_fkey FOREIGN KEY (menu_fkey)
        REFERENCES menu (menu_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

create unique index idx_company_functions_companies_fkey_menu_fkey
    on company_functions(companies_fkey, menu_fkey);

create index idx_company_functions_companies_fkey
    on company_functions(companies_fkey);

create index idx_company_functions_menu_fkey
    on company_functions(menu_fkey);

-- 3 down

-- 4 up
CREATE OR REPLACE FUNCTION public.get_company_fkey(IN p_token character varying DEFAULT '')
    RETURNS bigint
    LANGUAGE 'plpgsql'
AS $BODY$
DECLARE companies_fkey BIGINT := 0;
BEGIN

    select into companies_fkey  (select a.companies_fkey
                                 from users_companies as a
                                          join users_token as b on a.users_fkey = b.users_fkey and token = p_token);

    return companies_fkey;
END
$BODY$;

-- 4 down

-- 5 up
create table if not exists pricelists
(
    pricelists_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    pricelist varchar unique not null default '',
    CONSTRAINT pricelists_pkey PRIMARY KEY (pricelists_pkey)
);

INSERT INTO pricelists (pricelist) VALUES ('Default');

create table if not exists pricelist_items
(
    pricelist_items_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    pricelists_fkey bigint not null,
    stockitems_fkey bigint not null,
    price  numeric(15,2) NOT NULL DEFAULT 0.0,
    fromdate timestamp without time zone NOT NULL DEFAULT NOW(),
    todate timestamp without time zone NOT NULL DEFAULT '2100-01-01',
    comment varchar  not null default '',
    CONSTRAINT pricelist_items_pkey PRIMARY KEY (pricelist_items_pkey),
    CONSTRAINT pricelist_items_pricelists_fkey FOREIGN KEY (pricelists_fkey)
        REFERENCES pricelists (pricelists_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT pricelist_items_stockitems_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

create index idx_pricelist_items_pricelists_fkey
    on pricelist_items(pricelists_fkey);

create index idx_pricelist_items_stockitems_fkey
    on pricelist_items(stockitems_fkey);

create index idx_pricelist_items_stockitems_fkey_pricelists_fkey
    on pricelist_items(stockitems_fkey, pricelists_fkey);

create table if not exists customers
(
    customers_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    customer varchar not null default '',
    name varchar(100) not null default '',
    registrationnumber VARCHAR(50) not null default '',
    homepage VARCHAR(100) not null default '',
    phone VARCHAR(50) not null default '',
    pricelists_fkey bigint not null,
    CONSTRAINT customers_pkey PRIMARY KEY (customers_pkey),
    CONSTRAINT customers_pricelists_fkey FOREIGN KEY (pricelists_fkey)
        REFERENCES pricelists (pricelists_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX idx_customers_customer
    ON public.customers(customer);

-- 5 down

-- 6 up

DROP TABLE customers;
DROP TABLE pricelist_items;
DROP TABLE pricelists;

create table if not exists pricelists
(
    pricelists_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    pricelist varchar not null default '',
    companies_fkey bigint not null,
    CONSTRAINT pricelists_pkey PRIMARY KEY (pricelists_pkey),
    CONSTRAINT pricelists_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX idx_pricelists_pricelist_companies_fkey
    ON public.pricelists(pricelist, companies_fkey);

create table if not exists pricelist_items
(
    pricelist_items_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    pricelists_fkey bigint not null,
    stockitems_fkey bigint not null,
    price  numeric(15,2) NOT NULL DEFAULT 0.0,
    fromdate timestamp without time zone NOT NULL DEFAULT NOW(),
    todate timestamp without time zone NOT NULL DEFAULT '2100-01-01',
    comment varchar  not null default '',
    CONSTRAINT pricelist_items_pkey PRIMARY KEY (pricelist_items_pkey),
    CONSTRAINT pricelist_items_pricelists_fkey FOREIGN KEY (pricelists_fkey)
        REFERENCES pricelists (pricelists_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT pricelist_items_stockitems_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

create index idx_pricelist_items_pricelists_fkey
    on pricelist_items(pricelists_fkey);

create index idx_pricelist_items_stockitems_fkey
    on pricelist_items(stockitems_fkey);

create index idx_pricelist_items_stockitems_fkey_pricelists_fkey
    on pricelist_items(stockitems_fkey, pricelists_fkey);

create table if not exists customers
(
    customers_pkey serial not null ,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    customer varchar not null default '',
    name varchar(100) not null default '',
    registrationnumber VARCHAR(50) not null default '',
    homepage VARCHAR(100) not null default '',
    phone VARCHAR(50) not null default '',
    pricelists_fkey bigint not null,
    companies_fkey bigint not null,
    CONSTRAINT customers_pkey PRIMARY KEY (customers_pkey),
    CONSTRAINT customers_pricelists_fkey FOREIGN KEY (pricelists_fkey)
        REFERENCES pricelists (pricelists_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT customers_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX idx_customers_customer_companies_fkey
    ON public.customers(customer, companies_fkey);

-- 6 down

-- 7 up

-- Table: public.settings

-- DROP TABLE public.settings;

CREATE TABLE public.settings
(
    settings_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    setting_name character varying(200) COLLATE pg_catalog."default" UNIQUE NOT NULL DEFAULT ''::character varying,
    CONSTRAINT settings_pkey PRIMARY KEY (settings_pkey)
);

CREATE TABLE public.defined_settings_values
(
    defined_settings_values_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    settings_fkey bigint NOT NULL,
    setting_no bigint NOT NULL DEFAULT 0,
    setting_value text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    setting_order bigint NOT NULL DEFAULT 0,
    companies_fkey bigint NOT NULL DEFAULT 0,
    users_fkey bigint NOT NULL DEFAULT 0,
    setting_properties character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    setting_backend_properties character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT defined_settings_values_pkey PRIMARY KEY (defined_settings_values_pkey),
    CONSTRAINT defined_settings_values_fkey FOREIGN KEY (settings_fkey)
        REFERENCES public.settings (settings_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE INDEX  idx_defined_settings_values_fkey_settings_fkey
    ON settings(settings_pkey);

CREATE UNIQUE INDEX idx_settings_fkey_setting_no_companies_fkey_users_fkey
    ON public.defined_settings_values USING btree
        (settings_fkey ASC NULLS LAST, setting_no ASC NULLS LAST, companies_fkey ASC NULLS LAST, users_fkey ASC NULLS LAST);

CREATE TABLE public.default_settings_values
(
    default_settings_values_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby character varying(25) COLLATE pg_catalog."default" NOT NULL DEFAULT 'System'::character varying,
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    settings_fkey bigint NOT NULL,
    setting_no bigint NOT NULL DEFAULT 0,
    setting_value text COLLATE pg_catalog."default" NOT NULL DEFAULT ''::text,
    setting_order bigint NOT NULL DEFAULT 0,
    setting_properties character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    setting_backend_properties character varying COLLATE pg_catalog."default" NOT NULL DEFAULT ''::character varying,
    CONSTRAINT default_settings_values_pkey PRIMARY KEY (default_settings_values_pkey),
    CONSTRAINT default_settings_values_settings_fkey FOREIGN KEY (settings_fkey)
        REFERENCES public.settings (settings_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE INDEX idx_default_settings_values_fkey_settings_fkey
    ON settings(settings_pkey);

CREATE UNIQUE INDEX idx_settings_fkey_setting_no
    ON public.default_settings_values USING btree
        (settings_fkey ASC NULLS LAST, setting_no ASC NULLS LAST);

-- 7 down

-- 8 up


INSERT INTO settings (setting_name) values ('pricelists_grid_header');
INSERT INTO settings (setting_name) values ('pricelist_items_grid_header');
INSERT INTO settings (setting_name) values ('tockitems_grid_header');

INSERT INTO default_settings_values (settings_fkey, setting_no, setting_value, setting_order, setting_properties) VALUES
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelists_grid_header'),
 1, 'pricelists_pkey', 0, '{"visible":"false"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelists_grid_header'),
 2, 'pricelist', 0, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 1, 'pricelist_items_pkey', 0, '{"visible":"false"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 2, 'pricelist', 1, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 3, 'stockitem', 2, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 4, 'description', 3, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 5, 'price', 4, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 6, 'fromdate', 5, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 7, 'todate', 6, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'pricelist_items_grid_header'),
 8, 'companies_fkey', 0, '{"visible":"false"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'stockitems_grid_header'),
 0, 'stockitems_pkey', 0, '{"visible":"false"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'stockitems_grid_header'),
 1, 'stockitem', 1, '{"visible":"true"}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'stockitems_grid_header'),
 2, 'description', 2, '{visible:true}'),
((SELECT settings_pkey FROM settings WHERE setting_name = 'stockitems_grid_header'),
 3, 'companies_fkey', 2, '{"visible":"false"}');

INSERT INTO translations (languages_fkey, module, tag, translation) VALUES
(6, 'pricelist_grid_header', 'pricelists_pkey','Primär nyckel'),
(6, 'pricelist_grid_header', 'pricelist','Prislista'),
(6, 'pricelist_items_grid_header', 'pricelist_items_pkey','Primär nyckel'),
(6, 'pricelist_items_grid_header', 'pricelist','Prislista'),
(6, 'pricelist_items_grid_header', 'stockitem','Artikel'),
(6, 'pricelist_items_grid_header', 'description','Beskrivning'),
(6, 'pricelist_items_grid_header', 'price','Pris'),
(6, 'pricelist_items_grid_header', 'fromdate','Från datum'),
(6, 'pricelist_items_grid_header', 'todate','Till datum'),
(6, 'stockitems_grid_header', 'stockitem_pkey','Primär nyckel'),
(6, 'stockitems_grid_header', 'stockitem','Artikel'),
(6, 'stockitems_grid_header', 'description','Beskrivning'),

(6, 'pricelists', 'pricelists_pkey','Primär nyckel'),
(6, 'pricelists', 'pricelist','Prislista'),
(6, 'pricelist_items', 'pricelist_items_pkey','Primär nyckel'),
(6, 'pricelist_items', 'pricelists_pkey','Prislista'),
(6, 'pricelist_items', 'stockitem','Artikel'),
(6, 'pricelist_items', 'description','Beskrivning'),
(6, 'pricelist_items', 'price','Pris'),
(6, 'pricelist_items', 'fromdate','Från datum'),
(6, 'pricelist_items', 'todate','Till datum'),
(6, 'stockitem_', 'stockitem_pkey','Primär nyckel'),
(6, 'stockitem_', 'stockitem','Artikel'),
(6, 'stockitem_', 'description','Beskrivning');

CREATE OR REPLACE VIEW public."pricelist_items_grid"
AS
SELECT pricelist_items.pricelist_items_pkey,
       pricelists.pricelist,
       stockitems.stockitem,
       stockitems.description,
       pricelist_items.price,
       pricelist_items.fromdate,
       pricelist_items.todate,
       pricelists.companies_fkey
FROM ((pricelist_items
    JOIN stockitems ON ((pricelist_items.stockitems_fkey = stockitems.stockitems_pkey)))
         JOIN pricelists ON ((pricelist_items.pricelists_fkey = pricelists.pricelists_pkey)));


-- 8 down

-- 9 up
INSERT INTO menu (menu_pkey, parent_menu_fkey, sortorder, menu, menuaction, orientation)
VALUES (28,26, 20, 'Pricelists','/pricelists','left');

INSERT INTO translations (languages_fkey, module, tag, translation) VALUES
(6, 'MENU', 'Pricelists','Prislistor');

-- 9 down

--10 up
CREATE TABLE salesorders
(
    salesorders_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    customers_fkey bigint NOT NULL,
    users_fkey bigint NOT NULL,
    companies_fkey bigint NOT NULL,
    orderdate timestamp without time zone NOT NULL DEFAULT now(),
    deliverydate timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT salesorders_pkey PRIMARY KEY (salesorders_pkey),
    CONSTRAINT salesorders_customers_fkey FOREIGN KEY (customers_fkey)
        REFERENCES customers (customers_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorders_users_fkey FOREIGN KEY (users_fkey)
        REFERENCES users (users_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorders_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE salesorder_items
(
    salesorder_items_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    salesorders_fkey bigint NOT NULL,
    stockitems_fkey BIGINT NOT NULL,
    quantity NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    CONSTRAINT salesorder_items_pkey PRIMARY KEY (salesorder_items_pkey),
    CONSTRAINT salesorder_items_salesorders_fkey FOREIGN KEY (salesorders_fkey)
        REFERENCES salesorders (salesorders_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorder_items_stockitems_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE salesorder_statistics
(
    salesorder_statistics_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    salesorders_fkey bigint NOT NULL,
    stockitems_fkey BIGINT NOT NULL,
    customers_fkey bigint NOT NULL,
    users_fkey bigint NOT NULL,
    companies_fkey bigint NOT NULL,
    orderdate timestamp without time zone NOT NULL DEFAULT now(),
    deliverydate timestamp without time zone NOT NULL DEFAULT now(),
    quantity NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    CONSTRAINT salesorder_statistics_pkey PRIMARY KEY (salesorder_statistics_pkey),
    CONSTRAINT salesorder_statistics_salesorders_fkey FOREIGN KEY (salesorders_fkey)
        REFERENCES salesorders (salesorders_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorder_statistics_stockitems_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorder_statistics_customers_fkey FOREIGN KEY (customers_fkey)
        REFERENCES customers (customers_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorder_statistics_users_fkey FOREIGN KEY (users_fkey)
        REFERENCES users (users_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorder_statistics_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

ALTER TABLE stockitems
ALTER COLUMN insby SET DATA TYPE varchar,
ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE pricelists
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE customers
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE pricelist_items
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE companies
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE users
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE users_companies
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE warehouses
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE stockitems_stock_trans
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE stockitems_stock_reservations
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

ALTER TABLE stockitems_stock
    ALTER COLUMN insby SET DATA TYPE varchar,
    ALTER COLUMN modby SET DATA TYPE varchar;

DROP TABLE users_token;
DROP TABLE company_functions;
DROP TABLE menu;
DROP TABLE translations;
DROP TABLE languages;
DROP TABLE default_settings_values;
DROP TABLE defined_settings_values;
DROP TABLE settings;

-- 10 down

-- 11 up

ALTER TABLE salesorders
    ADD COLUMN open BOOLEAN NOT NULL DEFAULT true;

CREATE INDEX idx_salesorders_customers_fkey_open
    ON salesorders(customers_fkey, open);

-- 11 down

-- 12 up

ALTER TABLE salesorders
    ADD COLUMN orderno BIGINT UNIQUE NOT NULL;

CREATE TABLE counter
(
    counter_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    name VARCHAR NOT NULL,
    companies_fkey BIGINT NOT NULL,
    counter BIGINT NOT NULL DEFAULT 0,
    CONSTRAINT counter_counter_pkey PRIMARY KEY (counter_pkey),
    CONSTRAINT counter_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX counter_name_companies_fkey
    ON counter(name, companies_fkey);

-- 12 down

-- 13 up
CREATE UNIQUE INDEX idx_salesorder_item_salesorder_stockitem
    ON salesorder_items(salesorders_fkey, stockitems_fkey);

-- 13 down

-- 14 up

CREATE TABLE company_version
(
    company_version_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    companies_fkey bigint NOT NULL,
    version BIGINT NOT NULL,
    CONSTRAINT company_version_pkey PRIMARY KEY (company_version_pkey),
    CONSTRAINT company_version_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE UNIQUE INDEX idx_company_companies_fkey_version
    ON company_version(companies_fkey);

-- 14 down

-- 15 up
CREATE TABLE if not exists sentinel
(
    sentinel_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    organisation varchar,
    source varchar,
    method varchar,
    message varchar,
    recipients varchar,
    mailed bool NOT NULL DEFAULT false,
    closed bool NOT NULL DEFAULT false,
    CONSTRAINT pk_idx_sentinel_pkey PRIMARY KEY (sentinel_pkey)
);

-- 15 down

-- 16 up

CREATE TABLE if not exists units
(
    units_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT NOW(),
    unit varchar UNIQUE,
    description varchar,
    companies_fkey bigint NOT NULL,
    CONSTRAINT pk_idx_units_pkey PRIMARY KEY (units_pkey),
    CONSTRAINT units_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

ALTER TABLE stockitems
    ADD COLUMN purchaseprice NUMERIC(10,2) NOT NULL DEFAULT 0.0;

ALTER TABLE stockitems
    ADD COLUMN active BOOLEAN NOT NULL DEFAULT true;

ALTER TABLE stockitems
    ADD COLUMN stocked BOOLEAN NOT NULL DEFAULT true;

ALTER TABLE stockitems
    ADD COLUMN units_fkey BIGINT NOT NULL DEFAULT 0;

CREATE TABLE invoice
(
    invoice_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    customers_fkey bigint NOT NULL,
    companies_fkey bigint NOT NULL,
    invoicedate timestamp without time zone NOT NULL DEFAULT now(),
    paydate timestamp without time zone NOT NULL DEFAULT now(),
    CONSTRAINT invoice_pkey PRIMARY KEY (invoice_pkey),
    CONSTRAINT invoice_customers_fkey FOREIGN KEY (customers_fkey)
        REFERENCES customers (customers_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT salesorders_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE invoice_items
(
    invoice_items_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    invoice_fkey bigint NOT NULL,
    stockitems_fkey BIGINT NOT NULL,
    quantity NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    price NUMERIC(10,2) NOT NULL DEFAULT 0.0,
    CONSTRAINT invoice_items_pkey PRIMARY KEY (invoice_items_pkey),
    CONSTRAINT invoice_items_salesorders_fkey FOREIGN KEY (invoice_fkey)
        REFERENCES invoice (invoice_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE,
    CONSTRAINT invoice_items_stockitems_fkey FOREIGN KEY (stockitems_fkey)
        REFERENCES stockitems (stockitems_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

-- 16 down

-- 17 up
CREATE TABLE parameters
(
    parameters_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    companies_fkey bigint NOT NULL,
    parameter varchar NOT NULL DEFAULT '',
    description varchar NOT NULL DEFAULT '',
    CONSTRAINT parameters_pkey PRIMARY KEY (parameters_pkey),
    CONSTRAINT parameters_companies_fkey FOREIGN KEY (companies_fkey)
        REFERENCES companies (companies_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);

CREATE TABLE parameters_items
(
    parameters_items_pkey serial NOT NULL,
    editnum bigint NOT NULL DEFAULT 1,
    insby varchar NOT NULL DEFAULT 'System',
    insdatetime timestamp without time zone NOT NULL DEFAULT now(),
    modby varchar NOT NULL DEFAULT 'System',
    moddatetime timestamp without time zone NOT NULL DEFAULT now(),
    parameters_fkey bigint NOT NULL,
    param_value varchar NOT NULL DEFAULT '',
    param_description varchar NOT NULL DEFAULT '',
    CONSTRAINT parameters_items_pkey PRIMARY KEY (parameters_items_pkey),
    CONSTRAINT parameters_items_parameters_fkey FOREIGN KEY (parameters_fkey)
        REFERENCES parameters (parameters_pkey) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        DEFERRABLE
);


CREATE UNIQUE INDEX idx_parameters
    ON parameters(companies_fkey, parameter);

CREATE INDEX idx_parameters_items_parameters_fkey
    ON parameters_items(parameters_fkey);

CREATE UNIQUE INDEX idx_parameters_parameters_items
    ON parameters_items(parameters_fkey, param_value);

-- 17 down