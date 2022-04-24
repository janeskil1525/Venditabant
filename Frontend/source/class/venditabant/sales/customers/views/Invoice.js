qx.Class.define ( "venditabant.sales.customers.views.Invoice",
    {
        extend: venditabant.application.base.views.Base,
        include: [qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"},
            autotodo:{nullable:true, check:"Boolean"},
        },
        members: {
            // Public functions ...
            _customers_fkey:0,
            _customer_addresses_fkey:0,
            _customer_name:'',
            getView: function () {
                var page2 = new qx.ui.tabview.Page(this.tr("Invoice"));
                page2.setLayout(new qx.ui.layout.Canvas());
                // page2.setToolTipText(this.tr("Selected companys invoice address"));
                let lbl = this._createLbl(this.tr( "Address" ), 70);
                page2.add ( lbl, { top: 10, left: 10 } );

                let address1 = this._createTxt("Street", 250, false, '',
                    this.tr("Street and number if applicable")
                );
                page2.add ( address1, { top: 10, left: 120 } );
                this._address1 = address1;

                let address2 = this._createTxt("Address", 250, false, '');
                page2.add ( address2, { top: 45, left: 120 } );
                this._address2 = address2;

                let address3 = this._createTxt("Address", 250, false, '');
                page2.add ( address3, { top: 80, left: 120 } );
                this._address3 = address3

                lbl = this._createLbl(this.tr( "Zipcode / City" ), 100);
                page2.add ( lbl, { top: 115, left: 10 } );

                let zipcode = this._createTxt("Zipcode", 100, false, '', this.tr("Zipcode"));
                page2.add ( zipcode, { top: 115, left: 120 } );
                this._zipcode = zipcode

                let city = this._createTxt("City", 145, false, '', this.tr("City"));
                page2.add ( city, { top: 115, left: 225 } );
                this._city = city

                lbl = this._createLbl(this.tr( "Country" ), 70);
                page2.add ( lbl, { top: 150, left: 10 } );

                let country = this._createTxt("Country", 250, false, '', this.tr("Country"));
                page2.add ( country, { top: 150, left: 120 } );
                this._country = country;

                lbl = this._createLbl(this.tr( "Mail addressses" ), 120);
                page2.add ( lbl, { top: 10, left: 380 } );

                let inviceemails = this._createTxt(this.tr("Comma separated mail adresses"), 420, false, '',
                    this.tr("Comma separated mail adresses that should recieve invoices")
                );
                page2.add ( inviceemails, { top: 10, left: 510 } );
                this._inviceemails = inviceemails;

                lbl = this._createLbl(this.tr( "Invoice time" ), 120);
                lbl.setToolTipText(this.tr("Time to invoices should be paid"));
                page2.add ( lbl, { top: 50, left: 380 } );

                let invoicetime = new venditabant.settings.views.SettingsSelectBox().set({
                    width:150,
                    parameter:'INVOICEDAYS',
                    emptyrow:true,
                    tooltip:this.tr("Time to invoices should be paid"),
                });
                let invoicetimeview = invoicetime.getView()
                this._invoicetime = invoicetime;
                page2.add ( invoicetimeview, { top: 45, left: 510 } );

                lbl = this._createLbl(this.tr( "Invoice reference" ), 120);
                page2.add ( lbl, { top: 80, left: 380 } );

                let invoicereference = this._createTxt(this.tr("Invoice reference"), 420, false, '',
                    this.tr("Invoice reference")
                );
                this._invoicereference = invoicereference;
                page2.add(invoicereference, { top: 80, left: 510 })

                lbl = this._createLbl(this.tr( "Comment" ), 120);
                page2.add ( lbl, { top: 115, left: 380 } );

                let comment = this._createTextArea(this.tr("Comment"), 420);
                comment.setToolTipText(this.tr("Comment for invoice customer for example PO number"));
                comment.setHeight(65);
                this._comment = comment;

                page2.add ( comment, { top: 115, left: 510 } );

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveInvoiceData ( );
                }, this,this.tr("Save invoice address") );
                page2.add ( btnSignup, { bottom: 10, left: 10 } );
                if(!this.isAutotodo()) {
                    let btnNew = this._createBtn ( this.tr ( "Clear" ), "#FFAAAA70", 135, function ( ) {
                        this.clearScreen ( );
                    }, this, this.tr("Clear screen") );
                    page2.add ( btnNew, { bottom: 10, right: 10 } );
                } else {
                    let btnNew = this._createBtn ( this.tr ( "Back" ), "#FFAAAA70", 135, function ( ) {
                        this.backToCockpit ( );
                    }, this, this.tr("Back to the Cockpit") );
                    page2.add ( btnNew, { bottom: 10, right: 10 } );
                }

                return page2;
            },
            backToCockpit:function() {
                let root  = qx.core.Init.getApplication ( ).getRoot();
                let view = new venditabant.cockpit.views.AutoTodo();

                root._basewin.addView(root, view);
                //this.destroy();
            },
            saveInvoiceData:function() {
                let that = this;
                let address1 = this._address1.getValue();
                let address2 = this._address2.getValue();
                let address3 = this._address3.getValue();
                let zipcode = this._zipcode.getValue();
                let city = this._city.getValue();
                let country = this._country.getValue();
                let inviceemails = this._inviceemails.getValue();
                let invoicedays_fkey = this._invoicetime.getKey();
                let comment = this._comment.getValue();
                let invoicereference = this._invoicereference.getValue();

                let data = {
                    name:this.getCustomerName(),
                    address1: address1,
                    address2: address2,
                    address3: address3,
                    city: city,
                    zipcode:zipcode,
                    country: country,
                    mailadresses:inviceemails,
                    invoicedays_fkey:invoicedays_fkey,
                    customers_fkey:this.getCustomersFkey(),
                    type:'INVOICE',
                    customer_addresses_pkey: this.getCustomerAddressFkey(),
                    comment:comment,
                    reference:invoicereference,
                }
                let put = new venditabant.sales.customers.models.InvoiceAddress();
                put.saveInvoiceAddress(data,function(success) {
                    if(success !== 'success'){
                        alert(this.tr('Something went wrong saving the invoice address'));
                    } else {
                        that.loadInvoiceData();
                    }
                }, this)
            },
            loadInvoiceData:function() {
                let get = new venditabant.sales.customers.models.InvoiceAddress();
                get.load_invoice_address(function(response) {
                    if(response.data !== null) {
                        this._address1.setValue(response.data.address1);
                        this._address2.setValue(response.data.address2);
                        this._address3.setValue(response.data.address3);
                        this._zipcode.setValue(response.data.zipcode);
                        this._city.setValue(response.data.city);
                        this._country.setValue(response.data.country);
                        this._inviceemails.setValue(response.data.mailadresses);
                        this._invoicetime.setKey(response.data.invoicedays_fkey);
                        this.setCustomerAddressFkey(response.data.customer_addresses_pkey);
                        this._comment.setValue(response.data.comment);
                    } else {
                       this.clearScreen();
                    }

                },this,this.getCustomersFkey());

            },
            clearScreen:function(){
                this._address1.setValue('');
                this._address2.setValue('');
                this._address3.setValue('');
                this._zipcode.setValue('');
                this._city.setValue('');
                this._country.setValue('');
                this._inviceemails.setValue('');
                this._invoicetime.setKey(0);
                this.setCustomerAddressFkey(0);
                this._comment.setValue('')
            },
            setCustomersFkey:function(customers_fkey) {
                this._customers_fkey = customers_fkey;
                this.loadInvoiceData();
            },
            setCustomersFkeyExt:function(customers_fkey) {
                this._customers_fkey = customers_fkey;
            },
            getCustomersFkey:function() {
                return this._customers_fkey;
            },
            setCustomerAddressFkey(customer_addresses_fkey) {
                this._customer_addresses_fkey = customer_addresses_fkey;
            },
            getCustomerAddressFkey() {
                return this._customer_addresses_fkey;
            },
            setCustomerName:function(customer_name) {
                this._customer_name = customer_name;
            },
            getCustomerName:function() {
                return this._customer_name;
            }
        }
    });