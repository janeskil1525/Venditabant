
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
                page1.add ( name, { top: 10, left: 350 } );
                this._name = name

                lbl = this._createLbl(this.tr( "Org. nr" ), 70);
                page1.add ( lbl, { top: 45, left: 250 } );

                let orgnbr = this._createTxt("Org. nr", 250, false);
                page1.add ( orgnbr, { top: 45, left: 350 } );
                this._registrationnumber = orgnbr


                lbl = this._createLbl(this.tr( "Phone" ), 70);
                page1.add ( lbl, { top: 80, left: 10 } );

                let phone = this._createTxt("Phone", 150, true, this.tr("Phone is required"));
                page1.add ( phone, { top: 80, left: 90 } );
                this._phone = phone;

                lbl = this._createLbl(this.tr( "Homepage" ), 70);
                page1.add ( lbl, { top: 80, left: 250 } );

                let homepage = this._createTxt("Homepage", 250, false);
                page1.add ( homepage, { top: 80, left: 350 } );
                this._homepage = homepage


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
                let data = {
                    company: company,
                    name: name,
                    registrationnumber: registrationnumber,
                    homepage: homepage,
                    phone: phone,
                    languages_fkey:languages_fkey,
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
                    //alert("Set table data here");
                }, this);
                //return ;//list;
            }
        }
    });
