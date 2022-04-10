
INSERT INTO workflows (workflow) VALUES ('convert_order_to_invoice_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'convert_order_to_invoice_simple'),
           'action', '<actions>
       <type>convert_order_to_invoice_simple</type>
       <action name="convert_order_to_invoice" class="Import::Workflow::Action::InvoiceFromSo">
           <field name="salesorders_pkey" description="Key to salesorder" is_required="yes" ></field>
       </action>
       <action name="process_invoice" class="Engine::Workflow::Action::Transit">
                <field name="activity" description="activity" is_required="yes" > </field>
                <field name="payload" description="Transit payload" is_required="yes" />
                <field name="companies_pkey" description="Company key" is_required="yes" > </field>
                <field name="users_pkey" description="Key to user" is_required="yes" > </field>
       </action>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
       <type>convert_order_to_invoice_simple</type>
       <action name="convert_order_to_invoice" class="Import::Workflow::Action::InvoiceFromSo">
           <field name="salesorders_pkey" description="Key to salesorder" is_required="yes" ></field>
       </action>
       <action name="process_invoice" class="Engine::Workflow::Action::Transit">
                <field name="activity" description="activity" is_required="yes" > </field>
                <field name="payload" description="Transit payload" is_required="yes" />
                <field name="companies_pkey" description="Company key" is_required="yes" > </field>
                <field name="users_pkey" description="Key to user" is_required="yes" > </field>
       </action>
</actions>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'convert_order_to_invoice_simple'),
           'precheck', '<precheck>
    <actions>      
      <groups condition="convert_order_to_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
    <actions>      
      <groups condition="convert_order_to_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'convert_order_to_invoice_simple'),
           'persister', '<persisters>
           <persister name="ConvertInvoicePersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_import"
                      extra_data_field="source_pkey, target_pkey, import_type "
           />
          <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::MojoSimple"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
           <persister name="ConvertInvoicePersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_import"
                      extra_data_field="source_pkey, target_pkey, import_type "
           />
          <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::MojoSimple"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'convert_order_to_invoice_simple'),
           'workflow', '<workflow>
    <type>convert_order_to_invoice_simple</type>
    <description>Create a simple invoice from salesorder</description>
    <persister>ConvertInvoicePersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="convert_order_to_invoice" resulting_state="Invoice Created" />
    </state>
     <state name="Invoice Created">
        <description>Invoice is imported / created from a sales order</description>
        <action name="process_invoice" resulting_state="Invoice in process" />
    </state>
     <state name="Invoice in process">
        <description>Invoice is in next WF beeing processed</description>
        <action name="cleanup_workflow" resulting_state="NOCHANGE"  />
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>convert_order_to_invoice_simple</type>
    <description>Create a simple invoice from salesorder</description>
    <persister>ConvertInvoicePersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="convert_order_to_invoice" resulting_state="Invoice Created" />
    </state>
     <state name="Invoice Created">
        <description>Invoice is imported / created from a sales order</description>
        <action name="process_invoice" resulting_state="Invoice in process" />
    </state>
     <state name="Invoice in process">
        <description>Invoice is in next WF beeing processed</description>
        <action name="cleanup_workflow" resulting_state="NOCHANGE"  />
    </state>
</workflow>' ;

