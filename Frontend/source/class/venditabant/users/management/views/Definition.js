
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
                let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
                view.setBackgroundColor("white");
                // Add a TabView
                let tabView = new qx.ui.tabview.TabView();
                view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});

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

                var password1 = new qx.ui.form.PasswordField ( );
                password1.setPlaceholder ( this.tr ( "Password 1" ) );
                password1.setWidth ( 250 );
                page1.add ( password1, { top: 50, left: 90 } );
                this._password1 = password1;

                var password2 = new qx.ui.form.PasswordField ( );
                password2.setPlaceholder ( this.tr ( "Password 2" ) );
                password2.setWidth ( 250 );
                page1.add ( password2, { top: 50, left: 350 } );
                this._password2 = password2;

                lbl = this._createLbl(this.tr( "Active" ),70);
                page1.add ( lbl, { top: 90, left: 10 } );

                let active = new qx.ui.form.CheckBox("");
                page1.add ( active, { top: 90, left: 90 } );
                this._active = active;

                let languages = new venditabant.support.views.LanguageSelectBox().set({
                    width:150,
                    emptyrow:false,
                });
                let languagesview = languages.getView()
                this._languages = languages;
                page1.add ( languagesview, { top: 90, left: 350 } );

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
                view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});
                return view;
            },
            // Public functions ...
            __table : null,
            setParams: function (params) {
            },
            saveUser:function() {
                let that = this;
                let userid = this._userid.getValue();
                let username  = this._username.getValue();
                let active  = this._active.getValue();
                let password1  = this._password1.getValue();
                let password2  = this._password2.getValue();
                let languages_fkey = this._languages.getKey();
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

                let data = {
                    userid: userid,
                    username: username,
                    active:active,
                    password:password1,
                    languages_fkey:languages_fkey,
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
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "User", "Name", "Active", "languages_fkey" ]);
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
                    let active = selectedRows[0][4] ? false : true;
                    that._active.setValue(active);
                    that._password1.setValue('');
                    that._password2.setValue('');
                    that._languages.setKey(selectedRows[0][4])
                });
                var tcm = table.getTableColumnModel();

                // Display a checkbox in column 3
                tcm.setDataCellRenderer(3, new qx.ui.table.cellrenderer.Boolean());
                tcm.setColumnVisible(0,false);
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
                            response.data[i].languages_fkey
                        ]);
                    }
                    this._table.getTableModel().setData(tableData);
                }, this);
            }
        }
    });
