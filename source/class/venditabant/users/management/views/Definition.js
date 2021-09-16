
qx.Class.define ( "venditabant.users.management.views.Definition",
    {
        extend: qx.ui.window.Window,

        construct: function () {
            this.base(arguments);
            this.setLayout(new qx.ui.layout.Canvas());
            this.setWidth(1000);
            this.setHeight(1000);
            this._buildWindow();
            var app = qx.core.Init.getApplication();
            var root = app.getRoot();
            root.add(this, {top: 10, left: 10});

        },
        destruct: function () {
        },

        members: {
            // Public functions ...
            __table : null,
            setParams: function (params) {
            },
            _buildWindow: function () {
                var win = new qx.ui.window.Window("Users", "icon/16/apps/internet-feed-reader.png");
                win.setLayout(new qx.ui.layout.VBox(10));
                win.setStatus("Application is ready");
                win.open();
                let app = qx.core.Init.getApplication();
                let root = app.getRoot();
                root.add(win, {left: 350, top: 120});

                var atom = new qx.ui.basic.Atom("Manage users", "icon/22/apps/utilities-calculator.png");
                win.add(atom);
                win.setShowStatusbar(true);

                // Add a TabView
                var tabView = new qx.ui.tabview.TabView();
                tabView.setWidth(800);
                tabView.setHeight(300);
                win.add(tabView, {flex:1});

                var page1 = new qx.ui.tabview.Page("Definition");
                page1.setLayout(new qx.ui.layout.Canvas());

                let lbl = this._createLbl(this.tr( "User" ),70)
                page1.add ( lbl, { top: 10, left: 10 } );

                let userid = this._createTxt(this.tr( "User" ),150,true,this.tr("User is required") );
                page1.add ( userid, { top: 10, left: 90 } );
                this._userid = userid;

                lbl = this._createLbl(this.tr( "Name" ),70);
                page1.add ( lbl, { top: 10, left: 250 } );

                let username = this._createTxt(this.tr( "Name" ),250,true,this.tr("Name is required") );
                page1.add ( username, { top: 10, left: 350 } );
                this._username = username;

                lbl = this._createLbl(this.tr( "Password" ),70);
                page1.add ( lbl, { top: 50, left: 10 } );

                let password1 = this._createTxt(this.tr( "Password 1" ),250,true,this.tr("Name is required") );
                page1.add ( password1, { top: 50, left: 90 } );
                this._password1 = password1;

                let password2 = this._createTxt(this.tr( "Password 2" ),250,true,this.tr("Name is required") );
                page1.add ( password2, { top: 50, left: 350 } );
                this._password2 = password2;

                lbl = this._createLbl(this.tr( "Active" ),70);
                page1.add ( lbl, { top: 90, left: 10 } );

                let active = new qx.ui.form.CheckBox("");
                page1.add ( active, { top: 90, left: 90 } );
                this._active = active;

                let btnSignup = this._createBtn ( this.tr ( "Save" ), "rgba(239,170,255,0.44)", 135, function ( ) {
                    this.saveUser ( );
                }, this );
                page1.add ( btnSignup, { bottom: 10, left: 10 } );

                let btnCancel = this._createBtn ( this.tr ( "Cancel" ), "#FFAAAA70", 135, function ( ) {
                    this.cancel ( );
                }, this );
                page1.add ( btnCancel, { bottom: 10, right: 10 } );

                tabView.add(page1);

                /*var page2 = new qx.ui.tabview.Page("Page 2");
                tabView.add(page2);

                var page3 = new qx.ui.tabview.Page("Page 3");
                tabView.add(page3);*/
                this._createTable();
                win.add(this._table);

                this.loadUsers();
            },
            saveUser:function() {
                let that = this;
                let userid = this._userid.getValue();
                let username  = this._username.getValue();
                let active  = this._active.getValue();
                let password  = this._password1.getValue();

                let data = {
                    userid: userid,
                    username: username,
                    active:active,
                    password:password,
                }
                let model = new venditabant.users.management.models.Users();
                model.saveUser(data,function ( success ) {
                    if (success) {
                        that.loadUsers();
                    } else {
                        alert(this.tr('Something went wrong saving the user'));
                    }
                },this);

            },
            _createTxt:function(placeholder, width, required, requiredTxt) {
                let txt = new venditabant.widget.textfield.Standard().createTxt(placeholder, width, required, requiredTxt);
                return txt;
            },
            _createLbl:function(label, width, required, requiredTxt) {
                let lbl = new venditabant.widget.label.Standard().createLbl(label, width, required, requiredTxt);
                return lbl;
            },
            _createBtn : function (txt, clr, width, cb, ctx) {
                let btn = new venditabant.widget.button.Standard().createBtn(txt, clr, width, cb, ctx)

                return btn;
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "User", "Name", "Active" ]);
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

                    that._userid.setValue(selectedRows[0][1]);
                    that._username.setValue(selectedRows[0][2]);
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                //tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());

                // use a different header renderer
                //tcm.setHeaderCellRenderer(2, new qx.ui.table.headerrenderer.Icon("icon/16/apps/office-calendar.png", "A date"));

                this._table = table;

                return ;
            },
            loadUsers:function () {
                let users = new venditabant.users.management.models.Users();
                users.loadList(function(response) {
                    let tableData = [];
                    for(let i = 0; i < response.data.length; i++) {
                        tableData.push([
                            response.data[i].users_pkey,
                            response.data[i].userid,
                            response.data[i].username,
                            response.data[i].active,
                        ]);
                    }
                    this._table.getTableModel().setData(tableData);
                }, this);
            }
        }
    });