INSERT INTO workflows (workflow) VALUES ('invoice_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'action', '<actions>
<type>invoice_simple</type>
<action name="create_invoice" class="Invoice::Workflow::Action::Create">
              <field name="invoice_pkey"
                    description="Foreign key to invoice" is_required="no" >
              </field>
</action>
<action name="create_document" class="Invoice::Workflow::Action::Document"/>
<action name="print_invoice" class="Invoice::Workflow::Action::Print"/>
<action name="send_invoice" class="Invoice::Workflow::Action::Send"/>
<action name="pay_invoice" class="Invoice::Workflow::Action::Pay"/>
<action name="remind_invoice" class="Invoice::Workflow::Action::Remind"/>
<action name="resend_invoice" class="Invoice::Workflow::Action::Resend"/>
<action name="reprint_invoice" class="Invoice::Workflow::Action::Reprint"/>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
<type>invoice_simple</type>
<action name="create_invoice" class="Invoice::Workflow::Action::Create">
              <field name="invoice_pkey"
                    description="Foreign key to invoice" is_required="no" >
              </field>
</action>
<action name="create_document" class="Invoice::Workflow::Action::Document"/>
<action name="print_invoice" class="Invoice::Workflow::Action::Print"/>
<action name="send_invoice" class="Invoice::Workflow::Action::Send"/>
<action name="pay_invoice" class="Invoice::Workflow::Action::Pay"/>
<action name="remind_invoice" class="Invoice::Workflow::Action::Remind"/>
<action name="resend_invoice" class="Invoice::Workflow::Action::Resend"/>
<action name="reprint_invoice" class="Invoice::Workflow::Action::Reprint"/>
</actions>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'persister', '<persisters>
        <persister name="InvoicePersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_invoice"
                 extra_data_field="invoice_fkey, closed, users_fkey, companies_fkey"
          />
          <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::MojoSimple"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>


'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
        <persister name="InvoicePersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_invoice"
                 extra_data_field="invoice_fkey, closed, users_fkey, companies_fkey"
          />
          <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::MojoSimple"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>


' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'condition', '<conditions>
  <condition name="IsToBeMailed" class="Invoice::Workflow::Condition::IsToBeMailed">
        <param name="mail" value="1" />
  </condition>
</conditions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<conditions>
  <condition name="IsToBeMailed" class="Invoice::Workflow::Condition::IsToBeMailed">
        <param name="mail" value="1" />
  </condition>
</conditions>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'precheck', '<precheck>
    <actions>
     <groups condition="create_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="create_document">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
    <groups condition="send_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
    <groups condition="print_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
    <actions>
     <groups condition="create_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="create_document">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
    <groups condition="send_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
    <groups condition="print_invoice">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'auto_transit', '<auto_transit>
    <transits>
        <transit name="Create Document" class="Invoice::Helpers::Workflow"  method="load_workflow_list" activity="create_document," ></transit >
         <transit name="Print Send" class="Invoice::Helpers::Workflow"  method="load_workflow_list" activity="print_invoice,send_invoice" ></transit >
     </transits>
</auto_transit>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<auto_transit>
    <transits>
        <transit name="Create Document" class="Invoice::Helpers::Workflow"  method="load_workflow_list" activity="create_document," ></transit >
         <transit name="Print Send" class="Invoice::Helpers::Workflow"  method="load_workflow_list" activity="print_invoice,send_invoice" ></transit >
     </transits>
</auto_transit>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_simple'),
           'workflow', '<workflow>
    <type>invoice_simple</type>
    <description>Process a simple invoice</description>
    <persister>InvoicePersister</persister>

    <state name="INITIAL">
        <description>Create workflow for invoice
        </description>
        <action name="create_invoice" resulting_state="Invoice Created"/>        
    </state>

    <state name="Invoice Created">
         <action name="create_document" resulting_state="Document Created"/>
    </state>
    <state name="Document Created">
         <description>
              A PDF Document exixts and can be printed or sent by some means
        </description>
        <action name="print_invoice" resulting_state="Invoice Printed">
                <condition name="!IsToBeMailed" />
        </action>
        <action name="send_invoice" resulting_state="Invoice Sent">
                <condition name="IsToBeMailed" />
        </action>
    </state>
    <state name="Invoice Printed">
         <description>
             Invoice has been printed
        </description>
        <action name="reprint_invoice" resulting_state="NOCHANGE"/>
        <action name="remind_invoice" resulting_state="NOCHANGE"/>
        <action name="pay_invoice" resulting_state="Invoice Paid"/>
    </state>
    <state name="Invoice Sent">
        <description>
              Invoice has been printed
        </description>
        <action name="resend_invoice" resulting_state="NOCHANGE"/>
        <action name="remind_invoice" resulting_state="NOCHANGE"/>
        <action name="pay_invoice" resulting_state="Invoice Paid"/>
    </state>
    <state name="Invoice Paid">
        <description>
              Invoice has been paid
        </description>
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>invoice_simple</type>
    <description>Process a simple invoice</description>
    <persister>InvoicePersister</persister>

    <state name="INITIAL">
        <description>Create workflow for invoice
        </description>
        <action name="create_invoice" resulting_state="Invoice Created"/>        
    </state>

    <state name="Invoice Created">
         <action name="create_document" resulting_state="Document Created"/>
    </state>
    <state name="Document Created">
         <description>
              A PDF Document exixts and can be printed or sent by some means
        </description>
        <action name="print_invoice" resulting_state="Invoice Printed">
                <condition name="!IsToBeMailed" />
        </action>
        <action name="send_invoice" resulting_state="Invoice Sent">
                <condition name="IsToBeMailed" />
        </action>
    </state>
    <state name="Invoice Printed">
         <description>
             Invoice has been printed
        </description>
        <action name="reprint_invoice" resulting_state="NOCHANGE"/>
        <action name="remind_invoice" resulting_state="NOCHANGE"/>
        <action name="pay_invoice" resulting_state="Invoice Paid"/>
    </state>
    <state name="Invoice Sent">
        <description>
              Invoice has been printed
        </description>
        <action name="resend_invoice" resulting_state="NOCHANGE"/>
        <action name="remind_invoice" resulting_state="NOCHANGE"/>
        <action name="pay_invoice" resulting_state="Invoice Paid"/>
    </state>
    <state name="Invoice Paid">
        <description>
              Invoice has been paid
        </description>
    </state>
</workflow>' ;

INSERT INTO workflows (workflow) VALUES ('invoice_mail')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'precheck', '<precheck>
     <actions>
        <groups condition="create_mail" >
        <action name="get_customer_data" class="Invoice::PreCheck::Customer" method="find_customer" order= "1">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="get_recipients_data" class="Invoice::PreCheck::Recipients" method="find_recipients" order= "1">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
         <action name="historycompany" class="Invoice::PreCheck::Company" method="load_company" order= "4">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
     </groups>
        <groups condition="send_mail" >
         <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
     </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
     <actions>
        <groups condition="create_mail" >
        <action name="get_customer_data" class="Invoice::PreCheck::Customer" method="find_customer" order= "1">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="get_recipients_data" class="Invoice::PreCheck::Recipients" method="find_recipients" order= "1">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
         <action name="historycompany" class="Invoice::PreCheck::Company" method="load_company" order= "4">
                <field name="invoice_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
     </groups>
        <groups condition="send_mail" >
         <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
     </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'mappings', '<mappings>
     <groups condition="create_mail" >
        <map name="invicereference" source="customer"  templ_key="invicereference" source_key="reference" ></map>
        <map name="company_name"  source="company"  templ_key="company_name" source_key="name"></map>
         <map name="company_address1"  source="company"  templ_key="company_address1" source_key="address1"></map>
         <map name="company_address2"  source="company"  templ_key="company_address2" source_key="address2"></map>
         <map name="zipcode"  source="company"  templ_key="zipcode" source_key="zipcode"></map>
         <map name="city"  source="company"  templ_key="city" source_key="city"></map>
     </groups>
</mappings>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<mappings>
     <groups condition="create_mail" >
        <map name="invicereference" source="customer"  templ_key="invicereference" source_key="reference" ></map>
        <map name="company_name"  source="company"  templ_key="company_name" source_key="name"></map>
         <map name="company_address1"  source="company"  templ_key="company_address1" source_key="address1"></map>
         <map name="company_address2"  source="company"  templ_key="company_address2" source_key="address2"></map>
         <map name="zipcode"  source="company"  templ_key="zipcode" source_key="zipcode"></map>
         <map name="city"  source="company"  templ_key="city" source_key="city"></map>
     </groups>
</mappings>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'auto_transit', '<auto_transit>
    <transits>
        <transit name="Mail Created" class="Mailer::Helpers::Workflow"  method="load_workflow_list" activity="send_mail" ></transit >
         <transit name="Mail Sent" class="Mailer::Helpers::Workflow"  method="load_workflow_list" activity="mail_sent" ></transit >
     </transits>
</auto_transit>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<auto_transit>
    <transits>
        <transit name="Mail Created" class="Mailer::Helpers::Workflow"  method="load_workflow_list" activity="send_mail" ></transit >
         <transit name="Mail Sent" class="Mailer::Helpers::Workflow"  method="load_workflow_list" activity="mail_sent" ></transit >
     </transits>
</auto_transit>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'persister', '<persisters>
           <persister name="MailPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_mail"
                      extra_data_field="mailer_mails_fkeys, sent, companies_fkey"
           />
          <persister name="InvoicePersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_invoice"
                 extra_data_field="invoice_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
           <persister name="MailPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_mail"
                      extra_data_field="mailer_mails_fkeys, sent, companies_fkey"
           />
          <persister name="InvoicePersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_invoice"
                 extra_data_field="invoice_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'workflow', '<workflow>
    <type>invoice_mail</type>
    <description>Create mail</description>
    <persister>MailPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_mail" resulting_state="Mail Created" />
    </state>
     <state name="Mail Created">
        <description>Mail created ready to be sent</description>
        <action name="send_mail" resulting_state="Mail Sent" />
    </state>
     <state name="Mail Sent">
        <description>Set mail as sent</description>
        <action name="mail_sent" resulting_state="NOCHANGE"  />
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>invoice_mail</type>
    <description>Create mail</description>
    <persister>MailPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_mail" resulting_state="Mail Created" />
    </state>
     <state name="Mail Created">
        <description>Mail created ready to be sent</description>
        <action name="send_mail" resulting_state="Mail Sent" />
    </state>
     <state name="Mail Sent">
        <description>Set mail as sent</description>
        <action name="mail_sent" resulting_state="NOCHANGE"  />
    </state>
</workflow>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'invoice_mail'),
           'action', '<actions>
     <type>invoice_mail</type>
           <action name="create_mail" class="Mailer::Workflow::Action::Create"/>
           <action name="send_mail" class="Mailer::Workflow::Action::Send"/>
           <action name="mail_sent" class="Invoice::Workflow::Action::Sent"/>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
     <type>invoice_mail</type>
           <action name="create_mail" class="Mailer::Workflow::Action::Create"/>
           <action name="send_mail" class="Mailer::Workflow::Action::Send"/>
           <action name="mail_sent" class="Invoice::Workflow::Action::Sent"/>
