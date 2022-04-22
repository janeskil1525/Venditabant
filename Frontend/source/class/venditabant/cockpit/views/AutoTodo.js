

qx.Class.define ( "venditabant.cockpit.views.AutoTodo",
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
            _table: null,
            _selectedRow:null,
            getView:function() {

                var page1 = new qx.ui.tabview.Page("Auto todo's");
                page1.setLayout(new qx.ui.layout.Canvas());
                let version = this.tr( "Version" ) + ' ' + new venditabant.application.Const().getVersion();

                let lbl = this._createLbl(version, 100);
                page1.add ( lbl, { top: 10, left: 10 } );
                this._createTable();

                page1.add(this._table,{top: 50, left:5, right:5, height:"90%"});
                let jwt = new venditabant.utils.UserJwt();
                if(jwt.getUserJwt())

                this.loadAutoTodoList();
                return page1;
            },
            loadAutoTodoList:function () {
                let image = ["icon/16/actions/dialog-ok.png"];

                let autotodos = new venditabant.cockpit.models.AutoTodos();
                autotodos.loadList(function(response) {
                    if(response.data !== null) {
                        let tableData = [];
                        for(let i = 0; i < response.data.length; i++) {
                            let open = response.data[i].open ? true : false;
                            tableData.push([
                                response.data[i].auto_todo_pkey,
                                response.data[i].insdatetime,
                                response.data[i].moddatetime,
                                response.data[i].user_action,
                                response.data[i].check_type,
                                response.data[i].check_name,
                                response.data[i].key_id,
                                image[0],
                            ]);
                        }
                        this._table.getTableModel().setData(tableData);
                    }

                    //alert("Set table data here");
                }, this);
                //return ;//list;
            },
            _createTable : function() {
                // Create the initial data
                let rowData =  '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns([ "ID", "Created", "Last Check", "User action", "Check type", "Check name", "key_id", "Action" ]);
                tableModel.setData(rowData);

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
                    that._selectedRow = selectedRows[0];

                });
                table.addListener('cellDbltap', function(e){
                    if(that._selectedRow[4] === 'SQL_FALSE') {
                        that.sqlFalse();
                    } else if (that._selectedRow[4] === 'SQL_LIST') {
                        that.sqlList();
                    }
                });
                var tcm = table.getTableColumnModel();
                tcm.setColumnVisible(0,false);
                tcm.setColumnVisible(1,false);
                tcm.setColumnVisible(4,false);
                tcm.setColumnVisible(5,false);
                tcm.setColumnVisible(6,false);

                tcm.setDataCellRenderer(2, new qx.ui.table.cellrenderer.Date("YYYY-MM-DD HH:mm:SS"));
                // tcm.setColumnVisible(8,false);

                tcm.setColumnWidth(2,160)
                tcm.setColumnWidth(3,700)
                tcm.setColumnWidth(7,60)

                let renderer = new qx.ui.table.cellrenderer.Image();
                tcm.setDataCellRenderer(7, renderer);

                this._table = table;

                return ;
            },
            sqlList:function() {
                if(this._selectedRow[5] === 'CUSTOMER_DELIVERYADDRESS') {
                    alert("CUSTOMER_DELIVERYADDRESS")
                } else if(this._selectedRow[5] === 'CUSTOMER_INVOICEADDRESS') {
                    alert("CUSTOMER_INVOICEADDRESS")
                }
            },
            sqlFalse:function() {
                if(this._selectedRow[5] === 'COMPANY_CHECK_VATNO' ||
                    this._selectedRow[5] === 'COMPANY_CHECK_EMAIL' ||
                    this._selectedRow[5] === 'COMPANY_CHECK_GIRO' ||
                    this._selectedRow[5] === 'COMPANY_CHECK_INVOICEREF'
                ) {
                    let root  = qx.core.Init.getApplication ( ).getRoot();
                    let view = new venditabant.company.views.Definition();
                    root._basewin.addView(root, view);
                }
            }
        }
    });