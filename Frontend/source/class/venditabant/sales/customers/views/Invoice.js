qx.Class.define ( "venditabant.sales.customers.views.Invoice",
    {
        extend: venditabant.application.base.views.Base,
        include: [qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"}
        },
        members: {
            // Public functions ...
            _customers_fkey:0,
            _customer_addresses_fkey:0,
            _customer_name:'',
            getView: function () {
                var page2 = new qx.ui.tabview.Page(this.tr("Invoice"));
                page2.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Address" ), 70);
                page2.add ( lbl, { top: 10, left: 10 } );

                let address1 = this._createTxt("Street", 250, false, '');
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

                let zipcode = this._createTxt("Zipcode", 100, false, '');
                page2.add ( zipcode, { top: 115, left: 120 } );
                this._zipcode = zipcode

                let city = this._createTxt("City", 145, false, '');
                page2.add ( city, { top: 115, left: 225 } );
                this._city = city

                lbl = this._createLbl(this.tr( "Country" ), 70);
                page2.add ( lbl, { top: 150, left: 10 } );

                let country = this._createTxt("Country", 250, false, '');
                page2.add ( country, { top: 150, left: 120 } );
                this._country = country;

                lbl = this._createLbl(this.tr( "Mail addressses" ), 120);
                page2.add ( lbl, { top: 10, left: 380 } );

                let inviceemails = this._createTxt(this.tr("Comma separated mail adresses"), 420, false, '');
                page2.add ( inviceemails, { top: 10, left: 510 } );
                this._inviceemails = inviceemails;

                lbl = this._createLbl(this.tr( "Invoice time" ), 120);
                page2.add ( lbl, { top: 50, left: 380 } );

                let invoicetime = new venditabant.settings.views.SettingsSelectBox().set({
                    width:150,
                    parameter:'INVOICEDAYS',
                    emptyrow:true,
                });
                let invoicetimeview = invoicetime.getView()
                this._invoicetime = invoicetime;
                page2.add ( invoicetimeview, { top: 50, left: 510 } );


                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveInvoiceData ( );
                }, this );
                page2.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page2.add ( btnCancel, { bottom: 10, right: 10 } );

                return page2;
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
                }
                let put = new venditabant.sales.customers.models.InvoiceAddress();
                put.saveInvoiceAddress(data,function(success) {
                    if(success.status !== 'success'){
                        alert(this.tr('Something went wrong saving the invoice address'));
                    } else {
                        that.setCustomerAddressFkey(success.data);
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
            },
            setCustomersFkey:function(customers_fkey) {
                this._customers_fkey = customers_fkey;
                this.loadInvoiceData();
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