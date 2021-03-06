

qx.Class.define("venditabant.stock.stockitems.views.StockitemsSelectBox",
    {
        extend: qx.core.Object,
        include: [qx.locale.MTranslation],
        construct: function () {

        },
        destruct: function () {

        },
        properties: {
            width: {nullable: true, check: "Number"},
            emptyrow: {nullable: true, check: "Boolean"},
            tooltip: {nullable:true, check:"String"},
        },
        members: {
            _selectbox:null,
            getView: function () {
                let selectbox = new qx.ui.form.SelectBox();
                if (this.getTooltip()) {
                    selectbox.setToolTipText(this.getTooltip());
                }
                selectbox.setWidth(this.getWidth());
                selectbox.addListener("changeSelection", function (e) {
                    this._model = e.getData()[0];
                }, this);
                new venditabant.stock.stockitems.helpers.StockitemsLoadList().set({
                    list: selectbox,
                    emptyrow: this.isEmptyrow(),
                }).loadList('');
                this._selectbox = selectbox;
                return selectbox;
            },
            getStockitem:function() {
                if(this._model.getModel() === null) {
                    return '';
                } else {
                    return this._model.getModel().stockitem ? this._model.getModel().stockitem : '';
                }
            },
            getModel: function () {
                return this._model;
            },
            getKey:function() {
                if(this._model.getModel() === null) {
                    return 0;
                } else {
                    return this._model.getModel().stockitems_pkey ? this._model.getModel().stockitems_pkey : 0;
                }
            },
            setSelectedModel:function(value) {
                new venditabant.stock.stockitems.helpers.StockitemsLoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:false,
                }).loadList(value);
            },
            setKey:function(key) {
                new venditabant.stock.stockitems.helpers.StockitemsLoadList().set({
                    list: this._selectbox,
                    emptyrow: this.isEmptyrow(),
                    key:true,
                }).loadList(key);
            }

        }
    });