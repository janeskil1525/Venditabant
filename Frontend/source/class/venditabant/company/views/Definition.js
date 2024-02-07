
qx.Class.define ( "venditabant.company.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean" },
            autotodo:{nullable:true, check:"Boolean"},
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

                var validator = new qx.ui.form.validation.Manager();
                this._validator = validator;

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:150,
                    emptyrow:false,
                    tooltip:this.tr('Company language')
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { top: 45, left: 150 } );

                lbl = this._createLbl(this.tr( "Name" ), 70);
                page1.add ( lbl, { top: 10, left: 10 } );

                let name = this._createTxt("Name", 250, true,
                    this.tr("Name is requires"),
                    this.tr('Company official name for invoices and other customer communication')
                    );
                page1.add ( name, { top: 10, left: 150 } );
                this._name = name
                this._validator.add(this._name);

                lbl = this._createLbl(this.tr( "Org. nr" ), 70);
                page1.add ( lbl, { top: 45, left: 400 } );

                let orgnbr = this._createTxt("Org. nr", 250, true,
                    this.tr("Org. nr is required"),
                    this.tr("Organisational Number ATTENTION this is important it's correct since it will be used on invoices")
                );
                page1.add ( orgnbr, { top: 45, left: 550 } );
                this._registrationnumber = orgnbr
                this._validator.add(this._registrationnumber);

                lbl = this._createLbl(this.tr( "Phone" ), 120);
                page1.add ( lbl, { top: 80, left: 10 } );

                let phone = this._createTxt("Phone", 240, true,
                    this.tr("Phone is required"),
                    this.tr("Phone number that should be used on documents for customers")
                );
                page1.add ( phone, { top: 80, left: 150 } );
                this._phone = phone;
                this._validator.add(this._phone);

                lbl = this._createLbl(this.tr( "Homepage" ), 120);
                page1.add ( lbl, { top: 80, left: 400 } );

                let homepage = this._createTxt("Homepage", 150, true,
                    this.tr("Homepage is required"),
                    this.tr("Official homepage to be used on documents for customers")
                );
                page1.add ( homepage, { top: 80, left: 550 } );
                this._homepage = homepage
                this._validator.add(this._homepage);

                lbl = this._createLbl(this.tr( "VAT No" ), 120);
                page1.add ( lbl, { top: 115, left: 10 } );

                let vatno = this._createTxt("VAT No", 240, true,
                    this.tr("VAT No is required"),
                    this.tr("VAT Number ATTENTION this is important it's correct since it will be used on invoices")
                );
                page1.add ( vatno, { top: 115, left: 150 } );
                this._vatno = vatno;
                this._validator.add(this._vatno);

                lbl = this._createLbl(this.tr( "Address" ), 70);
                page1.add ( lbl, { top: 115, left: 400 } );

                let address1 = this._createTxt("Address", 250, true,
                    this.tr("Address is required"),
                    this.tr("Official address to be used in documents")
                );
                page1.add ( address1, { top: 115, left: 550 } );
                this._address1 = address1
                this._validator.add(this._address1);

                lbl = this._createLbl(this.tr( "Giro" ), 70);
                page1.add ( lbl, { top: 145, left: 10 } );

                let giro = this._createTxt("Giro", 240, true,
                    this.tr("Giro is required"),
                    this.tr("Giro to be used on invoices")
                );
                page1.add ( giro, { top: 145, left: 150 } );
                this._giro = giro;
                this._validator.add(this._giro);

                let address2 = this._createTxt("Address", 250, false,'',this.tr("More address if nessesary"));
                page1.add ( address2, { top: 145, left: 550 } );
                this._address2 = address2

                lbl = this._createLbl(this.tr( "Invoice ref." ), 150);
                page1.add ( lbl, { top: 175, left: 10 } );

                let invoiceref = this._createTxt("Invoice ref.", 240, true,
                    this.tr("Invoiceref is required"),
                    this.tr("Reference to be used on invoices")
                );
                page1.add ( invoiceref, { top: 175, left: 150 } );
                this._invoiceref = invoiceref;
                this._validator.add(this._invoiceref);

                let address3 = this._createTxt("Address", 250, false,'',
                    this.tr("More address if nessesary")
                );
                page1.add ( address3, { top: 175, left: 550 } );
                this._address3 = address3

                lbl = this._createLbl(this.tr( "Email" ), 70);
                page1.add ( lbl, { top: 210, left: 10 } );

                let email = this._createTxt("Email", 240, true,
                    this.tr("Email is required"),
                    this.tr("Official emai address be used on invoices and other documents")
                );
                page1.add ( email, { top: 210, left: 150 } );
                this._email = email;
                this._validator.add(this._email);

                lbl = this._createLbl(this.tr( "Zipcode / City" ), 150);
                page1.add ( lbl, { top: 210, left: 400 } );

                let zipcode = this._createTxt("Zipcode", 90, true,
                    this.tr("Zipcode is required"),
                    this.tr("Zipcode to be used on invoices")
                );
                page1.add ( zipcode, { top: 210, left: 550 } );
                this._zipcode = zipcode
                this._validator.add(this._zipcode);

                let city = this._createTxt("City", 150, true,
                    this.tr("City is required"),
                    this.tr("City to be used on invoices")
                );
                page1.add ( city, { top: 210, left: 650 } );
                this._city = city
                this._validator.add(this._city);

                lbl = this._createLbl(this.tr( "Invoice comment" ), 120);
                page1.add ( lbl, { top: 240, left: 10 } );

                let invoicecomment = this._createTextArea("Invoice comment", 650, 70, '',
                    this.tr("Comment to be shown on the invouces")
                );
                page1.add ( invoicecomment, { top: 240, left: 150 } );
                this._invoicecomment = invoicecomment;

                if(this.isAutotodo()) {
                    let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 540, function ( ) {
                        if(validator.validate()) {
                            this.saveCompany ( );
                        } else {
                            let messages = validator.getInvalidMessages();
                        }

                    }, this, this.tr("Save company") );

                    page1.add ( btnSave, { bottom: 10, left: 150 } );

                    let btnBack = this._createBtn ( this.tr ( "Back" ), "#FFAAAA70", 100, function ( ) {
                        this.backToCockpit ( );
                    }, this, this.tr("Back to the Cockpit") );

                    page1.add ( btnBack, { bottom: 10, left: 700 } );
                    this._btnSignup = btnSave;
                } else {
                    let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 650, function ( ) {
                        if(validator.validate()) {
                            this.saveCompany ( );
                        } else {
                            let messages = validator.getInvalidMessages();
                        }

                    }, this, this.tr("Save company") );
                    page1.add ( btnSave, { bottom: 10, left: 150 } );
                    this._btnSignup = btnSave;
                }
                // this._validator.bind("valid", this._btnSignup, "enabled");
                this.loadCompany();

                return page1;
            },
            backToCockpit:function() {
                let view = new venditabant.cockpit.helpers.AutoTodos();
                view.runCheckPoints();
            },
            saveCompany:function() {
                let that = this;
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

                    that._validator.validate();
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            }
        }
    });