</actions>' ;

INSERT INTO workflows (workflow) VALUES ('Salesorder item')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflows (workflow) VALUES ('Invoice item')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflows (workflow) VALUES ('salesorder_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'salesorder_simple'),
           'persister', '<persisters>
           <persister name="SalesordersPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_salesorders"
                      extra_data_field="salesorders_pkey"
           />
           <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>

'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
           <persister name="SalesordersPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
                      extra_table="workflow_salesorders"
                      extra_data_field="salesorders_pkey"
           />
           <persister name="TransitPersister"
                      class="Engine::Workflow::Persister::DBI::Mojo"
                      dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                      autocommit="1"
                      date_format="%Y-%m-%d %H:%M"
           />
</persisters>

' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'salesorder_simple'),
           'workflow', '<workflow>
    <type>salesorder_simple</type>
    <description>Create a simple salesorder</description>
    <persister>SalesordersPersister</persister>

    <state name="INITIAL">
        <description>This is the state the workflow enters when
            instantiated. Its like a "state zero" but since we are
            using names rather than IDs we cannot assume
        </description>
        <action name="create_order" resulting_state="Order Created"/>
    </state>

    <state name="Order Created">
        <action name="additem_to_order" resulting_state="NOCHANGE"/>
        <action name="close_order" resulting_state="Closed"/>
    </state>

    <state name="Closed">
        <action name="invoice_order" resulting_state="Invoiced"/>
    </state>

    <state name="Invoiced">
        <action name="archive_order" resulting_state="Archived"/>
    </state>

    <state name="Archived">
    </state>

</workflow>
'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>salesorder_simple</type>
    <description>Create a simple salesorder</description>
    <persister>SalesordersPersister</persister>

    <state name="INITIAL">
        <description>This is the state the workflow enters when
            instantiated. Its like a "state zero" but since we are
            using names rather than IDs we cannot assume
        </description>
        <action name="create_order" resulting_state="Order Created"/>
    </state>

    <state name="Order Created">
        <action name="additem_to_order" resulting_state="NOCHANGE"/>
        <action name="close_order" resulting_state="Closed"/>
    </state>

    <state name="Closed">
        <action name="invoice_order" resulting_state="Invoiced"/>
    </state>

    <state name="Invoiced">
        <action name="archive_order" resulting_state="Archived"/>
    </state>

    <state name="Archived">
    </state>

</workflow>
' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'salesorder_simple'),
           'validator', '<validators>
    <validator name="check_more_than_zero" class="Engine::Workflow::Validator::SalesordersFkey">
        <param name="max_size" value="20M" />
    </validator>
</validators>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<validators>
    <validator name="check_more_than_zero" class="Engine::Workflow::Validator::SalesordersFkey">
        <param name="max_size" value="20M" />
    </validator>
</validators>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'salesorder_simple'),
           'precheck', '<precheck>
     <actions>
        <groups condition="create_order" >
        <action name="customersfkey" class="Salesorder::PreCheck::Order" method="find_customers_fkey" order= "1">
                <field name="customer_addresses_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="openso" class="Salesorder::PreCheck::Order" method="find_open_salesorder" order= "2">
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="workflowid" class="Salesorder::PreCheck::Order" method="find_wf_id" order= "3">
                <field name="salesorders_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="invoicedays" class="Salesorder::PreCheck::Order" method="find_invoicedays_fkey" order= "4">
                <field name="invoicedays_fkey" class="Engine::Precheck::Keyvalidator" required="false" method="check_key"/>
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "5">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycustomer" class="Engine::Precheck::History::Data" method="load_customer" order= "6">
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "6">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
       <groups condition="additem_to_order">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "5">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "6">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
           <action name="prepareitems" class="Salesorder::PreCheck::Item" method="precheck" order= "7">
            </action>
        <action name="workflowid" class="Salesorder::PreCheck::Order" method="find_wf_id" order= "3">
                <field name="salesorders_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
       <groups condition="close_order">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="getwfid" class="Salesorder::PreCheck::WfFromSo" method="load_workflow_id" order= "5">
                <field name="salesorders_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
     <actions>
        <groups condition="create_order" >
        <action name="customersfkey" class="Salesorder::PreCheck::Order" method="find_customers_fkey" order= "1">
                <field name="customer_addresses_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="openso" class="Salesorder::PreCheck::Order" method="find_open_salesorder" order= "2">
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="workflowid" class="Salesorder::PreCheck::Order" method="find_wf_id" order= "3">
                <field name="salesorders_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="invoicedays" class="Salesorder::PreCheck::Order" method="find_invoicedays_fkey" order= "4">
                <field name="invoicedays_fkey" class="Engine::Precheck::Keyvalidator" required="false" method="check_key"/>
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "5">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycustomer" class="Engine::Precheck::History::Data" method="load_customer" order= "6">
                <field name="customers_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "6">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
       <groups condition="additem_to_order">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "5">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "6">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
           <action name="prepareitems" class="Salesorder::PreCheck::Item" method="precheck" order= "7">
            </action>
        <action name="workflowid" class="Salesorder::PreCheck::Order" method="find_wf_id" order= "3">
                <field name="salesorders_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
       <groups condition="close_order">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="getwfid" class="Salesorder::PreCheck::WfFromSo" method="load_workflow_id" order= "5">
                <field name="salesorders_pkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
       </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'salesorder_simple'),
           'action', '<actions>
       <type>salesorder_simple</type>
       <action name="create_order" class="Salesorder::Workflow::Action::Create">
           <field name="customers_fkey"
                  description="Foreign key to customer" is_required="yes" >
           </field>
       </action>
       <action name="additem_to_order" class="Salesorder::Workflow::Action::Item">
                  <field name="customer_addresses_fkey"
                           description="Foreign key to customer delivery address" is_required="yes" >
                  </field>
                  <field name="users_fkey"
                           description="Foreign key to user" is_required="yes" >
                  </field>
                 <field name="companies_fkey"
                            description="Foreign key to company" is_required="yes" >
                 </field>
                 <field name="salesorders_fkey"
                            description="Foreign key to salesorder" is_required="yes" >
                 </field>
                 <field name="quantity"
                            description="Sold quantity" is_required="yes" >
                 </field>
                 <field name="price"
                            description="Price of item" is_required="no" >
                 </field>
                 <field name="stockitems_fkey"
                            description="Foreign key to stockitems" is_required="yes" >
                 </field>
       </action>
       <action name="close_order" class="Salesorder::Workflow::Action::Close">
                  <field name="salesorders_pkey"
                           description="Key to salesorder to be closed" is_required="yes" >
                  </field>
                  <field name="users_fkey"
                           description="Foreign key to user" is_required="yes" >
                  </field>
                 <field name="companies_fkey"
                            description="Foreign key to company" is_required="yes" >
                 </field>
       </action>
       <action name="invoice_order" class="Engine::Workflow::Action::Transit">
                <field name="activity"
                           description="activity" is_required="yes" >
                </field>
                <field name="payload"
                           description="Transit payload" is_required="yes" >
                </field>
                <field name="companies_pkey"
                           description="Company key" is_required="yes" >
                </field>
                <field name="users_pkey"
                           description="Key to user" is_required="yes" >
                </field>
       </action>
       <action name="archive_order" class="Salesorder::Workflow::Action::Archive"/>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
       <type>salesorder_simple</type>
       <action name="create_order" class="Salesorder::Workflow::Action::Create">
           <field name="customers_fkey"
                  description="Foreign key to customer" is_required="yes" >
           </field>
       </action>
       <action name="additem_to_order" class="Salesorder::Workflow::Action::Item">
                  <field name="customer_addresses_fkey"
                           description="Foreign key to customer delivery address" is_required="yes" >
                  </field>
                  <field name="users_fkey"
                           description="Foreign key to user" is_required="yes" >
                  </field>
                 <field name="companies_fkey"
                            description="Foreign key to company" is_required="yes" >
                 </field>
                 <field name="salesorders_fkey"
                            description="Foreign key to salesorder" is_required="yes" >
                 </field>
                 <field name="quantity"
                            description="Sold quantity" is_required="yes" >
                 </field>
                 <field name="price"
                            description="Price of item" is_required="no" >
                 </field>
                 <field name="stockitems_fkey"
                            description="Foreign key to stockitems" is_required="yes" >
                 </field>
       </action>
       <action name="close_order" class="Salesorder::Workflow::Action::Close">
                  <field name="salesorders_pkey"
                           description="Key to salesorder to be closed" is_required="yes" >
                  </field>
                  <field name="users_fkey"
                           description="Foreign key to user" is_required="yes" >
                  </field>
                 <field name="companies_fkey"
                            description="Foreign key to company" is_required="yes" >
                 </field>
       </action>
       <action name="invoice_order" class="Engine::Workflow::Action::Transit">
                <field name="activity"
                           description="activity" is_required="yes" >
                </field>
                <field name="payload"
                           description="Transit payload" is_required="yes" >
                </field>
                <field name="companies_pkey"
                           description="Company key" is_required="yes" >
                </field>
                <field name="users_pkey"
                           description="Key to user" is_required="yes" >
                </field>
       </action>
       <action name="archive_order" class="Salesorder::Workflow::Action::Archive"/>
