
qx.Class.define("venditabant.users.login.SignupWindow",
    {
        extend:qx.ui.container.Composite,

        construct : function() {
            this.base (arguments);
            this.setLayout(new qx.ui.layout.Canvas);
            this.set({ width: 500, height: 300 });
            this._buildSignup ( );
            var top  = parseInt ( ( qx.bom.Document.getHeight ( ) - 200 ) / 2, 10 );
            var left = parseInt ( ( qx.bom.Document.getWidth  ( ) - 500 ) / 2, 10 );
            var app  = qx.core.Init.getApplication ( );
            var root = app.getRoot( );
            root.add ( this, { top: top, left: left } );
        },
        destruct : function() {

        },
        members : {
            _address: new venditabant.application.Const().venditabant_endpoint(),
            signup : function () {
                var email = this._email.getValue ( );
                var user_name = this._user_name.getValue ( );
                var company_name = this._company_name.getValue  ( );
                var company_orgnr = this._company_orgnr.getValue  ( );
                var company_address = this._company_address.getValue  ( );
                var pass1 = this._pass1.getValue ( );
                var pass2 = this._pass2.getValue ( );

                if ( company_name.length < 1 || email.length < 1 || pass1.length < 1 || company_orgnr.length < 1)  {
                    alert ( this.tr ( "Please provide username, password, and email" ) );
                    return;
                }
                if ( pass1 !== pass2 )  {
                    alert ( this.tr ( "Passwords do not match." ) );
                    return;
                }

                let data = {
                    email:email,
                    user_name:user_name,
                    company_name:company_name,
                    company_orgnr:company_orgnr,
                    company_address:company_address,
                    password:pass1,
                };
                let app = new venditabant.communication.Post ( );

                app.send ( this._address, "/api/signup/", data, function ( success ) {
                    let win = null;
                    if ( success )  {
                        this.login ( );
                    }
                    else  {
                        alert ( this.tr ( "Could not signup." ) );
                    }
                }, this );
            },
            login : function () {
                let login = new venditabant.users.login.LoginWindow();
                login.show();
                this.destroy();
            },
            setBGColor : function (btn, clr1, clr2) {
                let elem = btn.getContentElement();
                let dom = elem.getDomElement();
                let img = "linear-gradient(" + clr1 + " 35%" + clr2 + " 100%)";
                if( dom.style.setProperty ) {
                    dom.style.setProperty("background-image",img, null);
                } else {
                    dom.style.setProperty("backgroundImage",img);
                }
            },
            _createBtn : function ( txt, clr, width, cb, ctx )  {

                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            _createLBL : function(txt) {
                let font = new qx.bom.Font ( 14, [ "Arial" ] );

                let lbl = new qx.ui.basic.Label ( "<b style='color: #FFFFFF'>" + txt + "</b>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( 130 );

                return lbl;
            },
            _buildSignup : function () {
                let semi = new qx.ui.core.Widget ( );
                semi.set ( { opacity: 0.6, backgroundColor: "#404040" } );
                this.add ( semi, { top: 1, left: 1, right: 1, bottom: 1 } );

                let font = new qx.bom.Font ( 24, [ "Arial" ] );

                font.setBold ( true );
                let lbl = new qx.ui.basic.Label ( "<center><b style='color: #FFFFFF'>" + this.tr ( "Sign Up you and your company" ) + "</b></center>" );
                lbl.setFont ( font );
                lbl.setRich ( true );
                lbl.setWidth( this.getWidth ( ) - 20  );
                this.add ( lbl, { top: 10, left: 10 } );

                let line = new qx.ui.core.Widget ( );
                line.set ( { height: 2, backgroundColor: '#FFFFFF' } );
                this.add ( line, { top: 50, left: 10, right: 10 } );
                let validator = new qx.ui.form.validation.Manager();
                this._validator = validator;

                let lbl1 = this._createLBL(this.tr ( "Email" ));
                this.add ( lbl1, { top: 65, left: 10 } );

                let email = new qx.ui.form.TextField ( );
                email.setPlaceholder ( this.tr ( "Email" ) );
                email.setWidth ( 135 );
                email.setRequired(true);

                this.add ( email, { top: 65, right: 10, left: 160 } );
                this._email = email;
                this._validator.add(email, qx.util.Validate.email());

                lbl1 = this._createLBL(this.tr ( "Name" ));
                this.add ( lbl1, { top: 95, left: 10 } );

                let user_name = new qx.ui.form.TextField ( );
                user_name.setPlaceholder ( this.tr ( "Name" ) );
                user_name.setRequired(true);
                user_name.setRequiredInvalidMessage(this.tr("User name can not be emty"));
                this.add ( user_name, { top: 95, left: 160, right: 10 } );
                this._user_name = user_name;
                this._validator.add(this._user_name);

                lbl1 = this._createLBL(this.tr ( "Company" ));
                this.add ( lbl1, { top: 125, left: 10 } );

                let company_name = new qx.ui.form.TextField ( );
                company_name.setPlaceholder ( this.tr ( "Company" ) );
                company_name.setRequired(true);
                company_name.setRequiredInvalidMessage(this.tr("Company name can not be emty"));

                this.add ( company_name, { top: 125, left: 160, right: 10 } );
                this._company_name = company_name;
                this._validator.add(this._company_name);

                lbl1 = this._createLBL(this.tr ( "Org. number" ));
                this.add ( lbl1, { top: 155, left: 10 } );

                let company_orgnr = new qx.ui.form.TextField ( );
                company_orgnr.setPlaceholder ( this.tr ( "Org. number" ) );
                company_orgnr.setRequired(true);
                company_orgnr.setRequiredInvalidMessage(this.tr("Org. no can not be emty"));

                this.add ( company_orgnr, { top: 155, left: 160, right: 10 } );
                this._company_orgnr = company_orgnr;
                this._validator.add(this._company_orgnr);

                lbl1 = this._createLBL(this.tr ( "Address" ));
                this.add ( lbl1, { top: 185, left: 10 } );

                let company_address = new qx.ui.form.TextField ( );
                company_address.setPlaceholder ( this.tr ( "Company address" ) );
                this.add ( company_address, { top: 185, left: 160, right: 10 } );
                this._company_address = company_address;

                lbl1 = this._createLBL(this.tr ( "Password" ));
                this.add ( lbl1, { top: 220, left: 10 } );

                let pass1 = new qx.ui.form.PasswordField ( );
                pass1.setPlaceholder ( this.tr ( "Password" ) );
                pass1.setWidth ( 135 );
                pass1.setRequired(true);
                pass1.setRequiredInvalidMessage(this.tr("Password can not be emty"));
                this.add ( pass1, { top: 220, left: 160 } );
                this._pass1 = pass1;

                let pass2 = new qx.ui.form.PasswordField ( );
                pass2.setPlaceholder ( this.tr ( "Retype Password" ) );
                pass2.setWidth ( 135 );
                pass2.setRequired(true);
                pass2.setRequiredInvalidMessage(this.tr("Password can not be emty"));
                this.add ( pass2, { top: 220, right: 10 } );
                this._pass2 = pass2;


                let btnSignup = this._createBtn ( this.tr ( "Sign Up" ), "#AAAAFF70", 200, function ( ) {
                    if(this._validator.validate()) {
                        this.signup ( );
                    }
                }, this );
                this.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "GoBack" ), "#FFAAAA70", 200, function ( ) {
                    this.login ( );
                }, this );
                this.add ( btnCancel, { bottom: 10, right: 10 } );
            }

        }
    })
