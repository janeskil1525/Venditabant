/* ************************************************************************

   Copyright:

   License:

   Authors:

************************************************************************ */

/**
 * TODO: needs documentation
 */
qx.Class.define("delivery.page.Overview",
{
  extend : qx.ui.mobile.page.NavigationPage,

  construct : function()
  {
    this.base(arguments);
    this.setTitle("Delivery");
    this.setShowBackButton(true);
    this.setBackButtonText("Back");
  },


  members :
  {
    // overridden
    _selectedCustomer : null,
    _selectedStockitem:null,
    _initialize : function()
    {
      this.base(arguments);

      this.getContent().add(new qx.ui.mobile.basic.Label(this.tr("Select customer")));

      this.setupCustomerList();
      this._selectedStockitem = new qx.ui.mobile.basic.Label("");
      this._quantity = new qx.ui.mobile.form.NumberField(0);

      this.getContent().add(this._selectedStockitem);
      this.getContent().add(this._quantity);
      this._quantity.setVisibility('hidden');
      this._quantity.setPlaceholder(this.tr("Quantity"));

      let but = new qx.ui.mobile.form.Button(this.tr("Add"));
      but.addListener("tap", function() {
        if(this._quantity.getValue() > 0) {
          let data = {
            customer:this._selectedCustomer,
            quantity:this._quantity.getValue(),
            stockitem:this._selectedStockitem.getValue()
          };

          let sales = new venditabant.stock.stockitems.models.Salesorders();
          sales.add(function() {
            this._quantity.setVisibility('hidden');
            this._quantity.setValue(0);
            this._selectedStockitem.setValue('');
          }, this, data);
        }


        // sel.setSelection("item3");
      }, this);

      this.getContent().add(but);
      this.loadStockitemList();

      but = new qx.ui.mobile.form.Button(this.tr("Save"));
      this.getContent().add(but);
      but.addListener("tap", function(){
        // sel.setSelection("item3");
      }, this);

      //var title = new qx.ui.mobile.form.Title("item2");
      // title.bind("value",sel,"value");
      // this._customers.bind("value",title,"value");
      //this.getContent().add(title);
    },
    setupCustomerList:function() {

      let customers = new qx.ui.mobile.form.SelectBox();
      customers.addListener("changeSelection", function(evt) {
        this._selectedCustomer = evt.getData();
      }, this);
      let cust = new delivery.models.Customers();
      cust.loadList(function(response) {
        let tableData = new qx.data.Array();;
        for(let i = 0; i < response.data.length; i++) {
          tableData.append(response.data[i].customer);
        }
        customers.setModel(tableData);
      }, this);
      this.getContent().add(customers);
      // this._customers = customers;
      // this._loadCustomers();
    },
    _loadCustomers: function () {
      let cust = new delivery.models.Customers();
      cust.loadList(function(response) {
          let tableData = [];
          for(let i = 0; i < response.data.length; i++) {
            let tempItem = new qx.ui.form.ListItem(response.data[i].customer);
            cust.add(tempItem);
          }
        }, this);
      },
    loadStockitemList:function() {
      var data = [
        {title : "Row1", subtitle : "Sub1"},
        {title : "Row2", subtitle : "Sub2"},
        {title : "Row3", subtitle : "Sub3"},
        {title : "Row4", subtitle : "Sub4"},
        {title : "Row5", subtitle : "Sub5"},
        {title : "Row6", subtitle : "Sub6"},
        {title : "Row7", subtitle : "Sub7"},
        {title : "Row8", subtitle : "Sub8"},
        {title : "Row9", subtitle : "Sub9"},
        {title : "Row10", subtitle : "Sub10"},
        {title : "Row11", subtitle : "Sub11"},
      ];

      this.createUiList(data)
    },
    createUiList:function(data) {
      let list = new qx.ui.mobile.list.List({
        configureItem: function(item, data, row)
        {
          item.setImage("path/to/image.png");
          item.setTitle(data.title);
          item.setSubtitle(data.subtitle);
        },
        configureGroupItem: function(item, data) {
          item.setTitle(data.title);
        },
        group: function(data, row) {
          return {
            title: row < 2 ? "Selectable" : "Unselectable"
          };
        }
      });

      list.setModel(new qx.data.Array(data));
      list.addListener("changeSelection", function(evt) {

        let data = this._list.getModel().toArray()[evt.getData()];

        this._selectedStockitem.setValue(data.title);
        this._quantity.setVisibility('visible');


      }, this);

      this.getContent().add(list);
      this._list = list;
    },
    // overridden
    _back : function(triggeredByKeyEvent)
    {
      qx.core.Init.getApplication().getRouting().back();
    }
  }
});