</actions>' ;

INSERT INTO workflows (workflow) VALUES ('customer_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'customer_simple'),
           'precheck', '<precheck>
    <actions>
     <groups condition="create_customer">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_customer">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_invoiceaddress">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_deliveryaddress">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="delete_discountgeneral">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_discountgeneral">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_productgroupdiscount">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_stockitemdiscount">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
    <actions>
     <groups condition="create_customer">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_customer">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_invoiceaddress">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_deliveryaddress">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="delete_discountgeneral">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_discountgeneral">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_productgroupdiscount">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="save_stockitemdiscount">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'customer_simple'),
           'action', '<actions>
<type>customer_simple</type>
<action name="create_customer" class="Customers::Workflow::Action::Create"/>
<action name="update_customer" class="Customers::Workflow::Action::Update"/>
<action name="update_invoiceaddress" class="Customers::Workflow::Action::Invoiceaddress"/>
<action name="update_deliveryaddress" class="Customers::Workflow::Action::Deliveryaddress"/>
<action name="inactivate_customer" class="Customers::Workflow::Action::Inactivate"/>
<action name="block_customer" class="Customers::Workflow::Action::Block"/>
<action name="activate_customer" class="Customers::Workflow::Action::Activate"/>
<action name="delete_discountgeneral" class="Customers::Workflow::Action::DeleteDiscountGenereral"/>
<action name="save_discountgeneral" class="Customers::Workflow::Action::SaveDiscountGenereral"/>
<action name="save_productgroupdiscount" class="Customers::Workflow::Action::SaveDiscountProductgroup"/>
<action name="save_stockitemdiscount" class="Customers::Workflow::Action::SaveDiscountStockitem"/>
</actions>

'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
<type>customer_simple</type>
<action name="create_customer" class="Customers::Workflow::Action::Create"/>
<action name="update_customer" class="Customers::Workflow::Action::Update"/>
<action name="update_invoiceaddress" class="Customers::Workflow::Action::Invoiceaddress"/>
<action name="update_deliveryaddress" class="Customers::Workflow::Action::Deliveryaddress"/>
<action name="inactivate_customer" class="Customers::Workflow::Action::Inactivate"/>
<action name="block_customer" class="Customers::Workflow::Action::Block"/>
<action name="activate_customer" class="Customers::Workflow::Action::Activate"/>
<action name="delete_discountgeneral" class="Customers::Workflow::Action::DeleteDiscountGenereral"/>
<action name="save_discountgeneral" class="Customers::Workflow::Action::SaveDiscountGenereral"/>
<action name="save_productgroupdiscount" class="Customers::Workflow::Action::SaveDiscountProductgroup"/>
<action name="save_stockitemdiscount" class="Customers::Workflow::Action::SaveDiscountStockitem"/>
</actions>

' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'customer_simple'),
           'persister', '<persisters>
        <persister name="CustomerPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_customer"
                 extra_data_field="customers_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
        <persister name="CustomerPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_customer"
                 extra_data_field="customers_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'customer_simple'),
           'workflow', '<workflow>
    <type>customer_simple</type>
    <description>Customer</description>
    <persister>CustomerPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_customer" resulting_state="Customer active" />
    </state>
     <state name="Customer active">
        <description>Customer is active and can be used</description>
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="inactivate_customer" resulting_state="Customer inactive" />
        <action name="block_customer" resulting_state="Customer blocked" />
    </state>
    <state name="Customer blocked">
        <action name="unblock_customer" resulting_state="Customer active"  />
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
    </state>
     <state name="Customer inactive">
        <action name="activate_customer" resulting_state="Customer active"  />
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>customer_simple</type>
    <description>Customer</description>
    <persister>CustomerPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_customer" resulting_state="Customer active" />
    </state>
     <state name="Customer active">
        <description>Customer is active and can be used</description>
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="inactivate_customer" resulting_state="Customer inactive" />
        <action name="block_customer" resulting_state="Customer blocked" />
    </state>
    <state name="Customer blocked">
        <action name="unblock_customer" resulting_state="Customer active"  />
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
    </state>
     <state name="Customer inactive">
        <action name="activate_customer" resulting_state="Customer active"  />
        <action name="update_customer" resulting_state="NOCHANGE" />
        <action name="update_invoiceaddress" resulting_state="NOCHANGE" />
        <action name="update_deliveryaddress" resulting_state="NOCHANGE" />
        <action name="delete_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_discountgeneral" resulting_state="NOCHANGE" />
        <action name="save_productgroupdiscount" resulting_state="NOCHANGE" />
        <action name="save_stockitemdiscount" resulting_state="NOCHANGE" />
    </state>
</workflow>' ;

INSERT INTO workflows (workflow) VALUES ('stockitem_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'stockitem_simple'),
           'workflow', '<workflow>
    <type>stockitem_simple</type>
    <description>Stockitem</description>
    <persister>StockitemPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_stockitem" resulting_state="Stockitem active" />
    </state>
    <state name="Stockitem inactive">
        <action name="update_stockitem" resulting_state="NOCHANGE" />        
    </state>
    <state name="Stockitem active">
        <action name="update_stockitem" resulting_state="NOCHANGE" />        
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>stockitem_simple</type>
    <description>Stockitem</description>
    <persister>StockitemPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_stockitem" resulting_state="Stockitem active" />
    </state>
    <state name="Stockitem inactive">
        <action name="update_stockitem" resulting_state="NOCHANGE" />        
    </state>
    <state name="Stockitem active">
        <action name="update_stockitem" resulting_state="NOCHANGE" />        
    </state>
</workflow>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'stockitem_simple'),
           'precheck', '<precheck>
    <actions>
     <groups condition="create_stockitem">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_stockitem">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>

'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
    <actions>
     <groups condition="create_stockitem">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_stockitem">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>

' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'stockitem_simple'),
           'persister', '<persisters>
        <persister name="StockitemPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_stockitem"
                 extra_data_field="stockitems_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
        <persister name="StockitemPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_stockitem"
                 extra_data_field="stockitems_fkey, closed, users_fkey, companies_fkey"
          />
</persisters>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'stockitem_simple'),
           'action', '<actions>
      <type>stockitem_simple</type>
      <action name="create_stockitem" class="Stockitems::Workflow::Action::Create"/>
      <action name="update_stockitem" class="Stockitems::Workflow::Action::Update"/>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
      <type>stockitem_simple</type>
      <action name="create_stockitem" class="Stockitems::Workflow::Action::Create"/>
      <action name="update_stockitem" class="Stockitems::Workflow::Action::Update"/>
