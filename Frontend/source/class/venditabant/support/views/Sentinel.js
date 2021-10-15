
qx.Class.define ( "venditabant.support.views.Sentinel",
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
        getView: function () {
            let view = new qx.ui.container.Composite(new qx.ui.layout.Canvas());
            view.setBackgroundColor("white");

            // Add a TabView
            var tabView = new qx.ui.tabview.TabView();
            view.add(tabView, {top: 0, left: 5, right: 5, height: "50%"});
            let page1 = this.getDefinition();
            tabView.add(page1);

            this._createTable();
            view.add(this._table,{top:"52%", left:5, right:5,height:"45%"});
            this.loadSentinels();

            return view;
        },
        getDefinition:function () {
            var page1 = new qx.ui.tabview.Page(this.tr("Definition"));
            //page1.setLayout(new qx.ui.layout.VBox(4));
            page1.setLayout(new qx.ui.layout.Canvas());

            let lbl = this._createLbl(this.tr( "Source" ), 70);
            page1.add ( lbl, { top: 10, left: 10 } );

            let source = this._createTxt("Source", 848, true, this.tr("Customer is required"));
            page1.add ( source, { top: 10, left: 90 } );
            this._source = source;

            lbl = this._createLbl(this.tr( "Method" ), 70);
            page1.add ( lbl, { top: 45, left: 10 } );

            let method = this._createTxt("Method", 848, false);
            page1.add ( method, { top: 45, left: 90 } );
            this._method = method

            lbl = this._createLbl(this.tr( "Message" ), 70);
            page1.add ( lbl, { top: 88, left: 10 } );

            let message =  this._createTextArea(this.tr("Message"), 848, 150);
            page1.add ( message, { top: 80, left: 90 } );
            this._message = message;

            return page1;
        },
        _createTable : function() {
            // Create the initial data
            let rowData =  '';
            let that = this;

            // table model
            var tableModel = new qx.ui.table.model.Simple();
            tableModel.setColumns([ "ID", "Source", "Method", "Message", "Mailed", "Closed" ]);
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
                that._sentinel_pkey = selectedRows[0][0];
                that._source.setValue(selectedRows[0][1]);
                that._method.setValue(selectedRows[0][2]);
                that._message.setValue(selectedRows[0][3]);
            });
            var tcm = table.getTableColumnModel();

            // Display a checkbox in column 3
            tcm.setDataCellRenderer(4, new qx.ui.table.cellrenderer.Boolean());
            tcm.setDataCellRenderer(5, new qx.ui.table.cellrenderer.Boolean());

            tcm.setColumnVisible(0,false);
            tcm.setColumnWidth(1,300)
            tcm.setColumnWidth(2,150)
            tcm.setColumnWidth(3,400)

            // use a different header renderer

            this._table = table;
        },
        loadSentinels:function () {
            let sentinels = new venditabant.support.models.Sentinel();
            sentinels.loadList(function(response) {
                let tableData = [];
                for(let i = 0; i < response.data.length; i++) {
                    let mailed = response.data[i].mailed ? true : false;
                    let closed = response.data[i].closed ? true : false;
                    tableData.push([
                        response.data[i].sentinel_pkey,
                        response.data[i].source,
                        response.data[i].method,
                        response.data[i].message,
                        mailed,
                        closed,
                    ]);
                }
                this._table.getTableModel().setData(tableData);
                //alert("Set table data here");
            }, this);
            //return ;//list;
        }
    }
    });
