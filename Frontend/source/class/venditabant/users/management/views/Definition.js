
qx.Class.define ( "venditabant.users.management.views.Definition",
    {
        extend: venditabant.application.base.views.Base,
        include:[qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties : {
            support : { nullable : true, check: "Boolean", apply:"loadUsers" }
        },
        members: {
            getView: function() {
                this._newItem = 1;
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");
                // Add a TabView
                let tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});

                let page1 = new qx.ui.tabview.Page("Definition");
                page1.setLayout(new qx.ui.layout.Canvas());

                let page2 = new qx.ui.tabview.Page("History");
                page2.setLayout(new qx.ui.layout.Canvas());

                let history = new venditabant.History.views.HistoryList();
                let historyTable = history.getTable();
                page2.add(historyTable,{ top: 2, left: 10 });
                this.history = history;

                let validator = new qx.ui.form.validation.Manager();
                this._validator = validator;

                let lbl = this._createLbl(this.tr( "User" ),70)
                page1.add ( lbl, { top: 10, left: 10 } );

                let userid = this._createTxt(this.tr( "User" ),150,true,
                    this.tr("User is required"),
                    this.tr("User has to be a valid email address")
                );
                page1.add ( userid, { top: 10, left: 90 } );
                this._userid = userid;
                this._validator.add(this._userid, qx.util.Validate.email());

                lbl = this._createLbl(this.tr( "Name" ),70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let username = this._createTxt(this.tr( "Name" ),250,true,
                    this.tr("Name is required"),
                    this.tr("The users name")
                );
                page1.add ( username, { top: 10, left: 350 } );
                this._username = username;
                this._validator.add(this._username);

                lbl = this._createLbl(this.tr( "Password" ),70);
                page1.add ( lbl, { top: 50, left: 10 } );
                this._passwordLbl = lbl;

                var password1 = new qx.ui.form.PasswordField ( );
                password1.setPlaceholder ( this.tr ( "Password 1" ) );
                password1.setToolTipText(this.tr("A strong password"))
                password1.setWidth ( 250 );
                page1.add ( password1, { top: 50, left: 90 } );
                this._password1 = password1;
                this._validator.add(this._password1);

                var password2 = new qx.ui.form.PasswordField ( );
                password2.setPlaceholder ( this.tr ( "Password 2" ) );
                password2.setToolTipText(this.tr("A strong password"))
                password2.setWidth ( 250 );
                page1.add ( password2, { top: 50, left: 350 } );
                this._password2 = password2;
                this._validator.add(this._password2);

                lbl = this._createLbl(this.tr( "Active" ),70);
                lbl.setToolTipText(this.tr("User is active and can login"))
                page1.add ( lbl, { top: 90, left: 10 } );

                let active = new qx.ui.form.CheckBox("");
                active.setToolTipText(this.tr("User is active and can login"))
                page1.add ( active, { top: 90, left: 90 } );
                this._active = active;

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:150,
                    emptyrow:false,
                    tooltip:this.tr("The language to use for this user"),
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { top: 90, left: 350 } );

                let btnSave = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    if(this._validator.validate()) {
                        if ( this._newItem === 1 && this._password2.getValue() !== this._password1.getValue() )  {
                            alert ( this.tr ( "Passwords do not match." ) );
                        } else {
                            this.saveUser ( );
                            this.loadUsers();
                        }
                    }
                    that._newItem = 1;
                }, this, this.tr("Save user") );
                page1.add ( btnSave, { bottom: 10, left: 10 } );

                let btnNew = this._createBtn ( this.tr ( "New" ), "#FFAAAA70", 135, function ( ) {
                    this.clearFields ( );
                    this._password1.setVisibility('visible');
                    this._password2.setVisibility('visible');
                    this._passwordLbl.setVisibility('visible');
                    this._newItem = 1;
                }, this, this.tr("New user") );
                page1.add ( btnNew, { bottom: 10, right: 10 } );

                tabView.add(page1);
                tabView.add(page2);
                /*var page2 = new qx.ui.tabview.Page("Page 2");
                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Page 3");
                tabView.add(page3);*/
                this._createTable();
                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});
                return view;
            },
            // Public functions ...
            __table : null,
            clearFields: function (params) {
                this._users_pkey = 0;
                this._userid.setValue('');
                this._username.setValue('');
                this._active.setValue(false);
                this._password1.setValue('');
                this._password2.setValue('');
            },
            saveUser:function() {
                let that = this;
                let users_pkey = this._users_pkey;
                let userid = this._userid.getValue();
                let username  = this._username.getValue();
                let active  = this._active.getValue();
                let password1  = this._password1.getValue();
                let password2  = this._password2.getValue();
                let languages_fkey = this._languages.getKey();


                let data = {
                    users_pkey: users_pkey,
                    userid: userid,
                    username: username,
                    active:active,

                    languages_fkey:languages_fkey,
                }
                if (this._newItem === 1) {
                    if ( password1 === null )  {
                        alert ( this.tr ( "Password can't be empty" ) );
                        return;
                    }

                    if ( password1 !== password2 )  {
                        alert ( this.tr ( "Passwords do not match." ) );
                        return;
                    }

                    if ( password1.length < 5 )  {
                        alert ( this.tr ( "Password is to short" ) );
                        return;
                    }
                    data.password = password1;
                }

                let model = new venditabant.users.management.models.Users();
                if(users_pkey > 0) {
                    model.saveUser(data,function ( success ) {
                        if (success) {
                            that.loadUsers();
                            that.clearFields();
                        } else {
                            alert(this.tr('Something went wrong saving the user'));
                        }
                    },this);
                } else {
                    model.createUser(data,function ( success ) {
                        if (success) {
                            that.loadUsers();
                            that.clearFields();
                        } else {
                            alert(this.tr('Something went wrong saving the user'));
                        }
                    },this);
                }


            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "User", "Name", "Active", "languages_fkey", "Language" ]);
                tableModel.setData(rowData);
                //tableModel.setColumnEditable(1, true);
                //tableModel.setColumnEditable(2, true);
                //tableModel.setColumnSortable(3, false);

                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 800,
                    height: 200
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);
                table.getSelectionModel().addListener('changeSelection', function(e){
                    var selectionModel = e.getTarget();
                    var selectedRows = [];
                    selectionModel.iterateSelection(function(index) {
                        selectedRows.push(table.getTableModel().getRowData(index));
                    });
                    that._users_pkey = selectedRows[0][0];
                    that._userid.setValue(selectedRows[0][1]);
                    that._username.setValue(selectedRows[0][2]);
                    let active = selectedRows[0][3] ? true : false;
                    that._active.setValue(active);
                    // that._password1.setValue('');
                    // that._password2.setValue('');
                    that._password1.setVisibility('hidden');
                    that._password2.setVisibility('hidden');
                    that._passwordLbl.setVisibility('hidden');
                    that._newItem = 0;
                    that._languages.setKey(selectedRows[0][4]);
                    that.history.loadHistory('users',that._users_pkey);
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(4,false);
                tcm.setColumnWidth(2,300)
                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;

                return ;
            },
            loadUsers:function () {
                let users = new venditabant.users.management.models.Users();
                let support = this.isSupport();
                users.set({
                    support:this.isSupport()
                });
                users.loadList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {
                        let active = response.data[i].active ? true : false;
                        tableData.push([
                            response.data[i].users_pkey,
                            response.data[i].userid,
                            response.data[i].username,
                            active,
                            response.data[i].languages_fkey,
                            response.data[i].lan
                        ]);
                    }
                    this._table.getTableModel().setData(tableData);

                }, this);
            }
        }
    });
