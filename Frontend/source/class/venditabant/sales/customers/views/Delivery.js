qx.Class.define ( "venditabant.sales.customers.views.Delivery",
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
                var page2 = new qx.ui.tabview.Page(this.tr("Delivery"));
                page2.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Address" ), 70);
                page2.add ( lbl, { top: 10, left: 10 } );

                lbl = this._createLbl(this.tr( "Name" ), 70);
                page2.add ( lbl, { top: 45, left: 10 } );

                let name = this._createTxt("Name", 250, false, '',
                    this.tr("Name for delivery address")
                );
                page2.add ( name, { top: 45, left: 120 } );
                this._name = name;

                let address1 = this._createTxt("Address", 250, false, '',
                    this.tr("Delivery address")
                );
                page2.add ( address1, { top: 80, left: 120 } );
                this._address1 = address1;

                let address2 = this._createTxt("Address", 250, false, '',
                    this.tr("Delivery address")
                );
                page2.add ( address2, { top: 115, left: 120 } );
                this._address2 = address2;

                let address3 = this._createTxt("Address", 250, false, '',
                    this.tr("Delivery address")
                );
                page2.add ( address3, { top: 150, left: 120 } );
                this._address3 = address3

                lbl = this._createLbl(this.tr( "Comment" ), 120);
                page2.add ( lbl, { top: 45, left: 380 } );

                let comment = this._createTextArea(this.tr("Comment"), 420, 60);
                comment.setToolTipText(this.tr("Remark for delivery address"))
                this._comment = comment;

                page2.add ( comment, { top: 45, left: 510 } );

                lbl = this._createLbl(this.tr( "Zipcode / City" ), 100);
                page2.add ( lbl, { top: 115, left: 380 } );

                let zipcode = this._createTxt("Zipcode", 100, false, '',
                    this.tr("Zipcode part of delivery address")
                );
                page2.add ( zipcode, { top: 115, left: 510 } );
                this._zipcode = zipcode

                let city = this._createTxt("City", 145, false, '',
                    this.tr("City part of delivery address")
                );
                page2.add ( city, { top: 115, left: 615 } );
                this._city = city

                lbl = this._createLbl(this.tr( "Country" ), 70);
                page2.add ( lbl, { top: 150, left: 380 } );

                let country = this._createTxt("Country", 250, false, '',
                    this.tr("Country")
                );
                page2.add ( country, { top: 150, left: 510 } );
                this._country = country;

                lbl = this._createLbl(this.tr( "Mail addressses" ), 120);
                page2.add ( lbl, { top: 10, left: 380 } );

                let deliverymails = this._createTxt(this.tr("Comma separated mail adresses"), 420, false, '',
                    this.tr("Comma separated mail adresses that should recieve delivery related information")
                );
                page2.add ( deliverymails, { top: 10, left: 510 } );
                this._deliverymails = deliverymails;

                if(!this.isAutotodo()) {
                    let deliveryaddress = new venditabant.sales.customers.views.DeliveryAddressSelectBox().set({
                        width:250,
                        emptyrow:true,
                        delivery:this,
                        tooltip:this.tr("Select delivery address to edit")
                    });
                    let deliveryaddressview = deliveryaddress.getView()
                    this._deliveryaddress = deliveryaddress;
                    page2.add ( deliveryaddressview, { top: 10, left: 120 } );
                }

                let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveDeliveryData ( );
                }, this, this.tr("Save delivery address") );
                page2.add ( btnSave, { bottom: 10, left: 10 } );

                if(!this.isAutotodo()) {
                    let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 135, function ( ) {
                        this.clearScreen ( );
                    }, this, this.tr("New delivery address") );
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
            saveDeliveryData:function() {
                let that = this;
                let name = this._name.getValue();
                let address1 = this._address1.getValue();
                let address2 = this._address2.getValue();
                let address3 = this._address3.getValue();
                let zipcode = this._zipcode.getValue();
                let city = this._city.getValue();
                let country = this._country.getValue();
                let deliverymails = this._deliverymails.getValue();
                let comment = this._comment.getValue();

                let data = {
                    name: name,
                    address1: address1,
                    address2: address2,
                    address3: address3,
                    city: city,
                    zipcode: zipcode,
                    country: country,
                    mailadresses: deliverymails,
                    invoicedays_fkey: 0,
                    customers_fkey: this.getCustomersFkey(),
                    type:'DELIVERY',
                    customer_addresses_pkey: this.getCustomerAddressFkey(),
                    comment:comment,
                    reference:'',
                }
                let put = new venditabant.sales.customers.models.DeliveryAddress();
                put.saveDeliveryAddress(data,function(success) {
                    if(success !== 'success'){
                        alert(this.tr('Something went wrong saving the invoice address'));
                    } else {
                        that._deliveryaddress.setCustomersFkey(this.getCustomersFkey()) ;
                        let get = new venditabant.sales.customers.models.DeliveryAddress();
                        get.loadDeliveryAddressFromName(function(response) {
                            if(response.data !== null) {
                                that.setCustomerAddressFkey(response.data.customer_addresses_pkey);
                                that.loadDeliveryData();
                            }
                        },this, that.getCustomersFkey(), name);
                    }
                }, this)
            },
            loadDeliveryData:function() {
                let get = new venditabant.sales.customers.models.DeliveryAddress();
                get.loadDeliveryAddress(function(response) {
                    if(response.data !== null) {
                        this._name.setValue(response.data.name);
                        this._address1.setValue(response.data.address1);
                        this._address2.setValue(response.data.address2);
                        this._address3.setValue(response.data.address3);
                        this._zipcode.setValue(response.data.zipcode);
                        this._city.setValue(response.data.city);
                        this._country.setValue(response.data.country);
                        this._deliverymails.setValue(response.data.mailadresses);
                        this.setCustomerAddressFkey(response.data.customer_addresses_pkey);
                        this._deliveryaddress.setKey(response.data.customer_addresses_pkey);
                        this._comment.setValue(response.data.comment);
                    } else {
                        this.clearScreen();
                    }

                },this,this.getCustomerAddressFkey());

            },
            clearScreen:function() {
                this._name.setValue('');
                this._address1.setValue('');
                this._address2.setValue('');
                this._address3.setValue('');
                this._zipcode.setValue('');
                this._city.setValue('');
                this._country.setValue('');
                this._deliverymails.setValue('');
                this.setCustomerAddressFkey(0);
                this._comment.setValue('')
            },
            setCustomersFkeyExt:function(customers_fkey) {
                this._customers_fkey = customers_fkey;
            },
            setCustomersFkey:function(customers_fkey) {
                this.clearScreen();
                this._customers_fkey = customers_fkey;
                this._deliveryaddress.setCustomersFkey(customers_fkey) ;
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
            },
            loadDeliveryAddresses:function() {
                this._deliveryaddress.setSelectedModel(this.getCustomersFkey())
            }
        }
    });