</actions>' ;

INSERT INTO workflows (workflow) VALUES ('pricelist_simple')
ON CONFLICT (workflow)
    DO UPDATE SET moddatetime = now();

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'pricelist_simple'),
           'precheck', '<precheck>
    <actions>
     <groups condition="create_pricelist">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_pricelist">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<precheck>
    <actions>
     <groups condition="create_pricelist">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
    <groups condition="update_pricelist">
        <action name="historyuser" class="Engine::Precheck::History::Data" method="load_user" order= "2">
                <field name="users_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
        <action name="historycompany" class="Engine::Precheck::History::Data" method="load_company" order= "4">
                <field name="companies_fkey" class="Engine::Precheck::Keyvalidator" required="true" method="check_key"/>
        </action>
    </groups>
     </actions>
</precheck>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'pricelist_simple'),
           'workflow', '<workflow>
    <type>pricelist_simple</type>
    <description>Pricelist</description>
    <persister>PricelistPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_pricelist" resulting_state="Pricelist active" />
    </state>
    <state name="Pricelist active">
        <action name="update_pricelist" resulting_state="NOCHANGE" />        
    </state>
</workflow>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<workflow>
    <type>pricelist_simple</type>
    <description>Pricelist</description>
    <persister>PricelistPersister</persister>
    <state name="INITIAL">
        <description> </description>
        <action name="create_pricelist" resulting_state="Pricelist active" />
    </state>
    <state name="Pricelist active">
        <action name="update_pricelist" resulting_state="NOCHANGE" />        
    </state>
