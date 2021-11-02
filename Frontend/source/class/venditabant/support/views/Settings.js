

qx.Class.define ( "venditabant.support.views.Settings",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"}
        },
        members: {
            // Public functions ...
            __table : null,
            _default_mailer_mails_pkey: 0,
            getView: function () {
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "95%"});
                let page1 = this.getDefinition();
                tabView.add(page1);

                return view;
            },
            getDefinition:function () {
                var page1 = new qx.ui.tabview.Page(this.tr("Mail"));
                //page1.setLayout(new qx.ui.layout.VBox(4));
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "SMTP Address" ), 110);
                page1.add ( lbl, { top: 10, left: 10 } );

                let host = this._createTxt(this.tr("SMTP"), 250, false,'');
                page1.add ( host, { top: 10, left: 150 } );
                this._host = host;

                lbl = this._createLbl(this.tr( "Port" ), 110);
                page1.add ( lbl, { top: 45, left: 10 } );

                let port = this._createTxt(this.tr("Port"), 250, false, '');
                page1.add ( port, { top: 45, left: 150 } );
                this._port = port;

                lbl = this._createLbl(this.tr( "ssl" ), 110);
                page1.add ( lbl, { top: 80, left: 10 } );

                let ssl =  this._createTxt(this.tr("ssl"), 250, false,'');
                page1.add ( ssl, { top: 80, left: 150 } );
                this._ssl = ssl;

                lbl = this._createLbl(this.tr( "ssl_username" ), 110);
                page1.add ( lbl, { top: 115, left: 10 } );

                let sasl_username =  this._createTxt(this.tr("ssl_username"), 250, false,'');
                page1.add ( sasl_username, { top: 115, left: 150 } );
                this._sasl_username = sasl_username;

                lbl = this._createLbl(this.tr( "sasl_password" ), 110);
                page1.add ( lbl, { top: 150, left: 10 } );

                let sasl_password =  this._createTxt(this.tr("sasl_password"), 250, false,'');
                page1.add ( sasl_password, { top: 150, left: 150 } );
                this._sasl_password = sasl_password;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveSmtpData( );
                }, this );
                page1.add ( btnSignup, { bottom: 5, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.clearScreen ( );
                }, this );
                page1.add ( btnCancel, { bottom: 5, right: 10 } );
                this.loadSmtpSettings();

                return page1;
            },
            saveSmtpData:function() {
                let that = this;

                let host  = this._host.getValue();
                let port = this._port.getValue();
                let ssl = this._ssl.getValue();
                let sasl_username = this._sasl_username.getValue();
                let sasl_password = this._sasl_password.getValue();

                let data = {
                    setting: 'SMTP',
                    value: {
                        host:host,
                        port:port,
                        ssl:ssl,
                        sasl_username:sasl_username,
                        sasl_password:sasl_password
                    },
                }
                let model = new venditabant.support.models.SystemSettings();
                model.saveSystemSetting(data,function ( success ) {
                    if (success === 'success') {
                        that.loadTemplates(this._template.getKey());
                        that.clearScreen();
                    } else {
                        alert(this.tr('Something went wrong saving the customer'));
                    }
                },this);

            },
            loadSmtpSettings:function() {
                let that = this;
                let model = new venditabant.support.models.SystemSettings();
                model.load(function(response) {
                    if(typeof response.data !== 'undefined' && response.data !== null && response.data.length > 0) {
                        that._host.setValue(response.data.host);
                        that._port.setValue(response.data.port);
                        that._ssl.setValue(response.data.ssl);
                        that._sasl_username.setValue(response.data.sasl_username);
                        that._sasl_password.setValue(response.data.sasl_password);
                    }
                },this, 'SMTP');
            },
            clearScreen:function() {
                this._host.setValue('');
                this._port.setValue('');
                this._ssl.setValue('');
                this._sasl_username.setValue('');
                this._sasl_password.setValue('');

            },
        }
    });
