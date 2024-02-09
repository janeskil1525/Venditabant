qx.Class.define ( "venditabant.History.views.HistoryList",
    {
        extend: venditabant.application.base.views.Base,
        include: [qx.locale.MTranslation],
        construct: function () {
        },
        destruct: function () {
        },
        properties: {
            support: {nullable: true, check: "Boolean"},
            autotodo: {nullable: true, check: "Boolean"},
        },
        members: {
            getTable:function() {
                this._createHistoryTable();
                return this._table;
            },
            _createHistoryTable: function () {
                // Create the initial data
                let rowData = '';
                let that = this;

                // table model
                var tableModel = new qx.ui.table.model.Simple();
                tableModel.setColumns(
                    ["User", "Action", "Description", "Date", "State"]
                );
                tableModel.setData(rowData);
                // table
                var table = new qx.ui.table.Table(tableModel);

                table.set({
                    width: 800,
                    height: 345
                });

                table.getSelectionModel().setSelectionMode(qx.ui.table.selection.Model.SINGLE_SELECTION);

                this._table = table;
            },
            loadHistory:function(type,key) {
                let history  = new venditabant.History.models.History();
                let data = {};
                data.key = key;
                data.type = type;

                history.loadList(data,function(response) {
                    let tableData = [];
                    if(response.data === undefined || response.data === null) {
                        response.data = [];
                    }

                    for( let i = 0; i < response.data.length; i++) {
                        tableData.push([
                            response.data[i].workflow_user,
                            response.data[i].action,
                            response.data[i].description,
                            response.data[i].history_date,
                            response.data[i].state
                        ]);
                    }
                    this._table.getTableModel().setData(tableData);
                }, this);
            },
        },
    }
);