</workflow>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'pricelist_simple'),
           'persister', '<persisters>
        <persister name="PricelistPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_pricelist"
                 extra_data_field="pricelists_fkey, users_fkey, companies_fkey"
          />
</persisters>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<persisters>
        <persister name="PricelistPersister"
                 class="Engine::Workflow::Persister::DBI::Mojo"
                 dsn="DBI:Pg:dbname=Venditabant;host=192.168.1.108;port=5432;user=postgres; password=PV58nova64"
                 autocommit="1"
                 date_format="%Y-%m-%d %H:%M"
                 extra_table="workflow_pricelist"
                 extra_data_field="pricelists_fkey, users_fkey, companies_fkey"
          />
</persisters>' ;

INSERT INTO workflow_items (workflows_fkey, workflow_type, workflow)
VALUES (
           (SELECT workflows_pkey FROM workflows WHERE workflow = 'pricelist_simple'),
           'action', '<actions>
      <type>pricelist_simple</type>
      <action name="create_pricelist" class="Pricelists::Workflow::Action::Create"/>
      <action name="update_pricelist" class="Pricelists::Workflow::Action::Update"/>
</actions>'
       )
ON CONFLICT( workflows_fkey, workflow_type)
    DO UPDATE SET moddatetime = now(), workflow = '<actions>
      <type>pricelist_simple</type>
      <action name="create_pricelist" class="Pricelists::Workflow::Action::Create"/>
      <action name="update_pricelist" class="Pricelists::Workflow::Action::Update"/>
</actions>' ;
    