
qx.Class.define ( "venditabant.company.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean" }
        },
        members: {
            // Public functions ...
            __table : null,
            setParams: function (params) {
            },
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "100%"});
                let page1 = this.getDefinition();
                tabView.add(page1);


                return view;
            },
            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Company"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "Company" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let company = this._createTxt("Company", 150, true, this.tr("Customer is required"));
                page1.add ( company, { top: 10, left: 90 } );
                this._company = company;

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:150,
                    emptyrow:false,
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { top: 45, left: 90 } );

                lbl = this._createLbl(this.tr( "Name" ), 70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let name = this._createTxt("Name", 250, false);
                page1.add ( name, { top: 10, left: 400 } );
                this._name = name

                lbl = this._createLbl(this.tr( "Org. nr" ), 70);
                page1.add ( lbl, { top: 45, left: 250 } );

                let orgnbr = this._createTxt("Org. nr", 250, false);
                page1.add ( orgnbr, { top: 45, left: 400 } );
                this._registrationnumber = orgnbr

                lbl = this._createLbl(this.tr( "Phone" ), 70);
                page1.add ( lbl, { top: 80, left: 10 } );

                let phone = this._createTxt("Phone", 150, true, this.tr("Phone is required"));
                page1.add ( phone, { top: 80, left: 90 } );
                this._phone = phone;

                lbl = this._createLbl(this.tr( "Homepage" ), 70);
                page1.add ( lbl, { top: 80, left: 250 } );

                let homepage = this._createTxt("Homepage", 250, false);
                page1.add ( homepage, { top: 80, left: 400 } );
                this._homepage = homepage

                lbl = this._createLbl(this.tr( "VAT No" ), 70);
                page1.add ( lbl, { top: 115, left: 10 } );

                let vatno = this._createTxt("VAT No", 150, true, this.tr("Phone is required"));
                page1.add ( vatno, { top: 115, left: 90 } );
                this._vatno= vatno;

                lbl = this._createLbl(this.tr( "Address" ), 70);
                page1.add ( lbl, { top: 115, left: 250 } );

                let address1 = this._createTxt("Address", 250, false);
                page1.add ( address1, { top: 115, left: 400 } );
                this._address1 = address1

                lbl = this._createLbl(this.tr( "Giro" ), 70);
                page1.add ( lbl, { top: 145, left: 10 } );

                let giro = this._createTxt("Giro", 150, true, this.tr("Phone is required"));
                page1.add ( giro, { top: 145, left: 90 } );
                this._giro = giro;

                let address2 = this._createTxt("Address", 250, false);
                page1.add ( address2, { top: 145, left: 400 } );
                this._address2 = address2

                lbl = this._createLbl(this.tr( "Invoice ref." ), 70);
                page1.add ( lbl, { top: 175, left: 10 } );

                let invoiceref = this._createTxt("Invoice ref.", 150, true, this.tr("Phone is required"));
                page1.add ( invoiceref, { top: 175, left: 90 } );
                this._invoiceref = invoiceref;

                let address3 = this._createTxt("Address", 250, false);
                page1.add ( address3, { top: 175, left: 400 } );
                this._address3 = address3

                lbl = this._createLbl(this.tr( "Email" ), 70);
                page1.add ( lbl, { top: 210, left: 10 } );

                let email = this._createTxt("Email", 150, true, this.tr("Email is required"));
                page1.add ( email, { top: 210, left: 90 } );
                this._email = email;

                lbl = this._createLbl(this.tr( "Zipcode / City" ), 150);
                page1.add ( lbl, { top: 210, left: 250 } );

                let zipcode = this._createTxt("Zipcode", 90, false);
                page1.add ( zipcode, { top: 210, left: 400 } );
                this._zipcode = zipcode

                let city = this._createTxt("City", 150, false);
                page1.add ( city, { top: 210, left: 500 } );
                this._city = city

                lbl = this._createLbl(this.tr( "Invoice comment" ), 90);
                page1.add ( lbl, { top: 240, left: 10 } );

                let invoicecomment = this._createTextArea("Invoice comment", 560, 70, '');
                page1.add ( invoicecomment, { top: 240, left: 90 } );
                this._invoicecomment = invoicecomment;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveCompany ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen();
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );

                this.loadCompany();

                return page1;
            },
            saveCompany:function() {
                let that = this;
                let company = this._company.getValue();
                let name  = this._name.getValue();
                let registrationnumber = this._registrationnumber.getValue();
                let homepage = this._homepage.getValue();
                let phone = this._phone.getValue();
                let languages_fkey = this._languages.getKey();
                let address1 = this._address1.getValue() ? this._address1.getValue() : ' ';
                let address2 = this._address2.getValue() ? this._address2.getValue() : ' ';
                let address3 = this._address3.getValue() ? this._address3.getValue() : ' ';
                let zipcode = this._zipcode.getValue() ? this._zipcode.getValue() : ' ';
                let city = this._city.getValue() ? this._city.getValue() : ' ';
                let giro = this._giro.getValue() ? this._giro.getValue() : ' ';
                let email = this._email.getValue() ? this._email.getValue() : ' ';
                let vatno = this._vatno.getValue() ? this._vatno.getValue() : ' ';
                let invoicecomment = this._invoicecomment.getValue() ? this._invoicecomment.getValue() : ' ';
                let invoiceref = this._invoiceref.getValue() ? this._invoiceref.getValue() : ' ';

                let data = {
                    company: company,
                    name: name,
                    registrationnumber: registrationnumber,
                    homepage: homepage,
                    phone: phone,
                    languages_fkey:languages_fkey,
                    address1:address1,
                    address2:address2,
                    address3:address3,
                    zipcode:zipcode,
                    city:city,
                    giro:giro,
                    invoiceref:invoiceref,
                    email:email,
                    tin:vatno,
                    invoicecomment:invoicecomment,
                }
                let model = new venditabant.company.models.Company();
                model.saveCompany(data,function ( success ) {
                    if (success) {

                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);
            },
            loadCompany:function () {
                let that = this;
                let company = new venditabant.company.models.Company();
                company.loadCompany(function(response) {
                    that._company.setValue(response.data.company);
                    that._name.setValue(response.data.name);
                    that._registrationnumber.setValue(response.data.registrationnumber);
                    that._homepage.setValue(response.data.homepage);
                    that._phone.setValue(response.data.phone);
                    that._languages.setKey(response.data.languages_fkey);
                    that._address1.setValue(response.data.address1) ;
                    that._address2.setValue(response.data.address2) ;
                    that._address3.setValue(response.data.address3);
                    that._zipcode.setValue(response.data.zipcode) ;
                    that._city.setValue(response.data.city) ;
                    that._giro.setValue(response.data.giro);
                    that._email.setValue(response.data.email) ;
                    that._vatno.setValue(response.data.tin) ;
                    that._invoicecomment.setValue(response.data.invoicecomment);
                    that._invoiceref.setValue(response.data.invoiceref) ;
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            }
        }
    });
